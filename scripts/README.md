# Scripts

Automation utilities, build tools, and CLI wrappers for skills and workflows.

## Directory Structure

```
scripts/
├── bin/          # Executable scripts (add to PATH)
├── lib/          # Shared library functions
└── tools/        # Development and maintenance tools
```

## Available Scripts

### bin/wrap-up
CLI wrapper for the wrap-up skill. Invokes Claude Code's `/wrap-up` command in the current directory.

**Usage:**
```bash
wrap-up
```

**Requirements:**
- Claude Code CLI (`claude`) must be installed and in PATH

## Adding Scripts to PATH

Add the bin directory to your PATH for easy access:

```bash
# For bash
echo 'export PATH="$HOME/shulkerbox/scripts/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# For zsh
echo 'export PATH="$HOME/shulkerbox/scripts/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

## Script Guidelines

### Shebang
Always include a shebang line:
```bash
#!/usr/bin/env bash
```

### Error Handling
Use strict error handling:
```bash
set -euo pipefail
```

### Portability
- Use POSIX-compliant commands where possible
- Test on both macOS and Linux
- Handle path differences gracefully
- Use `$HOME` instead of `~`

### Documentation
Include usage documentation in comments:
```bash
#!/usr/bin/env bash
#
# script-name — Brief description
#
# Usage: script-name [options] [arguments]
#
# Options:
#   -h, --help    Show this help message
#
```

### Dependencies
Check for required commands:
```bash
if ! command -v required_tool &> /dev/null; then
    echo "Error: required_tool not found in PATH"
    exit 1
fi
```

## Creating New Scripts

1. Create the script in `scripts/bin/`:
   ```bash
   cat > scripts/bin/my-script << 'EOF'
   #!/usr/bin/env bash
   set -euo pipefail
   
   # Script logic here
   EOF
   ```

2. Make it executable:
   ```bash
   chmod +x scripts/bin/my-script
   ```

3. Test it:
   ```bash
   ./scripts/bin/my-script
   ```

4. Commit:
   ```bash
   git add scripts/bin/my-script
   git commit -m "feat: add my-script"
   ```

## Script Types

### CLI Wrappers
Scripts that invoke LLM skills or tools:
- Keep them simple
- Pass arguments through
- Handle tool availability

### Automation
Scripts that automate repetitive tasks:
- Document prerequisites
- Provide dry-run mode if destructive
- Use verbose output

### Utilities
Helper scripts for development:
- Single responsibility
- Composable with other tools
- Clear input/output
