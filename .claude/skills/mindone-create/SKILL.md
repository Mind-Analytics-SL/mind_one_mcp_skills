---
description: Create Mind One workspaces, collections (datagroups), and governed sheets (datagrids) from a natural language description. Use when the user wants to set up a new structure, schema, or data model in Mind One.
disable-model-invocation: true
argument-hint: [description of what to create]
---

Create Mind One structures based on the user's description: `$ARGUMENTS`

## Clarification

If the description is missing key details, ask before proceeding:
- What is the workspace for? (team, project, domain)
- What collection(s) should it contain?
- What fields should each governed sheet have?

Do not create anything until you have enough information to do it correctly.

## Steps

1. Call `mindone_list_workspaces` to check for existing workspaces and avoid duplicates.
2. Determine what needs to be created: workspace, collection(s), governed sheet(s), and fields.
3. Create resources in order — each step depends on the previous:
   - Workspace → `mindone_create_workspace`
   - Collection → `mindone_create_datagroup` (requires `workspaceIds` array — pass the workspace ID in an array)
   - Governed sheet → `mindone_create_datagrid` (requires `workspaceId`; optionally pass `datagroupIds` array to associate with a collection)
   - Fields → `mindone_update_datagrid_fields` (requires governed sheet ID)
4. Confirm each created resource by name and ID.

## Field type guide

Infer appropriate field types from the user's description:

| User says | Field type |
|---|---|
| name, title, label, description, notes, text | text |
| amount, price, count, quantity, score, number | number |
| date, deadline, timestamp, created, updated | date |
| active, enabled, flag, yes/no, boolean | boolean |
| status, category, type, priority (fixed set) | valid list (value list) |

For valid list fields, first call `mindone_list_value_lists` to check if a matching list already exists. If none exists, create one with `mindone_create_value_list`. Then reference it in the field definition via `valueListKey`.

## Output

Summarize what was created in a structured list with resource names and IDs. Offer to import data next.
