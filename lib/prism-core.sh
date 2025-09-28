#!/bin/bash
# PRISM Core Library - Foundation functions for PRISM framework

# Strict error handling
set -euo pipefail
IFS=$'\n\t'

# Core configuration
readonly PRISM_HOME="${PRISM_HOME:-$HOME/.prism}"

# Read version from VERSION file
if [[ -f "$PRISM_HOME/VERSION" ]]; then
    readonly PRISM_VERSION="$(cat "$PRISM_HOME/VERSION" | tr -d '[:space:]')"
elif [[ -f "$(dirname "${BASH_SOURCE[0]}")/../VERSION" ]]; then
    # Fallback to local VERSION file during development
    readonly PRISM_VERSION="$(cat "$(dirname "${BASH_SOURCE[0]}")/../VERSION" | tr -d '[:space:]')"
else
    # Ultimate fallback
    readonly PRISM_VERSION="2.0.1"
fi
readonly PRISM_CONFIG="${PRISM_CONFIG:-$PRISM_HOME/config.yaml}"
readonly PRISM_LIB="${PRISM_LIB:-$(dirname "${BASH_SOURCE[0]}")}"
readonly PRISM_LOG="${PRISM_LOG:-$PRISM_HOME/prism.log}"
readonly PRISM_REPO="https://github.com/afiffattouh/hildens-prism"

# Colors for output (with NO_COLOR support)
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

# Global error handler
error_handler() {
    local line_no=$1
    local bash_lineno=$2
    local last_command=$3
    local exit_code=$4

    log_error "Error occurred in script: ${BASH_SOURCE[1]}"
    log_error "Line $line_no: Command '$last_command' exited with code $exit_code"

    # Cleanup on error
    cleanup_on_error

    exit "$exit_code"
}

# Set up error trap
trap 'error_handler $LINENO $BASH_LINENO "$BASH_COMMAND" $?' ERR

# Cleanup function (to be overridden by scripts)
cleanup_on_error() {
    log_debug "Performing cleanup after error..."
    # Remove temporary files
    if [[ -n "${TEMP_DIR:-}" ]] && [[ -d "$TEMP_DIR" ]]; then
        rm -rf "$TEMP_DIR"
    fi
}

# Platform detection
detect_platform() {
    case "$OSTYPE" in
        darwin*)  echo "macos" ;;
        linux*)   echo "linux" ;;
        msys*|cygwin*|mingw*) echo "windows" ;;
        freebsd*) echo "freebsd" ;;
        *)        echo "unknown" ;;
    esac
}

# Check if running in CI environment
is_ci() {
    [[ "${CI:-false}" == "true" ]] || \
    [[ -n "${GITHUB_ACTIONS:-}" ]] || \
    [[ -n "${GITLAB_CI:-}" ]] || \
    [[ -n "${CIRCLECI:-}" ]]
}

# Portable date function
get_iso_date() {
    local platform=$(detect_platform)

    case "$platform" in
        macos|freebsd)
            # BSD date
            date -u +"%Y-%m-%dT%H:%M:%SZ"
            ;;
        linux|windows)
            # GNU date
            date -u --iso-8601=seconds | sed 's/+00:00/Z/'
            ;;
        *)
            # Fallback
            date +"%Y-%m-%d %H:%M:%S"
            ;;
    esac
}

# Check required commands
require_command() {
    local cmd=$1
    local package=${2:-$1}

    if ! command -v "$cmd" &> /dev/null; then
        log_error "Required command '$cmd' not found"
        log_info "Please install: $package"
        return 1
    fi
}

# Create directory with proper permissions
create_directory() {
    local dir=$1
    local perms=${2:-755}

    if [[ ! -d "$dir" ]]; then
        mkdir -p "$dir"
        chmod "$perms" "$dir"
        log_debug "Created directory: $dir"
    fi
}

# Safe file operations
safe_copy() {
    local src=$1
    local dst=$2

    # Validate source
    if [[ ! -f "$src" ]]; then
        log_error "Source file not found: $src"
        return 1
    fi

    # Create backup if destination exists
    if [[ -f "$dst" ]]; then
        local backup="${dst}.backup.$(date +%s)"
        cp "$dst" "$backup"
        log_debug "Created backup: $backup"
    fi

    # Copy with preservation
    cp -p "$src" "$dst"
    log_debug "Copied: $src -> $dst"
}

safe_move() {
    local src=$1
    local dst=$2

    # Validate source
    if [[ ! -e "$src" ]]; then
        log_error "Source not found: $src"
        return 1
    fi

    # Create backup if destination exists
    if [[ -e "$dst" ]]; then
        local backup="${dst}.backup.$(date +%s)"
        mv "$dst" "$backup"
        log_debug "Created backup: $backup"
    fi

    # Move
    mv "$src" "$dst"
    log_debug "Moved: $src -> $dst"
}

# Atomic operations
atomic_write() {
    local content=$1
    local target=$2
    local temp_file

    # Create temp file in same directory for atomic move
    temp_file=$(mktemp "${target}.XXXXXX")

    # Write content
    echo "$content" > "$temp_file"

    # Atomic move
    mv -f "$temp_file" "$target"

    log_debug "Atomically wrote to: $target"
}

# File locking for concurrent access
with_lock() {
    local lock_file=$1
    shift
    local command=("$@")

    local lock_acquired=0
    local max_wait=30
    local waited=0

    # Try to acquire lock
    while [[ $waited -lt $max_wait ]]; do
        if mkdir "$lock_file" 2>/dev/null; then
            lock_acquired=1
            break
        fi
        sleep 1
        ((waited++))
    done

    if [[ $lock_acquired -eq 0 ]]; then
        log_error "Failed to acquire lock: $lock_file"
        return 1
    fi

    # Execute command with lock
    local exit_code=0
    "${command[@]}" || exit_code=$?

    # Release lock
    rmdir "$lock_file"

    return $exit_code
}

# Check if running with sufficient permissions
check_permissions() {
    local target=$1

    if [[ -w "$target" ]]; then
        return 0
    else
        log_error "Insufficient permissions for: $target"
        return 1
    fi
}

# Verify system requirements
verify_requirements() {
    local errors=0

    # Check required commands
    local required_commands=(curl git mkdir cp mv rm)
    for cmd in "${required_commands[@]}"; do
        if ! command -v "$cmd" &> /dev/null; then
            log_error "Missing required command: $cmd"
            ((errors++))
        fi
    done

    # Check disk space (require at least 100MB)
    local available_space
    available_space=$(df "$HOME" | awk 'NR==2 {print $4}')
    if [[ $available_space -lt 102400 ]]; then
        log_error "Insufficient disk space: ${available_space}KB available"
        ((errors++))
    fi

    return $errors
}

# Export functions
export -f error_handler
export -f cleanup_on_error
export -f detect_platform
export -f is_ci
export -f get_iso_date
export -f require_command
export -f create_directory
export -f safe_copy
export -f safe_move
export -f atomic_write
export -f with_lock
export -f check_permissions
export -f verify_requirements