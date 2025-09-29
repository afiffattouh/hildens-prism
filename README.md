# PRISM Framework v2.0

> **Secure, modular, and professional AI context management for Claude Code**

[![Version](https://img.shields.io/badge/version-2.0.3-blue.svg)](https://github.com/afiffattouh/hildens-prism)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Security](https://img.shields.io/badge/security-hardened-orange.svg)](SECURITY.md)

## 🚀 Quick Install

```bash
# One-line installation
curl -fsSL https://raw.githubusercontent.com/afiffattouh/hildens-prism/main/install.sh | bash

# Or download and review first (recommended)
curl -fsSL https://raw.githubusercontent.com/afiffattouh/hildens-prism/main/install.sh -o install.sh
cat install.sh  # Review the script
bash install.sh
```

### ⚠️ Important: Enable the `prism` command

After installation, you **MUST** do one of the following:

**Option 1: Open a new terminal** (easiest)

**Option 2: Reload your shell configuration:**
```bash
# For macOS/zsh:
source ~/.zshrc

# For Linux/bash:
source ~/.bashrc
```

**Option 3: Use full path** (temporary):
```bash
~/bin/prism --help
```

Then verify installation:
```bash
prism --help  # Should display help information
prism version  # Should show 2.0.2
```

## 🎯 What is PRISM?

PRISM (Persistent Real-time Intelligent System Management) is a comprehensive framework that enhances Claude Code with:

- 🧠 **Persistent Memory** - Context maintained across sessions
- 🔒 **Security-First** - Input validation, checksums, secure operations
- 📝 **Smart Context** - Automatic pattern learning and application
- ⚡ **Professional CLI** - Clean, modular command interface
- 🔍 **Diagnostics** - Built-in doctor command for troubleshooting
- 🔄 **Auto-Updates** - Keep framework current with built-in updater
- 📊 **Session Management** - Track and restore development sessions
- ⚙️ **Configuration System** - Flexible project and global settings

## 📦 Features

### Core Capabilities
- ✅ **Project Initialization** - Quick setup with templates
- ✅ **Context Management** - Persistent knowledge base
- ✅ **Session Tracking** - Development history and restoration
- ✅ **Configuration Management** - Flexible settings system
- ✅ **Auto-Update System** - Stay current with latest features
- ✅ **Health Diagnostics** - Built-in troubleshooting
- ✅ **Security Hardening** - Input validation and secure operations
- ✅ **Multi-Platform** - macOS, Linux, and WSL support

### v2.0 Improvements
- ✅ Secure installation with verification
- ✅ Comprehensive error handling
- ✅ Modular architecture
- ✅ Unified CLI interface
- ✅ Diagnostic tools
- ✅ Platform compatibility
- ✅ Automatic backups before updates
- ✅ Rollback capability

## 🛠️ Complete Command Reference

### 📋 Command Overview

```bash
prism <command> [options]
```

| Command | Description |
|---------|-------------|
| `init` | Initialize PRISM in current directory |
| `context` | Manage project context and knowledge |
| `session` | Manage development sessions |
| `config` | Configure PRISM settings |
| `update` | Update PRISM framework |
| `doctor` | Diagnose and fix issues |
| `version` | Show version information |
| `help` | Show help message |

### 🚀 Initialize Command

Initialize PRISM in your project:

```bash
prism init [options]
```

**Options:**
- `--template <name>` - Use specific template (default, nodejs, python)
- `--force` - Overwrite existing configuration
- `--minimal` - Create minimal setup

**Examples:**
```bash
# Standard initialization
prism init

# Initialize with Node.js template
prism init --template nodejs

# Force reinitialize (overwrites existing)
prism init --force

# Minimal setup (lightweight)
prism init --minimal
```

### 📝 Context Command

Manage your project's persistent context:

```bash
prism context <action> [arguments]
```

**Actions:**
| Action | Description | Usage |
|--------|-------------|-------|
| `add` | Add new context entry | `prism context add [priority] [tags] [name]` |
| `query` | Search context files | `prism context query <search-term>` |
| `export` | Export context | `prism context export [format] [output]` |
| `update-templates` | Update context templates | `prism context update-templates` |
| `load-critical` | Load critical context items | `prism context load-critical` |
| `show` | Display specific context | `prism context show <type>` |

**Priority Levels:**
- `CRITICAL` - Essential information
- `HIGH` - Important context
- `MEDIUM` - Standard priority (default)
- `LOW` - Nice to have

**Examples:**
```bash
# Add high-priority security context
prism context add HIGH security "Authentication System"

# Search for authentication-related context
prism context query "auth"

# Export context as markdown
prism context export markdown context-export.md

# Export as JSON
prism context export json context.json

# Show patterns
prism context show patterns

# Update templates
prism context update-templates
```

### 💼 Session Command

Track and manage development sessions:

```bash
prism session <action> [arguments]
```

**Actions:**
| Action | Description | Usage |
|--------|-------------|-------|
| `start` | Start new session | `prism session start [description]` |
| `status` | Show current session | `prism session status` |
| `archive` | Archive current session | `prism session archive` |
| `restore` | Restore previous session | `prism session restore <session-id>` |
| `export` | Export session report | `prism session export [format] [session-id]` |
| `refresh` | Refresh session context | `prism session refresh` |
| `clean` | Clean old sessions | `prism session clean [days]` |

**Examples:**
```bash
# Start a new session with description
prism session start "Implementing user authentication"

# Check current session status
prism session status

# Archive current session when done
prism session archive

# Restore a previous session
prism session restore 20250929_143022

# Export session as markdown report
prism session export markdown session-report.md

# Clean sessions older than 30 days
prism session clean 30
```

### ⚙️ Config Command

Manage PRISM configuration:

```bash
prism config <action> [arguments]
```

**Actions:**
| Action | Description | Usage |
|--------|-------------|-------|
| `get` | Get configuration value | `prism config get <key>` |
| `set` | Set configuration value | `prism config set <key> <value>` |
| `list` | List all configuration | `prism config list` |
| `reset` | Reset to defaults | `prism config reset` |

**Configuration Keys:**
- `auto_update` - Enable automatic updates (true/false)
- `telemetry` - Enable telemetry (true/false)
- `color_output` - Enable colored output (true/false)
- `log_level` - Set logging level (TRACE/DEBUG/INFO/WARN/ERROR)
- `template` - Default template for init
- `archive_days` - Days to keep archived sessions

**Examples:**
```bash
# View all configuration
prism config list

# Get specific value
prism config get auto_update

# Set configuration value
prism config set auto_update false

# Change log level
prism config set log_level DEBUG

# Reset to defaults
prism config reset
```

### 🔄 Update Command

Keep PRISM up-to-date:

```bash
prism update [options]
```

**Options:**
- `--check` - Check for updates only (don't install)
- `--force` - Force update even if current
- `--beta` - Include beta versions

**Examples:**
```bash
# Check for updates without installing
prism update --check

# Install available updates
prism update

# Force reinstall current version
prism update --force

# Include beta versions
prism update --beta
```

### 🏥 Doctor Command

Diagnose and fix PRISM issues:

```bash
prism doctor [options]
```

**Options:**
- `--fix` - Attempt automatic fixes
- `--verbose` - Show detailed diagnostics

**Checks Performed:**
- Installation integrity
- PATH configuration
- File permissions
- Configuration validity
- Dependencies
- Version consistency

**Examples:**
```bash
# Run diagnostic check
prism doctor

# Auto-fix detected issues
prism doctor --fix

# Verbose diagnostics
prism doctor --verbose
```

### 🔍 Global Options

Available for all commands:

| Option | Description |
|--------|-------------|
| `-v, --verbose` | Enable verbose output |
| `-q, --quiet` | Suppress non-error output |
| `--no-color` | Disable colored output |
| `--log-level <level>` | Set log level (TRACE/DEBUG/INFO/WARN/ERROR) |
| `--config <path>` | Use custom config file |

**Examples:**
```bash
# Verbose initialization
prism init --verbose

# Quiet update check
prism update --check --quiet

# No color output
prism doctor --no-color

# Debug logging
prism context query "test" --log-level DEBUG
```

## 📁 Project Structure

After initialization, PRISM creates:

```
your-project/
├── .prism/
│   ├── config.yaml          # Project configuration
│   ├── context/            # Persistent knowledge base
│   │   ├── patterns.md     # Code patterns
│   │   ├── architecture.md # System architecture
│   │   ├── decisions.md    # Technical decisions
│   │   └── custom/         # Custom context files
│   ├── sessions/           # Session management
│   │   ├── current.md      # Active session
│   │   └── history/        # Archived sessions
│   ├── references/         # Documentation & guides
│   │   └── commands.md     # Command reference
│   └── templates/          # Project templates
├── CLAUDE.md              # Claude Code instructions
└── PRISM.md              # PRISM configuration doc
```

## ⚙️ Configuration

### Configuration Hierarchy

1. **Default Configuration** - Built-in defaults
2. **Global Configuration** - `~/.prism/config.yaml`
3. **Project Configuration** - `.prism/config.yaml`
4. **Command-line Options** - Runtime overrides

### Configuration File Format

```yaml
# PRISM Configuration
version: 2.0.2

# General settings
general:
  auto_update: true
  telemetry: false
  color_output: true
  log_level: INFO

# Context settings
context:
  auto_index: true
  index_interval: 3600
  max_context_size: 1048576

# Session settings
session:
  auto_archive: true
  archive_days: 30
  track_commands: true

# Templates
templates:
  default: default
  available:
    - default
    - nodejs
    - python
    - react
    - django

# Paths (usually don't change)
paths:
  home: ~/.prism
  bin: ~/bin
  logs: ~/.prism/logs
```

## 🔒 Security Features

- **Input Sanitization** - All user inputs validated
- **Path Traversal Prevention** - Secure file operations
- **Checksum Verification** - Integrity checks on updates
- **Atomic Operations** - Prevent partial updates
- **Secure Downloads** - HTTPS only with verification
- **Permission Checks** - Proper file permissions
- **Backup System** - Automatic backups before changes

## 🎯 Common Workflows

### Starting a New Project
```bash
# Initialize PRISM
prism init --template nodejs

# Start development session
prism session start "Initial setup"

# Add important context
prism context add HIGH architecture "Microservices design"

# Work on your project...

# Archive session when done
prism session archive
```

### Updating Context
```bash
# Add new patterns discovered
prism context add MEDIUM patterns "Repository pattern"

# Search existing context
prism context query "database"

# Export for documentation
prism context export markdown docs/context.md
```

### Maintaining PRISM
```bash
# Check system health
prism doctor

# Check for updates
prism update --check

# Update if available
prism update

# Clean old sessions (>30 days)
prism session clean 30
```

## 🐛 Troubleshooting

### Common Issues

**Command not found:**
```bash
# Add to PATH manually
export PATH="$HOME/bin:$PATH"

# Or use full path
~/bin/prism --help
```

**Permission denied:**
```bash
# Fix permissions
chmod +x ~/bin/prism
```

**Configuration issues:**
```bash
# Reset configuration
prism config reset

# Or run diagnostics
prism doctor --fix
```

**Update failures:**
```bash
# Force update
prism update --force

# Or reinstall
curl -fsSL https://raw.githubusercontent.com/afiffattouh/hildens-prism/main/install.sh | bash
```

## 📚 Documentation

- [Installation Guide](docs/INSTALL.md) - Detailed installation instructions
- [User Manual](docs/MANUAL.md) - Complete user guide
- [API Reference](docs/API.md) - Technical API documentation
- [Security Policy](SECURITY.md) - Security information
- [Contributing Guide](CONTRIBUTING.md) - How to contribute
- [Changelog](CHANGELOG.md) - Version history

## 🤝 Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

### How to Contribute
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🔗 Links

- [GitHub Repository](https://github.com/afiffattouh/hildens-prism)
- [Issue Tracker](https://github.com/afiffattouh/hildens-prism/issues)
- [Discussions](https://github.com/afiffattouh/hildens-prism/discussions)
- [Releases](https://github.com/afiffattouh/hildens-prism/releases)

## 🙏 Acknowledgments

PRISM is designed specifically for Claude Code, enhancing AI-assisted development with persistent context and professional tooling.

---

**PRISM v2.0** - Enterprise-grade context management for AI development

*For support, please open an issue on GitHub or start a discussion.*