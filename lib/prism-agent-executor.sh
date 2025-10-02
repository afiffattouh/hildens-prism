#!/bin/bash
# PRISM Agent Executor with Claude Code Tool Integration
# Implements tool-based agent execution following Anthropic's Claude Agent SDK principles

# Source guard - prevent multiple sourcing
if [[ -n "${_PRISM_PRISM_AGENT_EXECUTOR_LOADED:-}" ]]; then
    return 0
fi
readonly _PRISM_PRISM_AGENT_EXECUTOR_LOADED=1


# Source dependencies
source "$(dirname "${BASH_SOURCE[0]}")/prism-log.sh"
source "$(dirname "${BASH_SOURCE[0]}")/prism-agents.sh"
source "$(dirname "${BASH_SOURCE[0]}")/prism-resource-management.sh"
source "$(dirname "${BASH_SOURCE[0]}")/prism-agent-prompts.sh"

# Agent tool capabilities (what tools each agent can use)
# Using function for Bash 3.x compatibility (no associative arrays)
get_agent_tools() {
    local agent_type="$1"
    case "$agent_type" in
        architect) echo "Read Glob Grep" ;;
        coder) echo "Read Write Edit Bash Glob Grep" ;;
        tester) echo "Read Bash Glob" ;;
        reviewer) echo "Read Glob Grep" ;;
        documenter) echo "Read Write Edit" ;;
        security) echo "Read Bash Glob Grep" ;;
        performance) echo "Read Bash Glob" ;;
        refactorer) echo "Read Write Edit Glob Grep" ;;
        debugger) echo "Read Bash Glob Grep" ;;
        planner) echo "Read Glob Grep" ;;
        sparc) echo "Read Write Edit Bash Glob Grep" ;;
        *) echo "Read" ;;  # Default: Read only
    esac
}

# Agent workflows (gather context → take action → verify work → repeat)
execute_agent_with_workflow() {
    local agent_id="$1"
    local timeout="${2:-$DEFAULT_AGENT_TIMEOUT}"
    local agent_dir=".prism/agents/active/$agent_id"

    if [[ ! -d "$agent_dir" ]]; then
        log_error "Agent not found: $agent_id"
        return 1
    fi

    # Validate resources before execution
    if ! validate_resources "agent"; then
        log_error "Resource limits exceeded, cannot execute agent"
        update_agent_state "$agent_id" "failed"
        return 1
    fi

    # Increment active agent counter
    increment_agent_count

    # Set up cleanup trap
    trap "cleanup_on_exit '$agent_id'" EXIT INT TERM

    log_info "Executing agent workflow: $agent_id (timeout: ${timeout}s)"

    # Update state to working
    update_agent_state "$agent_id" "working"

    # Phase 1: Gather Context
    if ! gather_agent_context "$agent_id"; then
        log_error "Failed to gather context for $agent_id"
        update_agent_state "$agent_id" "failed"
        return 1
    fi

    # Phase 2: Take Action (via Claude Code)
    if ! execute_agent_action "$agent_id"; then
        log_error "Failed to execute action for $agent_id"
        update_agent_state "$agent_id" "failed"
        return 1
    fi

    # Phase 3: Verify Work
    if ! verify_agent_work "$agent_id"; then
        log_warning "Verification failed for $agent_id, attempting refinement"

        # Phase 4: Repeat (if verification fails)
        if ! refine_and_retry "$agent_id"; then
            log_error "Agent failed after refinement: $agent_id"
            update_agent_state "$agent_id" "failed"
            return 1
        fi
    fi

    # Success
    update_agent_state "$agent_id" "completed"
    decrement_agent_count
    log_success "Agent completed successfully: $agent_id"

    # Clear trap
    trap - EXIT INT TERM

    return 0
}

# Phase 1: Gather Context
gather_agent_context() {
    local agent_id="$1"
    local agent_dir=".prism/agents/active/$agent_id"

    log_info "[$agent_id] Gathering context..."

    # Read agent config
    local agent_type=$(grep "^type:" "$agent_dir/config.yaml" | awk '{print $2}')

    # Load agent-specific context files
    local context_content=""
    local context_files=()

    case "$agent_type" in
        architect)
            context_files=(".prism/context/architecture.md" ".prism/context/patterns.md" ".prism/context/decisions.md")
            ;;
        coder)
            context_files=(".prism/context/patterns.md")
            ;;
        tester)
            context_files=(".prism/context/patterns.md")
            ;;
        security)
            context_files=(".prism/context/security.md" ".prism/context/patterns.md")
            ;;
        performance)
            context_files=(".prism/context/performance.md" ".prism/context/patterns.md")
            ;;
        reviewer)
            context_files=(".prism/context/patterns.md" ".prism/context/security.md")
            ;;
        documenter)
            context_files=(".prism/context/patterns.md")
            ;;
        refactorer)
            context_files=(".prism/context/patterns.md")
            ;;
        debugger)
            context_files=(".prism/context/patterns.md")
            ;;
        planner)
            context_files=(".prism/context/patterns.md" ".prism/context/architecture.md")
            ;;
        sparc)
            # Load all context files for SPARC
            if [[ -d ".prism/context" ]]; then
                for file in .prism/context/*.md; do
                    if [[ -f "$file" ]]; then
                        context_files+=("$file")
                    fi
                done
            fi
            ;;
        *)
            log_warning "Unknown agent type: $agent_type, loading default context"
            context_files=(".prism/context/patterns.md")
            ;;
    esac

    # Load files with existence checking
    for file in "${context_files[@]}"; do
        if [[ -f "$file" ]]; then
            context_content="${context_content}$(cat "$file")"$'\n\n'
        else
            log_warning "[$agent_id] Context file not found: $file"
        fi
    done

    # Save gathered context
    echo "$context_content" > "$agent_dir/context.txt"

    log_info "[$agent_id] Context gathered ($(wc -l < "$agent_dir/context.txt") lines)"
    return 0
}

# Phase 2: Take Action (generates prompt for Claude Code)
execute_agent_action() {
    local agent_id="$1"
    local agent_dir=".prism/agents/active/$agent_id"

    log_info "[$agent_id] Executing action..."

    # Read agent config
    local agent_type=$(grep "^type:" "$agent_dir/config.yaml" | awk '{print $2}')
    local task=$(grep "^task:" "$agent_dir/config.yaml" | cut -d' ' -f2-)
    local tools="$(get_agent_tools "$agent_type")"

    # Load context
    local context=""
    if [[ -f "$agent_dir/context.txt" ]]; then
        context="$(cat "$agent_dir/context.txt")"
    fi

    # Generate enhanced agent-specific prompt using the new prompt system
    log_info "[$agent_id] Generating enhanced ${agent_type} agent prompt..."
    generate_agent_prompt "$agent_type" "$task" "$tools" "$context" > "$agent_dir/action_prompt.md"

    log_info "[$agent_id] Enhanced action prompt generated at $agent_dir/action_prompt.md"
    log_info "[$agent_id] USER ACTION REQUIRED: Execute this agent via Claude Code"
    log_info "[$agent_id] Copy the prompt from $agent_dir/action_prompt.md and use Claude Code to execute"

    # In a full implementation, this would trigger Claude Code's Task tool
    # For now, we generate the enhanced prompt for manual execution

    return 0
}

# Phase 3: Verify Work
verify_agent_work() {
    local agent_id="$1"
    local agent_dir=".prism/agents/active/$agent_id"

    log_info "[$agent_id] Verifying work..."

    # Check if results exist
    if [[ ! -f "$agent_dir/results.md" ]]; then
        log_warning "[$agent_id] No results file found, verification skipped"
        return 1
    fi

    # Basic verification checks
    local verification_passed=true

    # 1. Check for common quality issues
    if grep -qi "TODO\|FIXME\|HACK" "$agent_dir/results.md"; then
        log_warning "[$agent_id] Found TODO/FIXME/HACK markers in results"
        verification_passed=false
    fi

    # 2. Check for error indicators
    if grep -qi "error\|failed\|exception" "$agent_dir/results.md"; then
        log_warning "[$agent_id] Found error indicators in results"
        verification_passed=false
    fi

    # 3. Check minimum content
    local result_lines=$(wc -l < "$agent_dir/results.md")
    if [[ $result_lines -lt 5 ]]; then
        log_warning "[$agent_id] Results too short ($result_lines lines), may be incomplete"
        verification_passed=false
    fi

    if $verification_passed; then
        log_success "[$agent_id] Verification passed"
        echo "PASSED" > "$agent_dir/verification_status.txt"
        return 0
    else
        log_warning "[$agent_id] Verification failed"
        echo "FAILED" > "$agent_dir/verification_status.txt"
        return 1
    fi
}

# Phase 4: Refine and Retry
refine_and_retry() {
    local agent_id="$1"
    local agent_dir=".prism/agents/active/$agent_id"

    log_info "[$agent_id] Refining and retrying..."

    # Check retry count
    local retry_count=0
    if [[ -f "$agent_dir/retry_count.txt" ]]; then
        retry_count=$(cat "$agent_dir/retry_count.txt")
    fi

    if [[ $retry_count -ge 3 ]]; then
        log_error "[$agent_id] Maximum retries (3) exceeded"
        return 1
    fi

    # Increment retry count
    echo $((retry_count + 1)) > "$agent_dir/retry_count.txt"

    # Add refinement instructions to prompt
    cat >> "$agent_dir/action_prompt.md" << EOF

## Refinement (Attempt $((retry_count + 2)))

Previous attempt had issues. Please address:

$(cat "$agent_dir/verification_status.txt" 2>/dev/null || echo "Quality concerns detected")

Focus on:
- Completeness of solution
- Code quality and error handling
- Following established patterns
- Clear documentation

Retry with these improvements.
EOF

    log_info "[$agent_id] Refinement prompt updated, retry attempt $((retry_count + 1))"

    # Re-execute
    execute_agent_action "$agent_id"

    return 0
}

# Helper: Update agent state
update_agent_state() {
    local agent_id="$1"
    local new_state="$2"
    local agent_dir=".prism/agents/active/$agent_id"

    if [[ -f "$agent_dir/config.yaml" ]]; then
        sed -i.bak "s/^state: .*/state: $new_state/" "$agent_dir/config.yaml"
        rm -f "$agent_dir/config.yaml.bak"
        log_info "[$agent_id] State updated to: $new_state"
    fi
}

# Export functions
export -f execute_agent_with_workflow
export -f gather_agent_context
export -f execute_agent_action
export -f verify_agent_work
export -f refine_and_retry
export -f update_agent_state
