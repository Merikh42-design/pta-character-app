# Pathways to Adventure - Data Structure

This document describes the JSON data packs used by the app.

## Core Data Packs (in `data_packs/core/`)

| File                    | Description                              | Loaded By              |
|-------------------------|------------------------------------------|------------------------|
| `class_descriptors.json` | Class descriptions for ABC Wizard       | `DataService`          |
| `classes.json`           | Class starting stats                     | `DataService`          |
| `ancestries.json`        | Ancestry data                            | `DataService`          |
| `backgrounds.json`       | Background data                          | `DataService`          |
| `spells.json`            | All spells                               | (Future use)           |
| `maneuvers.json`         | All maneuvers                            | (Future use)           |
| `chants.json`            | All chants                               | (Future use)           |
| `free_reactions.json`    | Free Actions + Reactions                 | (Future use)           |
| `states.json`            | States, Afflictions, Boons               | `DataService`          |
| `equipment.json`         | Equipment library                        | `DataService`          |

## How the App Uses the Data

1. **ABC Wizard** loads Class Descriptors, Ancestries, and Backgrounds.
2. Selections are saved to `characterProvider`.
3. **Character Sheet** and **Radial Wheel** react to changes in the provider.
4. `DataService` is the single source of truth for loading JSON files.

## Notes for Future Expansion

- Class Features will be added when `class_features.json` is ready.
- Spells, Maneuvers, and Chants will be integrated into the sheet later.
