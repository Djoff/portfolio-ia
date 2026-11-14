---
titre: "Video production with fact-checking"
statut: "realise"
date: 2025-11-05
outils: ["n8n", "OpenRouter", "Claude", "Tavily", "Google Workspace", "Fliki"]
resume: "A pipeline that writes video scripts with web research, then checks facts and sources before production."
etapes:
  - { nom: "Topic queue", type: "normal" }
  - { nom: "Writing + web research", type: "ia" }
  - { nom: "Structured format", type: "controle" }
  - { nom: "Script document", type: "normal" }
  - { nom: "Fact-check", type: "ia" }
  - { nom: "Link check", type: "controle" }
  - { nom: "Video", type: "normal" }
---

## Problem

Producing videos regularly for several channels takes a lot of writing, and AI-generated text can contain factual errors.

## Solution

Topics go into a queue (spreadsheet). An AI agent writes the full script using web research, in an enforced format, and saves it to a document. A second workflow reviews each script: an agent checks the claims and lists its sources, and every link is tested before the script is marked as verified.

## Risks & safeguards

- **Hallucinations** → fact-checking is separate from writing, with sources cited for every fact.
- **Invented or dead sources** → every cited link is tested automatically and its status recorded.
- **Unusable output** → the AI's answer must follow a structured format; on failure, an alert is sent.
- **Lost tracking** → every topic carries a status (to do, in progress, done, verified).

## Outcome

A production pipeline where each script is written, tracked and verified before it becomes a video.

## Lessons learned

The first version had 26 nodes and was fragile; the simplified 17-node version is easier to maintain. Splitting "write" and "verify" into two separate agents is a principle I would reuse everywhere.
