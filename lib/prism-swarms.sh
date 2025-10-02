#!/bin/bash
# PRISM Swarm Orchestration
# Implements multi-agent coordination patterns following Anthropic's Claude Agent SDK principles

# Source guard - prevent multiple sourcing
if [[ -n "${_PRISM_PRISM_SWARMS_LOADED:-}" ]]; then
    return 0
fi
readonly _PRISM_PRISM_SWARMS_LOADED=1


# Source dependencies
source "$(dirname "${BASH_SOURCE[0]}")/prism-log.sh"
source "$(dirname "${BASH_SOURCE[0]}")/prism-agents.sh"
source "$(dirname "${BASH_SOURCE[0]}")/prism-agent-executor.sh"
source "$(dirname "${BASH_SOURCE[0]}")/prism-resource-management.sh"

# Swarm registry
SWARM_REGISTRY_DIR=".prism/agents/swarms"

# Initialize swarm system
init_swarm_system() {
    mkdir -p "$SWARM_REGISTRY_DIR"/{active,completed,logs}
    log_info "Swarm orchestration system initialized"
}

# Create a swarm
create_swarm() {
    local swarm_name="$1"
    local topology="$2"  # hierarchical, mesh, pipeline, parallel, adaptive
    local task_description="$3"

    local swarm_id="swarm_${swarm_name}_$(date +%s)"
    local swarm_dir="$SWARM_REGISTRY_DIR/active/$swarm_id"

    mkdir -p "$swarm_dir"/{agents,results,logs}

    # Create swarm configuration
    cat > "$swarm_dir/config.yaml" << EOF
id: $swarm_id
name: $swarm_name
topology: $topology
task: $task_description
state: initializing
created: $(date -u +%Y-%m-%dT%H:%M:%SZ)
agents: []
EOF

    log_info "Created swarm: $swarm_name ($topology)"
    echo "$swarm_id"
}

# Add agent to swarm
add_agent_to_swarm() {
    local swarm_id="$1"
    local agent_type="$2"
    local agent_task="$3"
    local agent_role="${4:-worker}"  # coordinator or worker

    local swarm_dir="$SWARM_REGISTRY_DIR/active/$swarm_id"

    if [[ ! -d "$swarm_dir" ]]; then
        log_error "Swarm not found: $swarm_id"
        return 1
    fi

    # Create agent
    local agent_id=$(create_agent "$agent_type" "${swarm_id}_${agent_type}" "$agent_task")

    # Link agent to swarm
    mkdir -p "$swarm_dir/agents"
    ln -s "$(pwd)/.prism/agents/active/$agent_id" "$swarm_dir/agents/$agent_id"

    # Update swarm config
    echo "$agent_id:$agent_type:$agent_role" >> "$swarm_dir/agents.list"

    log_info "Added $agent_type agent to swarm $swarm_id (role: $agent_role)"
    echo "$agent_id"
}

# Execute Pipeline Swarm
# Pattern: Agent1 → Agent2 → Agent3 (sequential)
execute_pipeline_swarm() {
    local swarm_id="$1"
    local timeout="${2:-$DEFAULT_SWARM_TIMEOUT}"
    local swarm_dir="$SWARM_REGISTRY_DIR/active/$swarm_id"

    # Validate resources
    if ! validate_resources "swarm"; then
        log_error "[PIPELINE] Resource limits exceeded, cannot execute swarm"
        return 1
    fi

    increment_swarm_count
    trap "decrement_swarm_count" EXIT INT TERM

    log_info "[PIPELINE] Executing swarm: $swarm_id (timeout: ${timeout}s)"

    # Record start time
    local start_time=$(date +%s)

    if [[ ! -f "$swarm_dir/agents.list" ]]; then
        log_error "No agents in swarm"
        decrement_swarm_count
        return 1
    fi

    # Read agents in order
    local agent_list=()
    while IFS=':' read -r agent_id agent_type agent_role; do
        agent_list+=("$agent_id")
    done < "$swarm_dir/agents.list"

    # Execute agents sequentially
    local previous_output=""
    for agent_id in "${agent_list[@]}"; do
        log_info "[PIPELINE] Executing agent: $agent_id"

        # Pass previous agent's output as context
        if [[ -n "$previous_output" ]]; then
            local agent_dir=".prism/agents/active/$agent_id"
            echo "## Input from Previous Agent" >> "$agent_dir/context.txt"
            echo "$previous_output" >> "$agent_dir/context.txt"
        fi

        # Check timeout
        local elapsed=$(($(date +%s) - start_time))
        if [[ $elapsed -gt $timeout ]]; then
            log_error "[PIPELINE] Swarm timeout exceeded: ${elapsed}s > ${timeout}s"
            decrement_swarm_count
            return 124
        fi

        # Execute agent
        if ! execute_agent_with_workflow "$agent_id"; then
            log_error "[PIPELINE] Agent failed: $agent_id, stopping pipeline"
            decrement_swarm_count
            return 1
        fi

        # Save output for next agent
        local agent_dir=".prism/agents/active/$agent_id"
        if [[ -f "$agent_dir/results.md" ]]; then
            previous_output=$(cat "$agent_dir/results.md")
        fi

        log_success "[PIPELINE] Agent completed: $agent_id"
    done

    decrement_swarm_count
    trap - EXIT INT TERM
    log_success "[PIPELINE] Swarm completed successfully: $swarm_id"
    return 0
}

# Execute Parallel Swarm
# Pattern: [Agent1 || Agent2 || Agent3] (concurrent)
execute_parallel_swarm() {
    local swarm_id="$1"
    local swarm_dir="$SWARM_REGISTRY_DIR/active/$swarm_id"

    log_info "[PARALLEL] Executing swarm: $swarm_id"

    if [[ ! -f "$swarm_dir/agents.list" ]]; then
        log_error "No agents in swarm"
        return 1
    fi

    # Read all agents
    local agent_pids=()
    while IFS=':' read -r agent_id agent_type agent_role; do
        log_info "[PARALLEL] Starting agent: $agent_id"

        # Execute agent in background
        (
            execute_agent_with_workflow "$agent_id"
            echo $? > "$swarm_dir/agents/${agent_id}_exit_code.txt"
        ) &

        agent_pids+=($!)
    done < "$swarm_dir/agents.list"

    # Wait for all agents to complete
    log_info "[PARALLEL] Waiting for ${#agent_pids[@]} agents to complete..."

    local all_succeeded=true
    for pid in "${agent_pids[@]}"; do
        if ! wait "$pid"; then
            all_succeeded=false
        fi
    done

    if $all_succeeded; then
        log_success "[PARALLEL] All agents completed successfully"
        return 0
    else
        log_error "[PARALLEL] Some agents failed"
        return 1
    fi
}

# Execute Hierarchical Swarm
# Pattern: Coordinator → [Worker1, Worker2, Worker3]
execute_hierarchical_swarm() {
    local swarm_id="$1"
    local swarm_dir="$SWARM_REGISTRY_DIR/active/$swarm_id"

    log_info "[HIERARCHICAL] Executing swarm: $swarm_id"

    # Phase 1: Execute coordinator
    local coordinator_id=""
    local worker_ids=()

    while IFS=':' read -r agent_id agent_type agent_role; do
        if [[ "$agent_role" == "coordinator" ]]; then
            coordinator_id="$agent_id"
        else
            worker_ids+=("$agent_id")
        fi
    done < "$swarm_dir/agents.list"

    if [[ -z "$coordinator_id" ]]; then
        log_error "[HIERARCHICAL] No coordinator found in swarm"
        return 1
    fi

    log_info "[HIERARCHICAL] Executing coordinator: $coordinator_id"
    if ! execute_agent_with_workflow "$coordinator_id"; then
        log_error "[HIERARCHICAL] Coordinator failed"
        return 1
    fi

    # Get coordinator's plan/instructions
    local coordinator_output=""
    local coordinator_dir=".prism/agents/active/$coordinator_id"
    if [[ -f "$coordinator_dir/results.md" ]]; then
        coordinator_output=$(cat "$coordinator_dir/results.md")
    fi

    # Phase 2: Execute workers in parallel with coordinator's guidance
    log_info "[HIERARCHICAL] Executing ${#worker_ids[@]} workers..."

    local worker_pids=()
    for worker_id in "${worker_ids[@]}"; do
        log_info "[HIERARCHICAL] Starting worker: $worker_id"

        # Add coordinator's output to worker context
        local worker_dir=".prism/agents/active/$worker_id"
        echo "## Coordinator Instructions" >> "$worker_dir/context.txt"
        echo "$coordinator_output" >> "$worker_dir/context.txt"

        # Execute worker in background
        (
            execute_agent_with_workflow "$worker_id"
            echo $? > "$swarm_dir/agents/${worker_id}_exit_code.txt"
        ) &

        worker_pids+=($!)
    done

    # Wait for workers
    local all_succeeded=true
    for pid in "${worker_pids[@]}"; do
        if ! wait "$pid"; then
            all_succeeded=false
        fi
    done

    # Phase 3: Optional - Coordinator review of worker results
    log_info "[HIERARCHICAL] Workers completed, coordinator reviewing results"

    if $all_succeeded; then
        log_success "[HIERARCHICAL] Swarm completed successfully"
        return 0
    else
        log_error "[HIERARCHICAL] Some workers failed"
        return 1
    fi
}

# Execute Mesh Swarm
# Pattern: Agents communicate with each other (collaborative)
execute_mesh_swarm() {
    local swarm_id="$1"
    local swarm_dir="$SWARM_REGISTRY_DIR/active/$swarm_id"

    log_info "[MESH] Executing swarm: $swarm_id"

    # Create shared message board
    local message_board="$swarm_dir/message_board.txt"
    touch "$message_board"

    # Read all agents
    local agent_ids=()
    while IFS=':' read -r agent_id agent_type agent_role; do
        agent_ids+=("$agent_id")
    done < "$swarm_dir/agents.list"

    # Execute agents with ability to read messages from others
    local agent_pids=()
    for agent_id in "${agent_ids[@]}"; do
        log_info "[MESH] Starting agent: $agent_id"

        # Link message board to agent context
        local agent_dir=".prism/agents/active/$agent_id"
        ln -sf "$(pwd)/$message_board" "$agent_dir/message_board.txt"

        # Execute agent in background
        (
            execute_agent_with_workflow "$agent_id"

            # Post results to message board
            local results="$agent_dir/results.md"
            if [[ -f "$results" ]]; then
                echo "" >> "$message_board"
                echo "=== Message from $agent_id ===" >> "$message_board"
                cat "$results" >> "$message_board"
                echo "" >> "$message_board"
            fi

            echo $? > "$swarm_dir/agents/${agent_id}_exit_code.txt"
        ) &

        agent_pids+=($!)

        # Small delay to allow agents to stagger their starts
        sleep 1
    done

    # Wait for all agents
    local all_succeeded=true
    for pid in "${agent_pids[@]}"; do
        if ! wait "$pid"; then
            all_succeeded=false
        fi
    done

    if $all_succeeded; then
        log_success "[MESH] All agents completed successfully"
        return 0
    else
        log_error "[MESH] Some agents failed"
        return 1
    fi
}

# Execute Adaptive Swarm
# Pattern: Topology adjusts based on task complexity
execute_adaptive_swarm() {
    local swarm_id="$1"
    local swarm_dir="$SWARM_REGISTRY_DIR/active/$swarm_id"

    log_info "[ADAPTIVE] Analyzing swarm complexity..."

    # Read swarm task
    local task=$(grep "^task:" "$swarm_dir/config.yaml" | cut -d' ' -f2-)

    # Count agents
    local agent_count=$(wc -l < "$swarm_dir/agents.list" 2>/dev/null || echo 0)

    # Determine best topology based on agent count and task keywords
    local chosen_topology="pipeline"  # default

    if [[ $agent_count -eq 1 ]]; then
        # Single agent - no coordination needed
        chosen_topology="simple"
    elif [[ $agent_count -le 3 ]]; then
        # Few agents - pipeline works well
        chosen_topology="pipeline"
    elif echo "$task" | grep -qi "parallel\|independent\|concurrent"; then
        # Task suggests parallel execution
        chosen_topology="parallel"
    elif echo "$task" | grep -qi "coordinate\|plan\|delegate"; then
        # Task suggests hierarchical
        chosen_topology="hierarchical"
    elif [[ $agent_count -gt 5 ]]; then
        # Many agents - use mesh for collaboration
        chosen_topology="mesh"
    fi

    log_info "[ADAPTIVE] Selected topology: $chosen_topology (agents: $agent_count)"

    # Execute with chosen topology
    case "$chosen_topology" in
        pipeline)
            execute_pipeline_swarm "$swarm_id"
            ;;
        parallel)
            execute_parallel_swarm "$swarm_id"
            ;;
        hierarchical)
            execute_hierarchical_swarm "$swarm_id"
            ;;
        mesh)
            execute_mesh_swarm "$swarm_id"
            ;;
        simple)
            # Just execute the single agent
            local agent_id=$(head -1 "$swarm_dir/agents.list" | cut -d':' -f1)
            execute_agent_with_workflow "$agent_id"
            ;;
    esac
}

# Get swarm status
get_swarm_status() {
    local swarm_id="$1"
    local swarm_dir="$SWARM_REGISTRY_DIR/active/$swarm_id"

    if [[ ! -d "$swarm_dir" ]]; then
        echo "Swarm not found: $swarm_id"
        return 1
    fi

    echo "=== Swarm Status: $swarm_id ==="
    cat "$swarm_dir/config.yaml"

    echo ""
    echo "=== Agents ==="
    cat "$swarm_dir/agents.list" | while IFS=':' read -r agent_id agent_type agent_role; do
        local state=$(grep "^state:" ".prism/agents/active/$agent_id/config.yaml" 2>/dev/null | awk '{print $2}')
        echo "$agent_id | $agent_type | $agent_role | State: $state"
    done
}

# Export functions
export -f init_swarm_system
export -f create_swarm
export -f add_agent_to_swarm
export -f execute_pipeline_swarm
export -f execute_parallel_swarm
export -f execute_hierarchical_swarm
export -f execute_mesh_swarm
export -f execute_adaptive_swarm
export -f get_swarm_status
