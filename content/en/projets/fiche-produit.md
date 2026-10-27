---
titre: "Product sheet and price from photos"
statut: "realise"
date: 2026-10-08
outils: ["n8n", "Telegram", "Claude", "Baserow"]
resume: "Sending photos of a second-hand item by message is enough to get its product sheet and a price estimate."
etapes:
  - { nom: "Photos via Telegram", type: "normal" }
  - { nom: "Authorised sender?", type: "controle" }
  - { nom: "Album grouping", type: "normal" }
  - { nom: "Product sheet", type: "ia" }
  - { nom: "Price estimate", type: "ia" }
  - { nom: "Price calculation", type: "controle" }
  - { nom: "Save + confirmation", type: "normal" }
---

## Problem

For a second-hand seller, writing every product sheet and setting a price is slow and repetitive.

## Solution

The seller sends photos of an item via Telegram. The workflow waits until the whole album has arrived, then an AI model writes the product sheet and suggests an estimate. Final prices are computed by fixed rules, the sheet is saved to a database with an internal code, and a confirmation is sent back to the seller.

## Risks & safeguards

- **Unauthorised access** → only authorised senders can trigger the workflow.
- **Unrealistic AI price** → the AI estimates, but the final price is computed by deterministic rules.
- **Unnoticed error** → the seller receives a confirmation and stays in control of the listing.
- **Leftover data** → temporary album data is deleted after processing.

## Outcome

Creating a product sheet goes from a manual task to simply sending photos, with a human validating.

## Lessons learned

AI is excellent at describing, less reliable at pricing: combining it with explicit rules gets the best of both.
