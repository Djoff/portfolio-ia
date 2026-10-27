# Portfolio IA — cahier des charges

Date : 2026-10-27
Statut : en relecture

## 1. Objectif

Geoffrey, chef de projet IT généraliste, se spécialise en **stratégie et gouvernance de l'IA** (usage de l'IA, pas entraînement de modèles). Postes visés : Head of AI Product, AI Product Manager, responsable gouvernance IA.

Il veut une page web, partageable avec des recruteurs, qui présente sous forme de tuiles ses projets IA et d'automatisation — réalisés, en cours et à venir — et qui se met à jour facilement à mesure que des projets plus complexes arrivent.

**Critères de réussite**

- Un recruteur comprend en moins de 30 secondes le positionnement (produit + gouvernance IA) et voit les projets.
- Chaque projet met en avant les **risques identifiés et les garde-fous**, pas seulement la technique.
- Ajouter un projet = ajouter un fichier texte depuis l'interface web de GitHub, sans rien installer.
- Site publié en Suisse, note **A+** sur securityheaders.com et Mozilla Observatory.
- Affichage correct sur mobile, tablette et ordinateur, en mode clair et sombre.

## 2. Décisions prises

| Sujet | Décision |
|---|---|
| Technologie | Site statique généré par **Hugo** (exécutable unique, aucune dépendance npm) |
| Dépôt | GitHub, compte `Djoff`, dépôt public `portfolio-ia` |
| Hébergement | **Infomaniak, offre « Hébergement Web »** (pas de VPS) — phase 2 |
| Publication | GitHub Actions : vérification → build Hugo → envoi SFTP |
| Langues | Français et anglais |
| Contenu | Un fichier Markdown par projet et par langue |
| Identité | Nom + lien LinkedIn (pas de photo, pas d'e-mail, pas de formulaire) |
| Visuels | Schémas simplifiés générés depuis la liste des étapes |
| Design | Direction **B « éditorial suisse »** |
| Statistiques | Aucune (donc aucun cookie ni bandeau) |

## 3. Structure de la page

Une page par langue : `/fr/` et `/en/`. Un sélecteur FR/EN en haut de page. La racine `/` redirige selon la langue du navigateur (en-tête `Accept-Language`, règle dans `.htaccess`) : anglais → `/en/`, sinon `/fr/`. En local (phase 1, sans `.htaccess`), la racine affiche la version française.

Les styles sont dans une feuille CSS externe : aucun attribut `style` en ligne, pour rester compatible avec la CSP stricte (section 8).

De haut en bas :

1. **En-tête** : nom, titre « AI Product & Governance », 2–3 lignes de positionnement, lien LinkedIn.
2. **Filtre de statut** : Tous / Réalisés / En cours / À venir — réalisé en CSS pur (boutons radio + sélecteurs), sans JavaScript.
3. **Grille de tuiles** : 3 colonnes (ordinateur), 2 (tablette), 1 (mobile). Tri : statut (réalisé, en cours, à venir), puis date décroissante.
4. **Pied de page** : « Hébergé en Suisse · sans cookies ni traceurs », lien vers le dépôt GitHub.

### Tuile fermée

Badge de statut, titre, outils, résumé d'une phrase, miniature du schéma.

### Tuile ouverte

Dépliage sur place via l'élément HTML natif `<details>` (aucun JavaScript). Contenu :

- Schéma des étapes en grand
- **Problème**
- **Solution**
- **Risques & garde-fous** — encadré mis en avant
- **Résultat**
- **Ce que j'en retiens** — facultatif, masqué si vide

Une tuile « À venir » est en bordure pointillée ; seuls Problème et Solution sont obligatoires pour elle.

## 4. Format d'un fichier projet

Emplacements : `content/fr/projets/<slug>.md` et `content/en/projets/<slug>.md` (même `<slug>` dans les deux langues).

```markdown
---
titre: "Kogito Watch"
statut: "realise"            # realise | en-cours | a-venir
date: 2026-09-29
outils: ["n8n", "Baserow", "OpenRouter"]
resume: "Une veille IA quotidienne triée et résumée par un agent."
etapes:
  - { nom: "Sources", type: "normal" }
  - { nom: "Agent IA : tri", type: "ia" }
  - { nom: "Synthèse", type: "ia" }
  - { nom: "Contrôle", type: "controle" }
  - { nom: "Digest", type: "normal" }
---

## Problème
…

## Solution
…

## Risques & garde-fous
…

## Résultat
…

## Ce que j'en retiens
…
```

Les titres de section sont fixes (en anglais : Problem, Solution, Risks & safeguards, Outcome, Lessons learned). Le gabarit découpe le corps sur ces titres.

**Champs obligatoires** : `titre`, `statut`, `date`, `outils`, `resume`, `etapes` (au moins 2), sections Problème et Solution. Pour `realise` : aussi Risques & garde-fous et Résultat.

Un fichier `modele-projet.md` à la racine sert de modèle à copier.

## 5. Schéma des étapes

Généré par le gabarit Hugo en HTML/CSS (pas d'image, pas de JavaScript) à partir de `etapes`. Trois types :

- `normal` : fond beige
- `ia` : couleur d'accent (rouge brique)
- `controle` : fond foncé, préfixe ✓

Les étapes s'enchaînent avec des flèches et passent à la ligne sur mobile.

## 6. Design

Direction B validée sur maquette :

- **Clair** : fond crème `#f7f4ee`, texte `#22201c`, accent `#b23a2b`, tuiles blanches.
- **Sombre** (automatique via `prefers-color-scheme`) : fond `#1c1a17`, texte `#ece6db`, accent `#e07a62`.
- Titres en police à empattement **système** (Georgia et équivalents), texte en police sans empattement système. Aucune police téléchargée.
- Contraste conforme WCAG AA ; navigation clavier complète, focus visible.

## 7. Dépôt et publication

### Contenu du dépôt

```
content/fr/projets/      fichiers projets FR
content/en/projets/      fichiers projets EN
layouts/                 gabarits (page, tuile, schéma)
assets/ ou static/css/   feuille de style
static/.htaccess         en-têtes de sécurité + redirections
i18n/                    libellés FR/EN de l'interface
modele-projet.md         modèle de projet
LISEZMOI.md              mode d'emploi en français
.github/workflows/       automatisations
hugo.toml                configuration
```

`.superpowers/` et `skills-lock.json` sont exclus via `.gitignore`.

### Automatisations GitHub Actions

- **À chaque modification (phase 1)** : vérification des fichiers projets (champs obligatoires, paire FR/EN présente) puis build Hugo. Un échec bloque.
- **Publication (phase 2)** : sur la branche `main`, après vérification et build réussis, envoi SFTP vers Infomaniak. En cas d'échec, rien n'est publié et l'ancienne version reste en ligne ; GitHub envoie un e-mail.
- Version de Hugo **figée** ; actions tierces **figées par empreinte de commit** (SHA).

## 8. Sécurité

- Site : aucun JavaScript, aucune ressource externe, aucun cookie, aucun formulaire.
- En-têtes (`.htaccess`) :
  - `Content-Security-Policy: default-src 'none'; style-src 'self'; img-src 'self'; base-uri 'none'; form-action 'none'; frame-ancestors 'none'`
  - `Strict-Transport-Security: max-age=31536000; includeSubDomains` (preload envisagé plus tard)
  - `X-Content-Type-Options: nosniff`
  - `Referrer-Policy: strict-origin-when-cross-origin`
  - `Permissions-Policy` désactivant caméra, micro, géolocalisation, etc.
  - Redirection HTTP → HTTPS.
- Accès Infomaniak : compte SFTP dédié limité au dossier du site, clé SSH si l'offre le permet, stockée dans les secrets GitHub.
- Compte GitHub : commits signés avec `4498119+Djoff@users.noreply.github.com` ; double authentification à vérifier par Geoffrey.
- Contenu : relecture avant publication pour retirer URL de webhooks, noms de clients, identifiants internes. Les exports JSON de workflows ne sont jamais publiés.

## 9. Contenu initial

Projets proposés, à confirmer et rédiger avec Geoffrey (première version rédigée à partir des workflows n8n, en lecture seule) :

1. Kogito Watch — veille IA automatisée
2. Chaîne de production de contenu vidéo avec fact-check
3. Fiche produit et prix à partir d'une photo — anonymisé
4. Supervision des automatisations (alertes Telegram)
5. Ce site — conçu pour être sûr dès le départ

## 10. Phases

**Phase 1 — construire (sans Infomaniak)** : dépôt, site complet FR/EN, contenu initial, vérification automatique, tests locaux. Fin : site terminé, testé, non public.

**Phase 2 — mettre en ligne (quand Infomaniak est prêt)** : domaine et HTTPS, compte SFTP, publication automatique, contrôle des en-têtes (A+).

## 11. Tests

- Build Hugo sans erreur ni avertissement.
- Vérification automatique : un fichier incomplet fait échouer la vérification.
- Affichage : mobile (375 px), tablette (768 px), ordinateur ; clair et sombre ; FR et EN.
- Filtre de statut et dépliage des tuiles fonctionnels sans JavaScript.
- Accessibilité : contrastes, navigation clavier.
- Après mise en ligne : securityheaders.com et Mozilla Observatory à A+ ; aucune requête externe dans l'onglet réseau.

## 12. Données à fournir par Geoffrey

- Nom affiché et URL du profil LinkedIn.
- Texte de positionnement (première version proposée par Claude).
- Validation et corrections des textes de projets.
- Phase 2 : achat du domaine et de l'hébergement Infomaniak, création de l'accès SFTP (guidée).

## 13. Hors périmètre (version 1)

Statistiques de visite, pages de détail séparées, téléchargement de CV, audit du VPS Hostinger.
