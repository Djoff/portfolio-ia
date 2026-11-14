---
titre: "Production de vidéos avec fact-check"
statut: "realise"
date: 2025-11-05
outils: ["n8n", "OpenRouter", "Claude", "Tavily", "Google Workspace", "Fliki"]
resume: "Une chaîne qui rédige des scripts vidéo avec recherche web, puis vérifie les faits et les sources avant production."
etapes:
  - { nom: "File de sujets", type: "normal" }
  - { nom: "Rédaction + recherche web", type: "ia" }
  - { nom: "Format structuré", type: "controle" }
  - { nom: "Document du script", type: "normal" }
  - { nom: "Fact-check", type: "ia" }
  - { nom: "Vérification des liens", type: "controle" }
  - { nom: "Vidéo", type: "normal" }
---

## Problème

Produire régulièrement des vidéos pour plusieurs chaînes demande beaucoup de rédaction, et un texte généré par IA peut contenir des erreurs factuelles.

## Solution

Les sujets sont placés dans une file d'attente (tableur). Un agent IA rédige le script complet en s'appuyant sur une recherche web, au format imposé, puis le dépose dans un document. Un second workflow relit chaque script : un agent vérifie les affirmations, liste ses sources, et chaque lien est testé avant que le script ne passe au statut « vérifié ».

## Risques & garde-fous

- **Hallucinations** → un fact-check séparé de la rédaction, avec sources citées pour chaque fait.
- **Sources inventées ou mortes** → chaque lien cité est testé automatiquement et son état est consigné.
- **Sortie inexploitable** → la réponse de l'IA doit respecter un format structuré ; en cas d'échec, une alerte est envoyée.
- **Perte de suivi** → chaque sujet porte un statut (à faire, en cours, terminé, vérifié).

## Résultat

Une chaîne de production où chaque script est rédigé, tracé et vérifié avant de devenir une vidéo.

## Ce que j'en retiens

La première version comptait 26 nœuds et était fragile ; la version simplifiée à 17 nœuds est plus simple à maintenir. Séparer « rédiger » et « vérifier » en deux agents distincts est un principe que je réutiliserais partout.
