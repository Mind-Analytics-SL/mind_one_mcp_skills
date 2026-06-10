---
description: Insert or replace data in a Mind One datagrid. Use when the user wants to load, upload, add rows, or update data in a datagrid.
disable-model-invocation: true
argument-hint: [datagrid name or description]
---

Import data into a Mind One datagrid. Target: `$ARGUMENTS`

## Step 1 — Identify the target datagrid

- If `$ARGUMENTS` names a datagrid, call `mindone_search_datagrids` to find it.
- If ambiguous or not found, call `mindone_list_workspaces` → `mindone_list_datagroups` → `mindone_list_datagrids` to let the user pick.
- Confirm the target datagrid with the user before proceeding.

## Step 2 — Inspect the schema

Call `mindone_get_datagrid` to retrieve the field definitions. Display the field names and types so the user can see the expected format.

## Step 3 — Get the data

If the user has not yet provided data, ask them to share it (CSV, JSON array, markdown table, or plain text rows).

## Step 4 — Map columns to fields

Map the user's columns to datagrid fields:
- Match by name first (case-insensitive).
- For ambiguous columns, ask the user to confirm the mapping.
- Skip columns that have no matching field — do not invent mappings.
- If a required field is missing from the data, ask before proceeding.

## Step 5 — Choose the right operation

| Situation | Operation |
|---|---|
| Adding new rows to existing data | `mindone_insert_rows` (async — poll `mindone_get_job_status`) |
| Replacing all rows (full reload) | `mindone_replace_datagrid_data` — warn the user that all existing rows will be deleted |
| Updating / deleting multiple rows at once | `mindone_patch_rows` (sync — no polling needed) |
| Partially updating a single row by `__rowId` | `mindone_update_row` (async — poll `mindone_get_job_status`) |
| Fully replacing a single row by `__rowId` | `mindone_replace_row` (async — poll `mindone_get_job_status`) |

## Step 6 — Execute and confirm

- Run the chosen operation.
- For async operations, poll `mindone_get_job_status` until complete.
- Report how many rows were inserted, updated, or replaced.
- If there are errors, show which rows failed and why.
