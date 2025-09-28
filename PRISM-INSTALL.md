# PRISM Framework - Installation Guide

**PRISM**: Persistent Real-time Intelligent System Management for Claude Code

## 🚀 Quick Install (One Command)

### For macOS/Linux:
```bash
curl -sSL https://raw.githubusercontent.com/afiffattouh/hildens-prism/main/install-prism.sh | bash
```

### Alternative (if you prefer wget):
```bash
wget -qO- https://raw.githubusercontent.com/afiffattouh/hildens-prism/main/install-prism.sh | bash
```

## 📦 What Gets Installed

The installer creates:
- `~/.claude/` - Claude Code configuration directory
- `~/.claude/PRISM.md` - Main PRISM framework
- `~/.claude/CLAUDE.md` - Claude entry point
- `~/.claude/prism-init.sh` - Project initialization script
- `~/.claude/prism` - Command-line tool

## 🎯 Using PRISM

### 1. After Installation, Add to PATH:
```bash
# Add to your .bashrc, .zshrc, or shell config:
export PATH="$PATH:$HOME/.claude"
```

### 2. Initialize PRISM in Any Project:
```bash
cd your-project
prism init
```

Or without PATH:
```bash
cd your-project
~/.claude/prism-init.sh
```

## 📁 What PRISM Creates in Your Project

```
your-project/
├── .prism/
│   ├── context/         # Persistent memory
│   │   ├── architecture.md
│   │   ├── patterns.md
│   │   ├── decisions.md
│   │   └── domain.md
│   ├── sessions/        # Session tracking
│   └── references/      # Documentation
└── PRISM.md            # Project config
```

## 🔧 Manual Installation

If you prefer manual installation:

1. **Create Claude directory:**
```bash
mkdir -p ~/.claude
```

2. **Download PRISM files:**
```bash
cd ~/.claude
curl -O https://raw.githubusercontent.com/afiffattouh/hildens-prism/main/.claude/PRISM.md
curl -O https://raw.githubusercontent.com/afiffattouh/hildens-prism/main/.claude/CLAUDE.md
curl -O https://raw.githubusercontent.com/afiffattouh/hildens-prism/main/prism-init.sh
chmod +x prism-init.sh
```

3. **Add to PATH:**
```bash
export PATH="$PATH:$HOME/.claude"
```

## 💡 Features

- **Persistent Context**: Maintains memory across Claude Code sessions
- **Project Intelligence**: Learns and applies patterns
- **Time Synchronization**: Real-time awareness via WebSearch
- **Decision Tracking**: Logs all technical decisions
- **Security Standards**: Built-in OWASP compliance
- **Quality Gates**: Automated validation

## 🤝 Sharing PRISM

To share PRISM with your team:

1. **Send them this one-liner:**
```bash
curl -sSL https://raw.githubusercontent.com/afiffattouh/hildens-prism/main/install-prism.sh | bash
```

2. **Or share this guide:**
```
https://github.com/afiffattouh/hildens-prism/blob/main/PRISM-INSTALL.md
```

## 📝 Requirements

- **OS**: macOS, Linux, WSL on Windows
- **Tools**: curl or wget
- **Claude Code**: Any version

## 🔄 Updating PRISM

To update to the latest version:
```bash
prism update
```

Or manually:
```bash
~/.claude/prism-update.sh
```

## 🆘 Troubleshooting

### Command not found?
Add to PATH:
```bash
echo 'export PATH="$PATH:$HOME/.claude"' >> ~/.bashrc
source ~/.bashrc
```

### Permission denied?
```bash
chmod +x ~/.claude/prism-init.sh
chmod +x ~/.claude/prism
```

### Already installed?
The installer will detect and offer to update.

## 📚 Documentation

After installation, full documentation is available at:
- `~/.claude/PRISM.md` - Complete framework documentation
- `~/.claude/CLAUDE.md` - Claude Code configuration

## 🐛 Support

- **Issues**: https://github.com/afiffattouh/hildens-prism/issues
- **Updates**: https://github.com/afiffattouh/hildens-prism

---

**PRISM Framework** - Enhancing Claude Code with persistent intelligence