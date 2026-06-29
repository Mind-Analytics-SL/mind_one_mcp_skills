---
description: Search for governed sheets (datagrids) across all Mind One workspaces by name or topic. Use when the user asks to find, locate, or look up a governed sheet.
argument-hint: [search term]
---

Search Mind One for governed sheets matching: `$ARGUMENTS`

## Steps

1. Call `mindone_search_datagrids` with the user's search term.
2. If no results are returned:
   - Try a broader term (remove qualifiers, use root words).
   - If still empty, fall back to listing all workspaces → collections → governed sheets and filter by name manually.
3. Display results as a table: governed sheet name, workspace, collection, and description if available.
4. If there is only one result, offer to open it immediately.
5. If there are multiple results, ask which one the user wants to work with.

## Output format

Group results by workspace if there are more than five. Keep descriptions short (one line each). Do not show raw IDs unless the user asks.

## Follow-up offers

After finding a governed sheet, offer:
- View its schema and sample data → `mindone_get_datagrid`
- Import data into it → `/mindone-import`
- Explore the surrounding workspace → `/mindone-explore`
