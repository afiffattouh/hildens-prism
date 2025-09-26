#!/bin/bash

# PRISM Framework Update Script
# Updates PRISM framework files from the GitHub repository

# Configuration
GITHUB_REPO="https://github.com/afiffattouh/hildens-prism"
GITHUB_RAW="https://raw.githubusercontent.com/afiffattouh/hildens-prism"
BRANCH="main"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Files to update
CORE_FILES=(
    "PRISM.md"
    "prism-context.sh"
)

# Template files that can be updated (NOT user context!)
# These are framework files, not user-generated content
PRISM_TEMPLATE_FILES=(
    ".prism/time-sync.md"  # Time sync documentation only
)

# Cursor IDE integration files (optional)
CURSOR_FILES=(
    ".cursor/README.md"
    ".cursor/rules/code-generation-workflow.mdc"
    ".cursor/rules/core-development-principles.mdc"
    ".cursor/rules/documentation-standards.mdc"
    ".cursor/rules/emergency-protocols.mdc"
    ".cursor/rules/prism-integration.mdc"
    ".cursor/rules/quality-performance-standards.mdc"
    ".cursor/rules/security-standards.mdc"
    ".cursor/rules/testing-requirements.mdc"
)

# Files that should NEVER be updated (user's persistent context)
PROTECTED_FILES=(
    ".prism/context/architecture.md"
    ".prism/context/patterns.md"
    ".prism/context/decisions.md"
    ".prism/context/dependencies.md"
    ".prism/context/domain.md"
    ".prism/sessions/*"
    ".prism/references/*"
    ".prism/.time_sync"
    ".prism/.last_update"
)

# Header
echo -e "${BOLD}${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${BOLD}${BLUE}           PRISM Framework Update Manager${NC}"
echo -e "${BOLD}${BLUE}═══════════════════════════════════════════════════════${NC}"
echo ""

# Check if we're in a PRISM project
if [ ! -f "PRISM.md" ] || [ ! -d ".prism" ]; then
    echo -e "${RED}Error: This doesn't appear to be a PRISM project${NC}"
    echo -e "${YELLOW}Please run this script from a directory with PRISM installed${NC}"
    exit 1
fi

# Important message about context preservation
echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✓ Your persistent context is SAFE and will NOT be modified:${NC}"
echo -e "  • ${BOLD}.prism/context/${NC} - Your architecture, patterns, decisions"
echo -e "  • ${BOLD}.prism/sessions/${NC} - Your session history"
echo -e "  • ${BOLD}.prism/references/${NC} - Your API specs and rules"
echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BLUE}This updater only updates:${NC}"
echo -e "  • PRISM.md (framework rules)"
echo -e "  • prism-context.sh (management script)"
echo -e "  • Documentation files"
echo -e "  • .cursor/ IDE rules (if using Cursor)"
echo ""

# Function to get current version
get_current_version() {
    if [ -f ".prism/.version" ]; then
        cat .prism/.version
    else
        echo "unknown"
    fi
}

# Function to get latest version from GitHub
get_latest_version() {
    # Get the latest commit hash
    local latest_hash=$(curl -s "https://api.github.com/repos/afiffattouh/hildens-prism/commits/${BRANCH}" | grep '"sha"' | head -1 | cut -d'"' -f4 | cut -c1-7)

    if [ -z "$latest_hash" ]; then
        echo "unknown"
    else
        echo "$latest_hash"
    fi
}

# Function to backup current files
backup_files() {
    local backup_dir=".prism/backups/$(date +%Y%m%d_%H%M%S)"
    echo -e "${BLUE}Creating backup in $backup_dir...${NC}"

    mkdir -p "$backup_dir"

    for file in "${CORE_FILES[@]}"; do
        if [ -f "$file" ]; then
            cp "$file" "$backup_dir/"
            echo -e "  Backed up: $file"
        fi
    done

    # Backup Cursor files if they exist
    if [ -d ".cursor" ]; then
        mkdir -p "$backup_dir/.cursor"
        for file in "${CURSOR_FILES[@]}"; do
            if [ -f "$file" ]; then
                cp "$file" "$backup_dir/.cursor/"
                echo -e "  Backed up: $file"
            fi
        done
    fi

    echo -e "${GREEN}✓ Backup complete${NC}"
    echo ""
}

# Function to download file from GitHub
download_file() {
    local file=$1
    local url="${GITHUB_RAW}/${BRANCH}/${file}"
    local temp_file="/tmp/prism_update_$(basename $file)"

    echo -e "  Downloading: $file"

    # Download to temp location first
    if curl -s -f -o "$temp_file" "$url"; then
        # Compare with existing file
        if [ -f "$file" ]; then
            if diff -q "$file" "$temp_file" > /dev/null; then
                echo -e "    ${GRAY}No changes${NC}"
                rm "$temp_file"
                return 1
            else
                echo -e "    ${GREEN}Updated${NC}"
                mv "$temp_file" "$file"
                return 0
            fi
        else
            echo -e "    ${GREEN}Created${NC}"
            mv "$temp_file" "$file"
            return 0
        fi
    else
        echo -e "    ${RED}Failed to download${NC}"
        return 2
    fi
}

# Function to check for updates
check_updates() {
    echo -e "${BLUE}Checking for updates...${NC}"

    local current_version=$(get_current_version)
    local latest_version=$(get_latest_version)

    echo -e "Current version: ${YELLOW}$current_version${NC}"
    echo -e "Latest version:  ${GREEN}$latest_version${NC}"
    echo ""

    if [ "$current_version" = "$latest_version" ] && [ "$current_version" != "unknown" ]; then
        echo -e "${GREEN}✓ You're already on the latest version!${NC}"

        # Ask if they want to force update anyway
        read -p "Do you want to check for file updates anyway? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 0
        fi
    fi
}

# Function to update core files
update_core_files() {
    echo -e "${BLUE}Updating core PRISM files...${NC}"

    local updated=0
    local failed=0

    for file in "${CORE_FILES[@]}"; do
        download_file "$file"
        case $? in
            0) ((updated++)) ;;
            2) ((failed++)) ;;
        esac
    done

    # Make scripts executable
    if [ -f "prism-context.sh" ]; then
        chmod +x prism-context.sh
    fi

    echo ""

    if [ $updated -gt 0 ]; then
        echo -e "${GREEN}✓ Updated $updated file(s)${NC}"
    fi

    if [ $failed -gt 0 ]; then
        echo -e "${RED}✗ Failed to update $failed file(s)${NC}"
    fi

    if [ $updated -eq 0 ] && [ $failed -eq 0 ]; then
        echo -e "${YELLOW}No updates needed for core files${NC}"
    fi
}

# Function to update template files (optional)
update_templates() {
    echo ""
    echo -e "${YELLOW}Note: Your context files will NOT be modified${NC}"
    echo -e "${YELLOW}Only framework documentation will be updated${NC}"
    echo ""
    read -p "Do you want to update PRISM framework documentation? (y/n) " -n 1 -r
    echo

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}Updating framework documentation...${NC}"
        echo -e "${GREEN}✓ Your context is safe in:${NC}"
        echo -e "  • .prism/context/ (your decisions, patterns, architecture)"
        echo -e "  • .prism/sessions/ (your session history)"
        echo -e "  • .prism/references/ (your API specs and rules)"
        echo ""

        for file in "${PRISM_TEMPLATE_FILES[@]}"; do
            download_file "$file"
        done
    fi
}

# Function to update Cursor IDE files (optional)
update_cursor_files() {
    # Only ask if .cursor directory exists or user might want it
    if [ -d ".cursor" ]; then
        echo ""
        echo -e "${BLUE}Cursor IDE integration detected${NC}"
        read -p "Do you want to update Cursor IDE rules? (y/n) " -n 1 -r
        echo

        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo -e "${BLUE}Updating Cursor IDE rules...${NC}"

            local updated=0
            local failed=0

            # Create .cursor directory structure if it doesn't exist
            mkdir -p .cursor/rules

            for file in "${CURSOR_FILES[@]}"; do
                download_file "$file"
                case $? in
                    0) ((updated++)) ;;
                    2) ((failed++)) ;;
                esac
            done

            if [ $updated -gt 0 ]; then
                echo -e "${GREEN}✓ Updated $updated Cursor file(s)${NC}"
            fi

            if [ $failed -gt 0 ]; then
                echo -e "${YELLOW}⚠️ Failed to update $failed Cursor file(s)${NC}"
            fi
        fi
    else
        # Ask if user wants to add Cursor support even if not present
        echo ""
        read -p "Do you want to add Cursor IDE integration to your project? (y/n) " -n 1 -r
        echo

        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo -e "${BLUE}Adding Cursor IDE integration...${NC}"

            local updated=0
            local failed=0

            # Create .cursor directory structure
            mkdir -p .cursor/rules

            for file in "${CURSOR_FILES[@]}"; do
                download_file "$file"
                case $? in
                    0) ((updated++)) ;;
                    2) ((failed++)) ;;
                esac
            done

            if [ $updated -gt 0 ]; then
                echo -e "${GREEN}✓ Added $updated Cursor file(s)${NC}"
            fi

            if [ $failed -gt 0 ]; then
                echo -e "${RED}✗ Failed to add $failed Cursor file(s)${NC}"
            fi
        fi
    fi
}

# Function to save version
save_version() {
    local latest_version=$(get_latest_version)

    if [ "$latest_version" != "unknown" ]; then
        echo "$latest_version" > .prism/.version

        # Also save update timestamp
        cat > .prism/.last_update << EOF
# PRISM Framework Update Log
Last Updated: $(date -Iseconds)
Version: $latest_version
Repository: $GITHUB_REPO
Branch: $BRANCH
EOF

        echo ""
        echo -e "${GREEN}✓ Version updated to: $latest_version${NC}"
    fi
}

# Function to show changes
show_changelog() {
    echo ""
    echo -e "${BLUE}Recent changes from GitHub:${NC}"

    # Get recent commits
    curl -s "https://api.github.com/repos/afiffattouh/hildens-prism/commits?sha=${BRANCH}&per_page=5" | \
        grep '"message"' | \
        head -5 | \
        cut -d'"' -f4 | \
        while IFS= read -r line; do
            echo "  • $line"
        done

    echo ""
}

# Main execution
main() {
    # Parse arguments
    case "${1:-}" in
        --check|-c)
            check_updates
            exit 0
            ;;
        --force|-f)
            echo -e "${YELLOW}Force update mode${NC}"
            ;;
        --help|-h)
            echo "PRISM Framework Update Manager"
            echo ""
            echo "Usage: $0 [options]"
            echo ""
            echo "Options:"
            echo "  --check, -c    Check for updates without installing"
            echo "  --force, -f    Force update even if on latest version"
            echo "  --help, -h     Show this help message"
            echo ""
            echo "Without options, the script will check and install updates"
            exit 0
            ;;
    esac

    # Check for updates
    if [ "${1:-}" != "--force" ] && [ "${1:-}" != "-f" ]; then
        check_updates
    fi

    # Create backup
    backup_files

    # Update core files
    update_core_files

    # Ask about template updates
    update_templates

    # Ask about Cursor IDE updates
    update_cursor_files

    # Save version info
    save_version

    # Show recent changes
    show_changelog

    # Final message
    echo -e "${BOLD}${GREEN}═══════════════════════════════════════════════════════${NC}"
    echo -e "${BOLD}${GREEN}            Update Process Complete!${NC}"
    echo -e "${BOLD}${GREEN}═══════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${YELLOW}Note: Your context files in .prism/context/ were preserved${NC}"
    echo -e "${YELLOW}Backups saved in: .prism/backups/${NC}"
    echo ""
    echo -e "${BLUE}Run './prism-context.sh status' to verify everything is working${NC}"
}

# Run main function
main "$@"