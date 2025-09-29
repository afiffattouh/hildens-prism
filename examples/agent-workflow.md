# PRISM Agent Orchestration Examples

## Quick Start

Initialize the agent system in your project:

```bash
# Initialize PRISM with agent support
prism init
prism agent init
```

## Example 1: Simple Task with Single Agent

Create a coder agent to implement a feature:

```bash
# Create a coder agent
prism agent create coder feature_impl "Implement user authentication"

# Execute the agent task
prism agent execute agent_feature_impl_<timestamp>

# View results
prism agent result agent_feature_impl_<timestamp>
```

## Example 2: SPARC Workflow for Complex Feature

Use the SPARC methodology for systematic development:

```bash
# Create a SPARC swarm for complete feature development
SWARM_ID=$(prism agent swarm create sparc_auth "User authentication system")

# Add agents in SPARC sequence
prism agent swarm add $SWARM_ID spec-writer "Define auth requirements"
prism agent swarm add $SWARM_ID architect "Design auth architecture"
prism agent swarm add $SWARM_ID pseudocoder "Create auth algorithms"
prism agent swarm add $SWARM_ID coder "Implement auth system"
prism agent swarm add $SWARM_ID tester "Test auth implementation"

# Execute the pipeline
prism agent swarm execute $SWARM_ID
```

## Example 3: Parallel Security Audit

Run multiple security checks simultaneously:

```bash
# Create parallel swarm for security audit
SWARM_ID=$(prism agent swarm create security_audit parallel "Audit application security")

# Add security specialists
prism agent swarm add $SWARM_ID security-auditor "OWASP vulnerability scan"
prism agent swarm add $SWARM_ID security-auditor "Authentication audit"
prism agent swarm add $SWARM_ID security-auditor "Data encryption review"
prism agent swarm add $SWARM_ID reviewer "Security code review"

# Execute all agents in parallel
prism agent swarm execute $SWARM_ID
```

## Example 4: Hierarchical Development Team

Create a hierarchical swarm with coordinator and workers:

```bash
# Create hierarchical swarm
SWARM_ID=$(prism agent swarm create dev_team hierarchical "Develop payment module")

# Add coordinator (runs first)
prism agent swarm add $SWARM_ID sparc "Coordinate payment module development"

# Add worker agents (run in parallel after coordinator)
prism agent swarm add $SWARM_ID architect "Design payment architecture"
prism agent swarm add $SWARM_ID coder "Implement payment logic"
prism agent swarm add $SWARM_ID tester "Create payment tests"
prism agent swarm add $SWARM_ID documenter "Document payment API"

# Execute hierarchical workflow
prism agent swarm execute $SWARM_ID
```

## Example 5: Task Decomposition

Let PRISM decompose a complex task automatically:

```bash
# Decompose complex task
AGENTS=$(prism agent decompose "Build a complete e-commerce checkout system with payment processing, inventory management, and order tracking")

# This returns suggested agents:
# planner architect coder tester reviewer documenter

# Create swarm with suggested agents
SWARM_ID=$(prism agent swarm create auto_checkout pipeline "E-commerce checkout")

for agent in $AGENTS; do
    prism agent swarm add $SWARM_ID $agent "Work on checkout system"
done

prism agent swarm execute $SWARM_ID
```

## Claude Code Integration

When using with Claude Code, agents provide structured instructions:

```markdown
# In Claude Code, trigger multi-agent workflow
"I need to implement a complete user authentication system with JWT, 2FA, and social login"

# PRISM will orchestrate:
1. Specification agent → Define requirements
2. Architecture agent → Design system
3. Security agent → Security requirements
4. Coder agent → Implementation
5. Tester agent → Test suite
6. Reviewer agent → Code review
7. Documenter agent → API docs
```

## Advanced Patterns

### Pattern 1: Continuous Integration Pipeline

```bash
# CI/CD pipeline with agents
SWARM_ID=$(prism agent swarm create ci_pipeline pipeline "CI/CD workflow")

prism agent swarm add $SWARM_ID tester "Run unit tests"
prism agent swarm add $SWARM_ID security-auditor "Security scan"
prism agent swarm add $SWARM_ID performance-optimizer "Performance check"
prism agent swarm add $SWARM_ID devops "Deploy to staging"

prism agent swarm execute $SWARM_ID
```

### Pattern 2: Code Refactoring Team

```bash
# Refactoring swarm
SWARM_ID=$(prism agent swarm create refactor_team parallel "Refactor legacy module")

prism agent swarm add $SWARM_ID reviewer "Analyze code quality"
prism agent swarm add $SWARM_ID refactorer "Refactor code"
prism agent swarm add $SWARM_ID tester "Regression testing"
prism agent swarm add $SWARM_ID performance-optimizer "Optimize performance"

prism agent swarm execute $SWARM_ID
```

### Pattern 3: Bug Fix Squad

```bash
# Debug team for critical bug
SWARM_ID=$(prism agent swarm create debug_squad mesh "Fix critical production bug")

prism agent swarm add $SWARM_ID debugger "Identify root cause"
prism agent swarm add $SWARM_ID coder "Implement fix"
prism agent swarm add $SWARM_ID tester "Verify fix"
prism agent swarm add $SWARM_ID reviewer "Review changes"

prism agent swarm execute $SWARM_ID
```

## Monitoring and Management

### List Active Agents
```bash
prism agent list
```

### View Agent Results
```bash
prism agent result <agent_id>
```

### Clean Up Completed Agents
```bash
prism agent cleanup
```

## Agent Types Reference

| Agent Type | Specialization | Best For |
|------------|---------------|----------|
| sparc | Orchestration | Complex multi-step tasks |
| architect | System design | Architecture decisions |
| coder | Implementation | Writing code |
| tester | Quality assurance | Testing strategies |
| reviewer | Code review | Quality checks |
| security-auditor | Security | Vulnerability assessment |
| performance-optimizer | Performance | Optimization |
| refactorer | Code improvement | Refactoring |
| debugger | Bug fixing | Troubleshooting |
| documenter | Documentation | API docs, guides |
| devops | Deployment | CI/CD, infrastructure |

## Topology Patterns

| Topology | Execution | Use Case |
|----------|-----------|----------|
| parallel | All agents simultaneously | Independent tasks |
| pipeline | Sequential execution | Dependent steps |
| hierarchical | Coordinator then workers | Complex coordination |
| mesh | Inter-agent communication | Collaborative tasks |

## Best Practices

1. **Start with SPARC** for complex features
2. **Use parallel** for independent analysis tasks
3. **Use pipeline** for sequential workflows
4. **Use hierarchical** for team coordination
5. **Decompose tasks** before creating swarms
6. **Monitor agent results** for quality
7. **Clean up** completed agents regularly

## Integration with PRISM Context

Agents automatically use PRISM context:
- `.prism/context/patterns.md` - Coding standards
- `.prism/context/architecture.md` - System design
- `.prism/context/decisions.md` - Technical decisions
- `.prism/context/security.md` - Security requirements
- `.prism/context/performance.md` - Performance baselines

## Troubleshooting

### Agent Stuck in Working State
```bash
# Check agent status
cat .prism/agents/active/<agent_id>/config.yaml

# Force cleanup if needed
prism agent cleanup
```

### Swarm Execution Failed
```bash
# Check swarm logs
cat .prism/agents/swarms/<swarm_id>/config.yaml

# Review individual agent results
ls .prism/agents/results/
```

### No Results Generated
```bash
# Verify agent executed
prism agent list

# Check result directory
ls -la .prism/agents/results/
```

---
*PRISM Agent Orchestration System v2.0.5*