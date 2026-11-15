---
titre: "Sécuriser un serveur avec un assistant IA, sous supervision"
statut: "realise"
date: 2026-11-14
outils: ["Claude Code", "Hostinger", "Tailscale", "Healthchecks", "Cron"]
resume: "Un assistant IA a audité mon serveur Linux puis l'a sécurisé étape par étape : il propose, je valide chaque action sensible."
etapes:
  - { nom: "Instantané avant toute action", type: "controle" }
  - { nom: "Audit du serveur", type: "ia" }
  - { nom: "Plan d'amélioration", type: "ia" }
  - { nom: "Validation humaine", type: "controle" }
  - { nom: "Accès, pare-feu, comptes", type: "normal" }
  - { nom: "Restauration testée", type: "controle" }
  - { nom: "Maintenance et alertes", type: "normal" }
---

## Problème

Mon serveur héberge mes automatisations (n8n, Baserow), mais je maîtrise peu l'administration Linux et les bonnes pratiques de sécurité. L'audit l'a confirmé : accès d'administration ouvert à tout Internet, connexion par mot de passe acceptée, pare-feu inactif, deux comptes administrateurs et 62 mises à jour en attente.

## Solution

Un assistant IA de développement a pris la main sur le serveur, sous ma supervision. Il a d'abord réalisé un audit en lecture seule, puis proposé un plan d'amélioration, appliqué étape par étape après ma validation :

- accès d'administration uniquement par un réseau privé, avec une clé et sans mot de passe ; les tentatives répétées sont bloquées automatiquement ;
- pare-feu actif : seuls le trafic web et le réseau privé passent ;
- un seul compte administrateur, le compte d'origine étant désactivé ;
- sauvegardes hors site vérifiées chaque semaine, et restauration réellement testée ;
- mises à jour installées automatiquement tous les 15 jours, avec une alerte si une tâche échoue ou ne se lance pas.

## Risques & garde-fous

- **Action destructrice de l'IA** → l'IA propose et j'approuve chaque étape cruciale ; un instantané complet du serveur est pris avant toute modification.
- **Perte d'accès au serveur** → chaque nouvel accès est testé avant de fermer l'ancien ; un accès de secours reste possible par la console de l'hébergeur.
- **Fuite de secrets** → aucun mot de passe ni aucune clé n'est transmis à l'IA : je les saisis moi-même dans le terminal.
- **Service interrompu** → les scripts s'arrêtent au moindre doute, sans rien modifier ; n8n et Baserow sont contrôlés après chaque étape.
- **Faux sentiment de sécurité** → une sauvegarde n'est jugée fiable qu'après une vraie restauration ; une alerte se déclenche si une tâche automatique échoue ou se tait.

## Résultat

En une séance, le serveur est passé d'exposé à durci, sans interruption notable de service. Il se maintient désormais à jour tout seul, et je suis prévenu si quelque chose cloche.

## Ce que j'en retiens

Une IA peut compenser un manque de compétences techniques, à condition de garder la décision. En validant chaque étape, j'ai aussi compris ce qui était fait, et pourquoi.
