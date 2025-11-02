# PRISM Skills - Simple Integration Design

**Created**: 2025-11-02
**Version**: 2.0 (Simplified)
**Status**: DESIGN

## Philosophy: Keep It Simple

PRISM Skills follows Claude's native skills design: **Markdown + YAML metadata + optional scripts**. We don't reinvent - we integrate and enhance minimally.

## Core Concept

**Skills are folders with a SKILL.md file**. That's it.

Claude automatically invokes skills based on their description. PRISM adds:
1. **Built-in skills** for common PRISM workflows
2. **Easy skill creation** via `prism skill create`
3. **PRISM context awareness** (optional enhancement)

## File Structure

### Minimal Skill (Just Works™)

```
~/.prism/skills/my-skill/
└── SKILL.md
```

**SKILL.md**:
```markdown
---
name: my-skill
description: Brief description of what this does and when to use it
---

# My Skill

## Instructions
Clear, concise instructions for Claude.

## Examples
```
User: "do the thing"
Assistant: *follows these instructions*
```
```

### Enhanced Skill (PRISM-Aware)

```
~/.prism/skills/my-skill/
├── SKILL.md
├── .prism-hints       # Optional: PRISM context hints
└── scripts/           # Optional: executable tools
    └── helper.sh
```

**.prism-hints** (optional):
```yaml
# Simple hints for PRISM integration
context_files:
  - patterns.md        # Suggest Claude read these if available
  - architecture.md

updates_context: true  # Skill may update session context

tags:
  - testing
  - automation
```

## Skill Locations

PRISM follows Claude Code standard with one addition:

1. **Personal**: `~/.prism/skills/` (symlinked to `~/.claude/skills/`)
2. **Project**: `.claude/skills/` (in project root)
3. **Built-in**: `~/.prism/lib/skills/` (PRISM-provided)

## Built-in Skills

PRISM ships with common skills pre-installed:

### 1. test-runner
**Location**: `~/.prism/lib/skills/test-runner/`

```markdown
---
name: test-runner
description: Run project tests automatically. Use when user wants to run tests or verify code changes.
---

# Test Runner

## Instructions

1. Detect test framework from project files:
   - JavaScript: Check package.json for jest, vitest, mocha
   - Python: Check for pytest, requirements.txt
   - Go: Check for go.mod

2. If PRISM context exists, check patterns.md for test commands

3. Run tests with appropriate command

4. If tests pass, update .prism/sessions/current.md with results

5. Show summary to user

## Examples
```
User: "run tests"
Assistant: *detects jest* → npm test → shows results
```
```

### 2. context-summary
**Location**: `~/.prism/lib/skills/context-summary/`

```markdown
---
name: context-summary
description: Summarize PRISM project context. Use when user asks about project setup, architecture, or patterns.
---

# Context Summary

## Instructions

1. Check if .prism/ directory exists
2. Read key context files if present:
   - .prism/context/patterns.md
   - .prism/context/architecture.md
   - .prism/PRISM.md
3. Generate concise summary
4. Highlight key patterns and decisions

## Examples
```
User: "what are our coding standards?"
Assistant: *reads patterns.md* → summarizes standards
```
```

### 3. session-save
**Location**: `~/.prism/lib/skills/session-save/`

```markdown
---
name: session-save
description: Save current session to PRISM. Use when user wants to save work or end session.
---

# Session Save

## Instructions

1. Check .prism/sessions/current.md for active work
2. Create archive entry in .prism/sessions/archive/
3. Generate session summary
4. Clear current.md for next session
5. Confirm save to user

## Examples
```
User: "save this session"
Assistant: *archives current work* → confirms save
```
```

### 4. skill-create
**Location**: `~/.prism/lib/skills/skill-create/`

```markdown
---
name: skill-create
description: Create a new Claude/PRISM skill interactively. Use when user wants to create a custom skill.
---

# Skill Creator

## Instructions

1. Ask user:
   - What should the skill do?
   - When should it be invoked?
   - Personal or project scope?

2. Create skill directory:
   - Personal: ~/.prism/skills/{skill-name}/
   - Project: .claude/skills/{skill-name}/

3. Generate SKILL.md with:
   - name: (lowercase-with-hyphens)
   - description: (clear, includes trigger words)
   - Instructions section
   - Examples section

4. Optionally create .prism-hints if PRISM-aware

5. Guide user on testing the skill

## Examples
```
User: "create a skill for running linters"
Assistant: *interactive questions* → generates skill
```
```

### 5. prism-init
**Location**: `~/.prism/lib/skills/prism-init/`

```markdown
---
name: prism-init
description: Initialize PRISM in a project. Use when user wants to set up PRISM or asks about PRISM setup.
---

# PRISM Initializer

## Instructions

1. Check if .prism/ exists (don't reinitialize)

2. Create structure:
   ```
   .prism/
   ├── context/
   │   ├── patterns.md
   │   └── architecture.md
   └── sessions/
       └── current.md
   ```

3. Populate templates with project-specific placeholders

4. Create .prism/TIMESTAMP

5. Guide user through next steps

## Examples
```
User: "set up PRISM"
Assistant: *creates structure* → explains workflow
```
```

## Skill Creation Workflow

### Command: `prism skill create`

```bash
# Interactive creation
prism skill create

# Quick creation
prism skill create my-skill --description "Does something useful"

# Project-scoped
prism skill create my-skill --scope project

# With template
prism skill create my-skill --template basic
```

**Interactive Prompts**:
```
PRISM Skill Creator
===================

What should your skill be called? (lowercase-with-hyphens)
> test-coverage-reporter

What does it do?
> Generates test coverage reports in markdown format

When should Claude use it? (trigger words/phrases)
> when user asks for coverage report, test coverage, or coverage analysis

Where should it live?
  1. Personal (~/.prism/skills/) - just for you
  2. Project (.claude/skills/) - for this project
> 1

Should it be PRISM-aware? (read/update context)
> y

Creating skill at: ~/.prism/skills/test-coverage-reporter/

✓ Created SKILL.md
✓ Created .prism-hints
✓ Skill ready!

Test it: "Hey Claude, show me test coverage"
```

### Generated Files

**~/.prism/skills/test-coverage-reporter/SKILL.md**:
```markdown
---
name: test-coverage-reporter
description: Generates test coverage reports in markdown format. Use when user asks for coverage report, test coverage, or coverage analysis.
---

# Test Coverage Reporter

## Instructions

1. Detect test framework and coverage tools
2. Run coverage command (e.g., `npm test -- --coverage`)
3. Parse coverage output
4. Generate markdown report
5. If PRISM context available, update .prism/sessions/current.md

## Examples

```
User: "show me test coverage"
Assistant: *runs coverage* → generates markdown report
```

```
User: "what's our coverage?"
Assistant: *checks existing coverage* → shows summary
```
```

**~/.prism/skills/test-coverage-reporter/.prism-hints**:
```yaml
# PRISM context hints
context_files:
  - patterns.md

updates_context: true
updates_files:
  - sessions/current.md

tags:
  - testing
  - coverage
  - reporting
```

## PRISM Context Integration (Optional)

Skills can optionally be PRISM-aware through `.prism-hints`:

### Simple Context Awareness

```yaml
# .prism-hints

# Files this skill might read
context_files:
  - patterns.md
  - architecture.md

# Does this skill update context?
updates_context: true

# Which files might it update?
updates_files:
  - sessions/current.md
  - context/patterns.md

# Tags for discovery
tags:
  - testing
  - automation
```

### How It Works

1. **When skill is invoked**, Claude checks for `.prism-hints`
2. **If present**, Claude suggests: "I see this skill uses patterns.md. Let me check that first."
3. **After execution**, Claude knows to update mentioned files
4. **User gets context-aware behavior** without complex infrastructure

## Implementation

### Phase 1: Basic Skills (Week 1)

**What to Build**:
1. Skill directory structure
2. Built-in skills (5 skills above)
3. `prism skill create` command
4. Symlink ~/.prism/skills → ~/.claude/skills

**Files to Create**:
```
~/.prism/lib/skills/
├── test-runner/SKILL.md
├── context-summary/SKILL.md
├── session-save/SKILL.md
├── skill-create/SKILL.md
└── prism-init/SKILL.md

lib/prism-skills.sh
```

**prism-skills.sh**:
```bash
#!/bin/bash
# PRISM Skills Management

skill_create() {
    local name="$1"
    local scope="${2:-personal}"  # personal or project

    if [[ "$scope" == "personal" ]]; then
        skill_dir="$HOME/.prism/skills/$name"
    else
        skill_dir=".claude/skills/$name"
    fi

    mkdir -p "$skill_dir"

    # Interactive prompts...
    # Generate SKILL.md
    # Optionally create .prism-hints
}

skill_list() {
    echo "=== Personal Skills ==="
    ls -1 ~/.prism/skills/ 2>/dev/null || echo "  (none)"

    echo ""
    echo "=== Project Skills ==="
    ls -1 .claude/skills/ 2>/dev/null || echo "  (none)"

    echo ""
    echo "=== Built-in Skills ==="
    ls -1 ~/.prism/lib/skills/ 2>/dev/null
}

skill_info() {
    local name="$1"
    # Find and display skill metadata
}
```

### Phase 2: Context Hints (Week 2)

**What to Build**:
1. `.prism-hints` parser
2. Context suggestion logic
3. Update tracking

**Simple Implementation**:
- Claude reads `.prism-hints` if present
- Uses as guidance, not enforcement
- Natural language suggestions to Claude

### Phase 3: Polish (Week 3)

**What to Build**:
1. Skill templates
2. Testing helper
3. Documentation

## Usage Examples

### Example 1: Using Built-in Skills

```
User: "run tests"
Claude: *test-runner skill activates*
        *detects Jest*
        npm test
        ✓ All tests passed (127 tests)

        Updated: .prism/sessions/current.md
```

### Example 2: Creating Custom Skill

```
User: "create a skill for formatting JSON"

Claude: I'll help create that skill. Let me ask a few questions:

        *skill-create activates*

        What should it be called?
User: json-formatter

Claude: When should I use it? (trigger words)
User: when formatting JSON or prettifying JSON

Claude: Personal or project?
User: personal

Claude: ✓ Created ~/.prism/skills/json-formatter/

        Try it: "format this JSON: {...}"
```

### Example 3: PRISM-Aware Skill

```
User: "run tests"

Claude: *test-runner skill activates*
        *reads .prism-hints*
        *sees: context_files: [patterns.md]*

        Let me check your test patterns first...
        *reads .prism/context/patterns.md*

        I see you use Jest with --coverage flag.

        npm test -- --coverage
        ✓ 95% coverage

        Updated: .prism/sessions/current.md
```

## Built-in Skills Reference

| Skill | Trigger | Purpose |
|-------|---------|---------|
| **test-runner** | "run tests", "test this" | Execute project tests |
| **context-summary** | "project setup", "our standards" | Summarize PRISM context |
| **session-save** | "save session", "end session" | Archive current work |
| **skill-create** | "create skill", "new skill" | Interactive skill creation |
| **prism-init** | "setup PRISM", "initialize PRISM" | Initialize PRISM in project |

## Best Practices

### 1. Write Clear Descriptions

**Good**:
```yaml
description: Run project tests automatically. Use when user wants to run tests, verify code changes, or check test status.
```

**Bad**:
```yaml
description: A skill for testing
```

### 2. Include Examples

Always show Claude how the skill should be used:

```markdown
## Examples

```
User: "run tests"
Assistant: *detects Jest* → npm test → shows results
```

```
User: "check if tests pass"
Assistant: *runs tests quietly* → reports status
```
```

### 3. Keep Instructions Simple

Focus on **what to do**, not **how Claude thinks**:

```markdown
## Instructions

1. Detect test framework
2. Run tests
3. Show results
4. Update session if PRISM available
```

### 4. Make Skills Focused

One skill = one job. Don't create mega-skills.

**Good**: Separate skills for `test-runner`, `coverage-reporter`
**Bad**: One `testing-suite` skill that does everything

### 5. Use .prism-hints Sparingly

Only add `.prism-hints` if the skill really needs PRISM context:

**Needs hints**: Skills that read/write PRISM context
**Doesn't need**: Generic skills that work anywhere

## CLI Commands

```bash
# Create a skill
prism skill create [name] [--scope personal|project]

# List skills
prism skill list

# Show skill info
prism skill info <name>

# Test a skill (shows SKILL.md)
prism skill show <name>

# Install built-in skills
prism skill install-builtin

# Create symlink to Claude
prism skill link-claude
```

## Migration from Complex Design

**Old approach**: Complex PRISM.yaml with 50+ fields
**New approach**: Simple SKILL.md + optional .prism-hints

**Why simpler is better**:
- ✅ Follows Claude's native design
- ✅ Less to learn and maintain
- ✅ Works with existing Claude ecosystem
- ✅ Easy to create skills (5 minutes vs 30 minutes)
- ✅ PRISM enhancements are optional, not required

## FAQ

**Q: Do skills work in Claude Code?**
A: Yes! PRISM skills are standard Claude skills. The `.prism-hints` file is optional PRISM enhancement.

**Q: Can I use Anthropic's marketplace skills?**
A: Yes! Install to `~/.prism/skills/` and they work immediately.

**Q: What about team sharing?**
A: Use `.claude/skills/` in your git repo. Team members get them automatically.

**Q: How do I know what skills are active?**
A: `prism skill list` or Claude will mention skills it's using.

**Q: Can skills execute code?**
A: Yes! Add scripts/ directory with executable files. Claude can invoke them.

**Q: Do I need .prism-hints?**
A: No! It's optional. Skills work fine without it. Add it only if you want PRISM context awareness.

## Summary

**PRISM Skills = Claude Skills + Optional PRISM Context Hints**

**Core principle**: Don't reinvent. Integrate minimally.

**File structure**:
- Minimal: Just `SKILL.md`
- Enhanced: Add `.prism-hints` for PRISM awareness

**Built-in skills**: 5 common PRISM workflows pre-packaged

**Creation**: Simple interactive `prism skill create`

**Integration**: Natural, not forced. Skills can be PRISM-aware or generic.

---

**Implementation**: 3 weeks
- Week 1: Basic skills + creation
- Week 2: Context hints
- Week 3: Polish + docs

**Complexity**: 🟢 Low
**Value**: 🟢 High
**Compatibility**: 🟢 100% with Claude ecosystem
