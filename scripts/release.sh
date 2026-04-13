#!/bin/bash

# Release Helper Script
# Creates a semantic version tag and GitHub release

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo ""
echo "🏷️  Shulkerbox Release Tool"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Check if we're on main branch
current_branch=$(git branch --show-current)
if [ "$current_branch" != "main" ]; then
    echo -e "${RED}❌ Error: You must be on the main branch to create a release${NC}"
    echo "   Current branch: $current_branch"
    exit 1
fi

# Check for uncommitted changes
if ! git diff-index --quiet HEAD --; then
    echo -e "${RED}❌ Error: You have uncommitted changes${NC}"
    echo "   Please commit or stash your changes first"
    exit 1
fi

# Get current version (last tag)
current_version=$(git describe --tags --abbrev=0 2>/dev/null || echo "v0.0.0")
echo -e "Current version: ${GREEN}$current_version${NC}"
echo ""

# Parse version numbers
if [[ $current_version =~ ^v([0-9]+)\.([0-9]+)\.([0-9]+) ]]; then
    major="${BASH_REMATCH[1]}"
    minor="${BASH_REMATCH[2]}"
    patch="${BASH_REMATCH[3]}"
else
    major=0
    minor=0
    patch=0
fi

# Calculate next versions
next_major="v$((major + 1)).0.0"
next_minor="v${major}.$((minor + 1)).0"
next_patch="v${major}.${minor}.$((patch + 1))"

# Show options
echo "Select version bump:"
echo "  1) Patch   → $next_patch (bug fixes)"
echo "  2) Minor   → $next_minor (new features, backward compatible)"
echo "  3) Major   → $next_major (breaking changes)"
echo "  4) Custom version"
echo "  5) Cancel"
echo ""
read -p "Enter choice [1-5]: " choice

case $choice in
    1)
        new_version=$next_patch
        ;;
    2)
        new_version=$next_minor
        ;;
    3)
        new_version=$next_major
        ;;
    4)
        read -p "Enter version (e.g., v1.2.3): " new_version
        # Validate format
        if ! [[ $new_version =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
            echo -e "${RED}❌ Invalid version format. Use: vMAJOR.MINOR.PATCH${NC}"
            exit 1
        fi
        ;;
    5)
        echo "Cancelled"
        exit 0
        ;;
    *)
        echo -e "${RED}❌ Invalid choice${NC}"
        exit 1
        ;;
esac

echo ""
echo -e "${GREEN}Creating release: $new_version${NC}"
echo ""

# Get release title
read -p "Release title (e.g., 'Feature Name' or press enter for default): " release_title
if [ -z "$release_title" ]; then
    release_title="Release $new_version"
else
    release_title="$new_version: $release_title"
fi

# Confirm
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Summary:"
echo "  Version: $new_version"
echo "  Title: $release_title"
echo ""
read -p "Proceed? [y/N]: " confirm

if [[ ! $confirm =~ ^[Yy]$ ]]; then
    echo "Cancelled"
    exit 0
fi

# Create tag
echo ""
echo "Creating tag..."
git tag -a "$new_version" -m "$release_title"

# Push tag
echo "Pushing tag..."
git push origin "$new_version"

# Create GitHub release with auto-generated notes
echo "Creating GitHub release..."
if command -v gh &> /dev/null; then
    gh release create "$new_version" \
        --title "$release_title" \
        --generate-notes

    echo ""
    echo -e "${GREEN}✅ Release created successfully!${NC}"
    echo ""
    echo "View at: https://github.com/derrybirkett/shulkerbox/releases/tag/$new_version"
else
    echo ""
    echo -e "${YELLOW}⚠️  GitHub CLI (gh) not found${NC}"
    echo ""
    echo "Tag created and pushed. Create the GitHub release manually at:"
    echo "  https://github.com/derrybirkett/shulkerbox/releases/new?tag=$new_version"
fi

echo ""
