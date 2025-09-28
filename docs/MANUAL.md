# PRISM User Manual

## Table of Contents

1. [Introduction](#introduction)
2. [Getting Started](#getting-started)
3. [Core Commands](#core-commands)
4. [Context Management](#context-management)
5. [Session Management](#session-management)
6. [Patterns & Learning](#patterns--learning)
7. [Templates](#templates)
8. [Diagnostics](#diagnostics)
9. [Advanced Usage](#advanced-usage)
10. [Best Practices](#best-practices)

## Introduction

PRISM (Persistent Real-time Intelligent System Management) enhances Claude Code with persistent memory and context management across development sessions.

### Key Concepts

- **Context**: Persistent knowledge about your project
- **Patterns**: Learned behaviors and preferences
- **Sessions**: Individual work sessions with state
- **Templates**: Reusable project configurations

## Getting Started

### First-Time Setup

1. **Install PRISM** (see [INSTALL.md](INSTALL.md))

2. **Enable the `prism` command** (IMPORTANT!)
   ```bash
   # Option A: Open a new terminal window
   # OR
   # Option B: Reload your shell:
   source ~/.zshrc  # macOS
   source ~/.bashrc # Linux

   # Verify it works:
   prism --help
   ```

   If you get "command not found", see [Troubleshooting](INSTALL.md#troubleshooting).

3. **Initialize your first project:**
   ```bash
   cd your-project
   prism init
   ```

4. **Claude Code now has persistent context!**

### Basic Workflow

```bash
# Start a new session
prism session start

# Work with Claude Code
# ... your development work ...

# Save session state
prism session save "Implemented user authentication"

# View context
prism context show
```

## Core Commands

### `prism init`

Initialize PRISM in a project:

```bash
prism init [OPTIONS]

Options:
  --template NAME    Use a template (nodejs, python, react, etc.)
  --force           Overwrite existing configuration
  --minimal         Minimal setup without templates
```

Examples:
```bash
# Basic initialization
prism init

# With Node.js template
prism init --template nodejs

# Force reinitialize
prism init --force
```

### `prism status`

Check PRISM status:

```bash
prism status

# Output:
# PRISM Status:
# ✅ Active in: /path/to/project
# 📊 Context items: 42
# 🔄 Current session: dev-session-2024
# ⏱️ Session duration: 2h 15m
```

### `prism help`

Get help for commands:

```bash
prism help [COMMAND]

# General help
prism help

# Command-specific help
prism help context
```

## Context Management

Context stores persistent knowledge about your project.

### View Context

```bash
# Show all context
prism context show

# Show specific category
prism context show patterns
prism context show architecture
prism context show decisions
```

### Add Context

```bash
# Add to patterns
prism context add patterns "Always use TypeScript strict mode"

# Add architectural decision
prism context add architecture "Microservices with REST APIs"

# Add with metadata
prism context add decisions "Use PostgreSQL" --tags "database,infrastructure"
```

### Search Context

```bash
# Search all context
prism context search "database"

# Search specific category
prism context search "API" --category patterns

# Regular expression search
prism context search "test.*unit" --regex
```

### Update Context

```bash
# Update existing item
prism context update 42 "Updated content"

# Update with confirmation
prism context update 42 "New content" --confirm
```

### Remove Context

```bash
# Remove by ID
prism context remove 42

# Remove with confirmation
prism context remove 42 --confirm

# Clear category
prism context clear patterns --confirm
```

## Session Management

Sessions track work periods and maintain state.

### Start Session

```bash
# Start new session
prism session start

# Named session
prism session start "feature-authentication"

# With description
prism session start --desc "Implementing OAuth2 login"
```

### Session Operations

```bash
# View current session
prism session current

# List all sessions
prism session list

# Save session state
prism session save "Completed login flow"

# End session
prism session end
```

### Resume Session

```bash
# Resume last session
prism session resume

# Resume specific session
prism session resume session-2024-01-15

# Resume with context restore
prism session resume --restore-context
```

## Patterns & Learning

PRISM learns from your development patterns.

### View Patterns

```bash
# Show learned patterns
prism patterns show

# Show pattern statistics
prism patterns stats

# Export patterns
prism patterns export > patterns.json
```

### Train Patterns

```bash
# Manual pattern addition
prism patterns add "Error handling pattern" --code "try-catch-finally"

# Learn from current session
prism patterns learn

# Import patterns
prism patterns import patterns.json
```

## Templates

Use templates for common project types.

### List Templates

```bash
# Show available templates
prism template list

# Show template details
prism template show nodejs
```

### Use Templates

```bash
# Apply template to current project
prism template apply nodejs

# Preview template changes
prism template apply react --dry-run

# Create from template
prism create my-app --template vue
```

### Custom Templates

```bash
# Create template from current project
prism template create my-template

# Share template
prism template export my-template > template.zip

# Import template
prism template import template.zip
```

## Diagnostics

### Health Check

```bash
# Run diagnostics
prism doctor

# Verbose output
prism doctor --verbose

# Auto-fix issues
prism doctor --fix
```

### Troubleshooting

```bash
# Check specific component
prism doctor --check context
prism doctor --check permissions
prism doctor --check claude

# Generate debug report
prism doctor --report > debug.log
```

## Advanced Usage

### Environment Variables

```bash
# Set custom home
export PRISM_HOME=/custom/path

# Enable debug mode
export PRISM_DEBUG=1

# Set log level
export PRISM_LOG_LEVEL=debug
```

### Configuration

Edit `~/.prism/config.yaml`:

```yaml
# Auto-save sessions
auto_save: true
save_interval: 300  # seconds

# Context limits
max_context_size: 1000
max_pattern_count: 500

# Features
features:
  learning: true
  suggestions: true
  auto_update: false
```

### Hooks

Create hooks for automation:

```bash
# Pre-session hook
~/.prism/hooks/pre-session.sh

# Post-session hook
~/.prism/hooks/post-session.sh

# Context update hook
~/.prism/hooks/on-context-update.sh
```

### Integration

#### Git Integration

```bash
# Add to .gitignore
echo ".prism/sessions/" >> .gitignore

# Track patterns
git add .prism/context/patterns.md
```

#### CI/CD Integration

```yaml
# GitHub Actions
- name: Setup PRISM
  run: |
    curl -fsSL https://raw.githubusercontent.com/afiffattouh/hildens-prism/main/install.sh | bash
    prism init --minimal
```

## Best Practices

### Context Management

1. **Keep context relevant** - Remove outdated information
2. **Use categories** - Organize context logically
3. **Tag important items** - Use tags for quick retrieval
4. **Regular cleanup** - Run `prism context clean` monthly

### Session Management

1. **Name sessions meaningfully** - Use feature or ticket names
2. **Save progress regularly** - Use auto-save or manual saves
3. **End sessions properly** - Always run `prism session end`
4. **Review old sessions** - Learn from past work

### Pattern Learning

1. **Review learned patterns** - Verify PRISM learns correctly
2. **Correct mistakes** - Remove incorrect patterns
3. **Share team patterns** - Export and share with team
4. **Update regularly** - Patterns should evolve

### Performance

1. **Limit context size** - Keep under 1000 items
2. **Archive old sessions** - Move to `.prism/archive/`
3. **Use minimal mode** - For CI/CD environments
4. **Regular maintenance** - Run `prism doctor` weekly

## Keyboard Shortcuts

When using PRISM interactively:

- `Ctrl+C` - Cancel current operation
- `Ctrl+D` - End session and exit
- `Tab` - Auto-complete commands
- `↑/↓` - Navigate command history

## FAQ

**Q: Why does `prism` show "command not found" after installation?**
A: The `~/bin` directory needs to be in your PATH. Either:
- Open a new terminal window (easiest)
- Run `source ~/.zshrc` (macOS) or `source ~/.bashrc` (Linux)
- Use the full path: `~/bin/prism --help`

**Q: How do I know which shell I'm using?**
A: Run `echo $SHELL`. It will show `/bin/zsh` (macOS) or `/bin/bash` (Linux).

**Q: Can I use PRISM immediately after installation?**
A: Yes, but you need to enable the command first. Use `~/bin/prism` for immediate access.

**Q: How much disk space does PRISM use?**
A: Typically 1-10MB per project, depending on context size.

**Q: Can I share context between projects?**
A: Yes, use `prism context export/import`.

**Q: Is my data secure?**
A: All data is stored locally. No external transmission.

**Q: Can I use PRISM with other AI tools?**
A: PRISM is optimized for Claude Code but stores plain text.

**Q: How do I backup PRISM data?**
A: Backup the `.prism/` directory in your project.

## Getting Help

- Command help: `prism help [command]`
- Diagnostics: `prism doctor`
- Documentation: See [API.md](API.md)
- Issues: [GitHub Issues](https://github.com/afiffattouh/hildens-prism/issues)

---

For API documentation and development, see [API.md](API.md).