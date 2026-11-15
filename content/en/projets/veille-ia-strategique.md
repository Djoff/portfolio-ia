---
titre: "Strategic AI watch: governance, value and finance"
statut: "realise"
date: 2026-10-11
outils: ["Claude Code", "Scheduled task", "Web search", "Artifact"]
resume: "Every week, an AI agent picks the few developments that change a decision or a deadline: AI value, agents, regulation, banking and finance."
etapes:
  - { nom: "Weekly research", type: "ia" }
  - { nom: "Sources ranked by tier", type: "controle" }
  - { nom: "Figures checked at the source", type: "controle" }
  - { nom: "Selection of 4 to 6 topics", type: "ia" }
  - { nom: "Edition published", type: "normal" }
  - { nom: "Quarterly source review", type: "controle" }
---

## Problem

Specialised newsletters cover product launches and technology, not what matters for steering AI in an organisation: real value, agents, regulation (AI Act, Switzerland, financial regulators). Reliable sources are scattered, and figures often circulate with no verifiable origin.

## Solution

Every Sunday, a scheduled task starts an AI agent that searches the week's news on four themes, including Swiss and French-language sources. It keeps 4 to 6 topics and writes, for each one, the fact and then "what it changes". It then publishes a new edition on a web page, with a calendar of regulatory deadlines and a method page that documents every source.

## Risks & safeguards

- **Unreliable sources** → four source tiers: reference, relay, watch list and candidate. Vendor surveys about their own product, commercial reports and copied articles are excluded.
- **Wrong or distorted figures** → a key figure is only quoted after reading the original document, and it is used as is, never recalculated. Otherwise it is marked "to be checked".
- **Agent drift** → the agent never promotes or excludes a source on its own: it proposes, and I approve every quarter.
- **Ambiguous silence** → a "Nothing to report" edition is published when no topic meets the bar: a missing edition always signals a problem.
- **Copyright** → articles are paraphrased, with no long quotes.

## Outcome

A new edition every week since October 2026, with an up-to-date calendar of deadlines. The method page makes every source choice traceable, and its limits are documented: some Swiss sources and some regulators' sites remain hard to read automatically.
