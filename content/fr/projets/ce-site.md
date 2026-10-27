---
titre: "Ce site, sûr dès la conception"
statut: "en-cours"
date: 2026-10-27
outils: ["Hugo", "GitHub Actions", "Claude Code", "Infomaniak"]
resume: "Une vitrine de projets conçue avec un assistant IA de développement, en réduisant au minimum ce qui peut être attaqué."
etapes:
  - { nom: "Cadrage et cahier des charges", type: "normal" }
  - { nom: "Réalisation avec un assistant IA", type: "ia" }
  - { nom: "Tests automatiques", type: "controle" }
  - { nom: "Revue de sécurité", type: "controle" }
  - { nom: "Publication en Suisse", type: "normal" }
---

## Problème

Présenter mes projets à des recruteurs sans que la vitrine elle-même devienne un risque, au moment où les failles liées à l'IA et à la chaîne logicielle se multiplient.

## Solution

Un site statique bilingue généré par Hugo : chaque projet est un simple fichier texte, vérifié automatiquement avant publication. Le site est conçu et réalisé avec un assistant IA de développement, encadré par un cahier des charges, des tests et une revue de sécurité.

## Risques & garde-fous

- **Chaîne d'approvisionnement logicielle** → un seul outil de génération, sans dépendances npm ; versions figées et vérifiées par empreinte.
- **Injection de code (XSS)** → aucun JavaScript et une politique de sécurité (CSP) qui interdit tout script.
- **Exposition de données** → aucun formulaire, cookie ni traceur ; aucune donnée interne publiée, avec un contrôle automatique.
- **Code produit par l'IA** → chaque étape est testée avant d'être acceptée, puis l'ensemble est relu.

## Résultat

Site terminé et testé localement ; mise en ligne en Suisse à venir.
