#!/bin/bash
# PRISM Resource Management
# Implements safeguards for timeouts, disk space, and process limits

# Source guard - prevent multiple sourcing
if [[ -n "${_PRISM_RESOURCE_MANAGEMENT_SH_LOADED:-}" ]]; then
    return 0
fi
readonly _PRISM_RESOURCE_MANAGEMENT_SH_LOADED=1

# Source dependencies
source "$(dirname "${BASH_SOURCE[0]}")/prism-log.sh"

# Configuration (can be overridden via environment variables)
readonly DEFAULT_AGENT_TIMEOUT="${PRISM_AGENT_TIMEOUT:-300}"  # 5 minutes
readonly DEFAULT_SWARM_TIMEOUT="${PRISM_SWARM_TIMEOUT:-1800}"  # 30 minutes
readonly MAX_CONCURRENT_AGENTS="${PRISM_MAX_AGENTS:-10}"
readonly MAX_CONCURRENT_SWARMS="${PRISM_MAX_SWARMS:-3}"
readonly MAX_DISK_USAGE_MB="${PRISM_MAX_DISK_MB:-1024}"  # 1GB
readonly CLEANUP_RETENTION_DAYS="${PRISM_RETENTION_DAYS:-7}"

# Resource tracking files
readonly RESOURCE_DIR=".prism/resources"
readonly ACTIVE_AGENTS_FILE="$RESOURCE_DIR/active_agents.count"
readonly ACTIVE_SWARMS_FILE="$RESOURCE_DIR/active_swarms.count"
readonly DISK_USAGE_FILE="$RESOURCE_DIR/disk_usage.txt"

# Initialize resource management
init_resource_management() {
    mkdir -p "$RESOURCE_DIR"
    echo "0" > "$ACTIVE_AGENTS_FILE"
    echo "0" > "$ACTIVE_SWARMS_FILE"
    log_info "Resource management initialized"
}

# Check if agent limit reached
check_agent_limit() {
    local current_count=$(cat "$ACTIVE_AGENTS_FILE" 2>/dev/null || echo 0)

    if [[ $current_count -ge $MAX_CONCURRENT_AGENTS ]]; then
        log_error "Agent limit reached: $current_count/$MAX_CONCURRENT_AGENTS"
        return 1
    fi

    return 0
}

# Check if swarm limit reached
check_swarm_limit() {
    local current_count=$(cat "$ACTIVE_SWARMS_FILE" 2>/dev/null || echo 0)

    if [[ $current_count -ge $MAX_CONCURRENT_SWARMS ]]; then
        log_error "Swarm limit reached: $current_count/$MAX_CONCURRENT_SWARMS"
        return 1
    fi

    return 0
}

# Increment agent counter
increment_agent_count() {
    local current=$(cat "$ACTIVE_AGENTS_FILE" 2>/dev/null || echo 0)
    echo $((current + 1)) > "$ACTIVE_AGENTS_FILE"
    log_debug "Active agents: $((current + 1))"
}

# Decrement agent counter
decrement_agent_count() {
    local current=$(cat "$ACTIVE_AGENTS_FILE" 2>/dev/null || echo 0)
    local new_count=$((current - 1))
    if [[ $new_count -lt 0 ]]; then
        new_count=0
    fi
    echo "$new_count" > "$ACTIVE_AGENTS_FILE"
    log_debug "Active agents: $new_count"
}

# Increment swarm counter
increment_swarm_count() {
    local current=$(cat "$ACTIVE_SWARMS_FILE" 2>/dev/null || echo 0)
    echo $((current + 1)) > "$ACTIVE_SWARMS_FILE"
    log_debug "Active swarms: $((current + 1))"
}

# Decrement swarm counter
decrement_swarm_count() {
    local current=$(cat "$ACTIVE_SWARMS_FILE" 2>/dev/null || echo 0)
    local new_count=$((current - 1))
    if [[ $new_count -lt 0 ]]; then
        new_count=0
    fi
    echo "$new_count" > "$ACTIVE_SWARMS_FILE"
    log_debug "Active swarms: $new_count"
}

# Execute with timeout (Bash 3.x compatible)
execute_with_timeout() {
    local timeout_seconds="$1"
    local agent_id="$2"
    shift 2
    local command="$@"

    log_info "Executing with timeout: ${timeout_seconds}s"

    # Execute command in background
    eval "$command" &
    local pid=$!

    # Monitor timeout
    local elapsed=0
    while [[ $elapsed -lt $timeout_seconds ]]; do
        # Check if process still running
        if ! kill -0 "$pid" 2>/dev/null; then
            # Process completed
            wait "$pid"
            local exit_code=$?
            log_info "Command completed in ${elapsed}s"
            return $exit_code
        fi

        sleep 1
        elapsed=$((elapsed + 1))
    done

    # Timeout reached - kill process
    log_warning "Timeout reached (${timeout_seconds}s) - terminating process $pid"
    kill -TERM "$pid" 2>/dev/null
    sleep 2

    # Force kill if still running
    if kill -0 "$pid" 2>/dev/null; then
        log_error "Process did not terminate gracefully, forcing kill"
        kill -KILL "$pid" 2>/dev/null
    fi

    # Mark agent as failed due to timeout
    if [[ -n "$agent_id" ]] && [[ -d ".prism/agents/active/$agent_id" ]]; then
        echo "TIMEOUT" > ".prism/agents/active/$agent_id/timeout_flag.txt"
    fi

    return 124  # Standard timeout exit code
}

# Check disk usage
check_disk_usage() {
    local prism_dir="${1:-.prism}"

    if [[ ! -d "$prism_dir" ]]; then
        return 0
    fi

    # Get disk usage in MB
    local usage_kb=$(du -sk "$prism_dir" 2>/dev/null | awk '{print $1}')
    local usage_mb=$((usage_kb / 1024))

    # Save current usage
    echo "$usage_mb" > "$DISK_USAGE_FILE"

    log_debug "Disk usage: ${usage_mb}MB / ${MAX_DISK_USAGE_MB}MB"

    if [[ $usage_mb -gt $MAX_DISK_USAGE_MB ]]; then
        log_warning "Disk usage exceeded: ${usage_mb}MB > ${MAX_DISK_USAGE_MB}MB"
        return 1
    fi

    return 0
}

# Automatic cleanup of old data
auto_cleanup() {
    local retention_days="${1:-$CLEANUP_RETENTION_DAYS}"

    log_info "Running automatic cleanup (retention: $retention_days days)"

    local cleaned_count=0

    # Clean up completed agents older than retention period
    if [[ -d ".prism/agents/completed" ]]; then
        while IFS= read -r agent_dir; do
            if [[ -d "$agent_dir" ]]; then
                # Check if older than retention period (using modification time)
                if [[ $(find "$agent_dir" -maxdepth 0 -mtime +$retention_days 2>/dev/null) ]]; then
                    log_debug "Removing old agent: $(basename "$agent_dir")"
                    rm -rf "$agent_dir"
                    cleaned_count=$((cleaned_count + 1))
                fi
            fi
        done < <(find .prism/agents/completed -mindepth 1 -maxdepth 1 -type d 2>/dev/null)
    fi

    # Clean up old log files
    if [[ -d ".prism/agents/logs" ]]; then
        find .prism/agents/logs -type f -name "*.log" -mtime +$retention_days -delete 2>/dev/null
    fi

    # Clean up old result files
    if [[ -d ".prism/agents/results" ]]; then
        find .prism/agents/results -type f -mtime +$retention_days -delete 2>/dev/null
    fi

    # Clean up old swarms
    if [[ -d ".prism/agents/swarms/completed" ]]; then
        find .prism/agents/swarms/completed -mindepth 1 -maxdepth 1 -type d -mtime +$retention_days -exec rm -rf {} \; 2>/dev/null
    fi

    log_info "Cleanup completed: removed $cleaned_count old agents"

    # Check disk usage after cleanup
    check_disk_usage
}

# Force cleanup if disk usage critical
force_cleanup_if_needed() {
    if ! check_disk_usage; then
        log_warning "Disk usage critical - forcing cleanup"
        auto_cleanup 3  # More aggressive: 3 days retention

        if ! check_disk_usage; then
            log_error "Disk usage still critical after cleanup"
            return 1
        fi
    fi

    return 0
}

# Get resource status
get_resource_status() {
    local active_agents=$(cat "$ACTIVE_AGENTS_FILE" 2>/dev/null || echo 0)
    local active_swarms=$(cat "$ACTIVE_SWARMS_FILE" 2>/dev/null || echo 0)
    local disk_usage=$(cat "$DISK_USAGE_FILE" 2>/dev/null || echo 0)

    cat << EOF
=== PRISM Resource Status ===
Active Agents: $active_agents / $MAX_CONCURRENT_AGENTS
Active Swarms: $active_swarms / $MAX_CONCURRENT_SWARMS
Disk Usage: ${disk_usage}MB / ${MAX_DISK_USAGE_MB}MB
Agent Timeout: ${DEFAULT_AGENT_TIMEOUT}s
Swarm Timeout: ${DEFAULT_SWARM_TIMEOUT}s
Retention: ${CLEANUP_RETENTION_DAYS} days
EOF
}

# Cleanup on exit handler
cleanup_on_exit() {
    local agent_id="$1"

    if [[ -n "$agent_id" ]]; then
        decrement_agent_count
        log_debug "Cleanup handler executed for agent: $agent_id"
    fi
}

# Validate resource limits before operation
validate_resources() {
    local operation_type="$1"  # agent or swarm

    # Check appropriate limit
    case "$operation_type" in
        agent)
            check_agent_limit || return 1
            ;;
        swarm)
            check_swarm_limit || return 1
            ;;
    esac

    # Check disk usage
    if ! check_disk_usage; then
        log_warning "Disk usage high - attempting cleanup"
        force_cleanup_if_needed || return 1
    fi

    return 0
}

# Monitor background process with timeout
monitor_background_process() {
    local pid="$1"
    local timeout="$2"
    local identifier="${3:-process}"

    local elapsed=0
    while [[ $elapsed -lt $timeout ]]; do
        if ! kill -0 "$pid" 2>/dev/null; then
            # Process completed
            wait "$pid" 2>/dev/null
            return $?
        fi

        sleep 1
        elapsed=$((elapsed + 1))

        # Log progress every 30 seconds
        if [[ $((elapsed % 30)) -eq 0 ]]; then
            log_debug "$identifier still running (${elapsed}s / ${timeout}s)"
        fi
    done

    # Timeout reached
    log_error "$identifier exceeded timeout (${timeout}s)"
    kill -TERM "$pid" 2>/dev/null
    sleep 2
    kill -KILL "$pid" 2>/dev/null

    return 124
}

# Export functions
export -f init_resource_management
export -f check_agent_limit
export -f check_swarm_limit
export -f increment_agent_count
export -f decrement_agent_count
export -f increment_swarm_count
export -f decrement_swarm_count
export -f execute_with_timeout
export -f check_disk_usage
export -f auto_cleanup
export -f force_cleanup_if_needed
export -f get_resource_status
export -f cleanup_on_exit
export -f validate_resources
export -f monitor_background_process
