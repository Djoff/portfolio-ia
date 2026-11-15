---
titre: "Moderniser une présentation sur la prise de parole avec un assistant IA"
statut: "realise"
date: 2026-11-15
outils: ["Claude Code", "PowerPoint", "Python"]
resume: "Un assistant IA a analysé ma présentation sur la prise de parole en public, corrigé ce que je validais, ajouté une section sur l'IA comme coach, puis l'a traduite en français."
etapes:
  - { nom: "Analyse du contenu et du rendu", type: "ia" }
  - { nom: "Décisions de l'auteur", type: "controle" }
  - { nom: "Corrections et section IA", type: "ia" }
  - { nom: "Contrôle visuel de chaque diapo", type: "controle" }
  - { nom: "Version française", type: "ia" }
---

## Problème

Je donne une intervention de deux heures sur la prise de parole en public à des étudiants de Master et de doctorat en informatique. Ma présentation datait de 2023 : coquilles, textes illisibles en salle, une étude scientifique citée de façon inexacte, aucune conclusion ni appel à l'action, et rien sur l'apport de l'IA.

## Solution

Un assistant IA de développement a lu les 26 diapositives, leurs notes et leur rendu dans PowerPoint, puis il a livré une analyse du fond et de la forme. J'ai tranché point par point : ce qui était volontaire est resté, comme deux diapositives sans titre ou un exemple de mauvais style. Il a ensuite appliqué les corrections retenues, retiré l'étude mal employée et ajouté une section « L'IA comme coach » : préparer son message, répéter, se faire transcrire, mesurer son débit et ses mots parasites, avec des liens vers des outils et des exemples prêts à l'emploi dans les notes. La présentation se termine désormais par un résumé et un appel à l'action pour les étudiants. Une version française complète a suivi.

## Risques & garde-fous

- **Erreur scientifique** → l'assistant a signalé l'étude citée de façon inexacte ; elle a été retirée de la présentation, et chaque référence écrite de mémoire était signalée « à vérifier ».
- **Perte du style de l'auteur** → aucune correction appliquée sans ma décision ; les choix volontaires ont été conservés.
- **Défauts d'affichage** → chaque diapositive a été rendue dans PowerPoint et contrôlée visuellement, en anglais comme en français.
- **Original écrasé** → chaque version a été enregistrée dans un nouveau fichier, l'original restant intact.
- **Mauvais usage de l'IA par le public** → la section IA rappelle ses limites : ne jamais lire un texte généré, vérifier les faits, préférer un modèle local pour des travaux non publiés.

## Résultat

Une présentation de 31 diapositives, en anglais et en français, plus lisible, sans erreur connue, et qui montre aux étudiants comment se servir de l'IA pour répéter sans lui laisser la parole.
