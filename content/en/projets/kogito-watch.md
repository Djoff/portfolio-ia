---
titre: "Kogito Watch"
statut: "realise"
date: 2026-09-29
outils: ["n8n", "Baserow", "OpenRouter", "Gmail"]
resume: "Automated news monitoring: an AI agent reads news feeds, keeps what matters and sends a digest."
etapes:
  - { nom: "Configuration", type: "normal" }
  - { nom: "RSS feeds", type: "normal" }
  - { nom: "De-duplication", type: "controle" }
  - { nom: "AI analysis", type: "ia" }
  - { nom: "Selection", type: "ia" }
  - { nom: "Email digest", type: "normal" }
  - { nom: "Sent / rejected log", type: "controle" }
---

## Problem

Following news from many sources takes time, and most articles are not relevant.

## Solution

A scheduled workflow reads the sources listed in a Baserow database, drops articles already processed, then asks a language model to analyse each article and decide whether it is worth reading. Selected articles are grouped into a digest emailed to the configured recipients.

## Risks & safeguards

- **AI misjudging relevance** → every rejected article is logged with the decision, so the AI's choices can be reviewed afterwards.
- **Duplicates** → articles already sent are stored and filtered out before analysis.
- **Ambiguous silence** → an empty digest is sent when nothing is selected, so you know the run happened.
- **Risky changes** → sources, recipients and sending day are set in the database, without editing the workflow.

## Outcome

Daily monitoring that runs on its own, with a record of every AI decision.

## Lessons learned

It took seven versions: an AI agent is tuned through short iterations on real data. Logging rejections is what makes the tool trustworthy.
