# PRISM Agent-Context Mapping Guide

## Overview
This document provides a comprehensive mapping between PRISM agents and their corresponding context elements, ensuring seamless integration between the agent orchestration system and PRISM's context management.

## Context File Structure

```
.prism/
├── context/                  # Core context files
│   ├── patterns.md          # Coding patterns and conventions
│   ├── architecture.md      # System architecture documentation
│   ├── decisions.md         # Architectural decision records (ADRs)
│   ├── standards.md         # Coding standards and guidelines
│   ├── testing.md           # Testing strategies and patterns
│   ├── security.md          # Security protocols and patterns
│   ├── performance.md       # Performance optimization patterns
│   ├── workflows.md         # Development workflows and processes
│   ├── documentation.md     # Documentation standards
│   └── methodology.md       # SPARC and development methodologies
├── templates/               # Reusable templates
│   ├── code/               # Code templates
│   ├── tests/              # Test templates
│   ├── docs/               # Documentation templates
│   └── plans/              # Planning templates
├── metrics/                # Performance and quality metrics
│   ├── performance/        # Performance benchmarks
│   ├── coverage/           # Test coverage reports
│   └── quality/            # Code quality metrics
├── security/               # Security-specific files
│   ├── protocols.md        # Security protocols
│   ├── threats.md          # Threat model
│   └── assessments/        # Security assessment reports
└── agents/                 # Agent system files
    ├── active/            # Currently active agents
    ├── results/           # Agent execution results
    └── swarms/            # Swarm configurations
```

## Agent-to-Context Mapping Matrix

| Agent Type | Primary Context | Secondary Context | Output Location | Templates Used |
|------------|----------------|-------------------|-----------------|----------------|
| **architect** | `architecture.md` | `patterns.md`, `decisions.md` | `context/architecture.md` | `templates/architecture/` |
| **coder** | `patterns.md` | `standards.md`, `style.md` | `context/implementations.md` | `templates/code/` |
| **tester** | `testing.md` | `quality.md`, `coverage.md` | `metrics/coverage/` | `templates/tests/` |
| **reviewer** | `standards.md` | `patterns.md`, `quality.md` | `reviews/` | `quality/checklist.md` |
| **security** | `security.md` | `protocols.md`, `threats.md` | `security/assessments/` | `security/audit-template.md` |
| **performance** | `performance.md` | `metrics.md`, `optimization.md` | `metrics/performance/` | `templates/benchmark/` |
| **documenter** | `documentation.md` | `standards.md`, `patterns.md` | `docs/` | `templates/docs/` |
| **planner** | `workflows.md` | `methodology.md`, `roadmap.md` | `planning/` | `templates/plans/` |
| **sparc** | **ALL** | Full context access | `sparc/` | All templates |
| **debugger** | `patterns.md` | `errors.md`, `logs.md` | `debugging/` | `templates/debug/` |
| **refactorer** | `patterns.md` | `standards.md`, `quality.md` | `refactoring/` | `templates/refactor/` |
| **integrator** | `architecture.md` | `apis.md`, `contracts.md` | `integration/` | `templates/integration/` |

## Context Access Patterns

### Read Access
All agents have read access to:
- Core context files (`patterns.md`, `architecture.md`, `decisions.md`)
- Their specialized context files
- Previous agent results
- Project configuration

### Write Access
Agents can write to:
- Their designated output locations
- Temporary working directories
- Message queues for inter-agent communication
- Context update proposals (require review)

### Update Patterns
1. **Direct Update**: Security and performance agents can directly update their metrics
2. **Proposal Update**: Architecture changes go through review
3. **Append Update**: Decisions and patterns are appended, not overwritten
4. **Versioned Update**: Major context changes create versions

## Agent Context Loading Sequence

### 1. Initialization Phase
```bash
# Agent loads core context
CONTEXT_PATTERNS=$(cat .prism/context/patterns.md)
CONTEXT_ARCHITECTURE=$(cat .prism/context/architecture.md)
CONTEXT_DECISIONS=$(cat .prism/context/decisions.md)
```

### 2. Specialization Phase
```bash
# Agent loads specialized context based on type
case $AGENT_TYPE in
    architect)
        SPECIAL_CONTEXT=$(cat .prism/context/architecture.md)
        TEMPLATES=$(ls .prism/templates/architecture/)
        ;;
    coder)
        SPECIAL_CONTEXT=$(cat .prism/context/patterns.md)
        TEMPLATES=$(ls .prism/templates/code/)
        ;;
    # ... other agents
esac
```

### 3. Execution Phase
```bash
# Agent uses context during execution
apply_patterns "$CONTEXT_PATTERNS"
follow_architecture "$CONTEXT_ARCHITECTURE"
respect_decisions "$CONTEXT_DECISIONS"
use_templates "$TEMPLATES"
```

### 4. Update Phase
```bash
# Agent updates context with findings
update_context "patterns" "$NEW_PATTERNS"
update_context "decisions" "$NEW_DECISIONS"
update_metrics "$PERFORMANCE_DATA"
```

## Context Integration Examples

### Example 1: Architecture Agent
```yaml
Agent: architect
Task: Design microservice for user authentication

Context Loading:
  - architecture.md: Existing system structure
  - patterns.md: Service design patterns
  - decisions.md: Previous architectural decisions

Execution:
  1. Analyze existing architecture
  2. Apply established patterns
  3. Design new service following conventions
  4. Document architectural decisions

Output:
  - Updated architecture.md with new service
  - New entry in decisions.md (ADR-001)
  - Service specification in specs/auth-service.md
```

### Example 2: Coder Agent
```yaml
Agent: coder
Task: Implement user authentication service

Context Loading:
  - patterns.md: Coding patterns and conventions
  - standards.md: Code style guidelines
  - templates/code/service.ts: Service template

Execution:
  1. Load service template
  2. Apply coding patterns
  3. Follow style guidelines
  4. Implement with error handling patterns

Output:
  - Implementation in src/services/auth.ts
  - Updated patterns.md with new patterns found
  - Test stubs in tests/services/auth.test.ts
```

### Example 3: Security Agent
```yaml
Agent: security
Task: Audit authentication service

Context Loading:
  - security.md: Security protocols
  - threats.md: Known threat vectors
  - protocols.md: Security check protocols

Execution:
  1. Load security protocols
  2. Check against threat model
  3. Validate security patterns
  4. Generate security report

Output:
  - Security assessment in security/assessments/auth-audit.md
  - Updated threats.md with new vectors
  - Recommendations in security/recommendations.md
```

## Swarm Context Coordination

### Hierarchical Swarm
```
Planner (Coordinator)
├── Reads: workflows.md, methodology.md
├── Writes: planning/task-breakdown.md
│
├── Architect (Worker)
│   ├── Reads: architecture.md + planner output
│   └── Writes: architecture/design.md
│
├── Coder (Worker)
│   ├── Reads: patterns.md + architect output
│   └── Writes: implementations/code.md
│
└── Tester (Worker)
    ├── Reads: testing.md + coder output
    └── Writes: tests/test-plan.md
```

### Pipeline Swarm
```
Architect → Coder → Tester → Reviewer
    ↓         ↓        ↓         ↓
arch.md → code.md → tests.md → review.md

Each agent:
- Reads previous agent's output
- Reads its specialized context
- Writes to its designated location
- Passes results to next agent
```

### Mesh Swarm
```
All agents share:
- Common message queue
- Shared context pool
- Cross-references to outputs
- Real-time updates

Context synchronization through:
- .prism/agents/messages/
- .prism/context/shared/
- .prism/agents/swarms/{swarm_id}/channels/
```

## Context Quality Gates

### Pre-Execution Validation
- Context files exist and are readable
- Templates are available
- Previous dependencies resolved
- Required patterns documented

### Post-Execution Validation
- Output follows patterns
- Context updates are valid
- No conflicts with existing context
- Documentation complete

### Context Merge Rules
1. **Patterns**: New patterns appended, conflicts flagged
2. **Architecture**: Changes require review
3. **Decisions**: New decisions added chronologically
4. **Standards**: Updates require consensus
5. **Metrics**: Automatic aggregation

## Best Practices

### 1. Context Versioning
```bash
# Before major changes
cp .prism/context/architecture.md .prism/context/architecture.md.$(date +%Y%m%d)
```

### 2. Context Validation
```bash
# Validate context integrity
prism context validate

# Check for conflicts
prism context check-conflicts
```

### 3. Context Synchronization
```bash
# Sync context across agents
prism agent sync-context

# Merge agent updates
prism context merge-updates
```

### 4. Context Backup
```bash
# Backup context before swarm execution
prism context backup

# Restore if needed
prism context restore
```

## Troubleshooting Context Issues

### Missing Context
```bash
# Check context availability
ls -la .prism/context/

# Initialize missing context
prism context init
```

### Context Conflicts
```bash
# View conflicts
prism context show-conflicts

# Resolve manually
vim .prism/context/conflicts.md

# Accept resolution
prism context resolve
```

### Context Corruption
```bash
# Validate context files
prism context validate --deep

# Repair corrupted files
prism context repair

# Restore from backup
prism context restore --latest
```

## Advanced Context Features

### Dynamic Context Loading
Agents can dynamically load context based on:
- Task complexity
- Project phase
- Available resources
- Previous execution results

### Context Inheritance
Child agents inherit context from:
- Parent agents in hierarchical swarms
- Previous agents in pipeline swarms
- Shared pool in mesh swarms

### Context Evolution
The system tracks:
- Pattern emergence
- Architecture evolution
- Decision impact
- Standard adoption

### Context Analytics
Monitor:
- Most used patterns
- Context access frequency
- Update patterns
- Agent context correlation

## Integration with Claude Code

When Claude Code activates agents:

1. **Automatic Context Detection**: Claude identifies required context from task
2. **Context Preloading**: Relevant context loaded before agent execution
3. **Context Suggestions**: Claude suggests context updates based on findings
4. **Context Validation**: Automatic validation against PRISM standards
5. **Context Documentation**: Changes documented with rationale

This mapping ensures that every agent has access to the appropriate context, maintains consistency across the codebase, and contributes to the evolution of the project's knowledge base.