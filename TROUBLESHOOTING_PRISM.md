# PRISM Framework - Claude Code Integration Troubleshooting Guide

## Common Issue: Claude Code Not Following PRISM Framework

### Quick Diagnostic Commands

Run these commands in your project directory to diagnose the issue:

```bash
# 1. Check if PRISM is initialized
ls -la .prism/

# 2. Verify CLAUDE.md exists
cat CLAUDE.md

# 3. Check PRISM context files
ls -la .prism/context/

# 4. Run PRISM doctor
prism doctor

# 5. Check current session
prism session status
```

## Root Causes and Solutions

### 1. Missing or Incorrect CLAUDE.md File

**Issue:** Claude Code needs a `CLAUDE.md` file in your project root to understand project-specific instructions.

**Solution:**
```bash
# Navigate to your project
cd /path/to/your/project

# Check if CLAUDE.md exists
if [ ! -f "CLAUDE.md" ]; then
    echo "CLAUDE.md is missing!"

    # Reinitialize PRISM
    prism init --force
fi
```

**Verify CLAUDE.md Content:**
Your project's `CLAUDE.md` should contain:
```markdown
# Project Instructions for Claude Code

## PRISM Framework Active
This project uses PRISM for context management.

## Context Files
Check `.prism/context/` for:
- patterns.md - Coding patterns to follow
- architecture.md - System design
- decisions.md - Technical decisions

## Project-Specific Instructions
[Your project-specific guidelines here]
```

### 2. PRISM Context Files Not Loaded

**Issue:** Context files exist but aren't being referenced properly.

**Solution:**
```bash
# Load critical context
prism context load-critical

# Refresh current session
prism session refresh

# Start a new session with context
prism session start "Working with PRISM context"
```

### 3. Global Claude Configuration Not Pointing to PRISM

**Issue:** Your global `~/.claude/CLAUDE.md` might not reference PRISM.

**Solution:**
Ensure `~/.claude/CLAUDE.md` contains:
```markdown
# Claude Code Configuration Entry Point

## PRISM Framework - CRITICAL PRIORITY
@PRISM.md
```

And `~/.claude/PRISM.md` exists with:
```markdown
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
```

### 4. Project .prism Directory Structure Issues

**Issue:** The `.prism` directory might be incomplete or corrupted.

**Solution:**
```bash
# Check directory structure
tree .prism/ || ls -R .prism/

# If structure is wrong, reinitialize
prism init --force

# Or manually create missing directories
mkdir -p .prism/context
mkdir -p .prism/sessions
mkdir -p .prism/references
```

### 5. Claude Code Session Not Aware of PRISM

**Issue:** Claude Code might be in a session that started before PRISM was initialized.

**Solution:**
1. Close the current Claude Code session
2. Navigate to your project directory
3. Start a fresh Claude Code session
4. Immediately run: `prism session start "New session with PRISM"`

## Complete Diagnostic Script

Save this as `diagnose-prism.sh` in your project:

```bash
#!/bin/bash

echo "==================================="
echo "PRISM Integration Diagnostic Tool"
echo "==================================="
echo ""

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check 1: PRISM Installation
echo "1. Checking PRISM installation..."
if command -v prism &> /dev/null; then
    echo -e "${GREEN}✓${NC} PRISM is installed"
    prism version
else
    echo -e "${RED}✗${NC} PRISM is not installed or not in PATH"
    echo "   Run: curl -fsSL https://raw.githubusercontent.com/afiffattouh/hildens-prism/main/install.sh | bash"
fi
echo ""

# Check 2: Project Initialization
echo "2. Checking project initialization..."
if [ -d ".prism" ]; then
    echo -e "${GREEN}✓${NC} .prism directory exists"
    ls -la .prism/
else
    echo -e "${RED}✗${NC} .prism directory not found"
    echo "   Run: prism init"
fi
echo ""

# Check 3: CLAUDE.md File
echo "3. Checking CLAUDE.md file..."
if [ -f "CLAUDE.md" ]; then
    echo -e "${GREEN}✓${NC} CLAUDE.md exists"
    echo "   First few lines:"
    head -5 CLAUDE.md
else
    echo -e "${RED}✗${NC} CLAUDE.md not found"
    echo "   Run: prism init --force"
fi
echo ""

# Check 4: Context Files
echo "4. Checking context files..."
if [ -d ".prism/context" ]; then
    echo -e "${GREEN}✓${NC} Context directory exists"
    for file in patterns.md architecture.md decisions.md; do
        if [ -f ".prism/context/$file" ]; then
            echo -e "   ${GREEN}✓${NC} $file exists"
        else
            echo -e "   ${YELLOW}⚠${NC} $file missing (optional)"
        fi
    done
else
    echo -e "${RED}✗${NC} Context directory not found"
fi
echo ""

# Check 5: Global Claude Configuration
echo "5. Checking global Claude configuration..."
if [ -f "$HOME/.claude/CLAUDE.md" ]; then
    echo -e "${GREEN}✓${NC} Global CLAUDE.md exists"
    if grep -q "PRISM" "$HOME/.claude/CLAUDE.md"; then
        echo -e "   ${GREEN}✓${NC} References PRISM"
    else
        echo -e "   ${YELLOW}⚠${NC} Does not reference PRISM"
    fi
else
    echo -e "${YELLOW}⚠${NC} Global CLAUDE.md not found"
fi

if [ -f "$HOME/.claude/PRISM.md" ]; then
    echo -e "${GREEN}✓${NC} Global PRISM.md exists"
else
    echo -e "${YELLOW}⚠${NC} Global PRISM.md not found"
fi
echo ""

# Check 6: Current Session
echo "6. Checking current session..."
if command -v prism &> /dev/null; then
    prism session status
else
    echo -e "${YELLOW}⚠${NC} Cannot check session (PRISM not available)"
fi
echo ""

# Summary
echo "==================================="
echo "Diagnostic Summary"
echo "==================================="
echo ""
echo "If any checks failed, follow the suggested fixes above."
echo "For a complete fix, run:"
echo "  1. prism doctor --fix"
echo "  2. prism init --force"
echo "  3. Start a new Claude Code session"
echo ""
```

## Manual Fix Procedure

If automated fixes don't work, follow these steps:

### Step 1: Clean Installation
```bash
# Navigate to your project
cd /path/to/your/project

# Remove existing PRISM files (backup first if needed)
mv .prism .prism.backup
mv CLAUDE.md CLAUDE.md.backup

# Reinitialize
prism init
```

### Step 2: Configure Context
```bash
# Add your project patterns
echo "# Project Patterns

## Code Style
- Use consistent indentation
- Follow existing patterns
" > .prism/context/patterns.md

# Add architecture notes
echo "# System Architecture

## Overview
[Your architecture details]
" > .prism/context/architecture.md

# Start a new session
prism session start "Fresh PRISM setup"
```

### Step 3: Test Integration
```bash
# In a new Claude Code conversation, type:
# "Check PRISM context files and summarize the project patterns"
# Claude should read and reference the .prism/context files
```

## Verification Checklist

After fixing, verify:

- [ ] `prism doctor` shows no errors
- [ ] `CLAUDE.md` exists in project root
- [ ] `.prism/context/` contains your context files
- [ ] Claude Code reads context files when asked
- [ ] Claude Code follows patterns defined in context files

## Tips for Better Integration

1. **Start Fresh Sessions**: Always start a new Claude Code session after initializing PRISM
2. **Explicit Context**: Ask Claude to "check PRISM context" at the start of sessions
3. **Update Context**: Keep `.prism/context/` files updated with project evolution
4. **Use Sessions**: Use `prism session start` to track work periods

## Debug Mode

For detailed debugging, set environment variable:
```bash
export LOG_LEVEL=DEBUG
prism doctor --verbose
```

## Getting Help

If issues persist:
1. Run the diagnostic script
2. Save the output
3. Check GitHub issues: https://github.com/afiffattouh/hildens-prism/issues
4. Include diagnostic output when reporting issues

---

*This troubleshooting guide is for PRISM v2.0.3*