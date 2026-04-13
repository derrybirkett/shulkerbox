# Development Workflow

This document outlines the development workflow and practices for this project.

## Branch Protection

### Main Branch Policy

**Direct pushes to `main` are blocked** by a pre-push git hook. All changes must go through feature branches and pull requests.

### Workflow

1. **Create a feature branch**
   ```bash
   git checkout -b feature/descriptive-name
   # or for fixes
   git checkout -b fix/bug-description
   ```

2. **Make your changes and commit**
   ```bash
   git add .
   git commit -m "feat: description of your changes"
   ```

3. **Push your branch**
   ```bash
   git push -u origin feature/descriptive-name
   ```

4. **Create a Pull Request** on GitHub

5. **After PR is merged**, update your local main:
   ```bash
   git checkout main
   git pull origin main
   ```

## Semantic Versioning

This project follows [Semantic Versioning 2.0.0](https://semver.org/).

### Version Format: MAJOR.MINOR.PATCH

- **MAJOR** version: incompatible API changes or breaking changes
- **MINOR** version: new functionality in a backward-compatible manner
- **PATCH** version: backward-compatible bug fixes

### Tagging Releases

When ready to create a release:

1. **Determine the version bump**
   - Breaking changes? → Bump MAJOR
   - New features? → Bump MINOR
   - Bug fixes only? → Bump PATCH

2. **Create and push the tag**
   ```bash
   # For a new minor version (e.g., 1.2.0 → 1.3.0)
   git tag -a v1.3.0 -m "Release v1.3.0: Brief description of changes"
   git push origin v1.3.0
   ```

3. **Create a GitHub Release** (see below)

### Initial Version

For pre-1.0.0 releases:
- Start at `v0.1.0`
- Use `0.x.y` for development versions
- Breaking changes can bump MINOR (not MAJOR) until v1.0.0
- Once stable, release `v1.0.0`

## GitHub Releases

### Creating a Release

After pushing a tag, create a GitHub release:

1. **Using GitHub CLI** (recommended):
   ```bash
   gh release create v1.3.0 \
     --title "v1.3.0: Feature Name" \
     --notes "
   ## What's Changed
   
   ### Features
   - New feature A
   - New feature B
   
   ### Bug Fixes
   - Fixed issue X
   - Fixed issue Y
   
   ### Documentation
   - Updated README
   
   **Full Changelog**: https://github.com/derrybirkett/shulkerbox/compare/v1.2.0...v1.3.0
   "
   ```

2. **Using GitHub Web UI**:
   - Go to: https://github.com/derrybirkett/shulkerbox/releases/new
   - Select your tag
   - Add release title and notes
   - Click "Publish release"

### Release Notes Template

Use this template for consistent release notes:

```markdown
## What's Changed

### Features ✨
- Feature description (#PR-number)

### Bug Fixes 🐛
- Fix description (#PR-number)

### Documentation 📚
- Doc changes

### Chores 🔧
- Maintenance tasks

### Breaking Changes ⚠️
- Breaking change description

**Full Changelog**: https://github.com/derrybirkett/shulkerbox/compare/vX.Y.Z...vX.Y.Z
```

## Commit Message Convention

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

### Types
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `chore`: Maintenance tasks
- `refactor`: Code refactoring
- `test`: Test changes
- `ci`: CI/CD changes

### Examples
```bash
feat(api): add user authentication endpoint
fix(parser): handle null values in JSON
docs: update installation instructions
chore: bump dependencies
```

## Release Helper Script

A convenience script is provided to streamline the release process:

```bash
./scripts/release.sh
```

This interactive script will:
- Validate you're on main with no uncommitted changes
- Show current version and calculate next versions
- Guide you through version selection
- Create and push the tag
- Create the GitHub release automatically

## Quick Reference

```bash
# Start new work
git checkout main
git pull origin main
git checkout -b feature/my-feature

# Commit work
git add .
git commit -m "feat: my feature"

# Push and create PR
git push -u origin feature/my-feature
# Then create PR on GitHub

# After merge, create a release
git checkout main
git pull origin main
./scripts/release.sh
```
