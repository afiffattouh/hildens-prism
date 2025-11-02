# PRISM Skills - Implementation Documentation

**Created**: 2025-11-02
**Version**: 2.3.0
**Status**: ✅ IMPLEMENTED

## Overview

PRISM Skills integrates seamlessly with Claude Code's native skills system, adding built-in skills for common PRISM workflows and a management CLI for easy skill creation and organization.

## Implementation Status

✅ **Core Library**: `lib/prism-skills.sh` - Complete
✅ **CLI Integration**: `bin/prism skill` command - Complete
✅ **Built-in Skills**: 5 skills implemented
✅ **Auto-linking**: Claude Code integration - Complete
⏳ **Documentation**: This document

## Architecture

### Skill Locations

PRISM uses a three-tier skill system:

1. **Built-in Skills**: `~/.prism/lib/skills/`
   - Pre-installed PRISM skills
   - Symlinked to personal skills for Claude Code visibility
   - Managed by PRISM updates

2. **Personal Skills**: `~/.prism/skills/`
   - User-created skills for personal use
   - Symlinked to `~/.claude/skills` for Claude Code
   - Persists across projects

3. **Project Skills**: `.claude/skills/` (in project root)
   - Project-specific skills
   - Committed to git, shared with team
   - Claude Code native location

### Symlink Chain

```
~/.claude/skills → ~/.prism/skills (directory symlink)
~/.prism/skills/<skill> → ~/.prism/lib/skills/<skill> (individual symlinks for built-in)
```

This allows Claude Code to discover all PRISM built-in skills through the standard `~/.claude/skills` location.

## Skill Structure

### Minimal Skill (Claude Code Compatible)

```
skill-name/
└── SKILL.md
```

**SKILL.md Format**:
```markdown
---
name: skill-name
description: Brief description with trigger words for when to use this skill
---

# Skill Title

Brief overview of what this skill does.

## Instructions

1. Clear step-by-step instructions
2. Include file paths, commands, or logic
3. Handle edge cases

## Examples

\`\`\`
User: "trigger phrase"
Assistant: [expected behavior]
\`\`\`
```

### Enhanced Skill (PRISM-Aware)

```
skill-name/
├── SKILL.md
└── .prism-hints
```

**.prism-hints Format**:
```yaml
# Optional: PRISM context files this skill should read
context_files:
  - patterns.md
  - architecture.md

# Optional: Whether this skill updates PRISM context
updates_context: true

# Optional: Specific files this skill might update
updates_files:
  - sessions/current.md

# Optional: Tags for categorization
tags:
  - testing
  - automation
```

## Built-in Skills

### 1. test-runner

**Location**: `~/.prism/lib/skills/test-runner/`
**Trigger**: User requests to run tests, verify code, or check test status

**Capabilities**:
- Auto-detects test frameworks (Jest, pytest, Go test, RSpec, PHPUnit)
- Checks PRISM patterns for custom test commands
- Runs appropriate test command
- Reports results
- Updates session context if PRISM exists

**Usage Example**:
```
User: "run tests"
Claude: [Detects Jest] → npm test → ✓ 127 tests passed
```

### 2. context-summary

**Location**: `~/.prism/lib/skills/context-summary/`
**Trigger**: User asks about project setup, architecture, or coding patterns

**Capabilities**:
- Reads PRISM context files (patterns.md, architecture.md, decisions.md)
- Generates concise project overview
- Highlights key patterns and architectural decisions

**Usage Example**:
```
User: "what are our coding standards?"
Claude: [Reads patterns.md] → Summarizes coding standards and best practices
```

### 3. session-save

**Location**: `~/.prism/lib/skills/session-save/`
**Trigger**: User wants to save work session or end development session

**Capabilities**:
- Archives current session from `.prism/sessions/current.md`
- Creates timestamped archive in `.prism/sessions/archive/`
- Clears current session for fresh start
- Generates session summary

**Usage Example**:
```
User: "save this session"
Claude: [Archives session] → Created: 2025-11-02_auth-feature.md
```

### 4. skill-create

**Location**: `~/.prism/lib/skills/skill-create/`
**Trigger**: User wants to create a new custom skill

**Capabilities**:
- Interactive prompts for skill metadata
- Validates skill name format (lowercase-with-hyphens)
- Creates SKILL.md with proper structure
- Optionally creates .prism-hints for PRISM awareness
- Guides user on testing new skill

**Usage Example**:
```
User: "create a skill for linting"
Claude: [Interactive prompts] → Creates ~/.prism/skills/lint-runner/
```

### 5. prism-init

**Location**: `~/.prism/lib/skills/prism-init/`
**Trigger**: User wants to initialize PRISM in a new project

**Capabilities**:
- Checks if PRISM already initialized
- Creates `.prism/` directory structure
- Populates template files (patterns.md, architecture.md, etc.)
- Creates timestamp file
- Guides user through setup

**Usage Example**:
```
User: "set up PRISM in this project"
Claude: [Creates .prism/ structure] → PRISM initialized! Edit .prism/context/ files.
```

## CLI Commands

### Core Commands

```bash
# List all available skills
prism skill list              # Basic list
prism skill list -v           # Verbose with descriptions

# Show skill statistics
prism skill stats

# Display skill details
prism skill info <skill-name>

# Link PRISM skills to Claude Code
prism skill link-claude

# Interactive skill creation
prism skill create

# Help
prism skill help
```

### Command Details

#### `prism skill list [-v|--verbose]`

Lists skills from all three locations (built-in, personal, project).

**Output (basic)**:
```
=== Built-in Skills ===
  context-summary
  prism-init
  session-save
  skill-create
  test-runner

=== Personal Skills ===
  my-custom-skill

=== Project Skills ===
  project-specific-skill
```

**Output (verbose)**:
```
=== Built-in Skills ===
  context-summary      Summarize PRISM project context, patterns, and setup...
  prism-init           Initialize PRISM framework in a project. Use when...
  session-save         Save current work session to PRISM archive. Use when...
  skill-create         Create a new Claude/PRISM skill interactively. Use...
  test-runner          Run project tests automatically. Use when user wants...
```

#### `prism skill stats`

Shows count of skills by type:

```
📊 PRISM Skills Statistics
==========================

  Built-in:   5 skills
  Personal:   2 skills
  Project:    1 skills
  ────────────────
  Total:      8 skills
```

#### `prism skill info <name>`

Displays complete SKILL.md content for a skill:

```bash
prism skill info test-runner
```

Output:
```
=== Built-in Skill: test-runner ===

---
name: test-runner
description: Run project tests automatically...
---

# Test Runner
...
[full SKILL.md content]
```

#### `prism skill link-claude`

Creates symlinks to make PRISM skills visible to Claude Code:

1. Creates `~/.claude/skills` → `~/.prism/skills` symlink
2. Creates individual symlinks for each built-in skill in `~/.prism/skills/`

**Output**:
```
[INFO] Symlinking built-in skills to ~/.prism/skills/
[INFO]   ✓ prism-init
[INFO]   ✓ context-summary
[INFO]   ✓ session-save
[INFO]   ✓ skill-create
[INFO]   ✓ test-runner
[INFO] ✓ Linked: ~/.claude/skills → ~/.prism/skills
```

**Behavior**:
- If `~/.claude/skills` already linked correctly: Reports already linked, still ensures built-in skills are symlinked
- If `~/.claude/skills` exists as directory: Prompts to migrate to symlink
- If `~/.claude/skills` linked elsewhere: Warns and exits

#### `prism skill create`

Interactive skill creation wizard (not yet implemented in CLI, but available as built-in skill through Claude).

## Integration with Claude Code

### How Skills Work

1. **Skill Discovery**: Claude Code scans `~/.claude/skills/` and `.claude/skills/` for folders containing `SKILL.md`
2. **Skill Loading**: Claude reads YAML frontmatter (name, description) from each `SKILL.md`
3. **Skill Invocation**: Based on user request, Claude matches description keywords and loads appropriate skill
4. **Skill Execution**: Claude follows instructions in the skill's markdown content
5. **Context Awareness**: If `.prism-hints` exists, Claude can use it as guidance (optional enhancement)

### PRISM Enhancement Layer

PRISM adds:
- **Built-in skills** for common PRISM workflows
- **Management CLI** (`prism skill` commands)
- **Auto-linking** (makes built-in skills available to Claude Code)
- **Optional context hints** (`.prism-hints` for PRISM-aware behavior)

**Key Principle**: PRISM skills are standard Claude skills. The `.prism-hints` file is an optional enhancement that doesn't break Claude Code compatibility.

## Implementation Files

### Core Library

**File**: `lib/prism-skills.sh`
**Functions**:
- `skill_create()` - Interactive skill creation wizard
- `skill_list(show_details)` - List skills from all locations
- `skill_info(skill_name)` - Display skill details
- `skill_link_claude()` - Setup Claude Code integration
- `skill_stats()` - Show skill statistics
- `prism_skills(subcmd, ...)` - Main command dispatcher

**Key Features**:
- Uses `find` with process substitution for portable glob handling (bash/zsh)
- Safe handling of undefined variables (PRISM_ROOT, PRISM_HOME)
- Structured output with clear sections

### CLI Integration

**File**: `bin/prism`
**Changes**:
1. Sources `prism-skills.sh` library (line 13)
2. Added `cmd_skill()` wrapper function (lines 353-373)
   - Creates temporary script with `PRISM_NO_STRICT=1`
   - Avoids strict mode conflicts in bash
3. Added skill dispatcher in main() (lines 493-495)
4. Updated help text with skill commands

**Wrapper Pattern**:
```bash
cmd_skill() {
    local temp_script=$(mktemp)
    cat > "$temp_script" << 'EOF'
#!/bin/bash
export PRISM_NO_STRICT=1
source "$PRISM_ROOT/lib/prism-core.sh"
source "$PRISM_ROOT/lib/prism-log.sh"
source "$PRISM_ROOT/lib/prism-skills.sh"
prism_skills "$@"
EOF
    PRISM_ROOT="$PRISM_ROOT" bash "$temp_script" "$@"
    local result=$?
    rm -f "$temp_script"
    return $result
}
```

This pattern is also used for `cmd_agent()` to avoid bash strict mode issues with complex shell operations.

### Built-in Skill Files

**Location**: `~/.prism/lib/skills/`

Each skill directory contains:
- `SKILL.md` - Main skill file (required)
- `.prism-hints` - Optional PRISM metadata

**Files Created**:
```
~/.prism/lib/skills/
├── test-runner/
│   ├── SKILL.md
│   └── .prism-hints
├── context-summary/
│   ├── SKILL.md
│   └── .prism-hints
├── session-save/
│   ├── SKILL.md
│   └── .prism-hints
├── skill-create/
│   ├── SKILL.md
│   └── .prism-hints
└── prism-init/
    ├── SKILL.md
    └── .prism-hints
```

## Technical Details

### Strict Mode Handling

PRISM uses `set -euo pipefail` in `prism-core.sh` for safety. However, skill operations use:
- Complex glob patterns
- Process substitution (`< <(find ...)`)
- Potentially undefined variables

**Solution**: Wrap skill commands in temporary script with `PRISM_NO_STRICT=1`:

```bash
export PRISM_NO_STRICT=1  # Disables strict mode in prism-core.sh
```

This is handled automatically by `cmd_skill()` wrapper.

### Variable Initialization

The `prism-skills.sh` library safely handles potentially undefined variables:

```bash
# Use PRISM_ROOT if set, fallback to HOME/.prism
if [[ -n "${PRISM_ROOT:-}" ]]; then
    PRISM_LIB_ROOT="$PRISM_ROOT"
elif [[ -n "${PRISM_HOME:-}" ]]; then
    PRISM_LIB_ROOT="$PRISM_HOME"
else
    PRISM_LIB_ROOT="$HOME/.prism"
fi
```

This avoids `unbound variable` errors in strict mode.

### Portable Glob Handling

To work in both bash and zsh, avoid direct glob expansion in favor of `find`:

```bash
# ❌ Breaks in zsh when directory is empty
for skill in "$HOME/.prism/skills"/*; do
    # ...
done

# ✅ Works in both bash and zsh
while IFS= read -r -d '' skill; do
    # ...
done < <(find "$HOME/.prism/skills" -maxdepth 1 -mindepth 1 -type d -print0 2>/dev/null)
```

### Logging

Uses PRISM's standard logging library (`prism-log.sh`):
- `log_info()` - Information messages
- `log_warn()` - Warnings
- `log_error()` - Errors

**Note**: Earlier version used `log_success()` which doesn't exist. Changed to `log_info()`.

## Usage Workflows

### Initial Setup (One-time)

```bash
# Link PRISM skills to Claude Code
prism skill link-claude

# Verify skills are visible
prism skill list
```

Output:
```
[INFO] Symlinking built-in skills to ~/.prism/skills/
[INFO]   ✓ prism-init
[INFO]   ✓ context-summary
[INFO]   ✓ session-save
[INFO]   ✓ skill-create
[INFO]   ✓ test-runner
[INFO] ✓ Linked: ~/.claude/skills → ~/.prism/skills

=== Built-in Skills ===
  context-summary
  prism-init
  session-save
  skill-create
  test-runner
```

### Creating Custom Skills

**Option 1: Through Claude (Recommended)**
```
User: "create a skill for running eslint"
Claude: [skill-create activates]
        [Interactive prompts]
        ✓ Created ~/.prism/skills/eslint-runner/
```

**Option 2: Manual Creation**
```bash
# Create skill directory
mkdir -p ~/.prism/skills/my-skill

# Create SKILL.md
cat > ~/.prism/skills/my-skill/SKILL.md << 'EOF'
---
name: my-skill
description: Does something useful. Use when user requests this specific thing.
---

# My Skill

## Instructions

1. Do step one
2. Do step two
3. Report results

## Examples

\`\`\`
User: "do the thing"
Assistant: [follows instructions]
\`\`\`
EOF
```

### Using Skills in Claude Code

Skills activate automatically based on description matching:

```
User: "run tests"
→ test-runner skill activates
→ Claude detects test framework
→ Runs appropriate test command
→ Shows results

User: "what are our coding patterns?"
→ context-summary skill activates
→ Reads .prism/context/patterns.md
→ Summarizes for user

User: "save my work"
→ session-save skill activates
→ Archives .prism/sessions/current.md
→ Confirms save
```

### Project-Specific Skills

```bash
# In your project directory
mkdir -p .claude/skills/deploy-staging

cat > .claude/skills/deploy-staging/SKILL.md << 'EOF'
---
name: deploy-staging
description: Deploy this project to staging environment. Use when user wants to deploy to staging.
---

# Deploy to Staging

## Instructions

1. Run tests first
2. Build production bundle
3. Run: `./scripts/deploy-staging.sh`
4. Verify deployment at https://staging.example.com
5. Report status

## Examples

\`\`\`
User: "deploy to staging"
Assistant: [runs deployment] → ✓ Deployed to staging
\`\`\`
EOF

# Commit to git for team sharing
git add .claude/skills/
git commit -m "Add staging deployment skill"
```

## Best Practices

### 1. Clear Descriptions with Trigger Words

**Good**:
```yaml
description: Run project tests automatically. Use when user wants to run tests, verify code changes, or check test status.
```

Includes: what it does + when to use + trigger keywords ("run tests", "verify code", "check test status")

**Bad**:
```yaml
description: A testing skill
```

Too vague, no trigger words, unclear when to activate.

### 2. Step-by-Step Instructions

```markdown
## Instructions

1. **Detect test framework**:
   - JavaScript: Check package.json for jest, vitest
   - Python: Check for pytest in requirements.txt
   - Go: Check for go.mod and *_test.go files

2. **Check PRISM patterns** (if .prism/ exists):
   - Read .prism/context/patterns.md "Testing" section
   - Use custom test command if specified

3. **Run tests**:
   - Use detected test command
   - Capture output

4. **Report results**:
   - Show pass/fail count
   - Highlight failures
   - Update .prism/sessions/current.md if PRISM active
```

### 3. Concrete Examples

Show Claude exactly what to do:

```markdown
## Examples

\`\`\`
User: "run tests"
Assistant: [Detects Jest in package.json]
           npm test
           ✓ 127 tests passed, 0 failed

           Updated: .prism/sessions/current.md
\`\`\`

\`\`\`
User: "are tests passing?"
Assistant: [Runs tests quietly]
           ✓ All tests passing (127 tests)
\`\`\`
```

### 4. One Skill, One Job

**Good**: Separate focused skills
- `test-runner` - Run tests
- `coverage-reporter` - Generate coverage reports
- `test-fixer` - Fix common test failures

**Bad**: Mega-skill
- `testing-suite` - Does everything (tests, coverage, fixing, debugging)

### 5. Optional PRISM Awareness

Only add `.prism-hints` if skill actually uses PRISM context:

**Needs .prism-hints**:
- Skills that read PRISM context files
- Skills that update session/context
- Skills specific to PRISM workflows

**Doesn't need .prism-hints**:
- Generic skills that work anywhere
- Skills with no PRISM dependencies
- Standard development tasks

## Troubleshooting

### Skills Not Visible in Claude Code

**Check symlinks**:
```bash
ls -la ~/.claude/skills
# Should show: ~/.claude/skills -> /Users/you/.prism/skills

ls -la ~/.prism/skills
# Should show symlinks to built-in skills
```

**Fix**:
```bash
prism skill link-claude
```

### Skill Not Activating

**Check description**:
- Description should include trigger keywords
- Match user's natural language
- Be specific about when to use

**Debug**:
```bash
# View skill details
prism skill info <skill-name>

# Check if Claude can see it
ls ~/.claude/skills/<skill-name>/SKILL.md
```

### Command Not Found Errors

**If `prism skill` doesn't work**:

Check if prism is in PATH:
```bash
which prism
# Should show: /Users/you/bin/prism
```

Check if skills library is installed:
```bash
ls ~/.prism/lib/prism-skills.sh
```

**Fix**:
```bash
# Reinstall/update PRISM
prism update
```

## Future Enhancements

### Planned Features

1. **Skill Templates**:
   - Pre-built templates for common skill types
   - `prism skill create --template testing`

2. **Skill Testing**:
   - Dry-run mode to test skills
   - `prism skill test <name>`

3. **Skill Marketplace**:
   - Share skills with community
   - `prism skill install <name>` from remote

4. **Enhanced Context Hints**:
   - More sophisticated PRISM awareness
   - Automatic context file suggestions
   - Smart session tracking

### Not Planned (By Design)

- Complex approval workflows (keep it simple)
- Skill versioning (use git for team skills)
- Skill dependencies (keep skills independent)
- Team repositories (use git repos with .claude/skills/)

## Summary

PRISM Skills provides:
- ✅ **5 built-in skills** for common PRISM workflows
- ✅ **CLI management** (`prism skill` commands)
- ✅ **Claude Code integration** (automatic via symlinks)
- ✅ **Simple skill creation** (minimal SKILL.md format)
- ✅ **Optional PRISM awareness** (.prism-hints enhancement)
- ✅ **100% Claude Code compatible** (standard skill format)

**Key Principle**: Extend, don't replace. PRISM skills are standard Claude skills with optional PRISM-specific enhancements.

---

**Version**: 2.3.0
**Last Updated**: 2025-11-02
**Status**: Production Ready
