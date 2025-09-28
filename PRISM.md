# PRISM.md - Persistent Real-time Intelligent System Management Framework

> **Enterprise-Grade AI Development Workflow for Claude Code**

## 🚀 Initialization Protocol

### On Framework Start
```yaml
initialization_sequence:
  1_time_sync:
    action: WebSearch "current UTC time"
    validate: Compare with system time
    alert: If drift >5 minutes
    use: Most accurate source
    log: .prism/sessions/.time_sync

  2_context_load:
    check: .prism/index.yaml exists
    load: CRITICAL priority items
    restore: sessions/current.md
    verify: Dependencies up to date

  3_environment_check:
    project: Detect framework/language
    git: Check repository status
    tools: Verify available tools
    permissions: Validate file access

  4_session_start:
    timestamp: Use synchronized time
    context: Load relevant patterns
    history: Archive previous if exists
    ready: Signal initialization complete
```

### Time Synchronization Commands
```markdown
# PRISM should execute on init:
1. WebSearch: "current UTC time"
2. WebSearch: "timezone [user location]"
3. Calculate offset from system time
4. Use web time for all timestamps
5. Log sync results to .prism/sessions/.time_sync
```

## 🎯 Core Development Principles

### Architecture-First Development
- **HUMANS** decide WHAT and WHY | **AI** implements HOW
- **DEFINE** interfaces before implementation
- **MAINTAIN** clear system boundaries
- **USE** existing patterns as reference
- **VALIDATE** against specifications

### Evidence-Based Practices
- **45%** of AI code contains vulnerabilities - review everything
- **MEASURE** before optimizing
- **VALIDATE** against requirements
- **DOCUMENT** AI contributions
- **TRACK** metrics and improvements

## 🛡️ Security Standards

### Critical Review Points
```yaml
priority_1_sql_injection: Parameterize all queries
priority_2_xss: Sanitize all user inputs
priority_3_auth: Manual review required
priority_4_crypto: Never AI-generate encryption
priority_5_logs: No sensitive data exposure
priority_6_deps: Scan all dependencies
priority_7_secrets: Never commit credentials
```

### Vulnerability Prevention
- **SCAN** OWASP Top 10 on every commit
- **VALIDATE** input boundaries explicitly
- **REVIEW** auth logic manually (86% fail rate)
- **TEST** adversarial inputs
- **AUDIT** error messages for data leaks
- **MONITOR** dependencies for CVEs
- **ENFORCE** least privilege principle

## 🧠 Context Management System

### Directory Structure
```
.prism/
├── context/
│   ├── architecture.md      # System design decisions
│   ├── patterns.md          # Code patterns & conventions
│   ├── decisions.md         # Technical decisions & rationale
│   ├── dependencies.md      # External libraries & versions
│   ├── domain.md           # Business logic & rules
│   ├── security.md         # Security requirements & policies
│   └── performance.md      # Performance baselines & targets
├── sessions/
│   ├── current.md          # Active session context
│   ├── .time_sync          # Time synchronization log
│   └── archive/            # Previous session summaries
├── references/
│   ├── api-contracts.yaml  # API specifications
│   ├── data-models.json    # Schema definitions
│   ├── security-rules.md   # Security requirements
│   └── test-scenarios.md   # Test coverage maps
├── workflows/
│   ├── development.md      # Development workflow
│   ├── review.md          # Code review checklist
│   └── deployment.md      # Deployment procedures
└── index.yaml              # Context retrieval index
```

### Context File Format
```markdown
# [Component/Feature Name]
**Last Updated**: [ISO timestamp]
**Priority**: CRITICAL | HIGH | MEDIUM | LOW
**Tags**: [searchable, keywords, here]
**Status**: ACTIVE | ARCHIVED | DEPRECATED

## Summary
Brief description for quick reference

## Details
Comprehensive information

## Decisions
- Why this approach was chosen
- Alternatives considered
- Trade-offs accepted

## Related
- Links to other context files
- Related code files with line numbers
- External documentation

## AI Instructions
- Specific patterns to follow
- Constraints to enforce
- Examples to reference
```

### Context Retrieval Protocol
```yaml
on_session_start:
  1. Load .prism/index.yaml
  2. Scan priority: CRITICAL items
  3. Check current.md for active context
  4. Import relevant patterns.md sections
  5. Verify time synchronization

on_task_begin:
  1. Query context by tags/keywords
  2. Load related context files
  3. Update current.md with task info
  4. Reference domain.md for business rules
  5. Check security.md for constraints

on_task_complete:
  1. Update relevant context files
  2. Archive session to archive/
  3. Update index.yaml with new references
  4. Prune stale context (>30 days)
  5. Generate session summary
```

## 📋 Development Workflow

### Task Decomposition Pattern
```
1. ANALYZE → Understand requirements fully
2. BREAK → Single responsibility (3-5 entities max)
3. DEFINE → Exact libraries, frameworks, constraints
4. GENERATE → Focus on one layer/component
5. REVIEW → Security, performance, patterns
6. INTEGRATE → Validate boundaries
7. TEST → 85% coverage minimum
8. DOCUMENT → Update context files
```

### Progressive Enhancement
1. **Basic** → Working functionality
2. **Secure** → Input validation, error handling
3. **Optimize** → Performance profiling
4. **Test** → Comprehensive coverage
5. **Refactor** → Maintainability
6. **Document** → Context and patterns

### Context Management Commands
```bash
# Initialize new project with PRISM
prism init

# Add context entry
prism context add --priority HIGH --tags "auth,security"

# Query context
prism context query "authentication"

# Start new session
prism session start "feature-name"

# Archive current session
prism session archive

# Export context for sharing
prism context export --format markdown
```

## ✅ Quality Gates

### Generation Standards
```yaml
coverage:
  unit_tests: 85%
  security_paths: 100%
  integration: All boundaries
  performance: All endpoints
  documentation: All public APIs

complexity:
  cyclomatic: <10
  cognitive: <15
  nesting: <4
  file_size: <300 lines
  function_size: <50 lines

performance:
  api_response: <200ms
  page_load: <3s
  bundle_size: <500KB
  memory: <100MB mobile
  database_query: <100ms
```

### Review Checklist
- [ ] Matches existing patterns
- [ ] No generic solutions
- [ ] Security validated
- [ ] Performance profiled
- [ ] Tests comprehensive
- [ ] Documentation clear
- [ ] Context files updated
- [ ] Dependencies scanned

## 🔧 Tool Configuration

### Prompt Engineering Templates
```markdown
CONTEXT: [Framework, Stack, Patterns from .prism/context/]
TASK: [Specific action, inputs, outputs]
CONSTRAINTS: [Security from .prism/context/security.md]
PATTERNS: [Reference from .prism/context/patterns.md]
REASONING: [Step-by-step for complex tasks]
EXAMPLES: [From .prism/references/]
```

### Effective Patterns
- **Chain-of-Thought**: Complex problem solving
- **Few-Shot**: Provide 2-3 examples from context
- **Iterative**: Refine in stages
- **Contextual**: Include surrounding code
- **Validated**: Test against specifications

## 📊 Testing Requirements

### Test-Driven AI Development
1. **AI generates** test scenarios from specs
2. **Human validates** edge cases and coverage
3. **AI implements** to pass tests
4. **Automated** feedback loop
5. **Human reviews** critical paths
6. **Update** test-scenarios.md

### Specialized Testing
- **Adversarial**: Malicious input resistance
- **Privacy**: PII handling validation
- **Performance**: Load, stress, endurance
- **Integration**: Boundary contracts
- **Regression**: Automated suite
- **Security**: Penetration testing

## 📝 Documentation Standards

### Code Documentation
```javascript
// Why: Explains decision rationale (not what)
// AI-Assumption: Documents AI limitations
// Alternative: Other approaches considered
// Context: References .prism/context/ files
// Ratio: 1 comment per 3-5 complex lines
```

### Commit Attribution
```bash
feat: implement user auth (AI-assisted)

- Tool: Claude Code v1.x
- Context: .prism/context/auth.md
- Reviewer: [name]
- Modified: [specific changes]

Prompt: "implement JWT auth with refresh"
PRISM Session: 2025-09-28-001
```

## 🔄 Session Management

### Session Lifecycle
```yaml
session_start:
  - Generate session ID
  - Create current.md
  - Load relevant context
  - Initialize metrics

session_active:
  - Track all operations
  - Update context real-time
  - Monitor quality metrics
  - Maintain audit trail

session_end:
  - Generate summary
  - Archive to sessions/archive/
  - Update context files
  - Calculate metrics
  - Prune old sessions
```

### Session Commands
```bash
# Start new session
prism session start "feature-description"

# Check session status
prism session status

# Archive current session
prism session archive

# Restore previous session
prism session restore [session-id]

# Export session report
prism session export
```

## 🚨 Red Flags & Warnings

### NEVER Use AI For
- ❌ Cryptographic implementations
- ❌ Financial calculations
- ❌ Regulatory compliance
- ❌ Safety-critical systems
- ❌ PII without review
- ❌ Production credentials
- ❌ Security architecture

### Context Corruption Signs
- Repetitive patterns
- Degrading quality
- Incorrect references
- Mixing concerns
- Outdated information
- → **ACTION**: `prism session refresh`

## 📈 Metrics & Monitoring

### Track Success
```yaml
quality:
  defect_rate: <5%
  tech_debt: <20%
  maintainability: >60
  test_coverage: >85%

velocity:
  time_to_market: -25%
  review_time: -70%
  bug_fix_time: -50%
  context_reuse: >40%

adoption:
  ai_success_rate: >80%
  intervention_rate: <20%
  coverage_achieved: >85%
  pattern_compliance: >90%

security:
  vulnerability_rate: <1%
  review_completion: 100%
  dependency_scan: 100%
```

### Continuous Improvement
- **Daily**: Monitor generation quality
- **Weekly**: Review patterns/anti-patterns
- **Monthly**: Security/performance audit
- **Quarterly**: Framework updates
- **Per-Session**: Context optimization

## ⚡ Performance Optimization

### AI Code Characteristics
- Simpler patterns (higher cyclomatic complexity)
- Resource intensive operations
- Generic solutions needing specialization
- → **PROFILE** everything

### Optimization Process
1. **Benchmark** current performance
2. **Profile** bottlenecks with tools
3. **Optimize** critical paths only
4. **Validate** improvements
5. **Monitor** for regression
6. **Document** in performance.md

## 🔐 Compliance & Governance

### Regulatory Alignment
- **Document** AI usage transparently
- **Audit** trails for all generation
- **Comply** with EU AI Act
- **Report** incidents promptly
- **Maintain** human oversight
- **Archive** all sessions

### Risk Management (NIST)
- **GOVERN**: Establish culture and policies
- **MAP**: Identify and document risks
- **MEASURE**: Quantify metrics and impact
- **MANAGE**: Allocate resources and mitigate

## 🏁 Implementation Guide

### Quick Start
```bash
# Install PRISM
curl -fsSL https://raw.githubusercontent.com/afiffattouh/hildens-prism/main/install.sh | bash

# Initialize project
cd your-project
prism init

# Start development session
prism session start "implement user authentication"

# Claude Code will now:
# 1. Load context automatically
# 2. Follow patterns from .prism/context/
# 3. Update context as you work
# 4. Maintain session history
```

### Project Types
```bash
# Web application
prism init --template webapp

# API service
prism init --template api

# Mobile app
prism init --template mobile

# Microservice
prism init --template microservice

# Custom configuration
prism init --custom
```

### Integration with Claude Code
When Claude Code starts a session:
1. **Reads** `.prism/index.yaml` for context map
2. **Loads** CRITICAL priority items automatically
3. **Restores** last session from `current.md`
4. **Follows** patterns in `.prism/context/patterns.md`
5. **Enforces** security from `.prism/context/security.md`
6. **Updates** context as development progresses
7. **Archives** sessions for future reference

## 🤖 Multi-Agent Workflows

### Automatic Agent Spawning
Claude Code's Task tool automatically creates specialized agents based on task complexity.

### Agent Types (Auto-Created)
1. **Requirements Analyst**: Clarifies specifications
2. **Architecture Designer**: System structure
3. **Code Generator**: Implementation
4. **Security Scanner**: Vulnerability detection
5. **Test Generator**: Coverage validation
6. **Code Reviewer**: Standards compliance
7. **Documentation Writer**: Context updates

### Triggering Multi-Agent Flows
```markdown
# Complex task → Claude spawns multiple agents
"Implement complete user authentication system"
→ Requirements → Architecture → Security → Implementation → Testing

# Parallel analysis → Concurrent agents
"Audit this codebase for security and performance"
→ [Security Agent || Performance Agent || Quality Agent]

# Review workflow → Sequential agents
"Review and refactor the payment module"
→ Analyzer → Refactorer → Tester → Documenter
```

## 🔄 Update & Maintenance

### Framework Updates
```bash
# Check for updates
prism update --check

# Update PRISM
prism update

# Update context templates
prism context update-templates

# Clean old sessions
prism session clean --days 30
```

### Best Practices
1. **Update** context files after major changes
2. **Archive** sessions weekly
3. **Review** patterns monthly
4. **Audit** security quarterly
5. **Optimize** performance as needed
6. **Share** learnings with team

---

**Remember**: AI augments, never replaces engineering judgment. PRISM ensures disciplined implementation within structured frameworks.

**Context is King**: The `.prism/` directory maintains your project's memory across AI sessions.

**Success Formula**: Clear Context + Structured Workflow + Human Oversight = Quality Output

*This document is your source of truth. Update quarterly based on learnings.*