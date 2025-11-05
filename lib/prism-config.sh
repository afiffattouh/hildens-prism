#!/bin/bash
# PRISM Configuration Management Library

# Source guard
if [[ -n "${_PRISM_CONFIG_SH_LOADED:-}" ]]; then
    return 0
fi
readonly _PRISM_CONFIG_SH_LOADED=1

# Source dependencies
if [[ -z "${PRISM_VERSION:-}" ]]; then
    source "$(dirname "${BASH_SOURCE[0]}")/prism-core.sh"
    source "$(dirname "${BASH_SOURCE[0]}")/prism-log.sh"
fi

# Configuration file location
readonly PRISM_CONFIG_FILE="${PRISM_HOME}/config/prism.conf"
readonly PRISM_CONFIG_DIR="${PRISM_HOME}/config"

# Initialize configuration system
init_config() {
    mkdir -p "$PRISM_CONFIG_DIR"

    # Create default config if it doesn't exist
    if [[ ! -f "$PRISM_CONFIG_FILE" ]]; then
        cat > "$PRISM_CONFIG_FILE" << 'EOF'
# PRISM Configuration File
# Edit this file to customize PRISM behavior

# Logging
LOG_LEVEL=INFO
LOG_TO_FILE=true
LOG_TO_STDOUT=true

# TOON Integration
PRISM_TOON_ENABLED=true
PRISM_TOON_AGENTS=true
PRISM_TOON_CONTEXT=true
PRISM_TOON_SESSION=true
PRISM_TOON_DEBUG=false

# Agent System
PRISM_AGENT_TIMEOUT=300
PRISM_MAX_AGENTS=10

# Session Management
PRISM_SESSION_AUTO_ARCHIVE=true
PRISM_SESSION_MAX_AGE=30

# Performance
PRISM_CACHE_ENABLED=true
PRISM_CACHE_TTL=3600

# Security
PRISM_STRICT_MODE=true
PRISM_VERIFY_SCRIPTS=true
EOF
        log_info "Created default configuration: $PRISM_CONFIG_FILE"
    fi
}

# Get configuration value
# Usage: prism_config_get <key>
prism_config_get() {
    local key="$1"

    if [[ -z "$key" ]]; then
        log_error "Usage: config get <key>"
        return 1
    fi

    # Initialize if needed
    init_config

    # Check if key exists in config file
    if grep -q "^${key}=" "$PRISM_CONFIG_FILE" 2>/dev/null; then
        grep "^${key}=" "$PRISM_CONFIG_FILE" | head -1 | cut -d'=' -f2-
        return 0
    fi

    # Check environment variable
    if [[ -n "${!key}" ]]; then
        echo "${!key}"
        return 0
    fi

    log_warn "Configuration key not found: $key"
    return 1
}

# Set configuration value
# Usage: prism_config_set <key> <value>
prism_config_set() {
    local key="$1"
    local value="$2"

    if [[ -z "$key" ]] || [[ -z "$value" ]]; then
        log_error "Usage: config set <key> <value>"
        return 1
    fi

    # Initialize if needed
    init_config

    # Update or add key
    if grep -q "^${key}=" "$PRISM_CONFIG_FILE" 2>/dev/null; then
        # Update existing key (macOS and Linux compatible)
        if [[ "$(uname)" == "Darwin" ]]; then
            sed -i '' "s|^${key}=.*|${key}=${value}|" "$PRISM_CONFIG_FILE"
        else
            sed -i "s|^${key}=.*|${key}=${value}|" "$PRISM_CONFIG_FILE"
        fi
        log_info "Updated configuration: ${key}=${value}"
    else
        # Add new key
        echo "${key}=${value}" >> "$PRISM_CONFIG_FILE"
        log_info "Added configuration: ${key}=${value}"
    fi

    return 0
}

# List all configuration
prism_config_list() {
    # Initialize if needed
    init_config

    log_info "Current PRISM Configuration:"
    log_info "=============================="
    log_info ""
    log_info "Configuration file: $PRISM_CONFIG_FILE"
    log_info ""

    # Display config file contents (skip comments and empty lines)
    while IFS= read -r line; do
        if [[ ! "$line" =~ ^# ]] && [[ -n "$line" ]]; then
            log_info "  $line"
        fi
    done < "$PRISM_CONFIG_FILE"

    log_info ""
    log_info "Environment overrides:"

    # Show environment variables that override config
    local override_found=false
    while IFS= read -r line; do
        if [[ "$line" =~ ^([A-Z_]+)= ]]; then
            local key="${BASH_REMATCH[1]}"
            if [[ -n "${!key}" ]]; then
                log_info "  ${key}=${!key} (from environment)"
                override_found=true
            fi
        fi
    done < "$PRISM_CONFIG_FILE"

    if [[ "$override_found" == "false" ]]; then
        log_info "  (none)"
    fi
}

# Reset configuration to defaults
prism_config_reset() {
    log_warn "This will reset all configuration to defaults"
    echo -n "Are you sure? (y/N): "
    read -r response

    if [[ "$response" =~ ^[Yy]$ ]]; then
        rm -f "$PRISM_CONFIG_FILE"
        init_config
        log_info "✅ Configuration reset to defaults"
    else
        log_info "Configuration reset cancelled"
    fi
}

# Edit configuration file
prism_config_edit() {
    init_config

    local editor="${EDITOR:-${VISUAL:-nano}}"

    if command -v "$editor" &>/dev/null; then
        "$editor" "$PRISM_CONFIG_FILE"
        log_info "Configuration file updated"
    else
        log_error "No editor found. Set EDITOR environment variable or use 'config set' command"
        log_info "Configuration file location: $PRISM_CONFIG_FILE"
        return 1
    fi
}

# Validate configuration
prism_config_validate() {
    init_config

    log_info "Validating configuration..."

    local errors=0

    # Check required keys
    local required_keys=("LOG_LEVEL" "PRISM_TOON_ENABLED")
    for key in "${required_keys[@]}"; do
        if ! prism_config_get "$key" >/dev/null 2>&1; then
            log_error "Missing required configuration: $key"
            ((errors++))
        fi
    done

    # Validate LOG_LEVEL
    local log_level=$(prism_config_get "LOG_LEVEL" 2>/dev/null)
    if [[ -n "$log_level" ]]; then
        case "$log_level" in
            TRACE|DEBUG|INFO|WARN|ERROR|FATAL)
                ;;
            *)
                log_error "Invalid LOG_LEVEL: $log_level (must be TRACE|DEBUG|INFO|WARN|ERROR|FATAL)"
                ((errors++))
                ;;
        esac
    fi

    # Validate boolean values
    local bool_keys=("LOG_TO_FILE" "LOG_TO_STDOUT" "PRISM_TOON_ENABLED" "PRISM_CACHE_ENABLED")
    for key in "${bool_keys[@]}"; do
        local value=$(prism_config_get "$key" 2>/dev/null)
        if [[ -n "$value" ]]; then
            case "$value" in
                true|false)
                    ;;
                *)
                    log_error "Invalid boolean value for $key: $value (must be true|false)"
                    ((errors++))
                    ;;
            esac
        fi
    done

    if [[ $errors -eq 0 ]]; then
        log_info "✅ Configuration is valid"
        return 0
    else
        log_error "❌ Configuration has $errors error(s)"
        return 1
    fi
}

# Export functions
export -f init_config
export -f prism_config_get
export -f prism_config_set
export -f prism_config_list
export -f prism_config_reset
export -f prism_config_edit
export -f prism_config_validate
