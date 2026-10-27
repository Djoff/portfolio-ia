---
titre: "Automation monitoring"
statut: "realise"
date: 2026-04-06
outils: ["n8n", "Telegram"]
resume: "When a workflow fails, an alert reaches my phone right away."
etapes:
  - { nom: "Error in a workflow", type: "normal" }
  - { nom: "Error capture", type: "controle" }
  - { nom: "Telegram alert", type: "normal" }
---

## Problem

An automation that fails silently is worse than no automation: you believe the work is done.

## Solution

A dedicated error workflow is triggered by n8n as soon as a workflow linked to it fails. It immediately sends a Telegram alert with the workflow name and the error.

## Risks & safeguards

- **Silent failure** → every error in a monitored workflow produces an immediate alert.
- **Blind spot** → this alert does not cover an outage of n8n itself: external monitoring is still to be added.
- **Slow diagnosis** → the alert says which workflow failed and why.

## Outcome

Incidents are reported as they happen instead of being discovered by chance.

## Lessons learned

Monitoring is not an end-of-project add-on: it is the first thing to set up before automating anything important.
