#!/bin/bash
# PRISM Agent Executor with Claude Code Tool Integration
# Implements tool-based agent execution following Anthropic's Claude Agent SDK principles

# Source dependencies
source "$(dirname "${BASH_SOURCE[0]}")/prism-log.sh"
source "$(dirname "${BASH_SOURCE[0]}")/prism-agents.sh"

# Agent tool capabilities (what tools each agent can use)
declare -A AGENT_TOOL_PERMISSIONS=(
    ["architect"]="Read Glob Grep"
    ["coder"]="Read Write Edit Bash Glob Grep"
    ["tester"]="Read Bash Glob"
    ["reviewer"]="Read Glob Grep"
    ["documenter"]="Read Write Edit"
    ["security"]="Read Bash Glob Grep"
    ["performance"]="Read Bash Glob"
    ["refactorer"]="Read Write Edit Glob Grep"
    ["debugger"]="Read Bash Glob Grep"
    ["planner"]="Read Glob Grep"
    ["sparc"]="Read Write Edit Bash Glob Grep"
)

# Agent workflows (gather context → take action → verify work → repeat)
execute_agent_with_workflow() {
    local agent_id="$1"
    local agent_dir=".prism/agents/active/$agent_id"

    if [[ ! -d "$agent_dir" ]]; then
        log_error "Agent not found: $agent_id"
        return 1
    fi

    log_info "Executing agent workflow: $agent_id"

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
    log_success "Agent completed successfully: $agent_id"
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
    case "$agent_type" in
        architect)
            context_content=$(cat .prism/context/{architecture,patterns,decisions}.md 2>/dev/null || echo "")
            ;;
        coder)
            context_content=$(cat .prism/context/patterns.md 2>/dev/null || echo "")
            ;;
        tester)
            context_content=$(cat .prism/context/patterns.md 2>/dev/null || echo "")
            ;;
        security)
            context_content=$(cat .prism/context/{security,patterns}.md 2>/dev/null || echo "")
            ;;
        performance)
            context_content=$(cat .prism/context/{performance,patterns}.md 2>/dev/null || echo "")
            ;;
        reviewer)
            context_content=$(cat .prism/context/{patterns,security}.md 2>/dev/null || echo "")
            ;;
        documenter)
            context_content=$(cat .prism/context/patterns.md 2>/dev/null || echo "")
            ;;
        refactorer)
            context_content=$(cat .prism/context/patterns.md 2>/dev/null || echo "")
            ;;
        debugger)
            context_content=$(cat .prism/context/patterns.md 2>/dev/null || echo "")
            ;;
        planner)
            context_content=$(cat .prism/context/{patterns,architecture}.md 2>/dev/null || echo "")
            ;;
        sparc)
            context_content=$(cat .prism/context/*.md 2>/dev/null || echo "")
            ;;
        *)
            log_warning "Unknown agent type: $agent_type, loading default context"
            context_content=$(cat .prism/context/patterns.md 2>/dev/null || echo "")
            ;;
    esac

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
    local tools="${AGENT_TOOL_PERMISSIONS[$agent_type]}"

    # Generate Claude Code prompt
    cat > "$agent_dir/action_prompt.md" << EOF
# PRISM Agent: ${agent_type^}

You are a specialized ${agent_type} agent executing a focused task.

## Task
${task}

## Context
$(cat "$agent_dir/context.txt" 2>/dev/null)

## Available Tools
You have access to these Claude Code tools:
${tools}

## Workflow (Anthropic Agent SDK Pattern)
1. **Analyze**: Understand the task and context fully
2. **Plan**: Break down into specific actions
3. **Execute**: Use tools to complete the task
4. **Validate**: Ensure quality and correctness
5. **Document**: Update relevant files

## Quality Standards
- Follow patterns from context
- Maintain consistency with existing code
- Include error handling
- Add tests where applicable
- Update documentation

## Output
Save all work to:
- Code: Appropriate project files
- Results: ${agent_dir}/results.md
- Logs: ${agent_dir}/execution.log

Execute this task systematically using the available tools.
EOF

    log_info "[$agent_id] Action prompt generated at $agent_dir/action_prompt.md"
    log_info "[$agent_id] USER ACTION REQUIRED: Execute this agent via Claude Code"
    log_info "[$agent_id] Copy the prompt from $agent_dir/action_prompt.md and use Claude Code to execute"

    # In a full implementation, this would trigger Claude Code's Task tool
    # For now, we generate the prompt for manual execution

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
