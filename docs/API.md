# PRISM API Reference

## Overview

PRISM provides both a CLI interface and a library API for integration with other tools.

## CLI API

### Command Structure

```bash
prism [GLOBAL_OPTIONS] COMMAND [COMMAND_OPTIONS] [ARGUMENTS]
```

### Global Options

| Option | Short | Description |
|--------|-------|-------------|
| `--help` | `-h` | Show help message |
| `--version` | `-v` | Show version |
| `--debug` | `-d` | Enable debug output |
| `--quiet` | `-q` | Suppress output |
| `--config FILE` | `-c` | Use custom config |
| `--home DIR` | | Override PRISM home |

### Commands

#### `init`

Initialize PRISM in a project.

```bash
prism init [OPTIONS]
```

**Options:**
- `--template NAME` - Use template
- `--force` - Overwrite existing
- `--minimal` - Minimal setup

**Exit Codes:**
- `0` - Success
- `1` - Already initialized
- `2` - Template not found
- `3` - Permission denied

#### `context`

Manage persistent context.

```bash
prism context SUBCOMMAND [OPTIONS]
```

**Subcommands:**
- `show [CATEGORY]` - Display context
- `add CATEGORY CONTENT` - Add context
- `update ID CONTENT` - Update item
- `remove ID` - Remove item
- `search QUERY` - Search context
- `clear [CATEGORY]` - Clear context
- `export [FILE]` - Export context
- `import FILE` - Import context

**Options:**
- `--json` - JSON output
- `--tags TAGS` - Comma-separated tags
- `--confirm` - Skip confirmation
- `--regex` - Use regex search

#### `session`

Manage work sessions.

```bash
prism session SUBCOMMAND [OPTIONS]
```

**Subcommands:**
- `start [NAME]` - Start session
- `end` - End current session
- `current` - Show current session
- `list` - List all sessions
- `resume [SESSION_ID]` - Resume session
- `save [MESSAGE]` - Save session state
- `export SESSION_ID` - Export session
- `import FILE` - Import session

**Options:**
- `--desc DESCRIPTION` - Session description
- `--restore-context` - Restore context on resume
- `--auto-save` - Enable auto-save

#### `doctor`

Run diagnostics.

```bash
prism doctor [OPTIONS]
```

**Options:**
- `--check COMPONENT` - Check specific component
- `--fix` - Apply automatic fixes
- `--verbose` - Detailed output
- `--report` - Generate report

**Components:**
- `context` - Context storage
- `permissions` - File permissions
- `claude` - Claude integration
- `dependencies` - System dependencies

#### `patterns`

Manage learned patterns.

```bash
prism patterns SUBCOMMAND [OPTIONS]
```

**Subcommands:**
- `show` - Display patterns
- `add PATTERN` - Add pattern
- `learn` - Learn from session
- `stats` - Show statistics
- `export` - Export patterns
- `import FILE` - Import patterns

#### `template`

Manage project templates.

```bash
prism template SUBCOMMAND [OPTIONS]
```

**Subcommands:**
- `list` - List templates
- `show NAME` - Show template details
- `apply NAME` - Apply template
- `create NAME` - Create from project
- `export NAME` - Export template
- `import FILE` - Import template

## Library API

### Bash Library

Source the PRISM libraries in your scripts:

```bash
#!/bin/bash
source /path/to/lib/prism-core.sh
source /path/to/lib/prism-security.sh
source /path/to/lib/prism-log.sh
```

### Core Functions

#### Error Handling

```bash
# Set up error handling
setup_error_handling

# Custom error handler
error_handler() {
    local line=$1
    local command=$2
    local code=$3
    log_error "Error at line $line: $command (exit $code)"
}

# Cleanup on exit
cleanup() {
    log_info "Cleaning up..."
    # Your cleanup code
}
```

#### Logging

```bash
# Log levels
log_debug "Debug message"
log_info "Info message"
log_warn "Warning message"
log_error "Error message"

# Structured logging
log_structured "EVENT" "key1=value1" "key2=value2"

# Log to file
export PRISM_LOG_FILE="/path/to/log"
log_info "This goes to file"
```

#### Security

```bash
# Sanitize input
clean_filename=$(sanitize_input "$user_input" "filename")
clean_path=$(sanitize_input "$user_input" "path")
clean_text=$(sanitize_input "$user_input" "text")
clean_id=$(sanitize_input "$user_input" "id")

# Validate path
if validate_path "$user_path"; then
    # Path is safe
fi

# Verify checksum
if verify_checksum "$file" "$expected_hash"; then
    # File is valid
fi
```

#### Platform Detection

```bash
# Detect platform
platform=$(detect_platform)
case "$platform" in
    macos) echo "Running on macOS" ;;
    linux) echo "Running on Linux" ;;
    wsl) echo "Running on WSL" ;;
esac

# Platform-specific commands
if is_macos; then
    # macOS specific
elif is_linux; then
    # Linux specific
fi

# Get ISO date (platform-independent)
iso_date=$(get_iso_date)
```

### Context API

#### Reading Context

```bash
# Load context
load_context "patterns"

# Get all context
contexts=$(get_all_contexts)

# Search context
results=$(search_context "query")

# Get by ID
item=$(get_context_by_id 42)
```

#### Writing Context

```bash
# Add context
add_context "patterns" "New pattern" "tag1,tag2"

# Update context
update_context 42 "Updated content"

# Remove context
remove_context 42

# Clear category
clear_context_category "patterns"
```

### Session API

#### Session Management

```bash
# Start session
session_id=$(start_session "feature-work")

# Get current session
current=$(get_current_session)

# Save session state
save_session_state "Checkpoint message"

# End session
end_session

# Resume session
resume_session "$session_id"
```

#### Session Data

```bash
# Add to session log
log_session_event "Started implementation"

# Get session metadata
metadata=$(get_session_metadata "$session_id")

# Export session
export_session "$session_id" "/path/to/export.json"

# Import session
import_session "/path/to/import.json"
```

### Pattern API

```bash
# Learn patterns from session
learn_patterns_from_session

# Add manual pattern
add_pattern "Pattern name" "pattern code" "category"

# Get pattern statistics
stats=$(get_pattern_stats)

# Apply pattern
apply_pattern "pattern_id" "/path/to/file"
```

### Template API

```bash
# List available templates
templates=$(list_templates)

# Apply template to project
apply_template "nodejs" "/path/to/project"

# Create template from project
create_template_from_project "my-template"

# Validate template
if validate_template "template_name"; then
    echo "Template is valid"
fi
```

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `PRISM_HOME` | PRISM home directory | `~/.prism` |
| `PRISM_CONFIG` | Config file location | `$PRISM_HOME/config.yaml` |
| `PRISM_LOG_LEVEL` | Log level (debug/info/warn/error) | `info` |
| `PRISM_LOG_FILE` | Log file path | `$PRISM_HOME/prism.log` |
| `PRISM_DEBUG` | Enable debug mode (0/1) | `0` |
| `PRISM_NO_COLOR` | Disable colored output | `0` |
| `PRISM_EDITOR` | Preferred editor | `$EDITOR` |
| `PRISM_SESSION_AUTO_SAVE` | Auto-save interval (seconds) | `300` |

## Configuration File

### Location

- Primary: `~/.prism/config.yaml`
- Project: `.prism/config.yaml`
- Custom: Via `--config` flag

### Format

```yaml
# PRISM Configuration
version: 2.1.0

# General settings
general:
  auto_update: true
  telemetry: false
  color_output: true

# Context settings
context:
  max_items: 1000
  auto_clean: true
  clean_after_days: 90

# Session settings
sessions:
  auto_save: true
  save_interval: 300
  max_sessions: 100
  archive_after_days: 30

# Pattern settings
patterns:
  learning_enabled: true
  min_occurrences: 3
  max_patterns: 500

# Claude integration
claude:
  enabled: true
  config_path: ~/.claude/PRISM.md
  auto_sync: true

# Logging
logging:
  level: info
  file: ~/.prism/logs/prism.log
  max_size: 10M
  rotate: true
  keep_days: 30

# Hooks
hooks:
  pre_session: ~/.prism/hooks/pre-session.sh
  post_session: ~/.prism/hooks/post-session.sh
  on_context_update: ~/.prism/hooks/on-context-update.sh
```

## Exit Codes

| Code | Description |
|------|-------------|
| `0` | Success |
| `1` | General error |
| `2` | Invalid arguments |
| `3` | Permission denied |
| `4` | Not found |
| `5` | Already exists |
| `6` | Invalid state |
| `7` | Dependency missing |
| `8` | Network error |
| `9` | Timeout |
| `10` | User cancelled |

## Hooks

### Available Hooks

| Hook | Trigger | Arguments |
|------|---------|-----------|
| `pre-session` | Before session start | session_id, session_name |
| `post-session` | After session end | session_id, duration |
| `on-context-update` | Context modified | category, action, item_id |
| `on-pattern-learn` | Pattern learned | pattern_id, pattern_name |
| `pre-init` | Before project init | project_path |
| `post-init` | After project init | project_path |

### Hook Example

```bash
#!/bin/bash
# ~/.prism/hooks/post-session.sh

session_id=$1
duration=$2

# Log session to external system
curl -X POST https://api.example.com/sessions \
    -H "Content-Type: application/json" \
    -d "{\"id\": \"$session_id\", \"duration\": $duration}"

# Backup session data
cp -r ~/.prism/sessions/$session_id /backup/
```

## Integration Examples

### CI/CD Integration

```yaml
# GitHub Actions
name: PRISM Setup
on: [push]
jobs:
  setup:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Install PRISM
        run: |
          curl -fsSL ${{ secrets.PRISM_INSTALLER_URL }} | bash
          prism init --minimal
      - name: Load context
        run: prism context import .prism/context.export
```

### Git Hooks

```bash
#!/bin/bash
# .git/hooks/pre-commit

# Save PRISM session state before commit
if command -v prism &> /dev/null; then
    prism session save "Pre-commit: $(git diff --cached --name-only | head -n1)"
fi
```

### Editor Integration

```vim
" Vim integration
command! PrismContext :!prism context show
command! PrismSession :!prism session current
command! -nargs=+ PrismAdd :!prism context add patterns "<args>"
```

## Security Considerations

1. **Input Validation**: Always use `sanitize_input` for user data
2. **Path Traversal**: Use `validate_path` for file operations
3. **Command Injection**: Never use eval or unquoted variables
4. **Permissions**: Check file permissions before operations
5. **Secrets**: Never log sensitive information

## Performance Tips

1. **Context Size**: Keep under 1000 items for best performance
2. **Session Archive**: Archive old sessions regularly
3. **Pattern Limit**: Limit patterns to 500 for quick matching
4. **Logging**: Use appropriate log levels in production
5. **Caching**: Enable caching for frequently accessed data

---

For more information, see the [User Manual](MANUAL.md) or visit our [GitHub repository](https://github.com/afiffattouh/hildens-prism).