---
titre: "Automation monitoring"
statut: "realise"
date: 2026-04-06
outils: ["n8n", "Telegram"]
resume: "Any error in a workflow immediately triggers an alert on my phone."
etapes:
  - { nom: "Error in a workflow", type: "normal" }
  - { nom: "Error capture", type: "controle" }
  - { nom: "Telegram alert", type: "normal" }
---

## Problem

An automation that fails silently is worse than no automation: you believe the work is done.

## Solution

A dedicated workflow is triggered by n8n as soon as another workflow fails. It immediately sends a Telegram alert with the workflow name and the error.

## Risks & safeguards

- **Silent failure** → every error produces an immediate alert.
- **Slow diagnosis** → the alert says which workflow failed and why.

## Outcome

Incidents are known within seconds instead of being discovered by chance.

## Lessons learned

Monitoring is not an end-of-project add-on: it is the first thing to set up before automating anything important.
