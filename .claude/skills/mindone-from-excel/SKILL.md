---
description: Turn an Excel/CSV spreadsheet into a governed Mind One structure. Use when the user loads a spreadsheet (.xlsx, .xls, .csv, Google Sheet export) and wants to set it up in Mind One — reading the file, recommending a schema, and creating the workspace / collection / governed sheet and loading the rows.
disable-model-invocation: true
argument-hint: [path to spreadsheet or what to set up]
---

Set up a Mind One structure from a spreadsheet the user provides: `$ARGUMENTS`

Your job is to READ the file, INFER a sensible data structure, RECOMMEND it, get the
user's confirmation, and then CREATE it correctly. Use your own reasoning for inference
and naming — but the create order, key, and async rules in Step 5 are HARD RULES you must
not break.

## Step 1 — Read the spreadsheet

- If the user gave a file path, read it. For `.xlsx`/`.xls`, parse the workbook (e.g. with
  a Python `openpyxl`/`pandas` snippet, or whatever parsing tool you have). For `.csv` or a
  pasted table, read it directly.
- If the workbook has multiple sheets/tabs, list them and ask the user which one to govern
  (or whether to set up several). Govern one sheet at a time.
- Extract the header row and a sample of data rows (the first ~20–50 rows is enough to infer
  types and cardinality — do not load the whole file just to design the schema).
- Detect and confirm the header row if it is not the first row (some files have title banners
  or blank rows above the headers). If columns are unnamed, propose names from the data.

## Step 2 — Infer and recommend a schema (use your judgment)

Reason over the sample to propose a structure. This is NOT a fixed mapping — apply judgment:

- **Type per column** — pick one of: `string`, `number`, `boolean`, `date`, `email`, `url`,
  `timestamp`, `imageUrl`. Infer from the values, not just the header (e.g. all values match
  an email pattern → `email`; ISO date strings → `date`; date + time → `timestamp`; `Yes/No`,
  `TRUE/FALSE`, `1/0` → `boolean`; image links → `imageUrl`). Note any mixed/dirty columns and
  default them to `string`.
- **Valid lists for low-cardinality text** — when a text column has a small, repeating set of
  distinct values relative to row count (e.g. Status, Category, Type, Priority, Region), it is
  a candidate for a **valid list**. Recommend creating one, list the distinct values you found,
  and propose a `key` (snake_case, e.g. `order_status`) and labels.
- **Flags** — mark a column `required` if it is non-empty across the sample and clearly
  identifying; mark `unique` if every value is distinct and it reads like an id/email/code.
  Be conservative; when unsure, leave it optional and say so.
- **Identifier column** — if there is no natural primary key, recommend adding an
  `autoincrement` field (e.g. `Id`) as order 1. Do NOT put values into autoincrement fields.
- **Names** — propose human-friendly names for the workspace, the collection, and the governed
  sheet, plus a field identifier KEY (camelCase, used in row data) and a `columnCode`
  (PascalCase, letters/numbers/underscore, starts with a letter, max 115 chars) for each field.
- Assign each field a 1-based `order` reflecting the spreadsheet column order.

## Step 3 — Present the recommendation and confirm

Show the user a clear, readable proposal (a table is good) before creating anything:

- The proposed workspace / collection / governed sheet names.
- Per column: source header → field name, key, columnCode, type, required/unique, and whether
  it becomes a valid list (with the distinct values).
- Note where the file will need a target workspace (and whether you will reuse an existing one).

Ask the user to confirm or edit. Do NOT create anything until they approve. If they change a
name, type, or list, update the plan and re-confirm the affected parts.

## Step 4 — Check what already exists

- Call `mindone_list_workspaces` (and `mindone_list_datagroups` for the chosen workspace) to
  avoid creating duplicates. Prefer reusing an existing workspace/collection if the user wants.
- Call `mindone_list_value_lists` to check whether a matching valid list already exists before
  creating a new one — reuse it via its existing `key` if so.

## Step 5 — Create, in this order (HARD RULES — do not break)

Create resources strictly in this sequence; each depends on the previous:

1. **Workspace** (if a new one is needed) → `mindone_create_workspace`.
   - **TIER LIMIT:** workspace creation may be blocked on the user's plan. If the call is
     denied (quota/permission error), STOP, report it clearly, and offer to use an existing
     workspace instead. Do not silently continue.
2. **Collection** (optional) → `mindone_create_datagroup` (requires `workspaceIds` as an array).
3. **Valid lists FIRST, before the governed sheet** → `mindone_create_value_list` for each
   recommended list (`key`, `name`, `values: [{ value, label, order }]`). You need each list's
   `key` to reference it from a field. Never create a field with `valueListKey` pointing at a
   list that does not exist yet.
4. **Governed sheet** → `mindone_create_datagrid` (SCHEMA ONLY — this endpoint does NOT accept
   rows). Requirements:
   - `name`, `workspaceId`, and `fields`.
   - **Associate it:** pass `workspaceId`, and pass the collection's id in `datagroupIds`
     (array) if you created/chose a collection.
   - **Every field MUST have a `columnCode`** (PascalCase, max 115 chars).
   - For a categorical field, reference its list via **`valueListKey`** (the list's `key`).
     For a small fixed set you are NOT making a reusable list for, you may instead use inline
     `validation: { options: [...] }`.
   - Number/date bounds go in `validation: { min, max }`; string patterns in
     `validation: { pattern }`.
5. **Load rows** → `mindone_insert_rows` with the created governed sheet's id.
   - **Row object keys MUST be the field identifier KEYS** (the keys of the `fields` object,
     e.g. `firstName`) — NOT the display `name` (`First Name`), NOT the `columnCode`
     (`FirstName`). If unsure, call `mindone_get_datagrid` to read the exact keys back.
   - Do NOT include autoincrement fields in row data — they fill automatically.
   - For valid-list / options fields, send the option `value` (not the label).
   - Convert each spreadsheet value to the field's type (ISO strings for date/timestamp,
     real booleans, numbers without thousands separators); leave empty cells out rather than
     sending empty strings for optional fields.
   - For large files, insert in batches.
   - **ASYNC — this is a HARD RULE:** `mindone_insert_rows` returns a `jobId` immediately. You
     MUST then poll `mindone_get_job_status` with that jobId (every ~1–2s) until the status is
     `succeeded` or `failed`. NEVER report success on the jobId alone — the job may still be
     running or may fail. (If a `mindone_wait_for_job` tool is available, you may use it
     instead of manual polling.)

## Step 6 — Summarize

Report a structured summary:
- Created resources with their names and IDs (workspace, collection, valid lists, governed sheet).
- How many rows were inserted (after the job reached `succeeded`).
- Any rows that failed validation — show which rows and why (from the job's `error`/`result`),
  and offer to fix and re-insert them.
- If any step was blocked by a tier/permission limit, state which step and what the user can do.

Then offer next actions: explore the new structure (`/mindone-explore`), add more data
(`/mindone-import`), or set up another sheet from the same workbook.
