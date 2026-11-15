---
titre: "Ce site, sûr dès la conception"
statut: "realise"
date: 2026-10-27
outils: ["Hugo", "GitHub Actions", "Claude Code", "Hostinger"]
resume: "Une vitrine de projets conçue avec un assistant IA de développement, en réduisant au minimum ce qui peut être attaqué."
etapes:
  - { nom: "Cadrage et cahier des charges", type: "normal" }
  - { nom: "Réalisation avec un assistant IA", type: "ia" }
  - { nom: "Tests automatiques", type: "controle" }
  - { nom: "Revue de sécurité", type: "controle" }
  - { nom: "Publication automatique en Europe", type: "normal" }
---

## Problème

Présenter mes projets à des recruteurs sans que la vitrine elle-même devienne un risque, au moment où les failles liées à l'IA et à la chaîne logicielle se multiplient.

## Solution

Un site statique bilingue généré par Hugo : chaque projet est un simple fichier texte, vérifié automatiquement avant publication. Le site est conçu et réalisé avec un assistant IA de développement, encadré par un cahier des charges, des tests et une revue de sécurité. La publication est automatique : chaque modification est testée, puis mise en ligne sans intervention manuelle.

## Risques & garde-fous

- **Chaîne d'approvisionnement logicielle** → un seul outil de génération, sans dépendances npm ; versions figées et vérifiées par empreinte.
- **Injection de code (XSS)** → aucun JavaScript et une politique de sécurité (CSP) qui interdit tout script.
- **Exposition de données** → aucun formulaire, cookie ni traceur ; aucune donnée interne publiée, avec un contrôle automatique.
- **Code produit par l'IA** → chaque étape est testée avant d'être acceptée, puis l'ensemble est relu.
- **Mise en ligne d'une version défaillante** → la publication n'a lieu que si tous les tests sont verts ; sinon, l'ancienne version reste en ligne. L'hébergeur lit le site publié, sans aucun accès en écriture au code.

## Résultat

Site en ligne, noté A+ par securityheaders.com et Mozilla Observatory. Ajouter un projet revient à déposer un fichier texte : il est en ligne une à deux minutes plus tard.
