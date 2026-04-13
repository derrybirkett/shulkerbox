# Plugins

Extensions and integrations for various development tools.

## What are Plugins?

Plugins extend the functionality of development tools by adding:
- New commands
- Custom workflows
- Tool integrations
- API connections
- Data sources

## Structure

```
plugins/
├── tool-name/
│   ├── plugin.json        # Plugin metadata
│   ├── commands/          # Custom commands
│   └── lib/              # Shared code
└── README.md
```

## Plugin Types

### CLI Extensions
Add commands to command-line tools:
- New subcommands
- Workflow automation
- Integration with external services

### IDE Integrations
Enhance IDE functionality:
- Custom actions
- Language support
- Tool integrations

### MCP Servers
Model Context Protocol servers for Claude Code:
- Custom tools
- Resource providers
- Context extensions

## Creating Plugins

### Plugin Metadata (plugin.json)
```json
{
  "name": "my-plugin",
  "version": "1.0.0",
  "description": "Does something useful",
  "type": "cli-extension",
  "commands": [
    {
      "name": "my-command",
      "description": "Command description",
      "script": "commands/my-command.sh"
    }
  ],
  "dependencies": ["tool1", "tool2"]
}
```

### Command Script
```bash
#!/usr/bin/env bash
#
# my-command — Description
#

set -euo pipefail

# Command implementation
```

## Installing Plugins

### For Copilot CLI
```bash
copilot plugins add ~/shulkerbox/plugins/my-plugin
```

### For Claude Code (MCP)
Add to `claude.json`:
```json
{
  "mcpServers": {
    "my-plugin": {
      "command": "node",
      "args": ["~/shulkerbox/plugins/my-plugin/server.js"]
    }
  }
}
```

## Best Practices

1. **Clear purpose**: Each plugin solves one problem
2. **Minimal dependencies**: Reduce external requirements
3. **Error handling**: Fail gracefully with helpful messages
4. **Documentation**: Explain installation and usage
5. **Versioning**: Track changes and compatibility

## Example Plugins

### GitHub Workflow Plugin
Automates common GitHub operations:
- Create issues from templates
- Manage PR workflows
- Track sprint progress

### Deploy Helper Plugin
Simplifies deployment tasks:
- Environment validation
- Build and deploy automation
- Rollback procedures

### Documentation Generator
Generates docs from code:
- API reference from types
- README from comments
- Changelog from commits
