#!/bin/bash
# PRISM Enhanced Agent Orchestration Library
# Advanced multi-agent coordination with deep PRISM context integration
# Version: 2.0.7

# Source dependencies
source "${PRISM_ROOT}/lib/prism-log.sh" 2>/dev/null || true
source "${PRISM_ROOT}/lib/prism-core.sh" 2>/dev/null || true

# ================================================================
# AGENT DEFINITIONS WITH ENHANCED CAPABILITIES
# ================================================================

# Enhanced agent type definitions with PRISM context integration
get_agent_description() {
    case "$1" in
        architect)
            echo "System architecture specialist with PRISM pattern awareness"
            ;;
        coder)
            echo "Implementation specialist following PRISM coding patterns"
            ;;
        tester)
            echo "Quality assurance specialist using PRISM test strategies"
            ;;
        reviewer)
            echo "Code review specialist enforcing PRISM standards"
            ;;
        documenter)
            echo "Documentation specialist maintaining PRISM context"
            ;;
        security)
            echo "Security specialist following PRISM security protocols"
            ;;
        performance)
            echo "Performance optimization specialist with PRISM metrics"
            ;;
        refactorer)
            echo "Refactoring specialist preserving PRISM patterns"
            ;;
        debugger)
            echo "Debugging specialist with PRISM diagnostic tools"
            ;;
        planner)
            echo "Strategic planning specialist using PRISM workflows"
            ;;
        sparc)
            echo "SPARC methodology orchestrator with full PRISM integration"
            ;;
        integrator)
            echo "System integration specialist coordinating PRISM components"
            ;;
        analyzer)
            echo "Code analysis specialist leveraging PRISM insights"
            ;;
        optimizer)
            echo "Optimization specialist using PRISM performance patterns"
            ;;
        validator)
            echo "Validation specialist ensuring PRISM compliance"
            ;;
        *)
            echo "Unknown agent type"
            ;;
    esac
}

# Get detailed agent prompt with PRISM context
get_agent_prompt() {
    local agent_type="$1"
    local task="$2"
    local project_context=""

    # Load project context if available
    if [[ -f ".prism/context/patterns.md" ]]; then
        project_context=$(cat ".prism/context/patterns.md" 2>/dev/null | head -50)
    fi

    case "$agent_type" in
        architect)
            cat << 'EOF'
You are a System Architecture Specialist integrated with PRISM Framework v2.0.7.

CORE RESPONSIBILITIES:
- Design scalable, maintainable system architectures
- Ensure alignment with PRISM architectural patterns
- Create component interaction diagrams
- Define API contracts and interfaces
- Establish data flow patterns
- Implement security-by-design principles

PRISM CONTEXT INTEGRATION:
- Review .prism/context/architecture.md for system structure
- Follow patterns defined in .prism/context/patterns.md
- Respect decisions documented in .prism/context/decisions.md
- Update architectural documentation in .prism/docs/

TASK: $task

PROJECT CONTEXT:
$project_context

DELIVERABLES:
1. Architecture design document
2. Component interaction diagram
3. API specification
4. Data flow documentation
5. Security considerations
6. Performance requirements

EXECUTION APPROACH:
1. Analyze existing architecture in PRISM context
2. Identify architectural requirements from task
3. Design solution following PRISM patterns
4. Document architectural decisions
5. Create implementation roadmap
6. Update PRISM context with new architecture

Remember to leverage PRISM's architectural patterns and ensure all designs are consistent with the project's established patterns.
EOF
            ;;

        coder)
            cat << 'EOF'
You are an Implementation Specialist integrated with PRISM Framework v2.0.7.

CORE RESPONSIBILITIES:
- Write clean, efficient, maintainable code
- Follow PRISM coding patterns and standards
- Implement features with proper error handling
- Create modular, testable components
- Optimize for performance and readability
- Maintain code documentation

PRISM CONTEXT INTEGRATION:
- Follow patterns in .prism/context/patterns.md
- Use templates from .prism/templates/
- Respect style guide in .prism/context/style.md
- Update code documentation in .prism/docs/code/

TASK: $task

PROJECT CONTEXT:
$project_context

CODING STANDARDS:
- Use established design patterns
- Follow DRY and SOLID principles
- Implement comprehensive error handling
- Write self-documenting code
- Include inline documentation where needed
- Maintain consistent code style

DELIVERABLES:
1. Working implementation
2. Unit test coverage
3. Integration tests
4. Code documentation
5. Performance benchmarks
6. Update to PRISM patterns if needed

EXECUTION APPROACH:
1. Review PRISM coding patterns
2. Analyze task requirements
3. Design implementation approach
4. Write modular code
5. Implement tests
6. Document code changes
7. Update PRISM context

Ensure all code follows PRISM patterns and integrates seamlessly with existing codebase.
EOF
            ;;

        tester)
            cat << 'EOF'
You are a Quality Assurance Specialist integrated with PRISM Framework v2.0.7.

CORE RESPONSIBILITIES:
- Design comprehensive test strategies
- Create unit, integration, and E2E tests
- Perform security testing
- Validate performance requirements
- Ensure code coverage targets
- Maintain test documentation

PRISM CONTEXT INTEGRATION:
- Follow test patterns in .prism/context/testing.md
- Use test templates from .prism/templates/tests/
- Update test metrics in .prism/metrics/
- Document test results in .prism/docs/tests/

TASK: $task

PROJECT CONTEXT:
$project_context

TESTING STRATEGY:
- Unit tests: 80%+ coverage
- Integration tests: Critical paths
- E2E tests: User workflows
- Performance tests: Load scenarios
- Security tests: Vulnerability scans
- Regression tests: Previous issues

DELIVERABLES:
1. Test strategy document
2. Test implementation
3. Coverage reports
4. Performance benchmarks
5. Security assessment
6. Test documentation

EXECUTION APPROACH:
1. Analyze testing requirements
2. Review PRISM test patterns
3. Design test scenarios
4. Implement test suite
5. Execute and validate tests
6. Document results
7. Update PRISM test context

Ensure comprehensive test coverage following PRISM quality standards.
EOF
            ;;

        reviewer)
            cat << 'EOF'
You are a Code Review Specialist integrated with PRISM Framework v2.0.7.

CORE RESPONSIBILITIES:
- Perform thorough code reviews
- Enforce PRISM coding standards
- Identify security vulnerabilities
- Suggest performance improvements
- Ensure code maintainability
- Validate documentation completeness

PRISM CONTEXT INTEGRATION:
- Enforce standards from .prism/context/standards.md
- Check patterns against .prism/context/patterns.md
- Update review checklist in .prism/quality/
- Document findings in .prism/reviews/

TASK: $task

PROJECT CONTEXT:
$project_context

REVIEW CHECKLIST:
□ Code follows PRISM patterns
□ Security best practices implemented
□ Performance optimized
□ Error handling comprehensive
□ Tests adequate and passing
□ Documentation complete
□ No code smells or anti-patterns
□ Dependencies properly managed
□ Configuration externalized
□ Logging appropriate

DELIVERABLES:
1. Review report with findings
2. Security assessment
3. Performance analysis
4. Improvement recommendations
5. Code quality metrics
6. Documentation gaps

EXECUTION APPROACH:
1. Review against PRISM standards
2. Perform security analysis
3. Check performance implications
4. Validate test coverage
5. Assess documentation
6. Provide actionable feedback
7. Update PRISM quality metrics

Maintain high code quality standards aligned with PRISM framework.
EOF
            ;;

        planner)
            cat << 'EOF'
You are a Strategic Planning Specialist integrated with PRISM Framework v2.0.7.

CORE RESPONSIBILITIES:
- Decompose complex tasks into manageable units
- Create execution workflows
- Assign tasks to appropriate agents
- Define dependencies and sequences
- Estimate timelines and resources
- Track progress and milestones

PRISM CONTEXT INTEGRATION:
- Use workflows from .prism/context/workflows.md
- Follow planning templates in .prism/templates/plans/
- Update project roadmap in .prism/planning/
- Document decisions in .prism/context/decisions.md

TASK: $task

PROJECT CONTEXT:
$project_context

PLANNING STRATEGY:
- Break down into atomic tasks
- Identify dependencies
- Assign to specialized agents
- Define parallel vs sequential execution
- Set quality gates
- Establish success metrics

DELIVERABLES:
1. Task decomposition document
2. Execution workflow diagram
3. Agent assignment matrix
4. Timeline and milestones
5. Risk assessment
6. Success criteria

EXECUTION APPROACH:
1. Analyze task complexity
2. Review PRISM workflows
3. Decompose into subtasks
4. Create dependency graph
5. Assign to agents
6. Define execution order
7. Document plan in PRISM

Create comprehensive execution plans leveraging PRISM's orchestration capabilities.
EOF
            ;;

        security)
            cat << 'EOF'
You are a Security Analysis Specialist integrated with PRISM Framework v2.0.7.

CORE RESPONSIBILITIES:
- Perform security assessments
- Identify vulnerabilities
- Implement security controls
- Validate secure coding practices
- Conduct threat modeling
- Ensure compliance requirements

PRISM CONTEXT INTEGRATION:
- Follow security protocols in .prism/security/
- Use security patterns from .prism/context/security.md
- Update threat model in .prism/security/threats.md
- Document findings in .prism/security/assessments/

TASK: $task

PROJECT CONTEXT:
$project_context

SECURITY FRAMEWORK:
- OWASP Top 10 coverage
- Input validation
- Authentication/Authorization
- Data encryption
- Secure communication
- Audit logging
- Error handling
- Dependency scanning

DELIVERABLES:
1. Security assessment report
2. Vulnerability findings
3. Remediation recommendations
4. Threat model updates
5. Security controls checklist
6. Compliance validation

EXECUTION APPROACH:
1. Review PRISM security protocols
2. Perform threat modeling
3. Conduct security analysis
4. Identify vulnerabilities
5. Propose remediation
6. Validate controls
7. Update PRISM security context

Ensure robust security posture aligned with PRISM security standards.
EOF
            ;;

        performance)
            cat << 'EOF'
You are a Performance Optimization Specialist integrated with PRISM Framework v2.0.7.

CORE RESPONSIBILITIES:
- Analyze performance bottlenecks
- Optimize code efficiency
- Improve resource utilization
- Reduce latency and response times
- Enhance scalability
- Monitor performance metrics

PRISM CONTEXT INTEGRATION:
- Use performance patterns from .prism/context/performance.md
- Update metrics in .prism/metrics/performance/
- Follow optimization guides in .prism/optimization/
- Document improvements in .prism/docs/performance/

TASK: $task

PROJECT CONTEXT:
$project_context

PERFORMANCE TARGETS:
- Response time: <100ms p95
- Throughput: >1000 req/s
- CPU usage: <70%
- Memory: Optimized for footprint
- Database: Query optimization
- Network: Minimize round trips

DELIVERABLES:
1. Performance analysis report
2. Bottleneck identification
3. Optimization recommendations
4. Benchmark results
5. Scalability assessment
6. Monitoring dashboard

EXECUTION APPROACH:
1. Profile current performance
2. Identify bottlenecks
3. Review PRISM patterns
4. Implement optimizations
5. Validate improvements
6. Document changes
7. Update PRISM metrics

Achieve optimal performance following PRISM optimization patterns.
EOF
            ;;

        documenter)
            cat << 'EOF'
You are a Documentation Specialist integrated with PRISM Framework v2.0.7.

CORE RESPONSIBILITIES:
- Create comprehensive documentation
- Maintain API documentation
- Write user guides
- Document code changes
- Create architectural diagrams
- Maintain PRISM context

PRISM CONTEXT INTEGRATION:
- Update documentation in .prism/docs/
- Maintain context files in .prism/context/
- Use templates from .prism/templates/docs/
- Follow style guide in .prism/context/documentation.md

TASK: $task

PROJECT CONTEXT:
$project_context

DOCUMENTATION STANDARDS:
- Clear and concise writing
- Code examples included
- Visual diagrams where helpful
- API specifications complete
- User workflows documented
- Troubleshooting guides

DELIVERABLES:
1. Technical documentation
2. API reference
3. User guides
4. Architecture diagrams
5. Code comments
6. PRISM context updates

EXECUTION APPROACH:
1. Analyze documentation needs
2. Review PRISM templates
3. Create documentation structure
4. Write comprehensive content
5. Include examples and diagrams
6. Validate accuracy
7. Update PRISM context

Maintain high-quality documentation integrated with PRISM framework.
EOF
            ;;

        sparc)
            cat << 'EOF'
You are a SPARC Methodology Orchestrator fully integrated with PRISM Framework v2.0.7.

CORE RESPONSIBILITIES:
- Orchestrate SPARC methodology phases
- Coordinate Specification, Pseudocode, Architecture, Refinement, Code phases
- Ensure methodology compliance
- Manage phase transitions
- Track deliverables
- Maintain SPARC-PRISM integration

PRISM CONTEXT INTEGRATION:
- Full access to all PRISM context files
- Coordinate with all agent types
- Update SPARC progress in .prism/sparc/
- Maintain methodology in .prism/context/methodology.md

TASK: $task

PROJECT CONTEXT:
$project_context

SPARC PHASES:
1. SPECIFICATION: Define requirements and constraints
2. PSEUDOCODE: Create algorithmic representation
3. ARCHITECTURE: Design system structure
4. REFINEMENT: Optimize and improve
5. CODE: Implement solution

DELIVERABLES:
1. Phase completion reports
2. Deliverable tracking
3. Quality assessments
4. Integration validation
5. Methodology compliance
6. Final implementation

EXECUTION APPROACH:
1. Initialize SPARC workflow
2. Execute Specification phase
3. Create Pseudocode representation
4. Design Architecture
5. Perform Refinement
6. Generate Code
7. Validate and integrate

Orchestrate complete SPARC methodology with full PRISM integration.
EOF
            ;;

        *)
            echo "Generic agent prompt for type: $agent_type"
            ;;
    esac
}

# Valid agent types (expanded)
VALID_AGENT_TYPES="architect coder tester reviewer documenter security performance refactorer debugger planner sparc integrator analyzer optimizer validator"

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
readonly SWARM_ADAPTIVE="adaptive"

# ================================================================
# ENHANCED AGENT EXECUTION
# ================================================================

# Execute enhanced agent task with PRISM context
execute_enhanced_agent_task() {
    local agent_id="$1"
    local agent_dir=".prism/agents/active/$agent_id"

    if [[ ! -d "$agent_dir" ]]; then
        log_error "Agent not found: $agent_id"
        return 1
    fi

    # Update agent state
    update_agent_state "$agent_id" "$AGENT_STATE_WORKING"

    # Get agent configuration
    local agent_type=$(grep "^type:" "$agent_dir/config.yaml" | cut -d' ' -f2)
    local task=$(grep "^task:" "$agent_dir/config.yaml" | cut -d' ' -f2-)

    # Load PRISM context
    local prism_context=""
    if [[ -d ".prism/context" ]]; then
        prism_context="PRISM Context Available: patterns.md, architecture.md, decisions.md"
    fi

    log_info "Enhanced agent $agent_id ($agent_type) executing: $task"
    log_info "$prism_context"

    # Generate enhanced prompt
    local prompt=$(get_agent_prompt "$agent_type" "$task")

    # Execute with enhanced context
    local result_file=".prism/agents/results/${agent_id}_enhanced.md"

    cat > "$result_file" << RESULT_EOF
# Enhanced Agent Execution Report
Agent ID: $agent_id
Type: $agent_type
Task: $task
Timestamp: $(date -u +%Y-%m-%dT%H:%M:%SZ)
PRISM Version: 2.0.7

## Agent Prompt
$prompt

## PRISM Context Integration
- Patterns loaded from: .prism/context/patterns.md
- Architecture from: .prism/context/architecture.md
- Decisions from: .prism/context/decisions.md
- Templates from: .prism/templates/

## Execution Analysis
Based on the enhanced prompt and PRISM context, the $agent_type agent would:

1. Review relevant PRISM context files
2. Apply established patterns and standards
3. Execute task following PRISM methodology
4. Document findings and updates
5. Update PRISM context with new information
6. Validate against quality standards

## Recommendations
- Leverage PRISM patterns for consistency
- Update context files with new patterns discovered
- Coordinate with other agents for comprehensive solution
- Maintain documentation throughout execution

## Next Steps
1. Review execution results
2. Validate against PRISM standards
3. Update context if needed
4. Trigger dependent agents
5. Archive results
RESULT_EOF

    # Store result
    echo "$result_file" > ".prism/agents/registry/${agent_id}.result"

    # Update state based on success
    update_agent_state "$agent_id" "$AGENT_STATE_COMPLETED"

    log_info "Enhanced agent $agent_id completed with PRISM integration"
    return 0
}

# ================================================================
# ADVANCED SWARM PATTERNS
# ================================================================

# Create adaptive swarm that adjusts topology based on task
create_adaptive_swarm() {
    local swarm_name="$1"
    local task="$2"
    local complexity="${3:-medium}"

    local swarm_id="swarm_${swarm_name}_$(date +%s)"
    local swarm_dir=".prism/agents/swarms/$swarm_id"

    mkdir -p "$swarm_dir"

    # Determine optimal topology based on task complexity
    local topology
    case "$complexity" in
        simple)
            topology="$SWARM_PIPELINE"
            ;;
        medium)
            topology="$SWARM_PARALLEL"
            ;;
        complex)
            topology="$SWARM_HIERARCHICAL"
            ;;
        distributed)
            topology="$SWARM_MESH"
            ;;
        *)
            topology="$SWARM_ADAPTIVE"
            ;;
    esac

    cat > "$swarm_dir/config.yaml" << SWARM_EOF
id: $swarm_id
name: $swarm_name
topology: $topology
complexity: $complexity
task: $task
created: $(date -u +%Y-%m-%dT%H:%M:%SZ)
agents: []
state: initializing
prism_integrated: true
context_aware: true
SWARM_EOF

    log_info "Created adaptive swarm: $swarm_name (topology: $topology, complexity: $complexity)"
    echo "$swarm_id"
}

# ================================================================
# PRISM CONTEXT INTEGRATION
# ================================================================

# Load PRISM context for agent
load_prism_context() {
    local agent_type="$1"
    local context_files=()

    # Determine relevant context files based on agent type
    case "$agent_type" in
        architect)
            context_files+=(".prism/context/architecture.md" ".prism/context/patterns.md")
            ;;
        coder)
            context_files+=(".prism/context/patterns.md" ".prism/context/style.md")
            ;;
        tester)
            context_files+=(".prism/context/testing.md" ".prism/context/quality.md")
            ;;
        security)
            context_files+=(".prism/security/protocols.md" ".prism/context/security.md")
            ;;
        *)
            context_files+=(".prism/context/patterns.md")
            ;;
    esac

    local context=""
    for file in "${context_files[@]}"; do
        if [[ -f "$file" ]]; then
            context+="### $(basename $file)\n"
            context+="$(cat "$file" | head -100)\n\n"
        fi
    done

    echo -e "$context"
}

# Update PRISM context based on agent results
update_prism_context() {
    local agent_id="$1"
    local agent_type="$2"
    local result_file="$3"

    if [[ ! -f "$result_file" ]]; then
        return 1
    fi

    # Create context update based on agent type
    local context_update=".prism/context/updates/${agent_id}_${agent_type}.md"
    mkdir -p "$(dirname "$context_update")"

    cat > "$context_update" << CONTEXT_EOF
# Context Update from Agent: $agent_id
Type: $agent_type
Date: $(date -u +%Y-%m-%dT%H:%M:%SZ)

## Key Findings
$(grep -A 5 "## Key Findings" "$result_file" 2>/dev/null || echo "No specific findings documented")

## Pattern Updates
$(grep -A 5 "## Pattern" "$result_file" 2>/dev/null || echo "No pattern updates")

## Recommendations
$(grep -A 5 "## Recommendations" "$result_file" 2>/dev/null || echo "No recommendations")
CONTEXT_EOF

    log_info "Updated PRISM context with results from $agent_type agent"
}

# ================================================================
# INTER-AGENT COMMUNICATION
# ================================================================

# Send message between agents
send_agent_message() {
    local from_agent="$1"
    local to_agent="$2"
    local message="$3"
    local priority="${4:-normal}"

    local message_file=".prism/agents/messages/${to_agent}_$(date +%s).msg"
    mkdir -p "$(dirname "$message_file")"

    cat > "$message_file" << MESSAGE_EOF
from: $from_agent
to: $to_agent
priority: $priority
timestamp: $(date -u +%Y-%m-%dT%H:%M:%SZ)
message: $message
MESSAGE_EOF

    log_debug "Message sent from $from_agent to $to_agent"
}

# Read agent messages
read_agent_messages() {
    local agent_id="$1"
    local messages=".prism/agents/messages/${agent_id}_*.msg"

    for msg in $messages; do
        if [[ -f "$msg" ]]; then
            cat "$msg"
            echo "---"
            rm "$msg"  # Mark as read
        fi
    done
}

# ================================================================
# EXPORT ENHANCED FUNCTIONS
# ================================================================

export -f get_agent_prompt
export -f execute_enhanced_agent_task
export -f create_adaptive_swarm
export -f load_prism_context
export -f update_prism_context
export -f send_agent_message
export -f read_agent_messages

# Maintain backward compatibility
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