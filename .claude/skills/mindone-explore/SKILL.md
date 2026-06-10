---
description: Browse and explore Mind One workspaces, datagroups, and datagrids. Use when the user asks what workspaces or datagrids they have, wants to see the structure of their Mind One account, or needs to navigate to a specific datagrid.
---

Explore the user's Mind One account interactively.

## Steps

1. Call `mindone_get_account` and greet the user with their account name.
2. Call `mindone_list_workspaces` and display the results.
3. If there is more than one workspace, ask which one to explore. If only one exists, proceed automatically. Offer to show full workspace details with `mindone_get_workspace` if the user asks.
4. Call `mindone_list_datagroups` for the selected workspace.
5. Ask which datagroup to explore, or offer to show all datagrids across the workspace. Offer to show full datagroup details with `mindone_get_datagroup` if the user asks.
6. Call `mindone_list_datagrids` for the selected datagroup.
7. Display a summary: datagrid name, description (if available), and field count.
8. Offer to show full details for any datagrid with `mindone_get_datagrid`.

## Output format

Use a clean tree or table layout. One line per item unless the user asks for more detail. Do not dump raw JSON — format it for readability.

## Follow-up offers

After exploration, offer the next natural actions:
- Import data into a datagrid → `/mindone-import`
- Search for a specific datagrid → `/mindone-search`
- Create a new structure → `/mindone-create`
