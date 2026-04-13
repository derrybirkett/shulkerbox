# Configs

Shared configuration files for tools and development environments.

## What Goes Here?

Reusable configuration files that you want to use across multiple projects:
- Tool configurations (ESLint, Prettier, TypeScript)
- IDE settings (VS Code, JetBrains)
- Build configurations (Vite, Webpack)
- CI/CD pipelines (GitHub Actions)
- Development environment setup

## Structure

```
configs/
├── eslint/
│   ├── base.js
│   ├── react.js
│   └── typescript.js
├── typescript/
│   ├── tsconfig.base.json
│   └── tsconfig.strict.json
├── vscode/
│   └── settings.json
└── github/
    └── workflows/
```

## Using Configs

### Extend in Project
```javascript
// eslint.config.js
import baseConfig from '~/shulkerbox/configs/eslint/base.js';

export default [
  ...baseConfig,
  // Project-specific overrides
];
```

### Symlink
```bash
# Link VS Code settings
ln -s ~/shulkerbox/configs/vscode/settings.json .vscode/settings.json

# Link TypeScript config
ln -s ~/shulkerbox/configs/typescript/tsconfig.base.json tsconfig.json
```

### Copy and Customize
```bash
# Copy as starting point
cp ~/shulkerbox/configs/github/workflows/ci.yml .github/workflows/
# Edit as needed
```

## Configuration Types

### Tool Configs
Standard configurations for:
- **ESLint**: Linting rules and plugins
- **Prettier**: Code formatting preferences
- **TypeScript**: Compiler options
- **Tailwind**: Design system tokens
- **Vite/Webpack**: Build configuration

### IDE Settings
Workspace settings for:
- **VS Code**: Editor preferences, extensions
- **JetBrains**: Code style, inspections
- **Vim/Neovim**: Plugin configuration

### CI/CD
Pipeline definitions for:
- **GitHub Actions**: Workflows
- **GitLab CI**: Pipeline configs
- **CircleCI**: Build steps

### Environment
Setup files for:
- **Docker**: Compose files, Dockerfiles
- **Shell**: Profile, aliases, functions
- **Git**: Global config, ignore patterns

## Best Practices

### Composable Configs
Structure configs to be extended:

```javascript
// configs/eslint/base.js
export default {
  rules: {
    // Base rules
  }
};

// configs/eslint/react.js
import base from './base.js';
export default {
  ...base,
  rules: {
    ...base.rules,
    // React-specific rules
  }
};
```

### Document Decisions
Explain non-obvious choices:

```javascript
export default {
  rules: {
    // Disabled because we use TypeScript for type checking
    'no-undef': 'off',
  }
};
```

### Version Dependencies
Track tool versions for configs:

```json
{
  "_meta": {
    "eslint": "^9.0.0",
    "prettier": "^3.0.0",
    "updated": "2026-04-13"
  }
}
```

## Sharing Configs

### As npm Package
```bash
# Publish configs as a package
cd configs/eslint
npm init -y
npm publish
```

### As Git Submodule
```bash
# Add as submodule
git submodule add https://github.com/you/shulkerbox configs-shared
```

### Direct Reference
```javascript
// Import from repo
import config from '~/shulkerbox/configs/eslint/base.js';
```

## Updating Configs

1. **Test changes**: Verify in a project first
2. **Document breaking changes**: Note in commit message
3. **Version appropriately**: Semver for breaking changes
4. **Migrate gradually**: Don't force immediate updates

## Example: ESLint Config

```javascript
// configs/eslint/base.js
export default {
  rules: {
    // Code quality
    'no-console': 'warn',
    'no-debugger': 'error',
    
    // Style (let Prettier handle formatting)
    'max-len': 'off',
    
    // Modern JS
    'prefer-const': 'error',
    'no-var': 'error',
  }
};
```

Use in project:
```javascript
// eslint.config.js
import base from '~/shulkerbox/configs/eslint/base.js';

export default base;
```
