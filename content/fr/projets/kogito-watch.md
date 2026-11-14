---
titre: "Kogito Watch"
statut: "realise"
date: 2026-09-29
outils: ["n8n", "Baserow", "OpenRouter", "Gmail"]
resume: "Une veille automatisée : un agent IA lit les flux d'actualité, retient l'essentiel et envoie un digest."
etapes:
  - { nom: "Configuration", type: "normal" }
  - { nom: "Flux RSS", type: "normal" }
  - { nom: "Dédoublonnage", type: "controle" }
  - { nom: "Analyse par l'IA", type: "ia" }
  - { nom: "Sélection", type: "ia" }
  - { nom: "Digest par e-mail", type: "normal" }
  - { nom: "Journal envoyés / rejetés", type: "controle" }
---

## Problème

Suivre l'actualité de plusieurs sources prend du temps, et la plupart des articles ne sont pas pertinents.

## Solution

Un workflow planifié lit les sources déclarées dans une base Baserow, écarte les articles déjà traités, puis demande à un modèle de langage d'analyser chaque article et de décider s'il mérite d'être lu. Les articles retenus sont regroupés dans un digest envoyé par e-mail aux destinataires configurés.

## Risques & garde-fous

- **Pertinence mal jugée par l'IA** → chaque article rejeté est enregistré avec la décision, ce qui permet de contrôler les choix de l'IA a posteriori.
- **Doublons et répétitions** → les articles déjà envoyés sont mémorisés et filtrés avant l'analyse.
- **Silence ambigu** → un digest vide est envoyé quand rien n'est retenu : on sait que la veille a tourné.
- **Modifications risquées** → sources, destinataires et jour d'envoi se règlent dans la base, sans toucher au workflow.

## Résultat

Une veille quotidienne qui tourne seule, avec une trace de chaque décision de l'IA.

## Ce que j'en retiens

Sept versions ont été nécessaires : un agent IA se règle par itérations courtes sur de vraies données. Garder une trace des rejets est ce qui rend l'outil digne de confiance.
