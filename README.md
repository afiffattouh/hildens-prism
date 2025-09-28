# PRISM Framework v2.0

> **Secure, modular, and professional AI context management for Claude Code**

[![Version](https://img.shields.io/badge/version-2.0.1-blue.svg)](https://github.com/afiffattouh/hildens-prism)
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
```

## 🎯 What is PRISM?

PRISM (Persistent Real-time Intelligent System Management) enhances Claude Code with:

- 🧠 **Persistent Memory** - Context maintained across sessions
- 🔒 **Security-First** - Input validation, checksums, secure operations
- 📝 **Smart Context** - Automatic pattern learning and application
- ⚡ **Professional CLI** - Clean, modular command interface
- 🔍 **Diagnostics** - Built-in doctor command for troubleshooting

## 📦 Features

### v2.0 Improvements
- ✅ Secure installation with verification
- ✅ Comprehensive error handling
- ✅ Modular architecture
- ✅ Unified CLI interface
- ✅ Diagnostic tools
- ✅ Platform compatibility

## 🛠️ Usage

### Initialize Project
```bash
prism init                    # Standard initialization
prism init --template nodejs  # With template
```

### Manage Context
```bash
prism context show patterns   # View patterns
prism context add patterns "New pattern"
prism context search "query"
```

### Run Diagnostics
```bash
prism doctor                  # Check system health
prism doctor --fix           # Apply automatic fixes
```

## 📁 Structure

```
your-project/
├── .prism/
│   ├── context/            # Persistent knowledge
│   ├── sessions/           # Session management
│   └── references/         # Documentation
├── CLAUDE.md              # Claude instructions
└── PRISM.md              # Configuration
```

## 🔒 Security

- Input sanitization
- Path traversal prevention
- Checksum verification
- Atomic file operations
- Secure download protocol

## 📚 Documentation

- [Installation Guide](docs/INSTALL.md)
- [User Manual](docs/MANUAL.md)
- [API Reference](docs/API.md)
- [Security Policy](SECURITY.md)

## 🤝 Contributing

Contributions welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) first.

## 📄 License

MIT License - see [LICENSE](LICENSE) file.

## 🔗 Links

- [GitHub Repository](https://github.com/afiffattouh/hildens-prism)
- [Issue Tracker](https://github.com/afiffattouh/hildens-prism/issues)
- [Discussions](https://github.com/afiffattouh/hildens-prism/discussions)

---

**PRISM v2.0** - Enterprise-grade context management for AI development