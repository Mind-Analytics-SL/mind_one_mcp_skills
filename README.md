# Mind One Skills for Claude Code

A collection of [Claude Code skills](https://code.claude.com/docs/en/slash-commands) that let you interact with [Mind One](https://getmindapp.io) directly from your AI conversations — browse workspaces, create data structures, import data, and search, all without leaving the chat.

## Prerequisites

- [Claude Code](https://claude.ai/code) v2.1+ installed
- Mind One MCP server configured — follow the [Mind One MCP setup guide](https://docs.getmindapp.io/docs/conectividad/mcp/) to connect your account

## Installation

### Option 1 — Add on session start (no copy required)

Clone the repository once, then pass it with `--add-dir` each time you start Claude Code:

```bash
git clone https://github.com/your-org/mind_one_mcp_skills ~/mind_one_mcp_skills
claude --add-dir ~/mind_one_mcp_skills
```

To update to the latest skills, run `git pull` inside the cloned folder.

### Option 2 — Install permanently to your profile

Clone and run the install script to copy the skills to `~/.claude/skills/`, making them available in every Claude Code session:

```bash
git clone https://github.com/your-org/mind_one_mcp_skills
cd mind_one_mcp_skills
./install.sh
```

Restart Claude Code after installing. To update, pull the latest changes and run `./install.sh` again.

## Available skills

| Skill | Command | Description |
|---|---|---|
| **Explore** | `/mindone-explore` | Browse your workspaces, datagroups, and datagrids |
| **Create** | `/mindone-create` | Create workspaces, datagroups, and datagrids from natural language |
| **Import** | `/mindone-import` | Insert or replace data in a datagrid |
| **Search** | `/mindone-search` | Find datagrids across all your workspaces |

## Usage

Invoke any skill directly with its slash command:

```
/mindone-explore
/mindone-create a workspace for the sales team with a contacts datagrid
/mindone-import orders into the Q1 Sales datagrid
/mindone-search customer
```

Or just ask Claude naturally — it will invoke the right skill when relevant:

```
What datagrids do I have?
Create a new workspace for the engineering team with a tasks grid.
Find all datagrids related to invoices.
Load this CSV into the Products datagrid.
```

## How it works

Each skill is a `SKILL.md` file that gives Claude step-by-step instructions for interacting with Mind One through its MCP tools. The skills follow the [Agent Skills](https://agentskills.io) open standard, so they work in any AI tool that supports it.

## Contributing

Contributions are welcome. To add a new skill:

1. Create a directory under `.claude/skills/` with a kebab-case name (e.g., `mindone-export`)
2. Add a `SKILL.md` following the [skill format](https://code.claude.com/docs/en/slash-commands)
3. Open a pull request with a short description of what the skill does

## License

MIT
