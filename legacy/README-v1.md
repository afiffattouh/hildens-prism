# PRISM Framework v2.0 - Production-Ready Release

> **Secure, modular, and professionally architected AI context management for Claude Code**

## 🔒 Security-First Installation

### Method 1: Secure Verified Installation (Recommended)
```bash
# Download installer and verify before execution
curl -fsSL https://raw.githubusercontent.com/afiffattouh/hildens-prism/v2/install-secure.sh -o install-prism.sh
curl -fsSL https://raw.githubusercontent.com/afiffattouh/hildens-prism/v2/checksums.txt -o checksums.txt

# Verify checksum
sha256sum -c checksums.txt --ignore-missing

# Review script (optional but recommended)
less install-prism.sh

# Run installer
bash install-prism.sh
```

### Method 2: Quick Installation (Less Secure)
```bash
# For development environments only
curl -fsSL https://raw.githubusercontent.com/afiffattouh/hildens-prism/v2/install-secure.sh | bash
```

## 🎯 What's New in v2.0

### Security Enhancements
- ✅ **Checksum verification** for all downloads
- ✅ **Input sanitization** to prevent injection attacks
- ✅ **Secure file operations** with atomic writes
- ✅ **GPG signature support** (optional)
- ✅ **No more curl | bash** by default

### Architecture Improvements
- ✅ **Modular library system** for maintainability
- ✅ **Comprehensive error handling** with recovery
- ✅ **Unified CLI interface** with subcommands
- ✅ **Structured logging** with rotation
- ✅ **Platform compatibility** (macOS, Linux, WSL)

### New Features
- ✅ **`prism doctor`** - Diagnostic and repair tool
- ✅ **`prism config`** - Configuration management
- ✅ **`prism update`** - Safe framework updates
- ✅ **Atomic operations** - No partial installations
- ✅ **Progress indicators** - Better user feedback

## 📦 Installation

### Prerequisites
- Bash 4.0+
- curl or wget
- git (recommended)
- sha256sum or shasum (for verification)

### Installation Steps

1. **Download and verify installer:**
```bash
curl -fsSL https://raw.githubusercontent.com/afiffattouh/hildens-prism/v2/install-secure.sh -o install-prism.sh
sha256sum install-prism.sh  # Compare with published checksum
```

2. **Run installer:**
```bash
bash install-prism.sh
```

3. **Add to PATH:**
```bash
export PATH="$PATH:$HOME/.claude/bin"
echo 'export PATH="$PATH:$HOME/.claude/bin"' >> ~/.bashrc
```

4. **Verify installation:**
```bash
prism doctor
```

## 🚀 Quick Start

### Initialize a New Project
```bash
cd your-project
prism init
```

### Use Templates
```bash
prism init --template nodejs   # Node.js project
prism init --template python   # Python project
prism init --minimal          # Minimal setup
```

### Manage Context
```bash
prism context show patterns       # View patterns file
prism context add patterns "New pattern"  # Add to patterns
prism context search "auth"       # Search in context
```

### Manage Sessions
```bash
prism session start              # Start new session
prism session status             # Check status
prism session archive            # Archive current
prism session restore <id>       # Restore session
```

## 🔧 CLI Commands

### Core Commands
| Command | Description |
|---------|-------------|
| `prism init` | Initialize PRISM in current directory |
| `prism context` | Manage context files |
| `prism session` | Manage sessions |
| `prism config` | Configure settings |
| `prism update` | Update framework |
| `prism doctor` | Run diagnostics |

### Context Management
```bash
prism context show <file>        # Display context file
prism context add <file> <text>  # Add to context
prism context update <file>      # Update context
prism context list              # List all files
prism context search <query>    # Search context
```

### Configuration
```bash
prism config get <key>          # Get config value
prism config set <key> <value>  # Set config value
prism config list              # List all config
prism config reset             # Reset to defaults
```

### Diagnostics
```bash
prism doctor                    # Run full diagnostic
prism doctor --fix             # Apply automatic fixes
prism doctor --verbose         # Detailed output
```

## 🏗️ Architecture

### Directory Structure
```
~/.claude/
├── bin/
│   └── prism              # Main CLI executable
├── lib/
│   ├── prism-core.sh      # Core functions
│   ├── prism-security.sh  # Security utilities
│   ├── prism-log.sh       # Logging system
│   ├── prism-doctor.sh    # Diagnostics
│   └── ...                # Other modules
├── config/
│   └── config.yaml        # Configuration
└── logs/
    └── prism.log         # Application logs
```

### Project Structure
```
your-project/
├── .prism/
│   ├── context/          # Persistent context
│   ├── sessions/         # Session management
│   └── references/       # Documentation
├── CLAUDE.md            # Claude Code instructions
└── PRISM.md            # Project configuration
```

## 🔒 Security Features

### Input Validation
- All user inputs sanitized
- Path traversal prevention
- Command injection protection
- URL validation

### Secure Downloads
- Checksum verification
- Optional GPG signatures
- HTTPS enforcement
- Progress indication

### File Operations
- Atomic writes
- Automatic backups
- Permission checks
- Lock files for concurrency

## 📊 Diagnostics

### Health Checks
```bash
# Run comprehensive diagnostics
prism doctor

# Check specific component
prism doctor --component installation
prism doctor --component security
prism doctor --component permissions
```

### Common Issues and Fixes

| Issue | Fix |
|-------|-----|
| Command not found | Add `~/.claude/bin` to PATH |
| Permission denied | Run `chmod +x ~/.claude/bin/prism` |
| Missing dependencies | Install required tools (curl, git) |
| Outdated version | Run `prism update` |

## 🔄 Updating

### Check for Updates
```bash
prism update --check
```

### Install Updates
```bash
prism update          # Stable releases only
prism update --beta   # Include beta versions
prism update --force  # Force reinstall
```

## 🧪 Testing

### Run Tests
```bash
cd tests
bash run_tests.sh
```

### Test Coverage
- Unit tests for all core functions
- Integration tests for CLI commands
- Security tests for input validation
- Performance benchmarks

## 🤝 Contributing

### Development Setup
```bash
git clone https://github.com/afiffattouh/hildens-prism.git
cd hildens-prism
./dev-setup.sh
```

### Code Standards
- Shellcheck compliance
- Consistent error handling
- Comprehensive logging
- Security-first design

## 📝 License

MIT License - See LICENSE file for details

## 🔗 Links

- **Repository**: [github.com/afiffattouh/hildens-prism](https://github.com/afiffattouh/hildens-prism)
- **Issues**: [Report bugs](https://github.com/afiffattouh/hildens-prism/issues)
- **Discussions**: [Community forum](https://github.com/afiffattouh/hildens-prism/discussions)

## ⚠️ Migration from v1.x

If upgrading from v1.x:

1. **Backup existing installation:**
```bash
cp -r ~/.claude ~/.claude.backup
```

2. **Run migration:**
```bash
prism migrate --from v1
```

3. **Verify migration:**
```bash
prism doctor
```

## 🎉 What's Next

### Roadmap
- [ ] Python/Go implementation (v3.0)
- [ ] Plugin system
- [ ] Team collaboration features
- [ ] Cloud synchronization
- [ ] IDE extensions

---

**PRISM v2.0** - Production-ready, secure, and professionally architected