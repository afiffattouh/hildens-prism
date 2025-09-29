# PRISM Installation Guide

## Requirements

### System Requirements
- **OS**: macOS, Linux, WSL2 (Windows)
- **Shell**: Bash 3.2+ (compatible with macOS default)
- **Tools**: curl, git
- **Permissions**: Write access to home directory

### Prerequisites
- Claude Code installed and configured
- Git for version control
- Internet connection for downloads

## Installation Methods

### 1. Quick Installation (One-Line)

The fastest way to install PRISM:

```bash
# One-line installation
curl -fsSL https://raw.githubusercontent.com/afiffattouh/hildens-prism/main/install.sh | bash
```

### 2. Secure Installation (Recommended)

Download and review the script before running:

```bash
# Download installer
curl -fsSL https://raw.githubusercontent.com/afiffattouh/hildens-prism/main/install.sh -o install.sh

# Review the script (always recommended)
cat install.sh

# Run installation
bash install.sh
```

### 3. Manual Installation

For maximum control, clone and install manually:

```bash
# Clone repository
git clone https://github.com/afiffattouh/hildens-prism.git
cd hildens-prism

# Copy the installer and run
cp install.sh /tmp/
cd /tmp && bash install.sh
```

### 4. Development Installation

For contributors and developers:

```bash
# Fork and clone your fork
git clone https://github.com/YOUR-USERNAME/hildens-prism.git
cd hildens-prism

# Make changes to the code
# Test locally by copying files manually
cp -r lib ~/.prism/
cp bin/prism ~/bin/

# Or use the installer
bash install.sh
```

## What Gets Installed

The installer will:
1. Clone the PRISM repository to a temporary directory
2. Install libraries to `~/.prism/lib/`
3. Install the `prism` command to `~/bin/`
4. Create Claude Code integration at `~/.claude/PRISM.md`
5. Copy documentation to `~/.prism/docs/`
6. Update your PATH if needed

## Post-Installation

### ⚠️ CRITICAL: Enable the `prism` Command

The installer adds `prism` to `~/bin/`, but you **MUST** enable it first:

#### Option 1: Open a New Terminal (Easiest)
Simply close your current terminal and open a new one.

#### Option 2: Reload Your Shell Configuration
```bash
# For macOS (default shell is zsh):
source ~/.zshrc

# For Linux (usually bash):
source ~/.bashrc

# Not sure which shell? Check with:
echo $SHELL
```

#### Option 3: Use Full Path (Temporary)
```bash
# Works immediately without reloading:
~/bin/prism --help
```

### Verify Installation

After enabling the command, verify everything works:

```bash
# Should display help information
prism --help

# Check version
prism version

# Run diagnostics
prism doctor
```

If `prism` is still not found, see [Troubleshooting](#troubleshooting).

### Configure Claude Code

PRISM automatically integrates with Claude Code. Verify with:

```bash
# Check Claude configuration
ls ~/.claude/PRISM.md

# Test in a new project
mkdir test-project && cd test-project
prism init
```

## Updating PRISM

### Automatic Updates

```bash
# Check for updates
prism update --check

# Install updates
prism update
```

### Manual Updates

```bash
cd ~/hildens-prism
git pull origin main
bash install.sh
```

## Uninstallation

### Complete Removal

```bash
# Run uninstaller
prism uninstall --complete

# Or manually
rm -rf ~/.prism
rm -f ~/bin/prism
rm -f ~/.claude/PRISM.md
```

### Keep Configuration

```bash
# Remove binaries only
prism uninstall --keep-config
```

## Troubleshooting

### Common Issues

#### Permission Denied
```bash
# Fix permissions on installer
chmod +x install.sh

# Fix permissions on binary
chmod +x ~/bin/prism
```

#### Command Not Found (Most Common Issue)

This happens when `~/bin` is not in your PATH. Follow these steps:

**Step 1: Check if prism is installed**
```bash
ls -la ~/bin/prism
# Should show the file exists
```

**Step 2: Check your current PATH**
```bash
echo $PATH | grep -q "$HOME/bin" && echo "PATH is OK" || echo "PATH needs updating"
```

**Step 3: Identify your shell**
```bash
echo $SHELL
# Usually shows /bin/zsh (macOS) or /bin/bash (Linux)
```

**Step 4: Update PATH based on your shell**
```bash
# For zsh (macOS default):
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# For bash (Linux default):
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

**Step 5: Verify it works**
```bash
which prism
# Should show: /Users/YOUR_NAME/bin/prism

prism --help
# Should display help
```

**Quick workaround if still having issues:**
```bash
# Use the full path instead
~/bin/prism --help
```

#### Installation Fails
```bash
# Check requirements
which bash curl git

# Try manual installation
git clone https://github.com/afiffattouh/hildens-prism.git
cd hildens-prism
bash install.sh

# Check for errors
echo $?  # Should be 0 for success
```

#### Bash Version Issues
```bash
# Check bash version
bash --version

# If below 3.2, update bash:
# macOS: brew install bash
# Linux: use package manager to update
```

### Platform-Specific

#### macOS
- Ensure Xcode Command Line Tools installed:
  ```bash
  xcode-select --install
  ```

#### Linux
- Install required packages:
  ```bash
  # Ubuntu/Debian
  sudo apt-get update
  sudo apt-get install curl git bash

  # RHEL/CentOS
  sudo yum install curl git bash
  ```

#### Windows (WSL2)
- Use WSL2, not Git Bash or Cygwin
- Ensure WSL2 is fully updated:
  ```bash
  wsl --update
  ```

## Configuration

### Environment Variables

```bash
# Set custom PRISM home
export PRISM_HOME="$HOME/.prism"

# Set log level
export PRISM_LOG_LEVEL="debug"

# Custom configuration
export PRISM_CONFIG="$HOME/.config/prism"
```

### Configuration File

Create `~/.prism/config.yaml`:

```yaml
# PRISM Configuration
version: 2.0.6

# Paths
paths:
  home: ~/.prism
  bin: ~/bin
  logs: ~/.prism/logs

# Features
features:
  auto_update: true
  telemetry: false
  claude_integration: true

# Logging
logging:
  level: info
  file: ~/.prism/prism.log
  rotate: true
  max_size: 10M
```

## Verification

After installation, verify everything works:

```bash
# Run comprehensive check
prism doctor --full

# Expected output:
# ✅ PRISM binary accessible
# ✅ Configuration valid
# ✅ Claude integration active
# ✅ Write permissions OK
# ✅ All dependencies met
```

## Getting Help

- Run `prism help` for command help
- Check `prism doctor` for diagnostics
- Visit [GitHub Issues](https://github.com/afiffattouh/hildens-prism/issues)
- Read the [User Manual](MANUAL.md)

---

For advanced configuration and API documentation, see [API.md](API.md).