---
titre: "Modernising a public speaking talk with an AI assistant"
statut: "realise"
date: 2026-11-15
outils: ["Claude Code", "PowerPoint", "Python"]
resume: "An AI assistant analysed my talk on public speaking, fixed what I approved, added a section on AI as a coach, then translated it into French."
etapes:
  - { nom: "Content and rendering analysis", type: "ia" }
  - { nom: "Author's decisions", type: "controle" }
  - { nom: "Fixes and AI section", type: "ia" }
  - { nom: "Visual check of every slide", type: "controle" }
  - { nom: "French version", type: "ia" }
---

## Problem

I give a two-hour session on public speaking to Master's and PhD students in computer science. My deck dated from 2023: typos, text too small to read in the room, a scientific study quoted inaccurately, no conclusion or call to action, and nothing on what AI can bring.

## Solution

An AI coding assistant read the 26 slides, their notes and their rendering in PowerPoint, then delivered an analysis of content and form. I decided point by point: what was intentional stayed, such as two slides without a title or an example of bad style. It then applied the fixes I kept, removed the misused study and added an "AI as your coach" section: preparing your message, rehearsing, getting transcribed, measuring your pace and filler words, with links to tools and ready-to-use examples in the notes. The talk now ends with a summary and a call to action for the students. A full French version followed.

## Risks & safeguards

- **Scientific error** → the assistant flagged the inaccurately quoted study; it was removed from the talk, and every reference written from memory was marked "to be checked".
- **Losing the author's style** → no fix applied without my decision; intentional choices were kept.
- **Display defects** → every slide was rendered in PowerPoint and checked visually, in English and in French.
- **Overwritten original** → each version was saved as a new file, leaving the original intact.
- **Audience misusing AI** → the AI section states its limits: never read a generated text, check the facts, prefer a local model for unpublished work.

## Outcome

A 31-slide talk, in English and French, easier to read, with no known errors, that shows students how to use AI to rehearse without handing it the microphone.
