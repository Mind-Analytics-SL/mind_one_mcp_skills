# CLAUDE.md — mind_one_mcp_skills

> Contexto de este repo para Claude Code (se auto-carga). Editar cuando algo cambie.

## Mind One de un vistazo
Plataforma **MDM** multi-tenant. Datos: workspaces → datagroups → datagrids (governed
sheets) + value lists. Repos hermanos en `~/projects/mind_one/`: frontend, api, mcp,
mcp_skills (este), docs, landing, infra.

## Qué es este repo
Colección de **skills de Claude Code** para interactuar con Mind One desde el chat
(explorar workspaces, crear estructuras, importar datos, buscar), apoyándose en el
**MCP** (mind-one-mcp). No es un paquete Node (no hay package.json); es un repo de skills
+ `install.sh`.

## Estructura / uso
- `install.sh` copia las skills a `~/.claude/skills/` (o usar `claude --add-dir <repo>`).
- Requiere el MCP de Mind One configurado (OAuth/Bearer contra mcp.getmindapp.io).
- Skills: `/mindone-explore`, `/mindone-search`, `/mindone-create`, etc.

## Notas
- Depende del contrato del MCP (mind-one-mcp) y por debajo de la API pública.
