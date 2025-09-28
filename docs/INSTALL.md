# PRISM Installation Guide

## Requirements

### System Requirements
- **OS**: macOS, Linux, WSL2 (Windows)
- **Shell**: Bash 4.0+
- **Tools**: curl, git
- **Permissions**: Write access to home directory

### Prerequisites
- Claude Code installed and configured
- Git for version control
- Internet connection for downloads

## Installation Methods

### 1. Secure Installation (Recommended)

The secure installer verifies checksums and validates the download:

```bash
# Download installer
curl -fsSL https://raw.githubusercontent.com/afiffattouh/hildens-prism/main/install-secure.sh -o install.sh

# Review the script (always recommended)
cat install.sh

# Run installation
bash install.sh
```

### 2. Manual Installation

For maximum control, install manually:

```bash
# Clone repository
git clone https://github.com/afiffattouh/hildens-prism.git
cd hildens-prism

# Run installer
./install-secure.sh
```

### 3. Development Installation

For contributors and developers:

```bash
# Fork and clone your fork
git clone https://github.com/YOUR-USERNAME/hildens-prism.git
cd hildens-prism

# Install with dev mode
./install-secure.sh --dev

# Link for development
./install-secure.sh --link
```

## Installation Options

```bash
./install-secure.sh [OPTIONS]

Options:
  --force         Overwrite existing installation
  --dev           Install development dependencies
  --link          Create symlinks instead of copying
  --prefix PATH   Custom installation directory
  --no-claude     Skip Claude Code integration
  --help          Show help message
```

## Post-Installation

### Verify Installation

```bash
# Check installation
prism doctor

# View version
prism version

# Get help
prism help
```

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
./install-secure.sh --force
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
# Fix permissions
chmod +x install-secure.sh
chmod +x bin/prism
```

#### Command Not Found
```bash
# Add to PATH
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

#### Installation Fails
```bash
# Run diagnostics
./install-secure.sh --debug

# Check requirements
which bash curl git
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
version: 2.0.0

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