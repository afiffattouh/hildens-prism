#!/bin/bash
# PRISM Claude Code Agent Integration
# Provides templates and patterns for Claude Code multi-agent orchestration

# Claude Code agent templates with specific capabilities
declare -A CLAUDE_AGENTS=(
    ["sparc"]="SPARC methodology orchestrator for systematic development"
    ["spec-writer"]="Requirements specification and documentation specialist"
    ["architect"]="System architecture and design pattern specialist"
    ["pseudocoder"]="Algorithm design and pseudocode specialist"
    ["coder"]="Implementation specialist with TDD practices"
    ["refactorer"]="Code optimization and refactoring specialist"
    ["tester"]="Test-driven development and quality assurance"
    ["reviewer"]="Code review and best practices enforcement"
    ["documenter"]="Technical documentation and API docs"
    ["security-auditor"]="Security vulnerability assessment"
    ["performance-optimizer"]="Performance analysis and optimization"
    ["debugger"]="Bug detection and resolution specialist"
    ["devops"]="CI/CD and deployment automation"
    ["ui-designer"]="User interface and experience design"
    ["data-modeler"]="Database design and data structure specialist"
)

# Agent capability matrix
declare -A AGENT_CAPABILITIES=(
    ["sparc"]="orchestration planning decomposition coordination"
    ["architect"]="design patterns structure scalability"
    ["coder"]="implementation testing refactoring debugging"
    ["tester"]="unit-testing integration-testing e2e-testing coverage"
    ["security-auditor"]="vulnerability-scan penetration-test compliance"
    ["performance-optimizer"]="profiling optimization caching scaling"
)

# Create Claude-aware agent with specific instructions
create_claude_agent() {
    local agent_type="$1"
    local task="$2"
    local context_files="$3"

    local agent_id=$(create_agent "$agent_type" "${agent_type}_claude_$(date +%s)" "$task")
    local agent_dir=".prism/agents/active/$agent_id"

    # Add Claude-specific instructions
    cat > "$agent_dir/claude_instructions.md" << EOF
# Claude Code Agent Instructions

## Agent Role: ${CLAUDE_AGENTS[$agent_type]}

## Task
$task

## Context Files to Load
$context_files

## Execution Guidelines

### For Claude Code:
1. Load PRISM context from .prism/context/ directory
2. Follow patterns defined in patterns.md
3. Respect architectural decisions in architecture.md
4. Apply security requirements from security.md
5. Maintain performance baselines from performance.md

### Agent-Specific Instructions
$(generate_agent_instructions "$agent_type")

## Communication Protocol
- Input: Task description and context
- Processing: Apply specialized knowledge
- Output: Structured results in markdown
- Handoff: Clear next steps for other agents

## Quality Checklist
- [ ] Context fully analyzed
- [ ] Patterns followed
- [ ] Security validated
- [ ] Performance considered
- [ ] Documentation updated
- [ ] Tests included (if applicable)
EOF

    echo "$agent_id"
}

# Generate agent-specific instructions
generate_agent_instructions() {
    local agent_type="$1"

    case "$agent_type" in
        sparc)
            cat << 'EOF'
### SPARC Orchestration
1. **Specification**: Define clear requirements
2. **Pseudocode**: Create algorithm design
3. **Architecture**: Design system structure
4. **Refinement**: Iterate and improve
5. **Code**: Generate implementation

Coordinate other agents through SPARC phases.
EOF
            ;;

        architect)
            cat << 'EOF'
### Architecture Guidelines
1. Analyze system requirements
2. Identify key components and boundaries
3. Define interfaces and contracts
4. Select appropriate design patterns
5. Document architectural decisions
6. Create component diagrams
7. Define data flow
EOF
            ;;

        coder)
            cat << 'EOF'
### Implementation Guidelines
1. Follow TDD approach (test first)
2. Implement based on specifications
3. Apply SOLID principles
4. Use appropriate design patterns
5. Write clean, readable code
6. Include error handling
7. Add logging and monitoring
EOF
            ;;

        tester)
            cat << 'EOF'
### Testing Guidelines
1. Write unit tests for all functions
2. Create integration test scenarios
3. Design end-to-end test flows
4. Ensure >80% code coverage
5. Test edge cases and error conditions
6. Validate performance requirements
7. Security testing scenarios
EOF
            ;;

        security-auditor)
            cat << 'EOF'
### Security Audit Guidelines
1. Check OWASP Top 10 vulnerabilities
2. Review authentication/authorization
3. Validate input sanitization
4. Check for SQL injection risks
5. Review encryption usage
6. Audit logging for sensitive data
7. Check dependency vulnerabilities
EOF
            ;;

        performance-optimizer)
            cat << 'EOF'
### Performance Optimization Guidelines
1. Profile current performance
2. Identify bottlenecks
3. Analyze database queries
4. Review caching strategies
5. Optimize algorithms (Big O)
6. Reduce network calls
7. Implement lazy loading
EOF
            ;;

        *)
            echo "Apply specialized knowledge for $agent_type role"
            ;;
    esac
}

# Create SPARC workflow swarm
create_sparc_swarm() {
    local task="$1"
    local swarm_id=$(create_swarm "sparc_workflow" "$SWARM_PIPELINE" "$task")

    # Add agents in SPARC sequence
    add_agent_to_swarm "$swarm_id" "sparc" "Orchestrate: $task"
    add_agent_to_swarm "$swarm_id" "spec-writer" "Specify requirements for: $task"
    add_agent_to_swarm "$swarm_id" "pseudocoder" "Design algorithms for: $task"
    add_agent_to_swarm "$swarm_id" "architect" "Architecture design for: $task"
    add_agent_to_swarm "$swarm_id" "coder" "Implement: $task"
    add_agent_to_swarm "$swarm_id" "refactorer" "Refine and optimize: $task"
    add_agent_to_swarm "$swarm_id" "tester" "Test implementation: $task"

    echo "$swarm_id"
}

# Create security audit swarm
create_security_swarm() {
    local target="$1"
    local swarm_id=$(create_swarm "security_audit" "$SWARM_PARALLEL" "Security audit: $target")

    # Add security specialists
    add_agent_to_swarm "$swarm_id" "security-auditor" "Vulnerability assessment: $target"
    add_agent_to_swarm "$swarm_id" "coder" "Fix security issues in: $target"
    add_agent_to_swarm "$swarm_id" "tester" "Security testing: $target"
    add_agent_to_swarm "$swarm_id" "documenter" "Security documentation: $target"

    echo "$swarm_id"
}

# Create full development swarm
create_dev_swarm() {
    local feature="$1"
    local swarm_id=$(create_swarm "full_development" "$SWARM_HIERARCHICAL" "Develop: $feature")

    # Coordinator
    add_agent_to_swarm "$swarm_id" "sparc" "Coordinate development: $feature"

    # Workers
    add_agent_to_swarm "$swarm_id" "spec-writer" "Requirements: $feature"
    add_agent_to_swarm "$swarm_id" "architect" "Design: $feature"
    add_agent_to_swarm "$swarm_id" "coder" "Implement: $feature"
    add_agent_to_swarm "$swarm_id" "tester" "Test: $feature"
    add_agent_to_swarm "$swarm_id" "reviewer" "Review: $feature"
    add_agent_to_swarm "$swarm_id" "documenter" "Document: $feature"

    echo "$swarm_id"
}

# Generate Claude Code task instructions
generate_claude_task() {
    local task="$1"
    local agents="$2"
    local output_file="${3:-.prism/agents/claude_task.md}"

    cat > "$output_file" << EOF
# Claude Code Multi-Agent Task

## Objective
$task

## Agent Orchestration Plan

### Agents Involved
$agents

## Execution Strategy

### Phase 1: Analysis and Planning
\`\`\`claude
@agent:planner
Analyze the task: "$task"
Decompose into subtasks
Identify required specialists
Create execution timeline
\`\`\`

### Phase 2: Design and Architecture
\`\`\`claude
@agent:architect
Design system architecture
Define component boundaries
Select design patterns
Document decisions in .prism/context/architecture.md
\`\`\`

### Phase 3: Implementation
\`\`\`claude
@agent:coder
Implement based on architecture
Follow patterns.md guidelines
Apply TDD practices
Include error handling
\`\`\`

### Phase 4: Testing and Validation
\`\`\`claude
@agent:tester
Write comprehensive tests
Validate requirements
Check edge cases
Ensure coverage > 80%
\`\`\`

### Phase 5: Review and Optimization
\`\`\`claude
@agent:reviewer
Review code quality
Check best practices
Validate security
Suggest improvements
\`\`\`

### Phase 6: Documentation
\`\`\`claude
@agent:documenter
Document implementation
Update API docs
Create usage examples
Update changelog
\`\`\`

## Context Loading

Load these PRISM context files:
- .prism/context/patterns.md
- .prism/context/architecture.md
- .prism/context/decisions.md
- .prism/context/security.md
- .prism/context/performance.md

## Success Criteria
- [ ] All requirements implemented
- [ ] Tests passing with >80% coverage
- [ ] Security validated
- [ ] Performance baselines met
- [ ] Documentation complete
- [ ] Code review approved

## Communication Protocol

### Agent Handoffs
Each agent should:
1. Load relevant context
2. Execute specialized task
3. Document results
4. Signal completion
5. Pass to next agent

### Result Aggregation
Final output should include:
- Implementation code
- Test results
- Security report
- Performance metrics
- Documentation updates

---
*Generated by PRISM Agent Orchestration System*
EOF

    log_info "Generated Claude task instructions: $output_file"
}

# Execute Claude-aware agent task
execute_claude_agent() {
    local agent_id="$1"
    local agent_dir=".prism/agents/active/$agent_id"

    # Load Claude instructions
    local instructions="$agent_dir/claude_instructions.md"

    if [[ -f "$instructions" ]]; then
        log_info "Executing Claude-aware agent: $agent_id"

        # Execute with Claude context
        CLAUDE_MODE=true execute_agent_task "$agent_id"
    else
        # Fallback to regular execution
        execute_agent_task "$agent_id"
    fi
}

# Generate agent communication message
generate_agent_message() {
    local from_agent="$1"
    local to_agent="$2"
    local message="$3"
    local data="$4"

    local timestamp=$(date -u +%Y-%m-%dT%H:%M:%SZ)
    local message_file=".prism/agents/messages/${from_agent}_to_${to_agent}_$(date +%s).json"

    mkdir -p .prism/agents/messages

    cat > "$message_file" << EOF
{
  "from": "$from_agent",
  "to": "$to_agent",
  "timestamp": "$timestamp",
  "message": "$message",
  "data": $data,
  "status": "pending"
}
EOF

    echo "$message_file"
}

# Route task to appropriate agent
route_task() {
    local task="$1"
    local complexity="${2:-auto}"

    # Analyze task to determine best agent
    local keywords=$(echo "$task" | tr '[:upper:]' '[:lower:]')

    if [[ "$keywords" == *"security"* ]] || [[ "$keywords" == *"vulnerability"* ]]; then
        echo "security-auditor"
    elif [[ "$keywords" == *"performance"* ]] || [[ "$keywords" == *"optimize"* ]]; then
        echo "performance-optimizer"
    elif [[ "$keywords" == *"test"* ]] || [[ "$keywords" == *"quality"* ]]; then
        echo "tester"
    elif [[ "$keywords" == *"design"* ]] || [[ "$keywords" == *"architecture"* ]]; then
        echo "architect"
    elif [[ "$keywords" == *"implement"* ]] || [[ "$keywords" == *"code"* ]]; then
        echo "coder"
    elif [[ "$keywords" == *"document"* ]] || [[ "$keywords" == *"docs"* ]]; then
        echo "documenter"
    elif [[ "$keywords" == *"review"* ]] || [[ "$keywords" == *"audit"* ]]; then
        echo "reviewer"
    elif [[ "$keywords" == *"refactor"* ]] || [[ "$keywords" == *"improve"* ]]; then
        echo "refactorer"
    elif [[ "$keywords" == *"debug"* ]] || [[ "$keywords" == *"fix"* ]]; then
        echo "debugger"
    else
        # Complex task needs orchestration
        echo "sparc"
    fi
}

# Create adaptive swarm based on task analysis
create_adaptive_swarm() {
    local task="$1"

    # Analyze task complexity
    local word_count=$(echo "$task" | wc -w)
    local has_security=$(echo "$task" | grep -i "security\|secure\|auth" | wc -l)
    local has_performance=$(echo "$task" | grep -i "performance\|optimize\|fast" | wc -l)
    local has_ui=$(echo "$task" | grep -i "ui\|interface\|design\|user" | wc -l)

    local swarm_name="adaptive_$(date +%s)"
    local topology="$SWARM_PARALLEL"

    # Determine topology based on task
    if [[ $word_count -gt 20 ]]; then
        topology="$SWARM_HIERARCHICAL"
    elif [[ "$task" == *"then"* ]] || [[ "$task" == *"after"* ]]; then
        topology="$SWARM_PIPELINE"
    fi

    local swarm_id=$(create_swarm "$swarm_name" "$topology" "$task")

    # Always start with planning
    add_agent_to_swarm "$swarm_id" "sparc" "Orchestrate: $task"

    # Add specialists based on task analysis
    if [[ $has_security -gt 0 ]]; then
        add_agent_to_swarm "$swarm_id" "security-auditor" "Security analysis: $task"
    fi

    if [[ $has_performance -gt 0 ]]; then
        add_agent_to_swarm "$swarm_id" "performance-optimizer" "Performance optimization: $task"
    fi

    if [[ $has_ui -gt 0 ]]; then
        add_agent_to_swarm "$swarm_id" "ui-designer" "UI design: $task"
    fi

    # Core development agents
    add_agent_to_swarm "$swarm_id" "architect" "Architecture: $task"
    add_agent_to_swarm "$swarm_id" "coder" "Implementation: $task"
    add_agent_to_swarm "$swarm_id" "tester" "Testing: $task"
    add_agent_to_swarm "$swarm_id" "reviewer" "Review: $task"

    echo "$swarm_id"
}

# Export Claude agent functions
export -f create_claude_agent
export -f create_sparc_swarm
export -f create_security_swarm
export -f create_dev_swarm
export -f generate_claude_task
export -f execute_claude_agent
export -f generate_agent_message
export -f route_task
export -f create_adaptive_swarm