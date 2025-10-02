#!/bin/bash
# PRISM Maintenance and Cleanup Utility
# Automated maintenance tasks for PRISM framework

set -e

# Source PRISM libraries
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$SCRIPT_DIR/../lib"

source "$LIB_DIR/prism-log.sh"
source "$LIB_DIR/prism-resource-management.sh"

# Configuration
readonly INTERACTIVE="${PRISM_MAINTENANCE_INTERACTIVE:-true}"
readonly DRY_RUN="${PRISM_MAINTENANCE_DRY_RUN:-false}"

# Display banner
show_banner() {
    echo "╔════════════════════════════════════════════════════════╗"
    echo "║        PRISM Framework Maintenance Utility            ║"
    echo "╚════════════════════════════════════════════════════════╝"
    echo ""
}

# Display usage
show_usage() {
    cat << EOF
Usage: $0 [command] [options]

Commands:
    status      - Show current resource usage and statistics
    cleanup     - Clean up old agents and data (default: 7 days)
    optimize    - Optimize disk usage and file structure
    reset       - Reset resource counters
    validate    - Validate PRISM installation
    full        - Run full maintenance (cleanup + optimize)

Options:
    --dry-run   - Show what would be done without making changes
    --yes       - Skip confirmation prompts
    --days N    - Set cleanup retention period (default: 7)
    --help      - Show this help message

Examples:
    $0 status
    $0 cleanup --days 3
    $0 full --dry-run
    $0 optimize --yes

EOF
}

# Confirm action
confirm() {
    local message="$1"

    if [[ "$INTERACTIVE" == "false" ]]; then
        return 0
    fi

    echo -n "$message (y/N): "
    read -r response
    [[ "$response" =~ ^[Yy]$ ]]
}

# Show resource status
cmd_status() {
    log_info "Collecting resource status..."
    echo ""

    # Initialize if needed
    [[ -d ".prism/resources" ]] || init_resource_management

    # Get status
    get_resource_status
    echo ""

    # Additional statistics
    echo "=== Storage Statistics ==="

    if [[ -d ".prism" ]]; then
        local total_size=$(du -sh .prism 2>/dev/null | awk '{print $1}')
        echo "Total .prism size: $total_size"

        local agent_count=$(find .prism/agents/active -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')
        local completed_count=$(find .prism/agents/completed -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')
        echo "Active agents: $agent_count"
        echo "Completed agents: $completed_count"

        local log_count=$(find .prism/agents/logs -type f 2>/dev/null | wc -l | tr -d ' ')
        echo "Log files: $log_count"

        local result_count=$(find .prism/agents/results -type f 2>/dev/null | wc -l | tr -d ' ')
        echo "Result files: $result_count"
    fi

    echo ""
}

# Cleanup old data
cmd_cleanup() {
    local retention_days="${1:-$CLEANUP_RETENTION_DAYS}"

    log_info "Starting cleanup (retention: $retention_days days)"

    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "DRY RUN MODE - No changes will be made"
    fi

    # Count items to clean
    local agents_to_clean=0
    local logs_to_clean=0
    local results_to_clean=0

    if [[ -d ".prism/agents/completed" ]]; then
        agents_to_clean=$(find .prism/agents/completed -mindepth 1 -maxdepth 1 -type d -mtime +$retention_days 2>/dev/null | wc -l | tr -d ' ')
    fi

    if [[ -d ".prism/agents/logs" ]]; then
        logs_to_clean=$(find .prism/agents/logs -type f -name "*.log" -mtime +$retention_days 2>/dev/null | wc -l | tr -d ' ')
    fi

    if [[ -d ".prism/agents/results" ]]; then
        results_to_clean=$(find .prism/agents/results -type f -mtime +$retention_days 2>/dev/null | wc -l | tr -d ' ')
    fi

    echo ""
    echo "Items to clean:"
    echo "  Completed agents: $agents_to_clean"
    echo "  Log files: $logs_to_clean"
    echo "  Result files: $results_to_clean"
    echo ""

    if [[ $agents_to_clean -eq 0 ]] && [[ $logs_to_clean -eq 0 ]] && [[ $results_to_clean -eq 0 ]]; then
        log_info "Nothing to clean up"
        return 0
    fi

    if ! confirm "Proceed with cleanup?"; then
        log_info "Cleanup cancelled"
        return 0
    fi

    if [[ "$DRY_RUN" == "false" ]]; then
        auto_cleanup "$retention_days"
        log_success "Cleanup completed"
    else
        log_info "Dry run completed - no changes made"
    fi
}

# Optimize disk usage
cmd_optimize() {
    log_info "Starting optimization..."

    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "DRY RUN MODE - No changes will be made"
    fi

    local optimizations_made=0

    # Remove empty directories
    echo ""
    echo "Checking for empty directories..."
    local empty_dirs=$(find .prism -type d -empty 2>/dev/null | wc -l | tr -d ' ')

    if [[ $empty_dirs -gt 0 ]]; then
        echo "Found $empty_dirs empty directories"

        if [[ "$DRY_RUN" == "false" ]] && confirm "Remove empty directories?"; then
            find .prism -type d -empty -delete 2>/dev/null
            optimizations_made=$((optimizations_made + 1))
            log_success "Removed empty directories"
        fi
    else
        echo "No empty directories found"
    fi

    # Remove duplicate result files
    echo ""
    echo "Checking for duplicate files..."

    # Consolidate logs
    if [[ -d ".prism/agents/logs" ]]; then
        local log_size=$(du -sh .prism/agents/logs 2>/dev/null | awk '{print $1}')
        echo "Current log directory size: $log_size"

        if confirm "Compress old log files?"; then
            if [[ "$DRY_RUN" == "false" ]]; then
                # Find logs older than 7 days and compress them
                find .prism/agents/logs -type f -name "*.log" -mtime +7 ! -name "*.gz" -exec gzip {} \; 2>/dev/null
                optimizations_made=$((optimizations_made + 1))
                local new_size=$(du -sh .prism/agents/logs 2>/dev/null | awk '{print $1}')
                log_success "Compressed old logs (new size: $new_size)"
            fi
        fi
    fi

    # Optimize registry files
    echo ""
    echo "Optimizing registry files..."
    if [[ -f ".prism/agents/registry/agents.list" ]]; then
        local registry_lines=$(wc -l < .prism/agents/registry/agents.list)
        echo "Registry entries: $registry_lines"

        if [[ $registry_lines -gt 1000 ]]; then
            if [[ "$DRY_RUN" == "false" ]] && confirm "Clean up old registry entries?"; then
                # Keep only last 1000 entries
                tail -1000 .prism/agents/registry/agents.list > .prism/agents/registry/agents.list.tmp
                mv .prism/agents/registry/agents.list.tmp .prism/agents/registry/agents.list
                optimizations_made=$((optimizations_made + 1))
                log_success "Optimized registry file"
            fi
        fi
    fi

    echo ""
    if [[ $optimizations_made -gt 0 ]]; then
        log_success "Optimization completed: $optimizations_made improvements made"
    else
        log_info "No optimizations needed"
    fi
}

# Reset resource counters
cmd_reset() {
    log_warning "Resetting resource counters..."

    if ! confirm "This will reset all active agent/swarm counters. Continue?"; then
        log_info "Reset cancelled"
        return 0
    fi

    if [[ "$DRY_RUN" == "false" ]]; then
        init_resource_management
        log_success "Resource counters reset"
    else
        log_info "Dry run - counters not reset"
    fi
}

# Validate PRISM installation
cmd_validate() {
    log_info "Validating PRISM installation..."
    echo ""

    local errors=0
    local warnings=0

    # Check required directories
    echo "Checking directory structure..."
    local required_dirs=(
        ".prism"
        ".prism/context"
        ".prism/agents"
        ".prism/agents/active"
        ".prism/agents/completed"
        ".prism/agents/logs"
        ".prism/agents/results"
        ".prism/agents/registry"
        ".prism/agents/swarms"
        ".prism/resources"
    )

    for dir in "${required_dirs[@]}"; do
        if [[ -d "$dir" ]]; then
            echo "  ✓ $dir"
        else
            echo "  ✗ $dir (missing)"
            ((warnings++))
        fi
    done

    # Check required library files
    echo ""
    echo "Checking library files..."
    local required_libs=(
        "lib/prism-log.sh"
        "lib/prism-agents.sh"
        "lib/prism-agent-executor.sh"
        "lib/prism-verification.sh"
        "lib/prism-swarms.sh"
        "lib/prism-resource-management.sh"
    )

    for lib in "${required_libs[@]}"; do
        if [[ -f "$lib" ]]; then
            if bash -n "$lib" 2>/dev/null; then
                echo "  ✓ $lib (syntax OK)"
            else
                echo "  ✗ $lib (syntax error)"
                ((errors++))
            fi
        else
            echo "  ✗ $lib (missing)"
            ((errors++))
        fi
    done

    # Check resource limits
    echo ""
    echo "Checking resource configuration..."
    echo "  Max agents: $MAX_CONCURRENT_AGENTS"
    echo "  Max swarms: $MAX_CONCURRENT_SWARMS"
    echo "  Max disk usage: ${MAX_DISK_USAGE_MB}MB"
    echo "  Retention: ${CLEANUP_RETENTION_DAYS} days"

    # Summary
    echo ""
    if [[ $errors -eq 0 ]] && [[ $warnings -eq 0 ]]; then
        log_success "Validation passed - PRISM installation is healthy"
        return 0
    elif [[ $errors -eq 0 ]]; then
        log_warning "Validation completed with $warnings warning(s)"
        return 0
    else
        log_error "Validation failed with $errors error(s) and $warnings warning(s)"
        return 1
    fi
}

# Full maintenance
cmd_full() {
    log_info "Running full maintenance..."
    echo ""

    cmd_status
    echo ""
    cmd_cleanup
    echo ""
    cmd_optimize
    echo ""
    cmd_validate
}

# Main command dispatcher
main() {
    local command="${1:-status}"
    shift || true

    # Parse options
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            --yes)
                INTERACTIVE=false
                shift
                ;;
            --days)
                CLEANUP_RETENTION_DAYS="$2"
                shift 2
                ;;
            --help)
                show_usage
                exit 0
                ;;
            *)
                shift
                ;;
        esac
    done

    show_banner

    case "$command" in
        status)
            cmd_status
            ;;
        cleanup)
            cmd_cleanup "${CLEANUP_RETENTION_DAYS}"
            ;;
        optimize)
            cmd_optimize
            ;;
        reset)
            cmd_reset
            ;;
        validate)
            cmd_validate
            ;;
        full)
            cmd_full
            ;;
        help|--help)
            show_usage
            ;;
        *)
            log_error "Unknown command: $command"
            echo ""
            show_usage
            exit 1
            ;;
    esac
}

main "$@"
