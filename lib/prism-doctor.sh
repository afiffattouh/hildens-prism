#!/bin/bash
# PRISM Doctor - Diagnostic and repair functions


# Dependencies are loaded by the main script
# If running standalone, source them
if [[ -z "${PRISM_VERSION:-}" ]]; then
    source "$(dirname "${BASH_SOURCE[0]}")/prism-core.sh"
    source "$(dirname "${BASH_SOURCE[0]}")/prism-log.sh"
    source "$(dirname "${BASH_SOURCE[0]}")/prism-security.sh"
fi

# Diagnostic results
# Use regular arrays for compatibility with bash 3.x
declare -a DIAGNOSTIC_KEYS
declare -a DIAGNOSTIC_VALUES
declare -a ISSUES
declare -a FIXES

# Add diagnostic result
add_diagnostic() {
    local category=$1
    local test=$2
    local status=$3
    local message=$4

    # Store in parallel arrays for bash 3.x compatibility
    DIAGNOSTIC_KEYS+=("${category}:${test}")
    DIAGNOSTIC_VALUES+=("$status")

    if [[ "$status" != "OK" ]]; then
        ISSUES+=("[$category] $test: $message")

        # Suggest fix if available
        case "$test" in
            "executable")
                FIXES+=("chmod +x $message")
                ;;
            "missing_file")
                FIXES+=("touch $message")
                ;;
            "missing_dir")
                FIXES+=("mkdir -p $message")
                ;;
            "permissions")
                FIXES+=("chmod 755 $message")
                ;;
        esac
    fi
}

# Check system requirements
check_system_requirements() {
    log_section "System Requirements"

    # Check OS
    local platform=$(detect_platform)
    log_info "Platform: $platform"
    add_diagnostic "system" "platform" "OK" "$platform"

    # Check disk space
    local available_space
    available_space=$(df "$HOME" | awk 'NR==2 {print $4}')
    if [[ $available_space -lt 102400 ]]; then  # 100MB
        add_diagnostic "system" "disk_space" "WARNING" "Only ${available_space}KB available"
    else
        add_diagnostic "system" "disk_space" "OK" "${available_space}KB available"
    fi

    # Check required commands
    local required_commands=(bash curl git mkdir cp mv rm chmod)
    for cmd in "${required_commands[@]}"; do
        if command -v "$cmd" &> /dev/null; then
            add_diagnostic "system" "command_$cmd" "OK" "$cmd found"
        else
            add_diagnostic "system" "command_$cmd" "ERROR" "$cmd not found"
        fi
    done

    # Check optional commands
    local optional_commands=(gpg sha256sum openssl)
    for cmd in "${optional_commands[@]}"; do
        if command -v "$cmd" &> /dev/null; then
            add_diagnostic "system" "optional_$cmd" "OK" "$cmd found"
        else
            add_diagnostic "system" "optional_$cmd" "WARNING" "$cmd not found (optional)"
        fi
    done
}

# Check PRISM installation
check_prism_installation() {
    log_section "PRISM Installation"

    # Check PRISM_HOME
    if [[ -d "$PRISM_HOME" ]]; then
        add_diagnostic "install" "prism_home" "OK" "$PRISM_HOME exists"
    else
        add_diagnostic "install" "prism_home" "ERROR" "$PRISM_HOME not found"
        add_diagnostic "install" "missing_dir" "ERROR" "$PRISM_HOME"
    fi

    # Check directory structure
    local required_dirs=(lib bin config)
    for dir in "${required_dirs[@]}"; do
        if [[ -d "$PRISM_HOME/$dir" ]]; then
            add_diagnostic "install" "dir_$dir" "OK" "$PRISM_HOME/$dir exists"
        else
            add_diagnostic "install" "dir_$dir" "ERROR" "$PRISM_HOME/$dir not found"
            add_diagnostic "install" "missing_dir" "ERROR" "$PRISM_HOME/$dir"
        fi
    done

    # Check core files
    local core_files=(
        "lib/prism-core.sh"
        "lib/prism-log.sh"
        "lib/prism-security.sh"
        "bin/prism"
    )
    for file in "${core_files[@]}"; do
        if [[ -f "$PRISM_HOME/$file" ]]; then
            add_diagnostic "install" "file_$(basename $file)" "OK" "$file exists"

            # Check if executable
            if [[ "$file" == "bin/prism" ]] && [[ ! -x "$PRISM_HOME/$file" ]]; then
                add_diagnostic "install" "executable" "ERROR" "$PRISM_HOME/$file"
            fi
        else
            add_diagnostic "install" "file_$(basename $file)" "ERROR" "$file not found"
            add_diagnostic "install" "missing_file" "ERROR" "$PRISM_HOME/$file"
        fi
    done
}

# Check PATH configuration
check_path_configuration() {
    log_section "PATH Configuration"

    # Check if prism is in PATH
    if [[ ":$PATH:" == *":$PRISM_HOME/bin:"* ]]; then
        add_diagnostic "config" "path" "OK" "PRISM in PATH"
    else
        add_diagnostic "config" "path" "WARNING" "PRISM not in PATH"
        FIXES+=("export PATH=\"\$PATH:$PRISM_HOME/bin\"")
    fi

    # Check if prism command is accessible
    if command -v prism &> /dev/null; then
        add_diagnostic "config" "prism_command" "OK" "prism command accessible"
    else
        add_diagnostic "config" "prism_command" "WARNING" "prism command not found"
    fi
}

# Check project configuration
check_project_configuration() {
    log_section "Project Configuration"

    # Check if in a project directory
    if [[ -d ".prism" ]]; then
        add_diagnostic "project" "initialized" "OK" "PRISM initialized in current directory"

        # Check project structure
        local project_dirs=("context" "sessions" "references")
        for dir in "${project_dirs[@]}"; do
            if [[ -d ".prism/$dir" ]]; then
                add_diagnostic "project" "dir_$dir" "OK" ".prism/$dir exists"
            else
                add_diagnostic "project" "dir_$dir" "WARNING" ".prism/$dir not found"
            fi
        done

        # Check for CLAUDE.md
        if [[ -f "CLAUDE.md" ]]; then
            add_diagnostic "project" "claude_md" "OK" "CLAUDE.md exists"
        else
            add_diagnostic "project" "claude_md" "WARNING" "CLAUDE.md not found"
        fi

        # Check for PRISM.md
        if [[ -f "PRISM.md" ]]; then
            add_diagnostic "project" "prism_md" "OK" "PRISM.md exists"
        else
            add_diagnostic "project" "prism_md" "WARNING" "PRISM.md not found"
        fi
    else
        add_diagnostic "project" "initialized" "INFO" "No PRISM project in current directory"
    fi
}

# Check permissions
check_permissions() {
    log_section "File Permissions"

    # Check PRISM_HOME permissions
    if [[ -w "$PRISM_HOME" ]]; then
        add_diagnostic "permissions" "prism_home_write" "OK" "PRISM_HOME is writable"
    else
        add_diagnostic "permissions" "prism_home_write" "ERROR" "PRISM_HOME not writable"
        add_diagnostic "permissions" "permissions" "ERROR" "$PRISM_HOME"
    fi

    # Check log file permissions
    if [[ -f "$PRISM_LOG" ]]; then
        if [[ -w "$PRISM_LOG" ]]; then
            add_diagnostic "permissions" "log_write" "OK" "Log file is writable"
        else
            add_diagnostic "permissions" "log_write" "WARNING" "Log file not writable"
        fi
    fi

    # Check executable permissions
    if [[ -f "$PRISM_HOME/bin/prism" ]]; then
        if [[ -x "$PRISM_HOME/bin/prism" ]]; then
            add_diagnostic "permissions" "prism_exec" "OK" "prism is executable"
        else
            add_diagnostic "permissions" "prism_exec" "ERROR" "prism not executable"
            add_diagnostic "permissions" "executable" "ERROR" "$PRISM_HOME/bin/prism"
        fi
    fi
}

# Run security scan
run_security_scan() {
    log_section "Security Scan"

    # Check for sensitive data in config
    if [[ -f "$PRISM_CONFIG" ]]; then
        if grep -qE '(password|secret|token|api_key)' "$PRISM_CONFIG" 2>/dev/null; then
            add_diagnostic "security" "sensitive_data" "WARNING" "Potential sensitive data in config"
        else
            add_diagnostic "security" "sensitive_data" "OK" "No sensitive data detected"
        fi
    fi

    # Check file permissions
    local world_writable
    world_writable=$(find "$PRISM_HOME" -type f -perm -002 2>/dev/null | wc -l)
    if [[ $world_writable -gt 0 ]]; then
        add_diagnostic "security" "world_writable" "WARNING" "$world_writable world-writable files"
    else
        add_diagnostic "security" "world_writable" "OK" "No world-writable files"
    fi

    # Check for updates
    add_diagnostic "security" "updates" "INFO" "Run 'prism update --check' to check for updates"
}

# Apply fixes
apply_fixes() {
    if [[ ${#FIXES[@]} -eq 0 ]]; then
        return 0
    fi

    echo ""
    log_warn "Found ${#FIXES[@]} fixable issues"
    echo ""
    echo "Suggested fixes:"
    for fix in "${FIXES[@]}"; do
        echo "  $fix"
    done
    echo ""

    echo -n "Would you like to apply these fixes? (y/n) "
    read -r response

    if [[ "$response" =~ ^[Yy]$ ]]; then
        for fix in "${FIXES[@]}"; do
            log_info "Applying: $fix"
            eval "$fix" || log_warn "Failed to apply: $fix"
        done
        log_info "✅ Fixes applied"
    else
        log_info "Fixes not applied"
    fi
}

# Generate report
generate_report() {
    log_header "Diagnostic Report"

    local total_tests=0
    local passed_tests=0
    local warnings=0
    local errors=0

    # Count results
    for result in "${DIAGNOSTICS[@]}"; do
        ((total_tests++))
        case "$result" in
            "OK")
                ((passed_tests++))
                ;;
            "WARNING")
                ((warnings++))
                ;;
            "ERROR")
                ((errors++))
                ;;
        esac
    done

    # Print summary
    echo ""
    echo -e "${BOLD}Summary:${NC}"
    echo -e "  Total Tests: $total_tests"
    echo -e "  ${GREEN}Passed: $passed_tests${NC}"
    echo -e "  ${YELLOW}Warnings: $warnings${NC}"
    echo -e "  ${RED}Errors: $errors${NC}"
    echo ""

    # Print issues
    if [[ ${#ISSUES[@]} -gt 0 ]]; then
        echo -e "${BOLD}Issues Found:${NC}"
        for issue in "${ISSUES[@]}"; do
            echo -e "  • $issue"
        done
        echo ""
    fi

    # Overall status
    if [[ $errors -eq 0 ]]; then
        if [[ $warnings -eq 0 ]]; then
            echo -e "${GREEN}✅ System is healthy!${NC}"
        else
            echo -e "${YELLOW}⚠ System is functional with warnings${NC}"
        fi
    else
        echo -e "${RED}❌ System has errors that need attention${NC}"
    fi

    return $errors
}

# Main doctor function
prism_doctor() {
    # Clear previous results
    DIAGNOSTICS=()
    ISSUES=()
    FIXES=()

    # Run all checks
    check_system_requirements
    check_prism_installation
    check_path_configuration
    check_project_configuration
    check_permissions
    run_security_scan

    # Generate report
    generate_report
    local exit_code=$?

    # Apply fixes if available
    apply_fixes

    return $exit_code
}

# Export main function
export -f prism_doctor