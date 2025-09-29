#!/bin/bash
# PRISM Update Library - Auto-update functionality


# Dependencies are loaded by the main script
# If running standalone, source them
if [[ -z "${PRISM_VERSION:-}" ]]; then
    source "$(dirname "${BASH_SOURCE[0]}")/prism-core.sh"
    source "$(dirname "${BASH_SOURCE[0]}")/prism-log.sh"
    source "$(dirname "${BASH_SOURCE[0]}")/prism-security.sh"
fi

# Update configuration
readonly UPDATE_REPO="https://github.com/afiffattouh/hildens-prism"
readonly UPDATE_BRANCH="main"
readonly VERSION_URL="https://raw.githubusercontent.com/afiffattouh/hildens-prism/${UPDATE_BRANCH}/VERSION"
readonly INSTALLER_URL="https://raw.githubusercontent.com/afiffattouh/hildens-prism/${UPDATE_BRANCH}/install.sh"

# Get current version
get_current_version() {
    # Always prefer VERSION file over constant
    if [[ -f "$PRISM_HOME/VERSION" ]]; then
        local version=$(cat "$PRISM_HOME/VERSION" | tr -d '[:space:]')
        if [[ -n "$version" ]]; then
            echo "$version"
            return 0
        fi
    fi
    # Fallback to constant
    echo "${PRISM_VERSION:-2.0.6}"
}

# Get remote version
get_remote_version() {
    local remote_version
    if remote_version=$(curl -fsSL "$VERSION_URL" 2>/dev/null); then
        echo "$remote_version" | tr -d '[:space:]'
    else
        return 1
    fi
}

# Compare versions (basic comparison)
compare_versions() {
    local current=$1
    local remote=$2

    # Remove 'v' prefix if present
    current=${current#v}
    remote=${remote#v}

    if [[ "$current" == "$remote" ]]; then
        return 0  # Same version
    fi

    # Simple string comparison (works for semantic versioning)
    # Returns 1 if remote is newer
    if [[ "$remote" > "$current" ]]; then
        return 1
    else
        return 2  # Current is newer (shouldn't happen unless developing)
    fi
}

# Backup current installation
backup_installation() {
    local backup_dir="$PRISM_HOME.backup.$(date +%Y%m%d_%H%M%S)"

    log_info "Backing up current installation to $backup_dir"

    if cp -r "$PRISM_HOME" "$backup_dir"; then
        log_info "✅ Backup created successfully"
        echo "$backup_dir"
        return 0
    else
        log_error "Failed to create backup"
        return 1
    fi
}

# Perform update
perform_update() {
    local force=$1
    local temp_dir=$(mktemp -d)
    local backup_dir=""

    # Cleanup on exit
    trap "rm -rf $temp_dir" EXIT

    log_info "Downloading latest version..."

    # Clone the repository
    if ! git clone --depth 1 --branch "$UPDATE_BRANCH" "$UPDATE_REPO" "$temp_dir/prism" &>/dev/null; then
        log_error "Failed to download update"
        return 1
    fi

    # Create backup unless forced
    if [[ "$force" != "true" ]]; then
        backup_dir=$(backup_installation)
        if [[ $? -ne 0 ]]; then
            log_error "Update aborted - backup failed"
            return 1
        fi
    fi

    log_info "Installing update..."

    # Update library files
    if [[ -d "$temp_dir/prism/lib" ]]; then
        cp -r "$temp_dir/prism/lib"/* "$PRISM_HOME/lib/" 2>/dev/null || true
        log_info "✅ Libraries updated"
    fi

    # Update binary
    if [[ -f "$temp_dir/prism/bin/prism" ]]; then
        cp "$temp_dir/prism/bin/prism" "$HOME/bin/prism"
        chmod +x "$HOME/bin/prism"

        # Fix paths in binary
        if [[ "$(uname)" == "Darwin" ]]; then
            sed -i '' "s|PRISM_ROOT=\"\$(dirname \"\$SCRIPT_DIR\")\"|PRISM_ROOT=\"$PRISM_HOME\"|g" "$HOME/bin/prism"
        else
            sed -i "s|PRISM_ROOT=\"\$(dirname \"\$SCRIPT_DIR\")\"|PRISM_ROOT=\"$PRISM_HOME\"|g" "$HOME/bin/prism"
        fi

        log_info "✅ Binary updated"
    fi

    # Update documentation
    if [[ -d "$temp_dir/prism/docs" ]]; then
        cp -r "$temp_dir/prism/docs"/* "$PRISM_HOME/docs/" 2>/dev/null || true
        log_info "✅ Documentation updated"
    fi

    # Update VERSION file
    if [[ -f "$temp_dir/prism/VERSION" ]]; then
        cp "$temp_dir/prism/VERSION" "$PRISM_HOME/VERSION"
    fi

    # Update README
    if [[ -f "$temp_dir/prism/README.md" ]]; then
        cp "$temp_dir/prism/README.md" "$PRISM_HOME/README.md"
    fi

    log_info "✅ Update completed successfully!"

    # Show what's new
    if [[ -f "$temp_dir/prism/CHANGELOG.md" ]]; then
        log_info ""
        log_info "What's new:"
        head -20 "$temp_dir/prism/CHANGELOG.md" 2>/dev/null || true
    fi

    if [[ -n "$backup_dir" ]]; then
        log_info ""
        log_info "Previous version backed up to: $backup_dir"
        log_info "To restore: rm -rf $PRISM_HOME && mv $backup_dir $PRISM_HOME"
    fi

    return 0
}

# Main update function
prism_update() {
    local check_only=${1:-false}
    local force=${2:-false}
    local beta=${3:-false}

    log_info "Checking for updates..."

    # Get current version from VERSION file or fallback
    local current_version
    if [[ -f "$PRISM_HOME/VERSION" ]]; then
        current_version=$(cat "$PRISM_HOME/VERSION" | tr -d '[:space:]')
    else
        current_version="${PRISM_VERSION:-2.0.6}"
    fi
    log_info "Current version: $current_version"

    # Get remote version
    local remote_version=$(get_remote_version)
    if [[ $? -ne 0 ]]; then
        log_error "Failed to check remote version"
        log_info "Please check your internet connection"
        return 1
    fi

    log_info "Latest version: $remote_version"

    # Compare versions
    local comparison
    compare_versions "$current_version" "$remote_version" && comparison=$? || comparison=$?

    log_debug "Version comparison result: $comparison"

    case $comparison in
        0)
            log_info "✅ You are running the latest version"
            return 0
            ;;
        1)
            log_info "🆕 Update available: $current_version → $remote_version"

            if [[ "$check_only" == "true" ]]; then
                log_info "Run 'prism update' to install the update"
                return 0
            fi

            # Confirm update unless forced
            if [[ "$force" != "true" ]]; then
                echo ""
                read -p "Do you want to update now? (y/N): " -n 1 -r
                echo ""
                if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                    log_info "Update cancelled"
                    return 0
                fi
            fi

            # Perform update
            perform_update "$force"
            return $?
            ;;
        2)
            log_warn "Your version ($current_version) is newer than remote ($remote_version)"
            log_info "This might happen if you're running a development version"
            return 0
            ;;
    esac
}

# Rollback to backup
prism_rollback() {
    local backup_dir=$1

    if [[ -z "$backup_dir" ]] || [[ ! -d "$backup_dir" ]]; then
        log_error "Invalid backup directory"
        return 1
    fi

    log_info "Rolling back to $backup_dir..."

    # Remove current installation
    rm -rf "$PRISM_HOME"

    # Restore backup
    if mv "$backup_dir" "$PRISM_HOME"; then
        log_info "✅ Rollback completed successfully"
        return 0
    else
        log_error "Rollback failed"
        return 1
    fi
}