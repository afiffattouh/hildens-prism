# PRISM.md - Persistent Real-time Intelligent Security Management Framework

## 🚀 Initialization Protocol

### On Framework Start
```yaml
initialization_sequence:
  1_time_sync:
    action: WebSearch "current UTC time"
    validate: Compare with system time
    alert: If drift >5 minutes
    use: Most accurate source
    log: .claude/.time_sync

  2_context_load:
    check: .claude/index.yaml exists
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
5. Log sync results to .claude/.time_sync
```

## 🎯 Core Principles

### Architecture-First Development
- **HUMANS** decide WHAT and WHY | **AI** implements HOW
- **DEFINE** interfaces before implementation
- **MAINTAIN** clear system boundaries
- **USE** existing patterns as reference

### Evidence-Based Practices
- **45%** of AI code contains vulnerabilities - review everything
- **MEASURE** before optimizing
- **VALIDATE** against requirements
- **DOCUMENT** AI contributions

## 🛡️ Security Standards

### Critical Review Points
```yaml
priority_1_sql_injection: Parameterize all queries
priority_2_xss: Sanitize all user inputs
priority_3_auth: Manual review required
priority_4_crypto: Never AI-generate encryption
priority_5_logs: No sensitive data exposure
```

### Vulnerability Prevention
- **SCAN** OWASP Top 10 on every commit
- **VALIDATE** input boundaries explicitly
- **REVIEW** auth logic manually (86% fail rate)
- **TEST** adversarial inputs
- **AUDIT** error messages for data leaks

## 📋 Development Workflow

### Task Decomposition Pattern
```
1. BREAK → Single responsibility (3-5 entities max)
2. DEFINE → Exact libraries, frameworks, constraints
3. GENERATE → Focus on one layer/component
4. REVIEW → Security, performance, patterns
5. INTEGRATE → Validate boundaries
6. TEST → 85% coverage minimum
```

### Progressive Enhancement
1. **Basic** → Working functionality
2. **Secure** → Input validation, error handling
3. **Optimize** → Performance profiling
4. **Test** → Comprehensive coverage
5. **Refactor** → Maintainability

### Context Management
- `/clear` frequently (prevent drift)
- **RESTART** sessions every 5-10 operations
- **LIMIT** scope to prevent hallucination
- **REFERENCE** existing code patterns

## ✅ Quality Gates

### Generation Standards
```yaml
coverage:
  unit_tests: 85%
  security_paths: 100%
  integration: All boundaries
  performance: All endpoints

complexity:
  cyclomatic: <10
  cognitive: <15
  nesting: <4
  file_size: <300 lines

performance:
  api_response: <200ms
  page_load: <3s
  bundle_size: <500KB
  memory: <100MB mobile
```

### Review Checklist
- [ ] Matches existing patterns
- [ ] No generic solutions
- [ ] Security validated
- [ ] Performance profiled
- [ ] Tests comprehensive
- [ ] Documentation clear

## 🔧 Tool Configuration

### Prompt Engineering
```markdown
CONTEXT: [Framework, Stack, Patterns]
TASK: [Specific action, inputs, outputs]
CONSTRAINTS: [Security, Performance, Style]
REASONING: [Step-by-step for complex tasks]
EXAMPLES: [Reference implementations]
```

### Effective Patterns
- **Chain-of-Thought**: Complex problem solving
- **Few-Shot**: Provide 2-3 examples
- **Iterative**: Refine in stages
- **Contextual**: Include surrounding code

## 📊 Testing Requirements

### Test-Driven AI Development
1. **AI generates** test scenarios
2. **Human validates** edge cases
3. **AI implements** to pass tests
4. **Automated** feedback loop
5. **Human reviews** coverage

### Specialized Testing
- **Adversarial**: Malicious input resistance
- **Privacy**: PII handling validation
- **Performance**: Load, stress, endurance
- **Integration**: Boundary contracts
- **Regression**: Automated suite

## 📝 Documentation Standards

### Code Documentation
```javascript
// Why: Explains decision rationale (not what)
// AI-Assumption: Documents AI limitations
// Alternative: Other approaches considered
// Ratio: 1 comment per 3-5 complex lines
```

### Commit Attribution
```bash
feat: implement user auth (AI-assisted)

- Tool: Claude Code v1.x
- Reviewer: [name]
- Modified: [specific changes]

Prompt: "implement JWT auth with refresh"
```

## 🚨 Red Flags & Warnings

### NEVER Use AI For
- ❌ Cryptographic implementations
- ❌ Financial calculations
- ❌ Regulatory compliance
- ❌ Safety-critical systems
- ❌ PII without review

### Context Corruption Signs
- Repetitive patterns
- Degrading quality
- Incorrect references
- Mixing concerns
- → **ACTION**: `/clear` and restart

## 📈 Metrics & Monitoring

### Track Success
```yaml
quality:
  defect_rate: <5%
  tech_debt: <20%
  maintainability: >60

velocity:
  time_to_market: -25%
  review_time: -70%
  bug_fix_time: -50%

adoption:
  ai_success_rate: >80%
  intervention_rate: <20%
  coverage_achieved: >85%
```

### Continuous Improvement
- **Daily**: Monitor generation quality
- **Weekly**: Review patterns/anti-patterns
- **Monthly**: Security/performance audit
- **Quarterly**: Framework updates

## 🧠 Context Management System

### File-Based Knowledge Base
Maintain persistent context across sessions using structured files optimized for AI retrieval.

### Initialization & Time Sync
```yaml
on_init:
  1. Web search: "current time UTC"
  2. Verify: timezone and date accuracy
  3. Set: system timestamp baseline
  4. Log: initialization time to context

timestamp_sources:
  primary: WebSearch for "current UTC time"
  fallback: System time if web unavailable
  format: ISO 8601 (YYYY-MM-DDTHH:mm:ssZ)

validation:
  - Compare web time with system time
  - Alert if drift >5 minutes
  - Use most accurate source
```

### Directory Structure
```
.claude/
├── context/
│   ├── architecture.md      # System design decisions
│   ├── patterns.md          # Code patterns & conventions
│   ├── decisions.md         # Technical decisions & rationale
│   ├── dependencies.md      # External libraries & versions
│   └── domain.md           # Business logic & rules
├── sessions/
│   ├── current.md          # Active session context
│   └── history/            # Previous session summaries
├── references/
│   ├── api-contracts.yaml  # API specifications
│   ├── data-models.json    # Schema definitions
│   └── security-rules.md   # Security requirements
└── index.yaml              # Context retrieval index
```

### Context File Format
```markdown
# [Component/Feature Name]
**Last Updated**: [ISO timestamp]
**Priority**: CRITICAL | HIGH | MEDIUM | LOW
**Tags**: [searchable, keywords, here]

## Summary
Brief description for quick reference

## Details
Comprehensive information

## Related
- Links to other context files
- Related code files with line numbers
- External documentation

## Decisions
- Why this approach was chosen
- Alternatives considered
- Trade-offs accepted
```

### Context Retrieval Protocol
```yaml
on_session_start:
  1. Load .claude/index.yaml
  2. Scan priority: CRITICAL items
  3. Check current.md for active context
  4. Import relevant patterns.md sections

on_task_begin:
  1. Query context by tags/keywords
  2. Load related context files
  3. Update current.md with task info
  4. Reference domain.md for business rules

on_task_complete:
  1. Update relevant context files
  2. Archive session to history/
  3. Update index.yaml with new references
  4. Prune stale context (>30 days)
```

### Context Maintenance Commands
```bash
# Initialize context system
claude-context init

# Add context entry
claude-context add --priority HIGH --tags "auth,security"

# Query context
claude-context query "authentication"

# Prune old context
claude-context prune --days 30

# Export context for sharing
claude-context export --format markdown
```

### Auto-Context Triggers
```yaml
triggers:
  architecture_change:
    - Update: architecture.md
    - Notify: "Architecture modified - review context"

  new_dependency:
    - Update: dependencies.md
    - Check: security implications

  api_modification:
    - Update: api-contracts.yaml
    - Regenerate: client/server stubs

  security_finding:
    - Priority: CRITICAL
    - Update: security-rules.md
    - Alert: immediate review required
```

### Context Optimization Rules
- **LIMIT** each file to <2000 lines
- **INDEX** with semantic tags for fast retrieval
- **SUMMARIZE** verbose content into bullet points
- **LINK** related contexts via YAML references
- **PRUNE** outdated context automatically
- **VERSION** critical decisions with timestamps

### Integration with Claude Code
```markdown
# At session start, Claude should:
1. Check .claude/context/index.yaml
2. Load CRITICAL priority items
3. Scan current.md for continuity
4. Import relevant patterns for current work

# During development:
- Reference context files before decisions
- Update context when patterns emerge
- Link code changes to decisions.md
- Maintain architecture.md alignment

# At session end:
- Summarize key decisions
- Update affected context files
- Archive session notes
- Update retrieval index
```

## 🔄 Multi-Agent Workflows

### Automatic Agent Spawning
Claude Code's Task tool automatically creates specialized agents - no manual setup needed.

### Agent Types (Auto-Created)
1. **Requirements Analyst**: Clarifies specifications
2. **Architecture Designer**: System structure
3. **Code Generator**: Implementation
4. **Security Scanner**: Vulnerability detection
5. **Test Generator**: Coverage validation
6. **Code Reviewer**: Standards compliance

### Triggering Multi-Agent Flows
```markdown
# Complex task → Claude spawns multiple agents
"Implement complete user authentication system"
→ Requirements → Architecture → Security → Implementation → Testing

# Parallel analysis → Concurrent agents
"Audit this codebase for security and performance"
→ [Security Agent || Performance Agent || Quality Agent]
```

### Orchestration (Automatic)
- **Sequential**: Dependencies handled automatically
- **Parallel**: Independent tasks run concurrently
- **Context**: Shared between agents seamlessly
- **Results**: Aggregated and presented unified

## ⚡ Performance Optimization

### AI Code Characteristics
- Simpler patterns (higher complexity)
- Resource intensive
- Generic solutions
- → **PROFILE** everything

### Optimization Process
1. **Benchmark** current performance
2. **Profile** bottlenecks
3. **Optimize** critical paths
4. **Validate** improvements
5. **Monitor** regression

## 🏁 Implementation Phases

### Rollout Strategy
```
Months 1-3: Foundation
- Establish standards
- Train team
- Setup workflows

Months 4-6: Enhancement
- Multi-agent flows
- Advanced QA
- Debt monitoring

Months 7-12: Optimization
- Fine-tune models
- Autonomous capabilities
- Predictive analysis
```

## 🔐 Compliance & Governance

### Regulatory Alignment
- **Document** AI usage transparently
- **Audit** trails for all generation
- **Comply** with EU AI Act
- **Report** incidents promptly
- **Maintain** human oversight

### Risk Management (NIST)
- **GOVERN**: Establish culture
- **MAP**: Identify risks
- **MEASURE**: Quantify metrics
- **MANAGE**: Allocate resources

---

**Remember**: AI augments, never replaces engineering judgment. Success = disciplined implementation within structured frameworks.

*Update this document quarterly based on team learnings and industry evolution.*