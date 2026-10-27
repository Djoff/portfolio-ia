---
titre: "Supervision des automatisations"
statut: "realise"
date: 2026-04-06
outils: ["n8n", "Telegram"]
resume: "Quand un workflow échoue, une alerte arrive aussitôt sur mon téléphone."
etapes:
  - { nom: "Erreur dans un workflow", type: "normal" }
  - { nom: "Capture de l'erreur", type: "controle" }
  - { nom: "Alerte Telegram", type: "normal" }
---

## Problème

Une automatisation qui échoue en silence est pire qu'une absence d'automatisation : on croit que le travail est fait.

## Solution

Un workflow d'erreur dédié est déclenché par n8n dès qu'un workflow qui y est rattaché échoue. Il envoie aussitôt une alerte sur Telegram avec le nom du workflow et l'erreur.

## Risques & garde-fous

- **Échec silencieux** → chaque erreur d'un workflow supervisé produit une alerte immédiate.
- **Angle mort** → cette alerte ne couvre pas une panne de n8n lui-même : une surveillance externe reste à ajouter.
- **Diagnostic lent** → l'alerte indique quel workflow a échoué et pourquoi.

## Résultat

Les incidents sont signalés dès qu'ils surviennent, au lieu d'être découverts par hasard.

## Ce que j'en retiens

La supervision n'est pas un ajout de fin de projet : c'est la première chose à mettre en place avant d'automatiser quoi que ce soit d'important.
