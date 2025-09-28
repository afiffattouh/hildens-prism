#!/bin/bash
# PRISM Framework Installer - Simple version for main branch
# Version: 2.0.0

set -euo pipefail

# Configuration
readonly PRISM_REPO="https://github.com/afiffattouh/hildens-prism"
readonly PRISM_HOME="${PRISM_HOME:-$HOME/.prism}"
readonly BIN_DIR="${HOME}/bin"
readonly CLAUDE_DIR="${HOME}/.claude"

# Colors
if [[ -t 1 ]]; then
    readonly GREEN='\033[0;32m'
    readonly RED='\033[0;31m'
    readonly YELLOW='\033[1;33m'
    readonly BLUE='\033[0;34m'
    readonly BOLD='\033[1m'
    readonly NC='\033[0m'
else
    readonly GREEN=''
    readonly RED=''
    readonly YELLOW=''
    readonly BLUE=''
    readonly BOLD=''
    readonly NC=''
fi

# Print header
echo -e "${BOLD}${BLUE}╔═══════════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${BLUE}║      PRISM Framework Installer v2.0.0                 ║${NC}"
echo -e "${BOLD}${BLUE}║   Persistent Real-time Intelligent System Management  ║${NC}"
echo -e "${BOLD}${BLUE}╚═══════════════════════════════════════════════════════╝${NC}"
echo

# Check dependencies
echo -e "${BLUE}Checking dependencies...${NC}"
for cmd in git curl; do
    if ! command -v "$cmd" &> /dev/null; then
        echo -e "${RED}Error: $cmd is required but not installed${NC}"
        exit 1
    fi
done
echo -e "${GREEN}✓ All dependencies satisfied${NC}"

# Create temporary directory
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

# Clone repository
echo -e "${BLUE}Downloading PRISM framework...${NC}"
if git clone --depth 1 "$PRISM_REPO" "$TEMP_DIR/prism" &> /dev/null; then
    echo -e "${GREEN}✓ Downloaded successfully${NC}"
else
    echo -e "${RED}Failed to download PRISM${NC}"
    exit 1
fi

# Create directories
echo -e "${BLUE}Creating directories...${NC}"
mkdir -p "$PRISM_HOME"
mkdir -p "$BIN_DIR"
mkdir -p "$CLAUDE_DIR"
echo -e "${GREEN}✓ Directories created${NC}"

# Install files
echo -e "${BLUE}Installing PRISM files...${NC}"

# Copy library files
cp -r "$TEMP_DIR/prism/lib" "$PRISM_HOME/"
echo -e "${GREEN}✓ Library files installed${NC}"

# Copy and setup binary
cp "$TEMP_DIR/prism/bin/prism" "$BIN_DIR/"
chmod +x "$BIN_DIR/prism"
echo -e "${GREEN}✓ PRISM command installed${NC}"

# Copy documentation
cp -r "$TEMP_DIR/prism/docs" "$PRISM_HOME/" 2>/dev/null || true
cp "$TEMP_DIR/prism/README.md" "$PRISM_HOME/" 2>/dev/null || true
cp "$TEMP_DIR/prism/VERSION" "$PRISM_HOME/" 2>/dev/null || true

# Setup Claude integration
echo -e "${BLUE}Setting up Claude Code integration...${NC}"

# Create PRISM.md for Claude
cat > "$CLAUDE_DIR/PRISM.md" << 'EOF'
# PRISM Framework Integration

PRISM (Persistent Real-time Intelligent System Management) is active.

## Initialization Protocol

When user runs `/init` or requests PRISM initialization:

1. Check for `.prism/` directory
2. If not exists, run: `prism init`
3. Review generated CLAUDE.md for project instructions

## Context Management

Always check for PRISM context files when available:
- `.prism/context/patterns.md` - Coding patterns
- `.prism/context/architecture.md` - System architecture
- `.prism/context/decisions.md` - Technical decisions

## Commands

PRISM CLI is available at: `~/bin/prism`

Key commands:
- `prism init` - Initialize project
- `prism context show` - View context
- `prism doctor` - Diagnose issues
- `prism help` - Get help
EOF

echo -e "${GREEN}✓ Claude integration configured${NC}"

# Update PATH if needed
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
    echo -e "${YELLOW}Adding $BIN_DIR to PATH...${NC}"

    # Detect shell
    SHELL_RC=""
    if [[ -n "${BASH_VERSION:-}" ]]; then
        SHELL_RC="$HOME/.bashrc"
    elif [[ -n "${ZSH_VERSION:-}" ]]; then
        SHELL_RC="$HOME/.zshrc"
    fi

    if [[ -n "$SHELL_RC" ]] && [[ -f "$SHELL_RC" ]]; then
        echo "export PATH=\"\$HOME/bin:\$PATH\"" >> "$SHELL_RC"
        echo -e "${GREEN}✓ PATH updated in $SHELL_RC${NC}"
        echo -e "${YELLOW}Run 'source $SHELL_RC' or restart your shell${NC}"
    else
        echo -e "${YELLOW}Add this to your shell configuration:${NC}"
        echo "  export PATH=\"\$HOME/bin:\$PATH\""
    fi
fi

# Fix library paths in prism binary
sed -i.bak "s|PRISM_ROOT=\"\$(dirname \"\$SCRIPT_DIR\")\"|PRISM_ROOT=\"$PRISM_HOME\"|g" "$BIN_DIR/prism" 2>/dev/null || \
sed -i '' "s|PRISM_ROOT=\"\$(dirname \"\$SCRIPT_DIR\")\"|PRISM_ROOT=\"$PRISM_HOME\"|g" "$BIN_DIR/prism"
rm -f "$BIN_DIR/prism.bak"

# Verify installation
echo
echo -e "${BLUE}Verifying installation...${NC}"
if [[ -x "$BIN_DIR/prism" ]] && [[ -d "$PRISM_HOME/lib" ]]; then
    echo -e "${GREEN}✓ PRISM installed successfully!${NC}"
    echo
    echo -e "${BOLD}Installation Summary:${NC}"
    echo -e "  PRISM Home: $PRISM_HOME"
    echo -e "  Binary: $BIN_DIR/prism"
    echo -e "  Claude Config: $CLAUDE_DIR/PRISM.md"
    echo
    echo -e "${BOLD}Next Steps:${NC}"
    echo -e "  1. Run: ${BOLD}source ~/.bashrc${NC} (or restart shell)"
    echo -e "  2. Test: ${BOLD}prism --help${NC}"
    echo -e "  3. Initialize project: ${BOLD}prism init${NC}"
    echo
    echo -e "${GREEN}🎉 PRISM is ready to use!${NC}"
else
    echo -e "${RED}Installation verification failed${NC}"
    echo -e "Please check the installation manually or report an issue"
    exit 1
fi