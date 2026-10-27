# Portfolio IA — mode d'emploi

Site statique bilingue (français / anglais) généré par [Hugo](https://gohugo.io/). Chaque projet est un simple fichier texte.

## Ajouter un projet en 5 minutes (depuis github.com)

1. Ouvrez [`modele-projet.md`](modele-projet.md) et copiez tout son contenu.
2. Allez dans `content/fr/projets/`, cliquez sur **Add file → Create new file**, nommez le fichier en minuscules sans espace ni accent (par exemple `agent-rag.md`), collez le modèle et remplissez-le en français.
3. Faites de même dans `content/en/projets/`, **avec exactement le même nom de fichier**, en anglais.
4. Cliquez sur **Commit changes**.
5. Ouvrez l'onglet **Actions** : une coche verte signifie que le projet est valide.

## Les champs

| Champ | Valeurs |
|---|---|
| `statut` | `realise` (réalisé), `en-cours`, `a-venir` — sans accents |
| `date` | `AAAA-MM-JJ` ; les tuiles sont triées par statut puis par date, la plus récente d'abord |
| `etapes` | au moins 2 ; `type` vaut `normal`, `ia` (couleur d'accent) ou `controle` (foncé, avec ✓) |

Les titres de section doivent être écrits exactement comme dans le modèle. « Ce que j'en retiens » est facultatif.

## Si la vérification est rouge

Ouvrez l'exécution en échec dans l'onglet **Actions** : le message indique le fichier et le problème, par exemple :

- `champ manquant: titre` — un champ obligatoire est vide ou absent ;
- `statut invalide: fini` — le statut n'est pas l'une des trois valeurs ;
- `traduction manquante (en)` — le fichier n'existe pas dans l'autre langue ;
- `section inconnue: Probleme` — un titre de section est mal orthographié ;
- `section obligatoire manquante: Résultat` — un projet réalisé doit avoir Risques & garde-fous et Résultat.

Corrigez le fichier, validez à nouveau : rien n'est publié tant que la vérification n'est pas verte.

## Ce qu'il ne faut jamais publier

URL de webhooks, clés d'API, identifiants, noms de clients, exports JSON de workflows. Une vérification automatique bloque les cas les plus courants, mais relisez toujours avant de valider.

## Pour les curieux

- `bash tests/run.sh` lance tous les tests (Hugo 0.168.0 requis).
- `hugo server` affiche le site en local sur http://localhost:1313/fr/.
- Sécurité : aucun JavaScript, aucune ressource externe, en-têtes de sécurité dans `static/.htaccess`.
- Conception : [`docs/superpowers/specs/`](docs/superpowers/specs/).
