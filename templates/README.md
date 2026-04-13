# Templates

Project scaffolding, boilerplate, and starter files for rapid development.

## What are Templates?

Templates are reusable project structures, configuration files, and boilerplate code that help you start new projects or add features quickly.

## Structure

```
templates/
├── projects/          # Full project templates
│   ├── nextjs-saas/
│   ├── react-component-library/
│   └── cli-tool/
├── files/            # Individual file templates
│   ├── CLAUDE.md
│   ├── SPEC.md
│   └── PLAN.md
└── configs/          # Configuration templates
    ├── tsconfig.json
    ├── eslint.config.js
    └── vite.config.ts
```

## Using Templates

### Initialize Project from Template
```bash
# Copy project template
cp -r ~/shulkerbox/templates/projects/nextjs-saas ./my-project
cd my-project
npm install
```

### Use File Template
```bash
# Copy file template
cp ~/shulkerbox/templates/files/CLAUDE.md .
# Edit as needed
```

### Reference in Tools
```bash
# Claude Code can reference templates
claude "Create a new spec using the template"
```

## Template Types

### Project Templates
Complete project structures with:
- Directory layout
- Initial files
- Configuration
- Dependencies
- Documentation

### File Templates
Individual files like:
- CLAUDE.md (project instructions)
- SPEC.md (feature specifications)
- PLAN.md (implementation plans)
- README.md (project documentation)

### Configuration Templates
Standard configs for:
- TypeScript
- ESLint
- Prettier
- Build tools
- CI/CD

## Template Variables

Templates can include variables that get replaced:

```markdown
# {{PROJECT_NAME}}

Created: {{DATE}}
Author: {{AUTHOR}}
```

Process with:
```bash
sed -e "s/{{PROJECT_NAME}}/MyProject/g" \
    -e "s/{{DATE}}/$(date -I)/g" \
    template.md > output.md
```

## Creating Templates

### Project Template
1. Create a working project with your preferred setup
2. Remove generated files and build artifacts
3. Replace specific values with variables
4. Add README explaining setup
5. Move to `templates/projects/`

### File Template
1. Create the file with standard structure
2. Add placeholders for variable content
3. Document what should be customized
4. Move to `templates/files/`

## Best Practices

1. **Minimal but complete**: Include essentials, not everything
2. **Well-documented**: Explain what to customize
3. **Up-to-date**: Keep dependencies current
4. **Tested**: Verify templates work as expected
5. **Opinionated**: Encode your preferences and learnings
