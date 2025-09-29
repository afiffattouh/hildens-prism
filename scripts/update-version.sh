#!/bin/bash
# PRISM Framework Version Update Script
# Automates the version update process across all files

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Check if version argument is provided
if [[ $# -eq 0 ]]; then
    echo -e "${RED}Error: No version number provided${NC}"
    echo "Usage: $0 <new_version>"
    echo "Example: $0 2.0.3"
    exit 1
fi

NEW_VERSION="$1"
OLD_VERSION=$(cat VERSION 2>/dev/null || echo "unknown")

# Validate version format (basic semantic versioning)
if ! [[ "$NEW_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo -e "${RED}Error: Invalid version format${NC}"
    echo "Please use semantic versioning format: MAJOR.MINOR.PATCH"
    echo "Example: 2.0.3"
    exit 1
fi

echo -e "${BOLD}${BLUE}═══════════════════════════════════════════${NC}"
echo -e "${BOLD}${BLUE}  PRISM Version Update Script${NC}"
echo -e "${BOLD}${BLUE}═══════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}Current Version:${NC} $OLD_VERSION"
echo -e "${BOLD}New Version:${NC} $NEW_VERSION"
echo ""

# Function to update a file
update_file() {
    local file=$1
    local pattern=$2
    local replacement=$3
    local description=$4

    if [[ -f "$file" ]]; then
        echo -n "  Updating $description... "
        if [[ "$(uname)" == "Darwin" ]]; then
            # macOS sed syntax
            sed -i '' "$pattern" "$file"
        else
            # Linux sed syntax
            sed -i "$pattern" "$file"
        fi
        echo -e "${GREEN}✓${NC}"
    else
        echo -e "  ${YELLOW}⚠ Skipped $description (file not found)${NC}"
    fi
}

echo -e "${BOLD}Step 1: Updating Core Version Files${NC}"
echo -n "  Updating VERSION file... "
echo "$NEW_VERSION" > VERSION
echo -e "${GREEN}✓${NC}"

# Update local installation if it exists
if [[ -d "$HOME/.prism" ]]; then
    echo -n "  Updating ~/.prism/VERSION... "
    echo "$NEW_VERSION" > "$HOME/.prism/VERSION"
    echo -e "${GREEN}✓${NC}"
fi

echo ""
echo -e "${BOLD}Step 2: Updating Documentation${NC}"

# Update README.md version badge
update_file "README.md" \
    "s/version-[0-9]*\.[0-9]*\.[0-9]*/version-$NEW_VERSION/g" \
    "" \
    "README.md version badge"

# Update docs/API.md
update_file "docs/API.md" \
    "s/version: [0-9]*\.[0-9]*\.[0-9]*/version: $NEW_VERSION/g" \
    "" \
    "docs/API.md configuration"

# Update docs/INSTALL.md
update_file "docs/INSTALL.md" \
    "s/version: [0-9]*\.[0-9]*\.[0-9]*/version: $NEW_VERSION/g" \
    "" \
    "docs/INSTALL.md configuration"

# Update install.sh fallback version
update_file "install.sh" \
    "s/echo \"[0-9]*\.[0-9]*\.[0-9]*\"/echo \"$NEW_VERSION\"/g" \
    "" \
    "install.sh fallback version"

# Update lib/prism-core.sh
if [[ -f "lib/prism-core.sh" ]]; then
    echo -n "  Updating lib/prism-core.sh PRISM_VERSION... "
    if grep -q "^readonly PRISM_VERSION=" lib/prism-core.sh; then
        update_file "lib/prism-core.sh" \
            "s/^readonly PRISM_VERSION=\"[0-9]*\.[0-9]*\.[0-9]*\"/readonly PRISM_VERSION=\"$NEW_VERSION\"/g" \
            "" \
            ""
    else
        echo -e "${YELLOW}⚠ PRISM_VERSION constant not found${NC}"
    fi
fi

# Update lib/prism-update.sh fallback
if [[ -f "lib/prism-update.sh" ]]; then
    echo -n "  Updating lib/prism-update.sh fallback... "
    if grep -q "PRISM_VERSION:-[0-9]" lib/prism-update.sh; then
        update_file "lib/prism-update.sh" \
            "s/PRISM_VERSION:-[0-9]*\.[0-9]*\.[0-9]*/PRISM_VERSION:-$NEW_VERSION/g" \
            "" \
            ""
    else
        echo -e "${YELLOW}⚠ Fallback version not found${NC}"
    fi
fi

echo ""
echo -e "${BOLD}Step 3: Adding CHANGELOG Entry${NC}"

# Get current date
CURRENT_DATE=$(date +%Y-%m-%d)

# Check if CHANGELOG.md exists and add entry
if [[ -f "CHANGELOG.md" ]]; then
    # Check if version already exists in CHANGELOG
    if grep -q "## \[$NEW_VERSION\]" CHANGELOG.md; then
        echo -e "  ${YELLOW}⚠ Version $NEW_VERSION already exists in CHANGELOG${NC}"
    else
        echo -n "  Adding CHANGELOG entry... "
        # Create temporary file with new entry
        cat > /tmp/changelog_entry.tmp << EOF
## [$NEW_VERSION] - $CURRENT_DATE

### Changed
- Updated version to $NEW_VERSION

EOF

        # Insert after the header (line 3)
        if [[ "$(uname)" == "Darwin" ]]; then
            # macOS
            sed -i '' '4r /tmp/changelog_entry.tmp' CHANGELOG.md
        else
            # Linux
            sed -i '4r /tmp/changelog_entry.tmp' CHANGELOG.md
        fi
        rm /tmp/changelog_entry.tmp
        echo -e "${GREEN}✓${NC}"
    fi
else
    echo -e "  ${YELLOW}⚠ CHANGELOG.md not found${NC}"
fi

echo ""
echo -e "${BOLD}Step 4: Version Verification${NC}"

# Local verification
echo -n "  Checking VERSION file... "
if [[ "$(cat VERSION)" == "$NEW_VERSION" ]]; then
    echo -e "${GREEN}✓${NC} $NEW_VERSION"
else
    echo -e "${RED}✗${NC} Mismatch!"
fi

# Check local installation
if [[ -f "$HOME/.prism/VERSION" ]]; then
    echo -n "  Checking ~/.prism/VERSION... "
    if [[ "$(cat $HOME/.prism/VERSION)" == "$NEW_VERSION" ]]; then
        echo -e "${GREEN}✓${NC} $NEW_VERSION"
    else
        echo -e "${RED}✗${NC} Mismatch!"
    fi
fi

# Check if prism command is available
if command -v prism &> /dev/null; then
    echo -n "  Checking 'prism version' command... "
    PRISM_VERSION_OUTPUT=$(prism version 2>&1 | grep -o '[0-9]*\.[0-9]*\.[0-9]*' | head -1)
    if [[ "$PRISM_VERSION_OUTPUT" == "$NEW_VERSION" ]]; then
        echo -e "${GREEN}✓${NC} $NEW_VERSION"
    else
        echo -e "${YELLOW}⚠${NC} Shows $PRISM_VERSION_OUTPUT (may need restart)"
    fi
fi

echo ""
echo -e "${BOLD}Step 5: Files Changed${NC}"
echo "  Modified files:"
git status --short | grep -E "^ M " | sed 's/^ M /    - /'

echo ""
echo -e "${BOLD}Step 6: Verification Checklist${NC}"
echo "  Run these commands to verify:"
echo "    ${BLUE}cat VERSION${NC}"
echo "    ${BLUE}cat ~/.prism/VERSION${NC}"
echo "    ${BLUE}prism version${NC}"
echo "    ${BLUE}prism update --check${NC}"
echo ""
echo "  After pushing to GitHub:"
echo "    ${BLUE}curl -fsSL https://raw.githubusercontent.com/afiffattouh/hildens-prism/main/VERSION${NC}"

echo ""
echo -e "${BOLD}Step 7: Git Commands${NC}"
echo "  To commit these changes, run:"
echo "    ${BLUE}git add -A${NC}"
echo "    ${BLUE}git commit -m \"chore: Bump version to $NEW_VERSION\"${NC}"
echo "    ${BLUE}git push origin main${NC}"

echo ""
echo -e "${GREEN}${BOLD}✓ Version update to $NEW_VERSION completed!${NC}"
echo ""
echo -e "${YELLOW}Note: Remember to test 'prism update' from an older version after pushing.${NC}"