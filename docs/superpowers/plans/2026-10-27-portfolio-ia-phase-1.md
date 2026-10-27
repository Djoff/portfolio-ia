# Portfolio IA — Phase 1 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the bilingual (FR/EN) static portfolio site with Hugo — tiles, generated step diagrams, CSS-only status filter, security headers file, initial content and CI checks — finished and tested locally, not yet public.

**Architecture:** Hugo renders one home page per language from Markdown project files. Templates validate each project file and stop the build with `errorf` when a required field or section is missing, so "tests" are Hugo builds on fixture content driven by one Bash script. No JavaScript, no external resources; all styling in one external CSS file.

**Tech Stack:** Hugo standard edition 0.168.0 (no npm), HTML/CSS, Bash test script, GitHub Actions.

**Spec:** `docs/superpowers/specs/2026-10-27-portfolio-ia-design.md`

## Global Constraints

- Hugo version pinned: `0.168.0` (local install and CI).
- No JavaScript anywhere in the output: no `<script`, no `on*=` attributes.
- No inline styles: no `style=` attribute in any generated HTML (CSP `style-src 'self'`).
- No external resources: no `http(s)://` in any `src=` or CSS `url()`; only `href` to LinkedIn and GitHub.
- No fonts downloaded: titles `Georgia, "Times New Roman", serif`; text `system-ui, -apple-system, "Segoe UI", Roboto, sans-serif`.
- Colors light: background `#f7f4ee`, text `#22201c`, accent `#b23a2b`, tiles `#ffffff`. Dark (`prefers-color-scheme: dark`): background `#1c1a17`, text `#ece6db`, accent `#e07a62`.
- `statut` values: `realise` | `en-cours` | `a-venir`. Étape `type` values: `normal` | `ia` | `controle`.
- Section headings (FR / EN): `Problème`/`Problem`, `Solution`/`Solution`, `Risques & garde-fous`/`Risks & safeguards`, `Résultat`/`Outcome`, `Ce que j'en retiens`/`Lessons learned`.
- Commits authored with `4498119+Djoff@users.noreply.github.com` (already set in local git config); every commit message ends with `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`.
- Never publish n8n workflow JSON, webhook URLs, client names or internal IDs.

## Review Focus

1. A section heading typed slightly differently (`Probleme`, `Risques et garde-fous`) → build fails naming the file and the unknown heading, instead of silently dropping the section. Test in Task 2.
2. Raw HTML in a project body (e.g. `<script>alert(1)</script>`) → not rendered as HTML (Goldmark `unsafe = false`); output contains no `<script`. Test in Task 2.
3. A status with zero projects → its filter button is not rendered (no empty filter view). Test in Task 4.
4. Long titles and 6+ étapes at 375 px width → steps wrap, no horizontal page scroll. Check in Task 5.
5. An unknown étape `type` (e.g. `IA`) → build fails naming the file and the value. Test in Task 2.

---

## File Structure

```
hugo.toml                          site config, languages, params (nom, linkedin, github)
i18n/fr.toml, i18n/en.toml         UI labels + positioning text
data/sections.yaml                 canonical section keys ↔ FR/EN headings
layouts/index.html                 home page (header, filter, grid, footer)
layouts/_default/baseof.html       HTML skeleton (lang, meta, CSS link, lang switcher)
layouts/partials/projet/valider.html   validation (errorf)
layouts/partials/projet/sections.html  split rendered body into sections → dict
layouts/partials/projet/tuile.html     one tile (<details>)
layouts/partials/projet/schema.html    step diagram
layouts/partials/filtre.html           CSS-only status filter
static/css/site.css                all styles
static/.htaccess                   security headers, HTTPS + language redirect
content/fr/projets/*.md, content/en/projets/*.md   projects
content/fr/_index.md, content/en/_index.md          home pages (empty body)
modele-projet.md, LISEZMOI.md      template + French how-to
tests/run.sh                       test runner
tests/fixtures/<case>/fr|en/...    fixture content
.github/workflows/verifier.yml     CI
```

**Shared interfaces (used across tasks):**

- `site.Params.nom` (string), `site.Params.linkedin` (URL), `site.Params.github` (URL).
- i18n keys: `titre_pro`, `positionnement`, `filtre_tous`, `statut_realise`, `statut_en-cours`, `statut_a-venir`, `pied_hebergement`, `voir_code`, `autre_langue`.
- `data/sections.yaml`: keys `probleme`, `solution`, `risques`, `resultat`, `lecons`, each `{fr: "...", en: "..."}`.
- `partial "projet/sections.html" .` → `dict` with those five keys, values = HTML strings (`""` when absent).
- `partial "projet/valider.html" .` → renders nothing; calls `errorf` with message `"<file path>: <problem>"`.
- Tile root: `<details class="tuile" data-statut="{{ .Params.statut }}">`; step: `<li class="etape etape--{type}">`.
- Filter inputs: `<input type="radio" name="filtre" id="f-{statut}" class="filtre__choix">` with `id="f-tous"` for all.

## Test runner contract (`tests/run.sh`)

Bash, `set -euo pipefail`, runnable from Git Bash and Ubuntu. Helpers:

- `build_ok <name> <fixture-dir|-> <outdir-var>`: copies the repo (excluding `.git`, `public`, `content`, `tests`) to a temp dir, copies the fixture as `content/` (or the real `content/` when `-`), runs `hugo --quiet --panicOnWarning --destination "$tmp/public"`; fails the test if exit ≠ 0.
- `build_fails <name> <fixture-dir> <expected substring>`: same, but passes only if exit ≠ 0 **and** stderr contains the substring.
- `assert_contains <file> <text>`, `assert_not_contains <file> <text>`, `assert_count <file> <text> <n>`.
- Prints `PASS <name>` / `FAIL <name>`; exits 1 if any test failed; final line `N passed, M failed`.

Run: `bash tests/run.sh` → expected last line `N passed, 0 failed`.

---

### Task 1: Hugo scaffold, languages and test runner

**Files:**
- Create: `hugo.toml`, `i18n/fr.toml`, `i18n/en.toml`, `content/fr/_index.md`, `content/en/_index.md`, `layouts/_default/baseof.html`, `layouts/index.html` (minimal), `tests/run.sh`

**Interfaces:**
- Produces: `site.Params.nom|linkedin|github`, i18n keys listed above, `tests/run.sh` helpers.

- [ ] **Step 1: Install Hugo 0.168.0** — `winget install --id Hugo.Hugo -e --version 0.168.0 --source winget`; verify `hugo version` prints `v0.168.0`.
- [ ] **Step 2: Ask Geoffrey for display name and LinkedIn URL** (spec §12). Until answered, use `nom = "Geoffrey"` and `linkedin = "https://www.linkedin.com/"` and note it in the task report.
- [ ] **Step 3: Write `tests/run.sh`** with the helpers above and the first tests:

```bash
test_scaffold() {
  build_ok scaffold - OUT
  assert_contains "$OUT/fr/index.html" '<html lang="fr"'
  assert_contains "$OUT/en/index.html" '<html lang="en"'
  assert_contains "$OUT/fr/index.html" 'href="/en/"'
  assert_contains "$OUT/fr/index.html" 'href="/css/site.css"'
  assert_not_contains "$OUT/fr/index.html" '<script'
  assert_not_contains "$OUT/fr/index.html" 'style='
}
```

- [ ] **Step 4: Run** `bash tests/run.sh` → FAIL (no config).
- [ ] **Step 5: Write `hugo.toml`**: `defaultContentLanguage = "fr"`, `defaultContentLanguageInSubdir = true`, `disableKinds = ["taxonomy","term","RSS"]`, languages `fr` (`contentDir = "content/fr"`, weight 1) and `en` (`contentDir = "content/en"`, weight 2), `[markup.goldmark.renderer] unsafe = false`, `[params]` nom/linkedin/github (`https://github.com/Djoff/portfolio-ia`). Write `baseof.html` (lang attribute, charset, viewport, `<link rel="stylesheet" href="/css/site.css">`, language switcher link to the other translation using `autre_langue`). Minimal `index.html` defining `main`. Create empty `static/css/site.css`.
- [ ] **Step 6: Run** `bash tests/run.sh` → `1 passed, 0 failed`.
- [ ] **Step 7: Commit** — `git add hugo.toml i18n content layouts static tests && git commit -m "feat: squelette Hugo bilingue et script de tests"` (+ Co-Authored-By).

---

### Task 2: Project file validation and section splitting

**Files:**
- Create: `data/sections.yaml`, `layouts/partials/projet/valider.html`, `layouts/partials/projet/sections.html`, fixtures under `tests/fixtures/`
- Modify: `layouts/index.html` (call `valider.html` for every page in section `projets`), `tests/run.sh`

**Interfaces:**
- Consumes: `tests/run.sh` helpers.
- Produces: `partial "projet/valider.html"`, `partial "projet/sections.html"` (see shared interfaces).

**Validation rules** (spec §4), each an `errorf "%s: <message>" .File.Path`:
- missing/empty `titre`, `statut`, `date`, `outils`, `resume` → `champ manquant: <name>`
- `statut` not in allowed list → `statut invalide: <value>`
- fewer than 2 `etapes` → `au moins 2 etapes`; étape `type` not allowed → `type d'etape invalide: <value>`
- no translation (`not .IsTranslated`) → `traduction manquante`
- an `<h2>` heading not in `data/sections.yaml` for the page language → `section inconnue: <heading>`
- `probleme` or `solution` empty → `section obligatoire manquante: <heading>`; when `statut = realise`, also `risques` and `resultat`.

`sections.html`: split `.Content` on `<h2`; map each heading's text (after `plainify | htmlUnescape | strings.TrimSpace`) to its key via `data/sections.yaml`; body = HTML after the closing `</h2>`.

- [ ] **Step 1: Create fixtures** — `tests/fixtures/valide/` (one complete `realise` project FR+EN, one `a-venir` with only Problème/Solution) and one fixture per failing case: `sans-titre`, `statut-invalide`, `une-etape`, `type-etape-invalide` (`type: "IA"`), `sans-traduction` (FR only), `section-inconnue` (`## Probleme`), `realise-sans-risques`, `html-brut` (valid project whose Problème contains `<script>alert(1)</script>`).
- [ ] **Step 2: Add tests**

```bash
test_validation() {
  build_ok valide tests/fixtures/valide OUT
  build_fails sans-titre          tests/fixtures/sans-titre          'champ manquant: titre'
  build_fails statut-invalide     tests/fixtures/statut-invalide     'statut invalide: fini'
  build_fails une-etape           tests/fixtures/une-etape           'au moins 2 etapes'
  build_fails type-etape-invalide tests/fixtures/type-etape-invalide "type d'etape invalide: IA"
  build_fails sans-traduction     tests/fixtures/sans-traduction     'traduction manquante'
  build_fails section-inconnue    tests/fixtures/section-inconnue    'section inconnue: Probleme'
  build_fails realise-sans-risques tests/fixtures/realise-sans-risques 'section obligatoire manquante: Risques & garde-fous'
  build_ok html-brut tests/fixtures/html-brut OUT2
  assert_not_contains "$OUT2/fr/index.html" '<script'
}
```

- [ ] **Step 3: Run** → the `build_fails` tests FAIL (no validation yet).
- [ ] **Step 4: Implement** `data/sections.yaml`, `valider.html`, `sections.html`; call the validator from `index.html` for `where site.RegularPages "Section" "projets"`.
- [ ] **Step 5: Run** `bash tests/run.sh` → all pass.
- [ ] **Step 6: Commit** — `feat: validation des fichiers projets`.

---

### Task 3: Tiles, step diagram and page structure

**Files:**
- Create: `layouts/partials/projet/tuile.html`, `layouts/partials/projet/schema.html`
- Modify: `layouts/index.html`, `i18n/*.toml`, `tests/run.sh`

**Interfaces:**
- Consumes: `sections.html` dict, `site.Params`, i18n keys.
- Produces: tile and step markup (shared interfaces), consumed by the CSS in Task 5.

**Markup decisions:**
- Header: `<header class="entete">` with `<h1>` = `site.Params.nom`, `<p class="entete__titre">` = `titre_pro`, `<p class="entete__texte">` = `positionnement`, LinkedIn link `rel="noopener noreferrer me"`.
- Grid: `<section class="grille">`; order = `realise`, `en-cours`, `a-venir`, then `date` descending.
- Tile: `<details class="tuile" data-statut="...">` → `<summary>` holds badge (`<span class="badge badge--{statut}">` with i18n label), `<h2 class="tuile__titre">`, tools list `<ul class="outils">`, `<p class="tuile__resume">`, compact diagram; body holds full diagram then each non-empty section as `<section class="bloc bloc--{key}"><h3>{heading}</h3>{html}</section>`, in order probleme, solution, risques, resultat, lecons.
- Diagram: `<ol class="schema">` of `<li class="etape etape--{type}">`; `controle` steps prefixed `✓ `; arrows drawn by CSS (no extra markup).
- Footer: `<footer class="pied">` with `pied_hebergement` and link to `site.Params.github` (`voir_code`).

- [ ] **Step 1: Add tests** (against `tests/fixtures/valide`): `assert_count fr/index.html 'class="tuile"' 2`; first tile has `data-statut="realise"`; `class="etape etape--controle"` present and contains `✓`; `class="bloc bloc--risques"` present; `bloc--lecons` absent for the `a-venir` project; EN page shows `Problem` not `Problème`; header contains `site.Params.nom` and the LinkedIn href.
- [ ] **Step 2: Run** → FAIL.
- [ ] **Step 3: Implement** partials and `index.html`; add i18n labels (FR/EN) for badges, header and footer. Positioning text first draft: FR « Chef de projet IT, je pilote l'adoption de l'IA en entreprise : cadrage produit, gouvernance, maîtrise des risques. Ces projets montrent comment je conçois, teste et sécurise des usages concrets de l'IA. » — EN equivalent. Mark it as draft for Geoffrey's review.
- [ ] **Step 4: Run** → all pass.
- [ ] **Step 5: Commit** — `feat: tuiles, schémas et structure de page`.

---

### Task 4: CSS-only status filter

**Files:**
- Create: `layouts/partials/filtre.html`
- Modify: `layouts/index.html`, `tests/run.sh`

**Interfaces:**
- Consumes: tile `data-statut`.
- Produces: radio inputs `#f-tous`, `#f-realise`, `#f-en-cours`, `#f-a-venir` (class `filtre__choix`) placed **before** `.grille` as siblings, each with a `<label for>`; CSS rule pattern for Task 5: `#f-realise:checked ~ .grille .tuile:not([data-statut="realise"]) { display: none; }`.

- [ ] **Step 1: Add tests** — fixture `valide` (statuses `realise` and `a-venir`): `f-tous` present and `checked`; `f-realise` and `f-a-venir` present; `f-en-cours` absent (Review Focus 3). Real content (`-`) builds.
- [ ] **Step 2: Run** → FAIL.
- [ ] **Step 3: Implement** `filtre.html`: render a status input only if at least one project has that status; wrap labels in a `role="group"` with an i18n `aria-label`.
- [ ] **Step 4: Run** → all pass.
- [ ] **Step 5: Commit** — `feat: filtre de statut sans JavaScript`.

---

### Task 5: Design (style B), responsive, dark mode, accessibility

**Files:**
- Modify: `static/css/site.css`, `tests/run.sh`
- Create: `tests/fixtures/long/` (a project with a 70-character title and 7 étapes)

- [ ] **Step 1: Add tests** — `build_ok long tests/fixtures/long OUT`; over the whole output: no `style=`, no `<script`, no `http` inside `src=`; `site.css` contains `prefers-color-scheme: dark`, `:focus-visible`, and no `url(http`.
- [ ] **Step 2: Implement `site.css`** with the Global Constraints colors and fonts, CSS custom properties redefined in the dark media query; grid `repeat(auto-fill, minmax(18rem, 1fr))` giving 3/2/1 columns; tiles per the validated mockup (`.superpowers/brainstorm/*/content/tile-detail.html`); étapes `flex-wrap: wrap`, arrows via `.etape + .etape::before { content: "›" }`; `a-venir` tiles dashed border; `.bloc--risques` framed with accent left border; filter rules from Task 4; visible focus on `summary`, labels and links; `prefers-reduced-motion` respected.
- [ ] **Step 3: Run** `bash tests/run.sh` → all pass.
- [ ] **Step 4: Visual check** — `hugo server --port 1313`, open in the built-in browser at 375×812, 768×1024 and desktop, light and dark, FR and EN, with the `long` fixture and real content. Expected: no horizontal scroll at 375 px (Review Focus 4), steps wrap, tiles open/close with mouse and keyboard (Tab + Enter), filter works, text contrast ≥ 4.5:1 (check accent on cream and on dark).
- [ ] **Step 5: Commit** — `feat: design éditorial, responsive et mode sombre`.

---

### Task 6: Security headers and redirects

**Files:**
- Create: `static/.htaccess`
- Modify: `tests/run.sh`

- [ ] **Step 1: Add tests** — output `.htaccess` contains exactly these lines (values from spec §8):

```
Header always set Content-Security-Policy "default-src 'none'; style-src 'self'; img-src 'self'; base-uri 'none'; form-action 'none'; frame-ancestors 'none'"
Header always set Strict-Transport-Security "max-age=31536000; includeSubDomains"
Header always set X-Content-Type-Options "nosniff"
Header always set Referrer-Policy "strict-origin-when-cross-origin"
```

and a `Permissions-Policy` line containing `camera=()`, `microphone=()`, `geolocation=()`.
- [ ] **Step 2: Run** → FAIL.
- [ ] **Step 3: Implement** `.htaccess`: the headers above; `RewriteEngine On`; HTTP → HTTPS 301; on `/` only: `Accept-Language` starting with `en` → 302 `/en/`, otherwise 302 `/fr/`; `Options -Indexes`. Note in the file header that it is verified on Infomaniak in phase 2.
- [ ] **Step 4: Run** → all pass.
- [ ] **Step 5: Commit** — `feat: en-têtes de sécurité et redirections`.

---

### Task 7: Initial content, template and how-to

**Files:**
- Create: `content/fr/projets/{kogito-watch,production-video,fiche-produit,supervision,ce-site}.md` and the same five in `content/en/projets/`; `modele-projet.md`; `LISEZMOI.md`
- Modify: `tests/run.sh`

- [ ] **Step 1: Read source workflows (read-only)** via n8n MCP `n8n_get_workflow`: Kogito Watch Digest v7, EB création scripts simplifié, EB fact-check, product sheet, product sheet + price, Error log Telegram. Extract only purpose, steps, models used and safeguards. Never copy URLs, credentials, IDs, chat IDs or client names.
- [ ] **Step 2: Write the 5 FR projects + EN translations** following spec §4. Fiche produit: anonymized (« une boutique de seconde main »), no client names. « Ce site »: statut `realise`, risks = supply chain, XSS, data exposure; safeguards = Hugo without npm, strict CSP, no JS, Swiss hosting. Mark `Résultat` and `Ce que j'en retiens` as drafts for Geoffrey.
- [ ] **Step 3: Add test** — `build_ok contenu - OUT`; `assert_count "$OUT/fr/index.html" 'class="tuile"' 5`; whole `content/` contains none of: `webhook`, `n8n.`, `api_key`, `chat_id`.
- [ ] **Step 4: Run** → all pass.
- [ ] **Step 5: Write `modele-projet.md`** (front matter + five headings with one-line hints, FR and EN headings listed) and **`LISEZMOI.md`** in French: add a project from github.com in 5 steps (copy template → create `content/fr/projets/<slug>.md` → same slug in `content/en/projets/` → commit → check the green tick in Actions), meaning of `statut` and étape types, what to do when the check is red.
- [ ] **Step 6: Geoffrey reviews all texts** — present each project's FR text; apply corrections; re-run tests.
- [ ] **Step 7: Commit** — `feat: contenu initial, modèle et mode d'emploi`.

---

### Task 8: GitHub repository and CI

**Files:**
- Create: `.github/workflows/verifier.yml`

- [ ] **Step 1: Write `verifier.yml`** — triggers `push` and `pull_request`; `permissions: contents: read`; runner `ubuntu-24.04`; `actions/checkout` pinned to the full commit SHA of its latest release (resolve with `gh api repos/actions/checkout/releases/latest` then `gh api repos/actions/checkout/git/ref/tags/<tag>`), `persist-credentials: false`; install Hugo by downloading `hugo_0.168.0_linux-amd64.tar.gz` and `hugo_0.168.0_checksums.txt` from the GitHub release and verifying with `sha256sum --check --ignore-missing`; run `bash tests/run.sh`.
- [ ] **Step 2: Commit** — `ci: vérification automatique des projets`.
- [ ] **Step 3: Confirm with Geoffrey before publishing** — creating the public repo `Djoff/portfolio-ia` publishes the content. Show `git log --stat` and wait for an explicit yes.
- [ ] **Step 4: Create and push** — `gh repo create Djoff/portfolio-ia --public --source . --push --description "Portfolio IA & automatisation"`.
- [ ] **Step 5: Verify CI** — `gh run list --limit 1` shows the run; report its result to Geoffrey (do not poll repeatedly; check once it has had time to finish).
- [ ] **Step 6: Verify a red check blocks** — on a branch, commit a project without `titre`, push, confirm the run fails with `champ manquant: titre`, then delete the branch.

---

## Phase 2 (separate plan, once Infomaniak is ready)

Domain + HTTPS, dedicated SFTP account, deploy job in CI, live header check (securityheaders.com, Mozilla Observatory: A+), HSTS preload decision.
