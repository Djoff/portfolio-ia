---
titre: "Securing a server with an AI assistant, under supervision"
statut: "realise"
date: 2026-11-14
outils: ["Claude Code", "Hostinger", "Tailscale", "Healthchecks", "Cron"]
resume: "An AI assistant audited my Linux server, then secured it step by step: it proposes, I approve every sensitive action."
etapes:
  - { nom: "Snapshot before any change", type: "controle" }
  - { nom: "Server audit", type: "ia" }
  - { nom: "Improvement plan", type: "ia" }
  - { nom: "Human approval", type: "controle" }
  - { nom: "Access, firewall, accounts", type: "normal" }
  - { nom: "Tested restore", type: "controle" }
  - { nom: "Maintenance and alerts", type: "normal" }
---

## Problem

My server hosts my automations (n8n, Baserow), but I have little experience with Linux administration and security best practices. The audit confirmed it: admin access open to the whole Internet, password logins accepted, an inactive firewall, two administrator accounts and 62 pending updates.

## Solution

An AI coding assistant took over the server under my supervision. It first ran a read-only audit, then proposed an improvement plan, applied step by step after my approval:

- admin access only through a private network, with a key and no password; repeated attempts are blocked automatically;
- an active firewall: only web traffic and the private network get through;
- a single administrator account, with the original account disabled;
- off-site backups checked every week, and a restore actually tested;
- updates installed automatically every 15 days, with an alert if a task fails or does not run.

## Risks & safeguards

- **Destructive AI action** → the AI proposes and I approve every critical step; a full server snapshot is taken before any change.
- **Losing access to the server** → every new access path is tested before the old one is closed; emergency access remains possible through the host's console.
- **Secret leakage** → no password or key is ever given to the AI: I type them myself in the terminal.
- **Service outage** → scripts stop at the slightest doubt, without changing anything; n8n and Baserow are checked after every step.
- **False sense of security** → a backup only counts as reliable after a real restore; an alert fires if an automated task fails or goes silent.

## Outcome

In a single session, the server went from exposed to hardened, with no noticeable service interruption. It now keeps itself up to date, and I am warned if something goes wrong.

## Lessons learned

AI can make up for missing technical skills, as long as I keep the decision. By approving each step, I also understood what was being done, and why.
