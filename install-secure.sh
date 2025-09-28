#!/bin/bash
# PRISM Framework Secure Installer
# Version: 2.0.1
# DEPRECATED: This installer requires GitHub releases which are not yet available
# Please use install.sh instead:
# curl -fsSL https://raw.githubusercontent.com/afiffattouh/hildens-prism/main/install.sh | bash

set -euo pipefail
IFS=$'\n\t'

# Configuration
readonly INSTALLER_VERSION="2.0.1"
readonly PRISM_REPO="https://github.com/afiffattouh/hildens-prism"
readonly PRISM_HOME="${PRISM_HOME:-$HOME/.claude}"
readonly TEMP_DIR=$(mktemp -d)

# Colors (with NO_COLOR support)
if [[ "${NO_COLOR:-}" != "1" ]] && [[ -t 1 ]]; then
    readonly RED='\033[0;31m'
    readonly GREEN='\033[0;32m'
    readonly YELLOW='\033[1;33m'
    readonly BLUE='\033[0;34m'
    readonly BOLD='\033[1m'
    readonly NC='\033[0m'
else
    readonly RED=''
    readonly GREEN=''
    readonly YELLOW=''
    readonly BLUE=''
    readonly BOLD=''
    readonly NC=''
fi

# Cleanup on exit
cleanup() {
    local exit_code=$?
    if [[ -d "$TEMP_DIR" ]]; then
        rm -rf "$TEMP_DIR"
    fi
    exit $exit_code
}
trap cleanup EXIT

# Error handler
error_handler() {
    local line_no=$1
    echo -e "${RED}Error on line $line_no${NC}"
    cleanup
    exit 1
}
trap 'error_handler $LINENO' ERR

# Print header
print_header() {
    echo -e "${BOLD}${BLUE}╔═══════════════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}${BLUE}║      PRISM Framework Secure Installer v${INSTALLER_VERSION}      ║${NC}"
    echo -e "${BOLD}${BLUE}║   Persistent Real-time Intelligent System Management ║${NC}"
    echo -e "${BOLD}${BLUE}╚═══════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Check dependencies
check_dependencies() {
    echo -e "${BLUE}Checking dependencies...${NC}"

    local missing=()
    local required=(curl git tar)

    for cmd in "${required[@]}"; do
        if ! command -v "$cmd" &> /dev/null; then
            missing+=("$cmd")
        fi
    done

    if [[ ${#missing[@]} -gt 0 ]]; then
        echo -e "${RED}Missing required commands: ${missing[*]}${NC}"
        echo -e "${YELLOW}Please install them and try again.${NC}"
        exit 1
    fi

    echo -e "${GREEN}✓ All dependencies satisfied${NC}"
}

# Download with progress
download_file() {
    local url=$1
    local output=$2
    local description=${3:-"file"}

    echo -e "${BLUE}Downloading ${description}...${NC}"

    if ! curl -fsSL --progress-bar "$url" -o "$output"; then
        echo -e "${RED}Failed to download: $url${NC}"
        return 1
    fi

    echo -e "${GREEN}✓ Downloaded ${description}${NC}"
}

# Verify checksum
verify_checksum() {
    local file=$1
    local expected_hash=$2

    echo -e "${BLUE}Verifying checksum...${NC}"

    local actual_hash
    if command -v sha256sum &> /dev/null; then
        actual_hash=$(sha256sum "$file" | cut -d' ' -f1)
    elif command -v shasum &> /dev/null; then
        actual_hash=$(shasum -a 256 "$file" | cut -d' ' -f1)
    else
        echo -e "${YELLOW}⚠ Cannot verify checksum (no sha256sum or shasum)${NC}"
        return 0
    fi

    if [[ "$actual_hash" != "$expected_hash" ]]; then
        echo -e "${RED}✗ Checksum verification failed${NC}"
        echo -e "${RED}Expected: $expected_hash${NC}"
        echo -e "${RED}Got:      $actual_hash${NC}"
        return 1
    fi

    echo -e "${GREEN}✓ Checksum verified${NC}"
}

# Download and verify release
download_release() {
    local version=${1:-latest}

    echo -e "${BLUE}Fetching release information...${NC}"

    # Get release info
    local release_url="${PRISM_REPO}/releases/${version}"
    if [[ "$version" == "latest" ]]; then
        release_url="${PRISM_REPO}/releases/latest"
    fi

    # Download release tarball
    local tarball_url="${PRISM_REPO}/archive/refs/tags/v${INSTALLER_VERSION}.tar.gz"
    local tarball_path="${TEMP_DIR}/prism.tar.gz"

    download_file "$tarball_url" "$tarball_path" "PRISM v${INSTALLER_VERSION}"

    # Download checksums if available
    local checksums_url="${PRISM_REPO}/releases/download/v${INSTALLER_VERSION}/checksums.txt"
    local checksums_path="${TEMP_DIR}/checksums.txt"

    if curl -fsSL --head "$checksums_url" &> /dev/null; then
        download_file "$checksums_url" "$checksums_path" "checksums"

        # Verify tarball checksum
        local expected_hash=$(grep "prism.tar.gz" "$checksums_path" | cut -d' ' -f1)
        if [[ -n "$expected_hash" ]]; then
            verify_checksum "$tarball_path" "$expected_hash"
        fi
    else
        echo -e "${YELLOW}⚠ No checksums available for verification${NC}"
    fi

    # Extract tarball
    echo -e "${BLUE}Extracting files...${NC}"
    tar -xzf "$tarball_path" -C "$TEMP_DIR"
    echo -e "${GREEN}✓ Files extracted${NC}"
}

# Install files
install_files() {
    echo -e "${BLUE}Installing PRISM framework...${NC}"

    # Create PRISM home
    mkdir -p "$PRISM_HOME"

    # Find extracted directory
    local source_dir=$(find "$TEMP_DIR" -name "hildens-prism-*" -type d | head -1)
    if [[ -z "$source_dir" ]]; then
        source_dir="$TEMP_DIR"
    fi

    # Copy files
    for dir in lib bin config; do
        if [[ -d "$source_dir/$dir" ]]; then
            cp -r "$source_dir/$dir" "$PRISM_HOME/"
            echo -e "${GREEN}✓ Installed $dir${NC}"
        fi
    done

    # Copy individual files
    for file in README.md PRISM.md LICENSE; do
        if [[ -f "$source_dir/$file" ]]; then
            cp "$source_dir/$file" "$PRISM_HOME/"
        fi
    done

    # Make scripts executable
    chmod +x "$PRISM_HOME"/bin/* 2>/dev/null || true

    echo -e "${GREEN}✓ PRISM framework installed${NC}"
}

# Configure PATH
configure_path() {
    echo -e "${BLUE}Configuring PATH...${NC}"

    local shell_rc=""
    local shell_name=""

    # Detect shell
    if [[ -n "${BASH_VERSION:-}" ]]; then
        shell_rc="$HOME/.bashrc"
        shell_name="bash"
    elif [[ -n "${ZSH_VERSION:-}" ]]; then
        shell_rc="$HOME/.zshrc"
        shell_name="zsh"
    else
        shell_rc="$HOME/.profile"
        shell_name="sh"
    fi

    # Check if already in PATH
    if [[ ":$PATH:" != *":$PRISM_HOME/bin:"* ]]; then
        echo "" >> "$shell_rc"
        echo "# PRISM Framework" >> "$shell_rc"
        echo "export PATH=\"\$PATH:$PRISM_HOME/bin\"" >> "$shell_rc"
        echo "export PRISM_HOME=\"$PRISM_HOME\"" >> "$shell_rc"

        echo -e "${GREEN}✓ Added PRISM to PATH in $shell_rc${NC}"
        echo -e "${YELLOW}Note: Run 'source $shell_rc' to update current session${NC}"
    else
        echo -e "${GREEN}✓ PRISM already in PATH${NC}"
    fi
}

# Verify installation
verify_installation() {
    echo -e "${BLUE}Verifying installation...${NC}"

    local errors=0

    # Check directories
    for dir in lib bin; do
        if [[ ! -d "$PRISM_HOME/$dir" ]]; then
            echo -e "${RED}✗ Missing directory: $dir${NC}"
            ((errors++))
        else
            echo -e "${GREEN}✓ Found directory: $dir${NC}"
        fi
    done

    # Check executable
    if [[ ! -x "$PRISM_HOME/bin/prism" ]]; then
        echo -e "${RED}✗ prism command not executable${NC}"
        ((errors++))
    else
        echo -e "${GREEN}✓ prism command is executable${NC}"
    fi

    # Check libraries
    for lib in prism-core.sh prism-log.sh prism-security.sh; do
        if [[ ! -f "$PRISM_HOME/lib/$lib" ]]; then
            echo -e "${RED}✗ Missing library: $lib${NC}"
            ((errors++))
        else
            echo -e "${GREEN}✓ Found library: $lib${NC}"
        fi
    done

    if [[ $errors -eq 0 ]]; then
        echo -e "${GREEN}✓ Installation verified successfully${NC}"
        return 0
    else
        echo -e "${RED}✗ Installation verification failed with $errors errors${NC}"
        return 1
    fi
}

# Show next steps
show_next_steps() {
    echo ""
    echo -e "${BOLD}${GREEN}╔═══════════════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}${GREEN}║        PRISM Framework Installed Successfully!       ║${NC}"
    echo -e "${BOLD}${GREEN}╚═══════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${BLUE}Installation Location:${NC} $PRISM_HOME"
    echo ""
    echo -e "${YELLOW}Next Steps:${NC}"
    echo -e "  1. ${BOLD}Reload your shell:${NC}"
    echo -e "     source ~/.bashrc  # or ~/.zshrc"
    echo ""
    echo -e "  2. ${BOLD}Initialize PRISM in a project:${NC}"
    echo -e "     cd your-project"
    echo -e "     prism init"
    echo ""
    echo -e "  3. ${BOLD}Verify installation:${NC}"
    echo -e "     prism doctor"
    echo ""
    echo -e "${BLUE}Documentation:${NC} https://github.com/afiffattouh/hildens-prism"
    echo -e "${BLUE}Support:${NC} https://github.com/afiffattouh/hildens-prism/issues"
}

# Main installation
main() {
    print_header

    # Check if already installed
    if [[ -d "$PRISM_HOME/bin" ]] && [[ -f "$PRISM_HOME/bin/prism" ]]; then
        echo -e "${YELLOW}PRISM appears to be already installed.${NC}"
        echo -n "Do you want to reinstall/update? (y/n) "
        read -r response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            echo -e "${BLUE}Installation cancelled.${NC}"
            exit 0
        fi
    fi

    # Run installation steps
    check_dependencies
    download_release "latest"
    install_files
    configure_path
    verify_installation
    show_next_steps
}

# Run installer
main "$@"