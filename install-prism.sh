#!/bin/bash

# PRISM Framework Universal Installer
# One-command installation for new machines
# Usage: curl -sSL https://raw.githubusercontent.com/[your-username]/prism-framework/main/install-prism.sh | bash

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

# Configuration
CLAUDE_DIR="$HOME/.claude"
GITHUB_REPO="https://github.com/afiffattouh/hildens-prism"
GITHUB_RAW="https://raw.githubusercontent.com/afiffattouh/hildens-prism/main"

# Header
clear
echo -e "${BOLD}${BLUE}╔═══════════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${BLUE}║         PRISM Framework Universal Installer          ║${NC}"
echo -e "${BOLD}${BLUE}║   Persistent Real-time Intelligent System Management ║${NC}"
echo -e "${BOLD}${BLUE}╚═══════════════════════════════════════════════════════╝${NC}"
echo ""

# Function to check dependencies
check_dependencies() {
    echo -e "${BLUE}Checking dependencies...${NC}"

    local missing_deps=()

    # Check for curl
    if ! command -v curl &> /dev/null; then
        missing_deps+=("curl")
    fi

    # Check for git (optional but recommended)
    if ! command -v git &> /dev/null; then
        echo -e "${YELLOW}⚠ git not found (optional but recommended)${NC}"
    fi

    # If critical dependencies are missing
    if [ ${#missing_deps[@]} -gt 0 ]; then
        echo -e "${RED}✗ Missing required dependencies: ${missing_deps[*]}${NC}"
        echo -e "${YELLOW}Please install them first:${NC}"

        # Provide OS-specific installation commands
        if [[ "$OSTYPE" == "darwin"* ]]; then
            echo "  brew install ${missing_deps[*]}"
        elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
            echo "  sudo apt-get install ${missing_deps[*]}  # Debian/Ubuntu"
            echo "  sudo yum install ${missing_deps[*]}      # RedHat/CentOS"
        fi
        exit 1
    fi

    echo -e "${GREEN}✓ All dependencies satisfied${NC}"
}

# Function to create Claude directory structure
create_claude_structure() {
    echo -e "${BLUE}Creating Claude configuration directory...${NC}"

    # Create main Claude directory
    mkdir -p "$CLAUDE_DIR"
    mkdir -p "$CLAUDE_DIR/.prism"

    echo -e "${GREEN}✓ Created $CLAUDE_DIR${NC}"
}

# Function to download core files
download_core_files() {
    echo -e "${BLUE}Installing PRISM core files...${NC}"

    # Always create/update PRISM.md
    if [ ! -f "$CLAUDE_DIR/PRISM.md" ]; then
        echo -e "  Creating PRISM.md..."
        create_prism_md
    else
        echo -e "  ${YELLOW}PRISM.md already exists, preserving${NC}"
    fi

    # Create or update CLAUDE.md to include PRISM
    if [ ! -f "$CLAUDE_DIR/CLAUDE.md" ]; then
        echo -e "  Creating CLAUDE.md..."
        create_claude_md
    else
        # Check if PRISM is already referenced
        if ! grep -q "@PRISM.md" "$CLAUDE_DIR/CLAUDE.md"; then
            echo -e "  Updating CLAUDE.md to include PRISM..."
            # Backup original
            cp "$CLAUDE_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md.backup"
            # Add PRISM reference at the top
            {
                echo "# Claude Code Configuration Entry Point"
                echo ""
                echo "## PRISM Framework - CRITICAL PRIORITY"
                echo "@PRISM.md"
                echo ""
                tail -n +2 "$CLAUDE_DIR/CLAUDE.md.backup"
            } > "$CLAUDE_DIR/CLAUDE.md"
            echo -e "    ${GREEN}✓ Updated CLAUDE.md${NC}"
        else
            echo -e "  ${GREEN}✓ CLAUDE.md already includes PRISM${NC}"
        fi
    fi

    # Don't overwrite other existing SuperClaude files
    local optional_files=(
        "COMMANDS.md"
        "FLAGS.md"
        "PRINCIPLES.md"
        "RULES.md"
        "MCP.md"
        "PERSONAS.md"
        "ORCHESTRATOR.md"
        "MODES.md"
    )

    for file in "${optional_files[@]}"; do
        if [ ! -f "$CLAUDE_DIR/$file" ]; then
            echo -e "  ${YELLOW}$file not found (optional)${NC}"
        else
            echo -e "  ${GREEN}✓ $file exists (preserved)${NC}"
        fi
    done
}

# Function to create PRISM.md if download fails
create_prism_md() {
    cat > "$CLAUDE_DIR/PRISM.md" << 'EOF'
# PRISM.md - Persistent Real-time Intelligent System Management Framework

## 🎯 PRISM Framework for Claude Code

**Core Directive**: PRISM framework enhances Claude Code with persistent context and intelligent management.

## 🚀 Quick Start

### Initialize PRISM in a New Project
```bash
# Run in your project directory
~/.claude/prism-init.sh
```

## 🧠 Core Principles

### 1. Persistent Memory
- **ALWAYS** check for existing .prism/ context
- **MAINTAIN** context across sessions
- **UPDATE** patterns and decisions in real-time
- **REFERENCE** historical decisions

### 2. Real-time Awareness
- **SYNC** time on session start via WebSearch
- **TRACK** all timestamps
- **MONITOR** file changes
- **DETECT** environment changes

### 3. Intelligent Management
- **LEARN** from patterns
- **ADAPT** based on history
- **SUGGEST** improvements
- **PREVENT** known issues

## 📋 Project Structure
```
.prism/
├── context/
│   ├── architecture.md     # System design
│   ├── patterns.md         # Code patterns
│   ├── decisions.md        # Technical decisions
│   ├── dependencies.md     # Dependencies
│   └── domain.md          # Business logic
├── sessions/
│   ├── current.md         # Active session
│   └── archive/           # History
└── references/            # API specs, schemas
```

## 🛡️ Security Standards
- OWASP Top 10 scanning
- Input validation
- Authentication review
- Vulnerability testing

## ✅ Quality Gates
- Test coverage ≥85%
- Complexity <10
- Performance <200ms
- Security: Zero CRITICAL

---
*PRISM Framework - Auto-loads via ~/.claude/CLAUDE.md*
EOF
    echo -e "    ${GREEN}✓ Created PRISM.md${NC}"
}

# Function to create CLAUDE.md
create_claude_md() {
    cat > "$CLAUDE_DIR/CLAUDE.md" << 'EOF'
# Claude Code Configuration Entry Point

## PRISM Framework - CRITICAL PRIORITY
@PRISM.md

## Additional Components (Optional)
@COMMANDS.md
@FLAGS.md
@PRINCIPLES.md
@RULES.md
@MCP.md
@PERSONAS.md
@ORCHESTRATOR.md
@MODES.md
EOF
    echo -e "    ${GREEN}✓ Created CLAUDE.md${NC}"
}

# Function to download initialization scripts
download_init_scripts() {
    echo -e "${BLUE}Installing initialization scripts...${NC}"

    # Download prism-init.sh
    echo -e "  Downloading prism-init.sh..."
    if curl -sSf -o "$CLAUDE_DIR/prism-init.sh" "$GITHUB_RAW/prism-init.sh" 2>/dev/null; then
        chmod +x "$CLAUDE_DIR/prism-init.sh"
        echo -e "    ${GREEN}✓${NC}"
    else
        # Create local version
        create_init_script
    fi

    # Download prism-update.sh
    echo -e "  Downloading prism-update.sh..."
    if curl -sSf -o "$CLAUDE_DIR/prism-update.sh" "$GITHUB_RAW/prism-update.sh" 2>/dev/null; then
        chmod +x "$CLAUDE_DIR/prism-update.sh"
        echo -e "    ${GREEN}✓${NC}"
    else
        echo -e "    ${YELLOW}⚠ Update script not available${NC}"
    fi
}

# Function to create initialization script
create_init_script() {
    cat > "$CLAUDE_DIR/prism-init.sh" << 'EOF'
#!/bin/bash

# PRISM Project Initialization Script
# Run this in any project directory to initialize PRISM

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}Initializing PRISM Framework...${NC}"

# Create directory structure
mkdir -p .prism/context
mkdir -p .prism/sessions/archive
mkdir -p .prism/references

# Create context files
cat > .prism/context/architecture.md << 'ARCH'
# System Architecture
**Last Updated**: $(date -Iseconds)
**Priority**: CRITICAL

## Summary
System design and architecture decisions.

## Components
<!-- Define your components here -->

## Patterns
<!-- Document patterns here -->
ARCH

cat > .prism/context/patterns.md << 'PATTERNS'
# Code Patterns
**Last Updated**: $(date -Iseconds)
**Priority**: HIGH

## Summary
Code patterns and conventions.

## Patterns
<!-- Document patterns here -->
PATTERNS

cat > .prism/context/decisions.md << 'DECISIONS'
# Technical Decisions
**Last Updated**: $(date -Iseconds)
**Priority**: HIGH

## Summary
Technical decisions log.

## Decisions
<!-- Add decisions here -->
DECISIONS

# Create session file
cat > .prism/sessions/current.md << 'SESSION'
# Current Session
**Started**: $(date -Iseconds)

## Goals
<!-- Session goals -->

## Context
<!-- Loaded context -->
SESSION

# Create index
cat > .prism/index.yaml << 'INDEX'
version: 1.0.0
last_updated: $(date -Iseconds)

critical_context:
  - path: context/architecture.md
    tags: [architecture]
  - path: context/patterns.md
    tags: [patterns]
  - path: context/decisions.md
    tags: [decisions]
INDEX

# Create PRISM.md in project
cat > PRISM.md << 'PRISMMD'
# PRISM Framework - Project Configuration

This project uses PRISM framework.

## Quick Start
- Context: `.prism/context/`
- Session: `.prism/sessions/current.md`

See ~/.claude/PRISM.md for documentation.
PRISMMD

echo -e "${GREEN}✓ PRISM initialized successfully!${NC}"
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. Update .prism/context/architecture.md"
echo "  2. Document patterns as you code"
echo "  3. Log decisions in decisions.md"
EOF

    chmod +x "$CLAUDE_DIR/prism-init.sh"
    echo -e "    ${GREEN}✓ Created prism-init.sh${NC}"
}

# Function to create convenient aliases
create_aliases() {
    echo -e "${BLUE}Setting up convenient commands...${NC}"

    # Create a simple prism command
    cat > "$CLAUDE_DIR/prism" << 'EOF'
#!/bin/bash

# PRISM Command Line Interface
# Usage: prism [command] [args]

CLAUDE_DIR="$HOME/.claude"

case "$1" in
    init)
        "$CLAUDE_DIR/prism-init.sh"
        ;;
    update)
        "$CLAUDE_DIR/prism-update.sh"
        ;;
    help|--help|-h|"")
        echo "PRISM Framework CLI"
        echo ""
        echo "Usage: prism [command]"
        echo ""
        echo "Commands:"
        echo "  init    Initialize PRISM in current directory"
        echo "  update  Update PRISM framework"
        echo "  help    Show this help"
        ;;
    *)
        echo "Unknown command: $1"
        echo "Run 'prism help' for usage"
        exit 1
        ;;
esac
EOF

    chmod +x "$CLAUDE_DIR/prism"

    # Add to PATH if not already there
    if [[ ":$PATH:" != *":$CLAUDE_DIR:"* ]]; then
        echo -e "${YELLOW}Add this to your shell configuration (.bashrc, .zshrc, etc.):${NC}"
        echo -e "${BOLD}export PATH=\"\$PATH:$CLAUDE_DIR\"${NC}"
        echo ""
    fi

    echo -e "${GREEN}✓ Created 'prism' command${NC}"
}

# Function to show post-installation instructions
show_instructions() {
    echo ""
    echo -e "${BOLD}${GREEN}╔═══════════════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}${GREEN}║        PRISM Framework Installed Successfully!       ║${NC}"
    echo -e "${BOLD}${GREEN}╚═══════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${BLUE}Installation Summary:${NC}"
    echo -e "  ✓ Claude configuration: ${BOLD}$CLAUDE_DIR${NC}"
    echo -e "  ✓ PRISM framework files installed"
    echo -e "  ✓ Initialization scripts ready"
    echo ""
    echo -e "${YELLOW}Quick Start:${NC}"
    echo ""
    echo -e "  1. ${BOLD}Add to PATH${NC} (add to your .bashrc/.zshrc):"
    echo -e "     ${BLUE}export PATH=\"\$PATH:$CLAUDE_DIR\"${NC}"
    echo ""
    echo -e "  2. ${BOLD}Initialize PRISM in a project:${NC}"
    echo -e "     ${BLUE}cd your-project${NC}"
    echo -e "     ${BLUE}prism init${NC}"
    echo ""
    echo -e "  3. ${BOLD}Or use directly:${NC}"
    echo -e "     ${BLUE}~/.claude/prism-init.sh${NC}"
    echo ""
    echo -e "${GREEN}PRISM is ready to enhance your Claude Code experience!${NC}"
    echo ""
    echo -e "${BLUE}Documentation:${NC} ~/.claude/PRISM.md"
    echo -e "${BLUE}Repository:${NC} $GITHUB_REPO"
}

# Function to handle errors
handle_error() {
    echo -e "${RED}✗ Installation failed: $1${NC}"
    echo -e "${YELLOW}Please report issues at: $GITHUB_REPO/issues${NC}"
    exit 1
}

# Main installation flow
main() {
    # Trap errors
    trap 'handle_error "Unexpected error occurred"' ERR

    # Check if already installed
    if [ -d "$CLAUDE_DIR" ] && [ -f "$CLAUDE_DIR/PRISM.md" ]; then
        echo -e "${YELLOW}⚠ PRISM appears to be already installed${NC}"
        echo -n "Do you want to reinstall/update? (y/n) "
        read -r REPLY
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo -e "${BLUE}Installation cancelled${NC}"
            exit 0
        fi
        echo -e "${BLUE}Proceeding with update...${NC}"
    fi

    # Run installation steps
    check_dependencies
    create_claude_structure
    download_core_files
    download_init_scripts
    create_aliases
    show_instructions
}

# Run main installation
main "$@"