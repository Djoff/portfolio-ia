---
titre: "Fiche produit et prix à partir de photos"
statut: "realise"
date: 2026-10-08
outils: ["n8n", "Telegram", "Claude", "Baserow"]
resume: "Envoyer des photos d'un article d'occasion par messagerie suffit pour obtenir sa fiche produit et une estimation de prix."
etapes:
  - { nom: "Photos par Telegram", type: "normal" }
  - { nom: "Expéditeur autorisé ?", type: "controle" }
  - { nom: "Regroupement de l'album", type: "normal" }
  - { nom: "Fiche produit", type: "ia" }
  - { nom: "Estimation de prix", type: "ia" }
  - { nom: "Calcul des prix", type: "controle" }
  - { nom: "Enregistrement + confirmation", type: "normal" }
---

## Problème

Pour un vendeur d'articles d'occasion, rédiger chaque fiche produit et fixer un prix est long et répétitif.

## Solution

Le vendeur envoie les photos d'un article par Telegram. Le workflow attend que tout l'album soit reçu, puis un modèle d'IA rédige la fiche produit et propose une estimation. Les prix finaux sont calculés par des règles fixes, la fiche est enregistrée en base avec un code interne, et une confirmation est renvoyée au vendeur.

## Risques & garde-fous

- **Accès non autorisé** → seuls les expéditeurs autorisés peuvent déclencher le workflow.
- **Prix fantaisiste de l'IA** → l'IA estime, mais le prix final est calculé par des règles déterministes.
- **Erreur non vue** → le vendeur reçoit une confirmation et garde la main sur la mise en vente.
- **Données résiduelles** → les données temporaires de l'album sont supprimées après traitement.

## Résultat

La création d'une fiche passe d'une tâche manuelle à un simple envoi de photos, avec un humain qui valide.

## Ce que j'en retiens

L'IA est excellente pour décrire, moins fiable pour chiffrer : la combiner avec des règles explicites donne le meilleur des deux.
