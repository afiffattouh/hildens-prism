#!/bin/bash
# PRISM Agent Orchestration Library
# Provides multi-agent coordination and task decomposition capabilities

# Agent type definitions (using functions for Bash 3.x compatibility)
get_agent_description() {
    case "$1" in
        architect) echo "System architecture and design specialist" ;;
        coder) echo "Implementation and coding specialist" ;;
        tester) echo "Testing and quality assurance specialist" ;;
        reviewer) echo "Code review and analysis specialist" ;;
        documenter) echo "Documentation and technical writing specialist" ;;
        security) echo "Security analysis and vulnerability assessment" ;;
        performance) echo "Performance optimization specialist" ;;
        refactorer) echo "Code refactoring and improvement specialist" ;;
        debugger) echo "Bug detection and debugging specialist" ;;
        planner) echo "Task planning and decomposition specialist" ;;
        sparc) echo "SPARC methodology orchestrator" ;;
        *) echo "Unknown agent type" ;;
    esac
}

# Valid agent types
VALID_AGENT_TYPES="architect coder tester reviewer documenter security performance refactorer debugger planner sparc"

# Agent states
readonly AGENT_STATE_IDLE="idle"
readonly AGENT_STATE_WORKING="working"
readonly AGENT_STATE_COMPLETED="completed"
readonly AGENT_STATE_FAILED="failed"
readonly AGENT_STATE_BLOCKED="blocked"

# Swarm topologies
readonly SWARM_HIERARCHICAL="hierarchical"
readonly SWARM_MESH="mesh"
readonly SWARM_PIPELINE="pipeline"
readonly SWARM_PARALLEL="parallel"

# Agent registry (stores active agents) - using files for Bash 3.x
AGENT_REGISTRY_DIR=".prism/agents/registry"

# Initialize agent system
init_agent_system() {
    local project_root="${1:-.}"

    # Create agent workspace
    mkdir -p "$project_root/.prism/agents"/{active,completed,logs,results,registry,swarms,messages}

    # Initialize agent registry
    touch "$project_root/.prism/agents/registry/agents.list"

    log_info "Agent orchestration system initialized"
}

# Create an agent
create_agent() {
    local agent_type="$1"
    local agent_name="${2:-${agent_type}_$(date +%s)}"
    local task_description="$3"

    # Validate agent type
    if ! echo "$VALID_AGENT_TYPES" | grep -qw "$agent_type"; then
        log_error "Unknown agent type: $agent_type"
        return 1
    fi

    local agent_id="agent_${agent_name}_$$"
    local agent_dir=".prism/agents/active/$agent_id"

    mkdir -p "$agent_dir"

    # Get agent description
    local agent_desc=$(get_agent_description "$agent_type")

    # Create agent configuration
    cat > "$agent_dir/config.yaml" << EOF
id: $agent_id
name: $agent_name
type: $agent_type
description: $agent_desc
task: $task_description
state: $AGENT_STATE_IDLE
created: $(date -u +%Y-%m-%dT%H:%M:%SZ)
pid: $$
EOF

    # Register agent in file-based registry
    echo "$agent_id:$agent_type:$task_description" >> ".prism/agents/registry/agents.list"

    log_info "Created agent: $agent_name ($agent_type)"
    echo "$agent_id"
}

# Execute agent task
execute_agent_task() {
    local agent_id="$1"
    local agent_dir=".prism/agents/active/$agent_id"

    if [[ ! -d "$agent_dir" ]]; then
        log_error "Agent not found: $agent_id"
        return 1
    fi

    # Update agent state
    update_agent_state "$agent_id" "$AGENT_STATE_WORKING"

    # Get agent type and task from config file
    local agent_type=$(grep "^type:" "$agent_dir/config.yaml" | cut -d' ' -f2)
    local task=$(grep "^task:" "$agent_dir/config.yaml" | cut -d' ' -f2-)

    log_info "Agent $agent_id executing: $task"

    # Execute based on agent type
    case "$agent_type" in
        architect)
            execute_architect_task "$agent_id" "$task"
            ;;
        coder)
            execute_coder_task "$agent_id" "$task"
            ;;
        tester)
            execute_tester_task "$agent_id" "$task"
            ;;
        reviewer)
            execute_reviewer_task "$agent_id" "$task"
            ;;
        planner)
            execute_planner_task "$agent_id" "$task"
            ;;
        *)
            execute_generic_task "$agent_id" "$task"
            ;;
    esac

    local result=$?

    if [[ $result -eq 0 ]]; then
        update_agent_state "$agent_id" "$AGENT_STATE_COMPLETED"
    else
        update_agent_state "$agent_id" "$AGENT_STATE_FAILED"
    fi

    return $result
}

# Task execution functions for different agent types
execute_architect_task() {
    local agent_id="$1"
    local task="$2"
    local result_file=".prism/agents/results/${agent_id}_architecture.md"

    cat > "$result_file" << EOF
# Architecture Analysis
Agent: $agent_id
Task: $task
Timestamp: $(date -u +%Y-%m-%dT%H:%M:%SZ)

## System Components
- Analyzing system structure...
- Identifying key components...
- Mapping dependencies...

## Design Patterns
- Identifying architectural patterns...
- Evaluating design decisions...

## Recommendations
- Based on analysis of the task requirements
- Suggested architectural approach
EOF

    # Store result file path
    echo "$result_file" > ".prism/agents/registry/${agent_id}.result"
    log_info "Architect agent completed analysis"
    return 0
}

execute_coder_task() {
    local agent_id="$1"
    local task="$2"
    local result_file=".prism/agents/results/${agent_id}_code.md"

    cat > "$result_file" << EOF
# Implementation Plan
Agent: $agent_id
Task: $task
Timestamp: $(date -u +%Y-%m-%dT%H:%M:%SZ)

## Code Structure
- Planning implementation approach...
- Identifying required modules...

## Implementation Steps
1. Setup base structure
2. Implement core functionality
3. Add error handling
4. Write tests

## Code Templates
- Generated based on task requirements
EOF

    echo "$result_file" > ".prism/agents/registry/${agent_id}.result"
    log_info "Coder agent completed implementation plan"
    return 0
}

execute_tester_task() {
    local agent_id="$1"
    local task="$2"
    local result_file=".prism/agents/results/${agent_id}_tests.md"

    cat > "$result_file" << EOF
# Test Strategy
Agent: $agent_id
Task: $task
Timestamp: $(date -u +%Y-%m-%dT%H:%M:%SZ)

## Test Coverage
- Unit tests required
- Integration test scenarios
- End-to-end test cases

## Test Plan
1. Setup test environment
2. Write unit tests
3. Create integration tests
4. Perform validation
EOF

    echo "$result_file" > ".prism/agents/registry/${agent_id}.result"
    log_info "Tester agent completed test strategy"
    return 0
}

execute_reviewer_task() {
    local agent_id="$1"
    local task="$2"
    local result_file=".prism/agents/results/${agent_id}_review.md"

    cat > "$result_file" << EOF
# Code Review
Agent: $agent_id
Task: $task
Timestamp: $(date -u +%Y-%m-%dT%H:%M:%SZ)

## Review Checklist
- [ ] Code follows patterns
- [ ] Security validated
- [ ] Performance optimized
- [ ] Tests adequate
- [ ] Documentation complete

## Findings
- Analyzing code quality...
- Checking best practices...
- Identifying improvements...
EOF

    echo "$result_file" > ".prism/agents/registry/${agent_id}.result"
    log_info "Reviewer agent completed analysis"
    return 0
}

execute_planner_task() {
    local agent_id="$1"
    local task="$2"
    local result_file=".prism/agents/results/${agent_id}_plan.md"

    cat > "$result_file" << EOF
# Task Decomposition
Agent: $agent_id
Task: $task
Timestamp: $(date -u +%Y-%m-%dT%H:%M:%SZ)

## Task Breakdown
1. Analyze requirements
2. Design solution
3. Implement features
4. Test functionality
5. Document changes

## Agent Assignments
- Architect: System design
- Coder: Implementation
- Tester: Quality assurance
- Reviewer: Code review
- Documenter: Documentation

## Execution Strategy
- Sequential tasks: Design → Code → Test
- Parallel tasks: Review || Documentation
EOF

    echo "$result_file" > ".prism/agents/registry/${agent_id}.result"
    log_info "Planner agent completed task decomposition"
    return 0
}

execute_generic_task() {
    local agent_id="$1"
    local task="$2"
    local agent_type="${ACTIVE_AGENTS[$agent_id]}"
    local result_file=".prism/agents/results/${agent_id}_result.md"

    cat > "$result_file" << EOF
# Task Execution Result
Agent: $agent_id
Type: $agent_type
Task: $task
Timestamp: $(date -u +%Y-%m-%dT%H:%M:%SZ)

## Analysis
Executing specialized analysis for $agent_type agent...

## Results
Task processing completed based on agent specialization.

## Next Steps
Further actions may be required based on task requirements.
EOF

    echo "$result_file" > ".prism/agents/registry/${agent_id}.result"
    log_info "$agent_type agent completed task"
    return 0
}

# Update agent state
update_agent_state() {
    local agent_id="$1"
    local new_state="$2"
    local agent_dir=".prism/agents/active/$agent_id"

    if [[ -f "$agent_dir/config.yaml" ]]; then
        sed -i '' "s/^state: .*/state: $new_state/" "$agent_dir/config.yaml"
        echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) - State changed to: $new_state" >> "$agent_dir/log.txt"
    fi
}

# Create agent swarm
create_swarm() {
    local swarm_name="$1"
    local topology="${2:-$SWARM_PARALLEL}"
    local task="$3"

    local swarm_id="swarm_${swarm_name}_$(date +%s)"
    local swarm_dir=".prism/agents/swarms/$swarm_id"

    mkdir -p "$swarm_dir"

    # Create swarm configuration
    cat > "$swarm_dir/config.yaml" << EOF
id: $swarm_id
name: $swarm_name
topology: $topology
task: $task
created: $(date -u +%Y-%m-%dT%H:%M:%SZ)
agents: []
state: initializing
EOF

    log_info "Created swarm: $swarm_name (topology: $topology)"
    echo "$swarm_id"
}

# Add agent to swarm
add_agent_to_swarm() {
    local swarm_id="$1"
    local agent_type="$2"
    local task="$3"

    # Capture only the agent ID (last line of output)
    local agent_output=$(create_agent "$agent_type" "${swarm_id}_${agent_type}" "$task")
    local agent_id=$(echo "$agent_output" | tail -n 1)

    # Update swarm configuration with proper YAML format
    local swarm_dir=".prism/agents/swarms/$swarm_id"

    # Simple approach: just add to the agents list by inserting after last agent entry
    if grep -q "^agents: \[\]$" "$swarm_dir/config.yaml"; then
        # Replace empty array
        sed -i '' "s/^agents: \[\]$/agents:\n  - $agent_id/" "$swarm_dir/config.yaml"
    else
        # Find the last line that starts with "  - " under agents section and add after it
        # Or if no agents exist yet, add after "agents:" line
        local last_agent_line=$(grep -n "^  - agent_" "$swarm_dir/config.yaml" | tail -n 1 | cut -d: -f1)
        if [[ -n "$last_agent_line" ]]; then
            # Add after last agent
            sed -i '' "${last_agent_line}a\\
  - $agent_id" "$swarm_dir/config.yaml"
        else
            # Add after agents: line
            sed -i '' "/^agents:$/a\\
  - $agent_id" "$swarm_dir/config.yaml"
        fi
    fi

    echo "$agent_id"
}

# Execute swarm tasks
execute_swarm() {
    local swarm_id="$1"
    local swarm_dir=".prism/agents/swarms/$swarm_id"

    if [[ ! -d "$swarm_dir" ]]; then
        log_error "Swarm not found: $swarm_id"
        return 1
    fi

    # Get topology
    local topology=$(grep "^topology:" "$swarm_dir/config.yaml" | cut -d' ' -f2)

    log_info "Executing swarm $swarm_id with $topology topology"

    case "$topology" in
        "$SWARM_PARALLEL")
            execute_parallel_swarm "$swarm_id"
            ;;
        "$SWARM_PIPELINE")
            execute_pipeline_swarm "$swarm_id"
            ;;
        "$SWARM_HIERARCHICAL")
            execute_hierarchical_swarm "$swarm_id"
            ;;
        "$SWARM_MESH")
            execute_mesh_swarm "$swarm_id"
            ;;
        *)
            log_error "Unknown topology: $topology"
            return 1
            ;;
    esac
}

# Execute parallel swarm (all agents run simultaneously)
execute_parallel_swarm() {
    local swarm_id="$1"
    local swarm_dir=".prism/agents/swarms/$swarm_id"

    # Get all agents in swarm
    local agents=($(grep "^  - " "$swarm_dir/config.yaml" | sed 's/  - //'))

    log_info "Executing ${#agents[@]} agents in parallel"

    # Execute all agents
    for agent_id in "${agents[@]}"; do
        execute_agent_task "$agent_id" &
    done

    # Wait for all agents to complete
    wait

    log_info "Parallel swarm execution completed"
}

# Execute pipeline swarm (agents run sequentially)
execute_pipeline_swarm() {
    local swarm_id="$1"
    local swarm_dir=".prism/agents/swarms/$swarm_id"

    # Get all agents in swarm
    local agents=($(grep "^  - " "$swarm_dir/config.yaml" | sed 's/  - //'))

    log_info "Executing ${#agents[@]} agents in pipeline"

    # Execute agents sequentially
    for agent_id in "${agents[@]}"; do
        execute_agent_task "$agent_id"
        if [[ $? -ne 0 ]]; then
            log_error "Pipeline failed at agent: $agent_id"
            return 1
        fi
    done

    log_info "Pipeline swarm execution completed"
}

# Execute hierarchical swarm (coordinator delegates to workers)
execute_hierarchical_swarm() {
    local swarm_id="$1"
    local swarm_dir=".prism/agents/swarms/$swarm_id"

    # Get all agents in swarm
    local agents=($(grep "^  - " "$swarm_dir/config.yaml" | sed 's/  - //'))

    # First agent is the coordinator
    local coordinator="${agents[0]}"
    local workers=("${agents[@]:1}")

    log_info "Hierarchical swarm: coordinator=$coordinator, workers=${#workers[@]}"

    # Execute coordinator first
    execute_agent_task "$coordinator"

    # Then execute workers in parallel
    for worker_id in "${workers[@]}"; do
        execute_agent_task "$worker_id" &
    done

    wait

    log_info "Hierarchical swarm execution completed"
}

# Execute mesh swarm (agents communicate with each other)
execute_mesh_swarm() {
    local swarm_id="$1"
    local swarm_dir=".prism/agents/swarms/$swarm_id"

    # Get all agents in swarm
    local agents=($(grep "^  - " "$swarm_dir/config.yaml" | sed 's/  - //'))

    log_info "Executing ${#agents[@]} agents in mesh topology"

    # Create communication channels
    mkdir -p "$swarm_dir/channels"

    # Execute all agents with inter-communication
    for agent_id in "${agents[@]}"; do
        SWARM_CHANNEL="$swarm_dir/channels" execute_agent_task "$agent_id" &
    done

    wait

    log_info "Mesh swarm execution completed"
}

# Task decomposition
decompose_task() {
    local task="$1"
    local complexity="${2:-medium}"

    log_info "Decomposing task: $task (complexity: $complexity)"

    # Create planner agent for decomposition
    local planner_id=$(create_agent "planner" "task_decomposer" "$task")
    execute_agent_task "$planner_id"

    # Based on complexity, determine agent requirements
    case "$complexity" in
        simple)
            echo "coder"
            ;;
        medium)
            echo "architect coder tester"
            ;;
        complex)
            echo "planner architect coder tester reviewer documenter"
            ;;
        *)
            echo "architect coder tester reviewer"
            ;;
    esac
}

# Get agent result
get_agent_result() {
    local agent_id="$1"

    # First check if agent has a registry entry (for active/working agents)
    local result_file_path=".prism/agents/registry/${agent_id}.result"
    if [[ -f "$result_file_path" ]]; then
        local result_file=$(cat "$result_file_path")
        if [[ -f "$result_file" ]]; then
            cat "$result_file"
            return 0
        fi
    fi

    # If no registry entry, search directly in results directory
    local results_dir=".prism/agents/results"
    local result_files=("$results_dir"/${agent_id}_*.md)

    if [[ ${#result_files[@]} -gt 0 ]] && [[ -f "${result_files[0]}" ]]; then
        # Return the first matching result file
        cat "${result_files[0]}"
        return 0
    fi

    # No results found
    log_error "No results found for agent: $agent_id"
    log_info "Searched in:"
    log_info "  - Registry: $result_file_path"
    log_info "  - Results: $results_dir/${agent_id}_*.md"
    return 1
}

# List active agents
list_active_agents() {
    log_info "Active Agents:"

    local agent_dir=".prism/agents/active"
    local count=0

    if [[ -d "$agent_dir" ]]; then
        for dir in "$agent_dir"/agent_*; do
            if [[ -d "$dir" ]]; then
                local agent_id=$(basename "$dir")
                local agent_type=$(grep "^type:" "$dir/config.yaml" | cut -d' ' -f2)
                local task=$(grep "^task:" "$dir/config.yaml" | cut -d' ' -f2-)
                local state=$(grep "^state:" "$dir/config.yaml" | cut -d' ' -f2)
                echo "  - $agent_id ($agent_type): $task [${state}]"
                count=$((count + 1))
            fi
        done
    fi

    if [[ $count -eq 0 ]]; then
        echo "  No active agents"
    fi
}

# Clean up completed agents
cleanup_agents() {
    local agent_dir=".prism/agents/active"

    if [[ -d "$agent_dir" ]]; then
        for dir in "$agent_dir"/agent_*; do
            if [[ -d "$dir" ]]; then
                local state=$(grep "^state:" "$dir/config.yaml" | cut -d' ' -f2)
                if [[ "$state" == "$AGENT_STATE_COMPLETED" ]] || [[ "$state" == "$AGENT_STATE_FAILED" ]]; then
                    local agent_id=$(basename "$dir")
                    mv "$dir" ".prism/agents/completed/"

                    # Move registry file to completed directory instead of deleting
                    if [[ -f ".prism/agents/registry/${agent_id}.result" ]]; then
                        mv ".prism/agents/registry/${agent_id}.result" ".prism/agents/completed/${agent_id}/" 2>/dev/null
                    fi

                    log_info "Cleaned up agent: $agent_id"
                fi
            fi
        done
    fi
}

# Agent orchestration command interface
cmd_agent() {
    local action="$1"
    shift

    case "$action" in
        init)
            init_agent_system "$@"
            ;;
        create)
            create_agent "$@"
            ;;
        execute)
            execute_agent_task "$@"
            ;;
        list)
            list_active_agents
            ;;
        result)
            get_agent_result "$@"
            ;;
        cleanup)
            cleanup_agents
            ;;
        swarm)
            cmd_swarm "$@"
            ;;
        decompose)
            decompose_task "$@"
            ;;
        *)
            log_error "Unknown agent command: $action"
            echo "Usage: prism agent {init|create|execute|list|result|cleanup|swarm|decompose}"
            return 1
            ;;
    esac
}

# Swarm command interface
cmd_swarm() {
    local action="$1"
    shift

    case "$action" in
        create)
            create_swarm "$@"
            ;;
        add)
            add_agent_to_swarm "$@"
            ;;
        execute)
            execute_swarm "$@"
            ;;
        *)
            log_error "Unknown swarm command: $action"
            echo "Usage: prism agent swarm {create|add|execute}"
            return 1
            ;;
    esac
}

# Export functions for use in other scripts
export -f init_agent_system
export -f create_agent
export -f execute_agent_task
export -f create_swarm
export -f add_agent_to_swarm
export -f execute_swarm
export -f decompose_task
export -f get_agent_result
export -f list_active_agents
export -f cleanup_agents
export -f cmd_agent
export -f cmd_swarm