#!/bin/bash
# PRISM Integration Diagnostic Tool
# Version: 2.0.3

echo "==================================="
echo "PRISM Integration Diagnostic Tool"
echo "==================================="
echo ""

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check 1: PRISM Installation
echo -e "${BLUE}1. Checking PRISM installation...${NC}"
if command -v prism &> /dev/null; then
    echo -e "${GREEN}✓${NC} PRISM is installed"
    prism version
else
    echo -e "${RED}✗${NC} PRISM is not installed or not in PATH"
    echo "   Run: curl -fsSL https://raw.githubusercontent.com/afiffattouh/hildens-prism/main/install.sh | bash"
fi
echo ""

# Check 2: Project Initialization
echo -e "${BLUE}2. Checking project initialization...${NC}"
if [ -d ".prism" ]; then
    echo -e "${GREEN}✓${NC} .prism directory exists"
    echo "   Structure:"
    find .prism -type d -maxdepth 2 | sed 's/^/   /'
else
    echo -e "${RED}✗${NC} .prism directory not found"
    echo "   Run: prism init"
fi
echo ""

# Check 3: CLAUDE.md File
echo -e "${BLUE}3. Checking CLAUDE.md file...${NC}"
if [ -f "CLAUDE.md" ]; then
    echo -e "${GREEN}✓${NC} CLAUDE.md exists"

    # Check if it references PRISM
    if grep -q "PRISM" CLAUDE.md; then
        echo -e "   ${GREEN}✓${NC} References PRISM framework"
    else
        echo -e "   ${YELLOW}⚠${NC} Does not reference PRISM framework"
        echo "   Add: '## PRISM Framework Active' to CLAUDE.md"
    fi

    # Check if it references context files
    if grep -q ".prism/context" CLAUDE.md; then
        echo -e "   ${GREEN}✓${NC} References context files"
    else
        echo -e "   ${YELLOW}⚠${NC} Does not reference context files"
    fi
else
    echo -e "${RED}✗${NC} CLAUDE.md not found"
    echo "   Run: prism init --force"
fi
echo ""

# Check 4: Context Files
echo -e "${BLUE}4. Checking context files...${NC}"
if [ -d ".prism/context" ]; then
    echo -e "${GREEN}✓${NC} Context directory exists"

    # Check each context file
    for file in patterns.md architecture.md decisions.md; do
        if [ -f ".prism/context/$file" ]; then
            size=$(wc -c < ".prism/context/$file")
            if [ $size -gt 50 ]; then
                echo -e "   ${GREEN}✓${NC} $file exists (${size} bytes)"
            else
                echo -e "   ${YELLOW}⚠${NC} $file exists but seems empty (${size} bytes)"
            fi
        else
            echo -e "   ${YELLOW}⚠${NC} $file missing (optional)"
        fi
    done
else
    echo -e "${RED}✗${NC} Context directory not found"
    echo "   Run: prism init --force"
fi
echo ""

# Check 5: Global Claude Configuration
echo -e "${BLUE}5. Checking global Claude configuration...${NC}"
if [ -f "$HOME/.claude/CLAUDE.md" ]; then
    echo -e "${GREEN}✓${NC} Global CLAUDE.md exists"

    if grep -q "@PRISM.md" "$HOME/.claude/CLAUDE.md"; then
        echo -e "   ${GREEN}✓${NC} References @PRISM.md"
    else
        echo -e "   ${YELLOW}⚠${NC} Does not reference @PRISM.md"
        echo "   Add '@PRISM.md' to ~/.claude/CLAUDE.md"
    fi
else
    echo -e "${YELLOW}⚠${NC} Global CLAUDE.md not found at ~/.claude/CLAUDE.md"
    echo "   Create it with content:"
    echo "   # Claude Code Configuration"
    echo "   @PRISM.md"
fi

if [ -f "$HOME/.claude/PRISM.md" ]; then
    echo -e "${GREEN}✓${NC} Global PRISM.md exists"
else
    echo -e "${RED}✗${NC} Global PRISM.md not found"
    echo "   Copy from PRISM installation:"
    echo "   cp ~/.prism/templates/PRISM.md ~/.claude/"
fi
echo ""

# Check 6: Current Session
echo -e "${BLUE}6. Checking current session...${NC}"
if command -v prism &> /dev/null; then
    if [ -f ".prism/sessions/current.md" ]; then
        echo -e "${GREEN}✓${NC} Active session found"
        echo "   Session file: .prism/sessions/current.md"

        # Show session info
        if [ -f ".prism/sessions/current.md" ]; then
            echo "   Session started: $(head -1 .prism/sessions/current.md | grep -o '[0-9-]*' | head -1)"
        fi
    else
        echo -e "${YELLOW}⚠${NC} No active session"
        echo "   Run: prism session start 'Working on project'"
    fi
else
    echo -e "${YELLOW}⚠${NC} Cannot check session (PRISM not available)"
fi
echo ""

# Check 7: PRISM Doctor
echo -e "${BLUE}7. Running PRISM doctor...${NC}"
if command -v prism &> /dev/null; then
    prism doctor 2>&1 | sed 's/^/   /'
else
    echo -e "${YELLOW}⚠${NC} Cannot run doctor (PRISM not available)"
fi
echo ""

# Summary and Recommendations
echo "==================================="
echo -e "${BLUE}Diagnostic Summary${NC}"
echo "==================================="
echo ""

# Count issues
errors=0
warnings=0

# Analyze results (simplified check)
if ! command -v prism &> /dev/null; then
    ((errors++))
    echo -e "${RED}ERROR:${NC} PRISM is not installed"
fi

if [ ! -d ".prism" ]; then
    ((errors++))
    echo -e "${RED}ERROR:${NC} Project not initialized with PRISM"
fi

if [ ! -f "CLAUDE.md" ]; then
    ((errors++))
    echo -e "${RED}ERROR:${NC} CLAUDE.md file missing"
fi

if [ ! -f "$HOME/.claude/PRISM.md" ]; then
    ((warnings++))
    echo -e "${YELLOW}WARNING:${NC} Global PRISM.md configuration missing"
fi

# Provide fix recommendations
if [ $errors -gt 0 ] || [ $warnings -gt 0 ]; then
    echo ""
    echo -e "${BLUE}Recommended Fixes:${NC}"
    echo ""

    if ! command -v prism &> /dev/null; then
        echo "1. Install PRISM:"
        echo "   curl -fsSL https://raw.githubusercontent.com/afiffattouh/hildens-prism/main/install.sh | bash"
        echo ""
    fi

    if [ ! -d ".prism" ] || [ ! -f "CLAUDE.md" ]; then
        echo "2. Initialize PRISM in your project:"
        echo "   prism init"
        echo ""
    fi

    if [ ! -f "$HOME/.claude/PRISM.md" ]; then
        echo "3. Setup global Claude configuration:"
        echo "   mkdir -p ~/.claude"
        echo "   echo '@PRISM.md' >> ~/.claude/CLAUDE.md"
        echo "   curl -fsSL https://raw.githubusercontent.com/afiffattouh/hildens-prism/main/templates/PRISM.md > ~/.claude/PRISM.md"
        echo ""
    fi

    echo "4. Start a fresh Claude Code session after fixes"
    echo ""
else
    echo -e "${GREEN}✓${NC} All checks passed! PRISM should be working correctly."
    echo ""
    echo "If Claude Code still isn't following PRISM:"
    echo "1. Start a new Claude Code conversation"
    echo "2. Begin with: 'Check PRISM context files'"
    echo "3. Claude should acknowledge and load context"
fi

echo ""
echo "For detailed help, see: TROUBLESHOOTING_PRISM.md"
echo "Report issues: https://github.com/afiffattouh/hildens-prism/issues"