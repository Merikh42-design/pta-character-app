# Pathways to Adventure - Data Packs

## Structure

- `data_packs/core/` — **Runtime JSON files** loaded by the Flutter app (single source of truth for the built app).
  - `classes.json` — Starting stats + proficiencies (from your character_starting_stats.csv)
  - `class_descriptors.json` — UI-facing descriptions, keywords, difficulty for class picker
  - `equipment.json` — Weapons, shields, armor, tools (to be fully populated)
  - `states.json` — States, Afflictions, Boons
  - `maneuvers.json`, `spells.json`, `tactical_maneuvers.json` — Ability libraries
  - Other JSONs (backgrounds, chants, etc.) — Ready for your parsed data

- `data_packs/core/source/` — **Original editable source files** you provide (CSV, .txt). 
  - These are for you to edit and re-generate JSON from.
  - Do **not** edit the JSON files directly if you want to keep them in sync with your source.

## How to Update Data

1. Edit or add new CSV/.txt in `source/`
2. Share the new file here with me (Grok)
3. I will generate updated clean JSON and push it
4. Pull in your local repo

## Current Status (as of June 2026)
- Core runtime JSONs for classes, descriptors, states, and equipment are present.
- Many placeholder JSONs exist for future expansions you are parsing.
- All data is user-provided only (PDF used only for descriptor clarification when you asked).

This structure supports the Flutter app's offline JSON loading and the preview/playtest mode for in-development content.