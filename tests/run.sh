#!/usr/bin/env bash
# Lance tous les tests du site : bash tests/run.sh
# Chaque fonction test_* construit le site (contenu réel ou fixture) et vérifie le HTML produit.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HUGO="${HUGO:-hugo}"
TMP_ROOT="$(mktemp -d)"
trap 'rm -rf "$TMP_ROOT"' EXIT

PASSED=0
FAILED=0
CURRENT=""
CURRENT_OK=1

fail() {
  echo "    $*" >&2
  CURRENT_OK=0
}

# Copie le dépôt (sans contenu ni tests) dans un dossier temporaire, avec le contenu demandé.
prepare() {
  local name="$1" fixture="$2" dir="$TMP_ROOT/$1"
  rm -rf "$dir"
  mkdir -p "$dir"
  local item
  for item in "$ROOT"/* "$ROOT"/.[!.]*; do
    case "$(basename "$item")" in
      .git|.superpowers|.github|public|resources|content|tests|docs|.hugo_build.lock) continue ;;
    esac
    [ -e "$item" ] && cp -r "$item" "$dir/"
  done
  if [ "$fixture" = "-" ]; then
    cp -r "$ROOT/content" "$dir/content"
  else
    cp -r "$ROOT/$fixture" "$dir/content"
  fi
  echo "$dir"
}

# build_ok <nom> <fixture|-> <variable> : la construction doit réussir ; <variable> reçoit le dossier généré.
build_ok() {
  local name="$1" fixture="$2" var="$3" dir log
  dir="$(prepare "$name" "$fixture")"
  log="$dir/build.log"
  if ! (cd "$dir" && "$HUGO" --panicOnWarning --destination "$dir/public") >"$log" 2>&1; then
    fail "build_ok $name: la construction a échoué"
    sed 's/^/      /' "$log" >&2
  fi
  printf -v "$var" '%s' "$dir/public"
}

# build_fails <nom> <fixture> <texte attendu> : la construction doit échouer avec ce message.
build_fails() {
  local name="$1" fixture="$2" expected="$3" dir log
  dir="$(prepare "$name" "$fixture")"
  log="$dir/build.log"
  if (cd "$dir" && "$HUGO" --panicOnWarning --destination "$dir/public") >"$log" 2>&1; then
    fail "build_fails $name: la construction aurait dû échouer"
  elif ! grep -qF -- "$expected" "$log"; then
    fail "build_fails $name: message attendu « $expected » absent"
    sed 's/^/      /' "$log" >&2
  fi
}

assert_contains() {
  grep -qF -- "$2" "$1" 2>/dev/null || fail "assert_contains $1: « $2 » absent"
}

assert_not_contains() {
  if grep -qF -- "$2" "$1" 2>/dev/null; then fail "assert_not_contains $1: « $2 » présent"; fi
}

assert_count() {
  local n
  n="$( (grep -oF -- "$2" "$1" 2>/dev/null || true) | wc -l | tr -d ' ')"
  [ "$n" = "$3" ] || fail "assert_count $1: « $2 » trouvé $n fois, attendu $3"
}

# Vérifie un motif sur tous les fichiers générés d'un dossier.
assert_tree_not_contains() {
  local hits
  hits="$(grep -rlF -- "$2" "$1" 2>/dev/null || true)"
  [ -z "$hits" ] || fail "assert_tree_not_contains « $2 » présent dans : $hits"
}

# ---------------------------------------------------------------- tests

test_scaffold() {
  build_ok scaffold - OUT
  assert_contains "$OUT/fr/index.html" '<html lang="fr"'
  assert_contains "$OUT/en/index.html" '<html lang="en"'
  assert_contains "$OUT/fr/index.html" 'href="/en/"'
  assert_contains "$OUT/fr/index.html" 'href="/css/site.css"'
  assert_not_contains "$OUT/fr/index.html" '<script'
  assert_not_contains "$OUT/fr/index.html" 'style='
}

test_validation() {
  build_ok valide tests/fixtures/valide OUT
  build_fails sans-titre           tests/fixtures/sans-titre           'champ manquant: titre'
  build_fails statut-invalide      tests/fixtures/statut-invalide      'statut invalide: fini'
  build_fails une-etape            tests/fixtures/une-etape            'au moins 2 etapes'
  build_fails type-etape-invalide  tests/fixtures/type-etape-invalide  "type d'etape invalide: IA"
  build_fails sans-traduction      tests/fixtures/sans-traduction      'traduction manquante'
  build_fails section-inconnue     tests/fixtures/section-inconnue     'section inconnue: Probleme'
  build_fails realise-sans-risques tests/fixtures/realise-sans-risques 'section obligatoire manquante: Risques & garde-fous'
  build_ok html-brut tests/fixtures/html-brut OUT2
  assert_not_contains "$OUT2/fr/index.html" '<script'
}

test_tuiles() {
  build_ok tuiles tests/fixtures/valide OUT
  local fr="$OUT/fr/index.html" en="$OUT/en/index.html"
  assert_count "$fr" 'class="tuile"' 2
  local premier
  premier="$( (grep -o 'data-statut="[^"]*"' "$fr" || true) | head -1)"
  [ "$premier" = 'data-statut="realise"' ] || fail "première tuile : $premier, attendu realise"
  assert_contains "$fr" 'class="etape etape--controle"'
  assert_contains "$fr" '✓ Contrôle'
  assert_contains "$fr" 'class="etape etape--ia"'
  assert_contains "$fr" 'class="bloc bloc--risques"'
  assert_count "$fr" 'class="bloc bloc--lecons"' 1
  assert_contains "$fr" '<h3>Risques &amp; garde-fous</h3>'
  assert_contains "$en" '<h3>Problem</h3>'
  assert_not_contains "$en" 'Problème'
  assert_contains "$fr" '<h1>Geoffrey</h1>'
  assert_contains "$fr" 'href="https://www.linkedin.com/"'
  assert_contains "$fr" 'href="https://github.com/Djoff/portfolio-ia"'
  assert_contains "$fr" 'Hébergé en Suisse'
}

# ---------------------------------------------------------------- exécution

for t in $(declare -F | awk '{print $3}' | grep '^test_'); do
  CURRENT="$t"
  CURRENT_OK=1
  "$t"
  if [ "$CURRENT_OK" = 1 ]; then
    echo "PASS $t"
    PASSED=$((PASSED + 1))
  else
    echo "FAIL $t"
    FAILED=$((FAILED + 1))
  fi
done

echo "$PASSED passed, $FAILED failed"
[ "$FAILED" = 0 ]
