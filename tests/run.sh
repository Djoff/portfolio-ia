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

# Fichiers suivis par git contenant <mot> (sans tenir compte de la casse).
scan_depot() {
  (git -C "$ROOT" ls-files -z | (cd "$ROOT" && xargs -0 grep -li -- "$1") ) || true
}

# Liste privée, un mot par ligne : variable DENYLIST (secret de la CI, mots séparés
# par des virgules) et fichier local tests/.liste-privee, jamais versionné.
liste_privee() {
  if [ -n "${DENYLIST:-}" ]; then printf '%s\n' "$DENYLIST" | tr ',' '\n'; fi
  if [ -f "$ROOT/tests/.liste-privee" ]; then tr -d '\r' < "$ROOT/tests/.liste-privee"; fi
}

# ---------------------------------------------------------------- tests

test_scaffold() {
  build_ok scaffold - OUT
  assert_contains "$OUT/fr/index.html" '<html lang="fr"'
  assert_contains "$OUT/en/index.html" '<html lang="en"'
  assert_contains "$OUT/fr/index.html" 'href="/en/"'
  # La feuille de style porte l'empreinte de son contenu : un changement de style
  # change l'adresse, et les navigateurs ne gardent pas l'ancienne version en cache.
  local empreinte
  empreinte="$(md5sum "$ROOT/static/css/site.css" | cut -c1-10)"
  assert_contains "$OUT/fr/index.html" "href=\"/css/site.css?v=${empreinte}\""
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
  assert_contains "$fr" '<h1>Geoffrey Etwein</h1>'
  assert_contains "$fr" 'href="https://www.linkedin.com/in/geoffrey-etwein/"'
  assert_contains "$fr" 'href="https://github.com/Djoff/portfolio-ia"'
  assert_contains "$fr" 'Hébergé en Europe'
}

test_statut_arrete() {
  # Un projet arrêté a été réalisé : il s'affiche, avec son propre badge.
  build_ok statuts tests/fixtures/statuts OUT
  local fr="$OUT/fr/index.html" en="$OUT/en/index.html"
  assert_count "$fr" 'class="tuile"' 3
  assert_contains "$fr" 'class="badge badge--arrete">Arrêté</span>'
  assert_contains "$en" 'class="badge badge--arrete">Discontinued</span>'
  # Ordre : réalisé, en cours, arrêté, à venir.
  local ordre
  ordre="$(grep -o 'data-statut="[^"]*"' "$fr" | tr '\n' ' ')"
  [ "$ordre" = 'data-statut="realise" data-statut="arrete" data-statut="a-venir" ' ] || fail "ordre des tuiles : $ordre"
  assert_contains "$OUT/css/site.css" '.badge--arrete'
  # Comme un projet réalisé, il doit dire ce qu'il a donné.
  build_fails arrete-sans-resultat tests/fixtures/arrete-sans-resultat 'section obligatoire manquante: Résultat'
}

test_legende() {
  # Une seule légende par page, avec les trois types d'étapes, dans chaque langue.
  build_ok legende tests/fixtures/valide OUT
  local fr="$OUT/fr/index.html" en="$OUT/en/index.html"
  assert_count "$fr" 'class="legende"' 1
  assert_count "$en" 'class="legende"' 1
  assert_contains "$fr" '<span class="etape etape--ia">Étape réalisée par l&#39;IA</span>'
  assert_contains "$fr" '<span class="etape etape--controle">✓ Contrôle ou garde-fou</span>'
  assert_contains "$fr" '<span class="etape etape--normal">Étape standard</span>'
  assert_contains "$en" '<span class="etape etape--ia">Step performed by AI</span>'
  assert_contains "$en" '<span class="etape etape--controle">✓ Check or safeguard</span>'
  assert_contains "$en" '<span class="etape etape--normal">Standard step</span>'
  # Placée avant les tuiles.
  local l t
  l="$(grep -n 'class="legende"' "$fr" | head -1 | cut -d: -f1)"
  t="$(grep -n 'class="tuile"' "$fr" | head -1 | cut -d: -f1)"
  [ -n "$l" ] && [ -n "$t" ] && [ "$l" -lt "$t" ] || fail "la légende doit précéder les tuiles"
}

test_filtre() {
  # Désactivé par défaut (params.filtre = false) : ni boutons ni groupe.
  build_ok sans-filtre tests/fixtures/valide OUT0
  assert_not_contains "$OUT0/fr/index.html" 'class="filtre'
  assert_not_contains "$OUT0/fr/index.html" 'role="group"'
  assert_count "$OUT0/fr/index.html" 'class="tuile"' 2
  # Activé : le filtre reprend sa forme complète.
  export HUGO_PARAMS_FILTRE=true
  build_ok filtre tests/fixtures/valide OUT
  unset HUGO_PARAMS_FILTRE
  local fr="$OUT/fr/index.html"
  assert_contains "$fr" 'id="f-tous" class="filtre__choix" checked'
  assert_contains "$fr" 'id="f-realise"'
  assert_contains "$fr" 'id="f-a-venir"'
  assert_not_contains "$fr" 'id="f-en-cours"'
  assert_contains "$fr" 'for="f-a-venir"'
  assert_contains "$fr" 'role="group"'
  assert_contains "$OUT/en/index.html" '>All</label>'
}

test_design() {
  build_ok long tests/fixtures/long OUT
  assert_tree_not_contains "$OUT" 'style='
  assert_tree_not_contains "$OUT" '<script'
  assert_tree_not_contains "$OUT" 'src="http'
  local css="$OUT/css/site.css"
  assert_contains "$css" 'prefers-color-scheme: dark'
  assert_contains "$css" ':focus-visible'
  assert_contains "$css" 'prefers-reduced-motion'
  assert_contains "$css" '#f-realise:checked ~ .grille'
  assert_contains "$css" '#b23a2b'
  assert_contains "$css" '#e07a62'
  assert_not_contains "$css" 'url(http'
  assert_not_contains "$css" '@import'
}

# Texte du fichier $1 entre la première ligne contenant $2 et la première ligne contenant $3.
entre() {
  sed -n "/$2/,/$3/p" "$1"
}

test_langue() {
  # Le lien de langue est le plus haut possible sans avoir sa propre ligne : à droite du nom, dans la première ligne de l'en-tête.
  build_ok langue tests/fixtures/valide OUT
  local fr="$OUT/fr/index.html" en="$OUT/en/index.html"
  assert_count "$fr" 'class="langue"' 1
  assert_count "$en" 'class="langue"' 1
  assert_contains "$fr" 'hreflang="en" lang="en">English</a>'
  assert_contains "$en" 'hreflang="fr" lang="fr">Français</a>'
  entre "$fr" 'class="entete__haut"' 'class="entete__titre"' | grep -qF '<h1>' || fail "le nom doit être dans la première ligne de l'en-tête"
  entre "$fr" 'class="entete__haut"' 'class="entete__titre"' | grep -qF 'class="langue"' || fail "le lien de langue doit être sur la même ligne que le nom"
  # Il ne dépend ni de la légende ni du filtre.
  export HUGO_PARAMS_FILTRE=true
  build_ok langue-filtre tests/fixtures/valide OUT2
  unset HUGO_PARAMS_FILTRE
  assert_count "$OUT2/fr/index.html" 'class="langue"' 1
  entre "$OUT2/fr/index.html" 'class="entete__haut"' 'class="entete__titre"' | grep -qF 'class="langue"' || fail "avec filtre, le lien de langue reste dans l'en-tête"
}

test_lien() {
  # Le projet de la veille renvoie vers la veille publique, dans la langue du lecteur ; les autres tuiles n'ont pas de lien.
  build_ok lien - OUT
  assert_count "$OUT/fr/index.html" 'class="tuile__lien"' 1
  assert_contains "$OUT/fr/index.html" 'href="https://veille.forge74.com/fr/"'
  assert_contains "$OUT/fr/index.html" 'Lire la veille'
  assert_count "$OUT/en/index.html" 'class="tuile__lien"' 1
  assert_contains "$OUT/en/index.html" 'href="https://veille.forge74.com/en/"'
  assert_contains "$OUT/en/index.html" 'Read the watch'
  # Une clé de lien inconnue arrête la construction.
  build_fails lien-inconnu tests/fixtures/lien-inconnu 'lien inconnu: inconnu'
}

test_securite() {
  build_ok securite tests/fixtures/valide OUT
  local h="$OUT/.htaccess"
  assert_contains "$h" "Header always set Content-Security-Policy \"default-src 'none'; style-src 'self'; img-src 'self'; base-uri 'none'; form-action 'none'; frame-ancestors 'none'\""
  assert_contains "$h" 'Header always set Strict-Transport-Security "max-age=31536000; includeSubDomains"'
  assert_contains "$h" 'Header always set X-Content-Type-Options "nosniff"'
  assert_contains "$h" 'Header always set Referrer-Policy "strict-origin-when-cross-origin"'
  assert_contains "$h" 'camera=()'
  assert_contains "$h" 'microphone=()'
  assert_contains "$h" 'geolocation=()'
  assert_contains "$h" 'Options -Indexes'
  assert_contains "$h" 'RedirectMatch 404 /\.git(/|$)'
  assert_contains "$h" 'RewriteCond %{HTTP:Accept-Language} ^en'
  # Derrière un proxy TLS (fréquent en hébergement mutualisé), %{HTTPS} seul provoquerait une boucle de redirection.
  assert_contains "$h" 'RewriteCond %{HTTP:X-Forwarded-Proto} !https'
  # Une seule adresse : www redirige vers le domaine nu, directement en HTTPS.
  assert_contains "$h" 'RewriteCond %{HTTP_HOST} ^www\.(.+)$ [NC]'
  assert_contains "$h" 'RewriteRule ^ https://%1%{REQUEST_URI} [R=301,L]'
}

test_publication() {
  local w="$ROOT/.github/workflows/verifier.yml"
  # Publication : uniquement après des tests verts, sur main, sans écrasement de l'historique.
  assert_contains "$w" 'publier:'
  assert_contains "$w" 'needs: verifier'
  assert_contains "$w" "if: github.event_name == 'push' && github.ref == 'refs/heads/main'"
  assert_contains "$w" 'BRANCHE_SITE: site'
  assert_contains "$w" 'cancel-in-progress: false'
  assert_not_contains "$w" '--force'
  assert_not_contains "$w" 'push -f'
  # Le droit d'écriture est accordé à la seule tâche de publication.
  assert_count "$w" 'contents: write' 1
  local ecriture publier
  ecriture="$(grep -n 'contents: write' "$w" | cut -d: -f1)"
  publier="$(grep -n '^  publier:' "$w" | cut -d: -f1)"
  [ -n "$publier" ] && [ "$ecriture" -gt "$publier" ] || fail "contents: write hors de la tâche publier"
  # Toutes les actions tierces sont figées par empreinte de commit.
  local non_figees
  non_figees="$( (grep -E 'uses: ' "$w" | grep -vE '@[0-9a-f]{40}' ) || true)"
  [ -z "$non_figees" ] || fail "action non figée : $non_figees"
}

test_contenu() {
  build_ok contenu - OUT
  assert_count "$OUT/fr/index.html" 'class="tuile"' 9
  assert_count "$OUT/en/index.html" 'class="tuile"' 9
  # Les textes des projets ne contiennent ni lien ni identifiant technique.
  local motif hits
  for motif in webhook api_key apikey chat_id 'http://' 'https://'; do
    hits="$( (grep -rli -- "$motif" "$ROOT/content/fr" "$ROOT/content/en" "$ROOT/i18n" "$ROOT/data" || true) )"
    [ -z "$hits" ] || fail "contenu : « $motif » trouvé dans $hits"
  done
}

test_fuites() {
  # Le détecteur fonctionne : un mot présent dans le dépôt est bien trouvé.
  [ -n "$(scan_depot kogito)" ] || fail "scan_depot ne trouve pas un mot présent"
  # Aucun secret apparent dans les fichiers suivis.
  local hits
  hits="$( (git -C "$ROOT" ls-files -z | (cd "$ROOT" && xargs -0 grep -lE -- '(sk-[A-Za-z0-9]{16}|gh[pousr]_[A-Za-z0-9]{20}|xox[abp]-[A-Za-z0-9])') ) || true)"
  [ -z "$hits" ] || fail "secret apparent dans : $hits"
  # Liste privée (noms de clients, identifiants internes) : jamais dans le dépôt ni dans le site.
  build_ok fuites - OUT
  local mot n=0
  while IFS= read -r mot; do
    [ -n "$mot" ] || continue
    n=$((n + 1))
    hits="$(scan_depot "$mot")$( (grep -rli -- "$mot" "$OUT" || true) )"
    [ -z "$hits" ] || fail "mot de la liste privée n°$n trouvé dans : $hits"
  done < <(liste_privee)
  [ "$n" -gt 0 ] || echo "    (liste privée absente : définir DENYLIST ou tests/.liste-privee)" >&2
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
