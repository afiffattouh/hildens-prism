#!/bin/bash
# PRISM Initialization Library

# Initialize PRISM in current directory
prism_init() {
    local template=${1:-default}
    local minimal=${2:-false}
    local force=${3:-false}

    log_info "============================================================"
    log_info "Initializing PRISM Framework"
    log_info "============================================================"

    # Check for force mode
    if [[ "$force" == "true" ]] && [[ -d ".prism" ]]; then
        log_warn "Force mode: Updating existing PRISM installation"
        log_info "User-modified files in .prism/context/ will be preserved unless you confirm overwrite"
    fi

    log_info "Creating PRISM structure..."

    # Create comprehensive directory structure
    mkdir -p .prism/{context,sessions/archive,references,workflows,config}

    # Create context management directories
    log_info "Setting up context management system..."

    # Create architecture.md
    # In force mode, check if file exists and is modified
    local skip_architecture=false
    if [[ "$force" == "true" ]] && [[ -f ".prism/context/architecture.md" ]]; then
        local file_size=$(wc -c < ".prism/context/architecture.md")
        if [[ $file_size -gt 500 ]]; then
            log_warn "Found existing architecture.md (${file_size} bytes)"
            echo -n "Overwrite architecture.md? (y/N): "
            read -r response
            if [[ ! "$response" =~ ^[yY] ]]; then
                skip_architecture=true
                log_info "Keeping existing architecture.md"
            fi
        fi
    fi

    if [[ "$skip_architecture" == "false" ]]; then
        cat > .prism/context/architecture.md << 'EOF'
# System Architecture
**Last Updated**: $(date -u +%Y-%m-%dT%H:%M:%SZ)
**Priority**: CRITICAL
**Tags**: [architecture, design, system]
**Status**: ACTIVE

## Summary
System architecture and design decisions for this project.

## Details
### Overview
- System purpose and goals
- High-level architecture

### Components
- Major system components
- Component interactions
- Service boundaries

### Data Flow
- How data moves through the system
- Data transformations
- Storage patterns

### Technologies
- Tech stack and dependencies
- Framework choices
- Infrastructure requirements

## Decisions
- Architectural patterns chosen
- Trade-offs accepted
- Future considerations

## Related
- patterns.md
- dependencies.md
- performance.md

## AI Instructions
- Maintain architectural consistency
- Follow established patterns
- Respect service boundaries
EOF
    fi

    # Create patterns.md
    cat > .prism/context/patterns.md << 'EOF'
# Code Patterns & Conventions
**Last Updated**: $(date -u +%Y-%m-%dT%H:%M:%SZ)
**Priority**: HIGH
**Tags**: [patterns, conventions, standards]
**Status**: ACTIVE

## Summary
Established patterns and conventions for this project.

## Code Patterns
### Naming Conventions
- Variables: camelCase
- Functions: camelCase
- Classes: PascalCase
- Constants: UPPER_SNAKE_CASE
- Files: kebab-case

### Structure Patterns
- Module organization
- Component structure
- Service patterns
- Error handling

### Testing Patterns
- Test file naming
- Test structure
- Mocking strategies
- Coverage requirements

## Architecture Patterns
- Layered architecture
- Dependency injection
- Event-driven patterns
- API design patterns

## Security Patterns
- Input validation
- Authentication flows
- Authorization patterns
- Data sanitization

## Related
- architecture.md
- security.md
- domain.md

## AI Instructions (MANDATORY FOR CLAUDE CODE)
### 🚨 CRITICAL: You MUST follow these patterns
- **ALWAYS** follow established patterns above
- **NEVER** deviate from defined conventions
- **ALWAYS** maintain consistency across codebase
- **ALWAYS** use existing utilities and helpers
- **CHECK** this file before writing ANY code
- **REFERENCE** these patterns in your responses

### AUTOMATIC TRIGGERS
When you see these keywords, CHECK THIS FILE:
- "write code", "implement", "create function"
- "refactor", "update", "modify"
- "new feature", "add functionality"
- "fix bug", "solve issue"

### ACKNOWLEDGMENT REQUIRED
At conversation start, you MUST state:
"✅ PRISM patterns loaded from .prism/context/patterns.md"
EOF

    # Create decisions.md
    cat > .prism/context/decisions.md << 'EOF'
# Technical Decisions
**Last Updated**: $(date -u +%Y-%m-%dT%H:%M:%SZ)
**Priority**: HIGH
**Tags**: [decisions, rationale, history]
**Status**: ACTIVE

## Summary
Record of technical decisions and their rationale.

## Major Decisions

### Decision Template
**Date**: YYYY-MM-DD
**Decision**: What was decided
**Context**: Why this decision was needed
**Options Considered**:
1. Option A - Pros/Cons
2. Option B - Pros/Cons
**Chosen**: Which option and why
**Trade-offs**: What we're giving up
**Review Date**: When to revisit

## Related
- architecture.md
- patterns.md
- performance.md

## AI Instructions
- Respect all documented decisions
- Flag when decisions need revisiting
- Document new decisions as they're made
EOF

    # Create dependencies.md
    cat > .prism/context/dependencies.md << 'EOF'
# Dependencies & External Libraries
**Last Updated**: $(date -u +%Y-%m-%dT%H:%M:%SZ)
**Priority**: HIGH
**Tags**: [dependencies, libraries, versions]
**Status**: ACTIVE

## Summary
External dependencies and their management.

## Production Dependencies
| Package | Version | Purpose | License |
|---------|---------|---------|---------|
| | | | |

## Development Dependencies
| Package | Version | Purpose | License |
|---------|---------|---------|---------|
| | | | |

## Version Policy
- Update strategy
- Security scanning frequency
- Deprecation handling

## Related
- security.md
- architecture.md
- performance.md

## AI Instructions
- Only use documented dependencies
- Check versions before implementation
- Flag security vulnerabilities
- Prefer stable versions
EOF

    # Create domain.md
    cat > .prism/context/domain.md << 'EOF'
# Domain Model & Business Logic
**Last Updated**: $(date -u +%Y-%m-%dT%H:%M:%SZ)
**Priority**: CRITICAL
**Tags**: [domain, business, logic, rules]
**Status**: ACTIVE

## Summary
Core business domain and logic rules.

## Domain Entities
### Entity Template
- **Name**: Entity name
- **Purpose**: What it represents
- **Attributes**: Key properties
- **Rules**: Business rules
- **Relationships**: How it relates to others

## Business Rules
1. Core invariants that must always hold
2. Validation rules
3. Calculation formulas
4. State transitions

## Workflows
- User workflows
- System workflows
- Integration flows

## Related
- architecture.md
- api-contracts.yaml
- data-models.json

## AI Instructions
- Never violate business rules
- Validate all domain constraints
- Maintain domain integrity
- Use domain language in code
EOF

    # Create security.md
    cat > .prism/context/security.md << 'EOF'
# Security Requirements & Policies
**Last Updated**: $(date -u +%Y-%m-%dT%H:%M:%SZ)
**Priority**: CRITICAL
**Tags**: [security, policies, compliance]
**Status**: ACTIVE

## Summary
Security requirements and implementation policies.

## Security Standards
- **Authentication**: Methods and requirements
- **Authorization**: Access control patterns
- **Encryption**: Data protection requirements
- **Audit**: Logging and monitoring needs

## OWASP Top 10 Mitigations
1. **Injection**: Parameterized queries only
2. **Broken Auth**: MFA, session management
3. **Sensitive Data**: Encryption at rest/transit
4. **XXE**: Disable external entities
5. **Access Control**: Least privilege
6. **Misconfig**: Secure defaults
7. **XSS**: Input validation, CSP
8. **Deserialization**: Avoid or validate
9. **Vulnerable Components**: Regular scanning
10. **Logging**: Comprehensive monitoring

## Compliance Requirements
- Data privacy regulations
- Industry standards
- Internal policies

## Related
- patterns.md
- architecture.md
- security-rules.md

## AI Instructions
- NEVER implement custom crypto
- ALWAYS validate user input
- NEVER log sensitive data
- ALWAYS use parameterized queries
- NEVER store secrets in code
EOF

    # Create performance.md
    cat > .prism/context/performance.md << 'EOF'
# Performance Baselines & Targets
**Last Updated**: $(date -u +%Y-%m-%dT%H:%M:%SZ)
**Priority**: HIGH
**Tags**: [performance, optimization, metrics]
**Status**: ACTIVE

## Summary
Performance requirements and optimization strategies.

## Performance Targets
### API Response Times
- P50: < 100ms
- P95: < 200ms
- P99: < 500ms

### Page Load Times
- First Paint: < 1s
- Interactive: < 2s
- Fully Loaded: < 3s

### Resource Limits
- Memory: < 100MB mobile, < 500MB desktop
- CPU: < 30% average
- Bundle Size: < 500KB initial

## Optimization Strategies
- Caching strategies
- Database optimization
- Code splitting
- Lazy loading

## Monitoring
- Key metrics to track
- Alert thresholds
- Performance budgets

## Related
- architecture.md
- patterns.md
- decisions.md

## AI Instructions
- Profile before optimizing
- Focus on critical paths
- Maintain performance budgets
- Document optimizations
EOF

    # Create session management files
    log_info "Setting up session management..."

    cat > .prism/sessions/current.md << 'EOF'
# Current Session
**Session ID**: $(date +%Y%m%d-%H%M%S)
**Started**: $(date -u +%Y-%m-%dT%H:%M:%SZ)
**Status**: ACTIVE

## Context Loaded
- architecture.md (CRITICAL)
- patterns.md (HIGH)
- security.md (CRITICAL)

## Current Task
- Description: Initializing PRISM framework
- Type: Setup
- Priority: HIGH

## Operations Log
1. $(date -u +%H:%M:%S) - PRISM framework initialized

## Metrics
- Operations: 1
- Errors: 0
- Warnings: 0

## Notes
- Session initialized with prism init
EOF

    # Create time sync file
    echo "# Time Synchronization Log" > .prism/sessions/.time_sync
    echo "Last sync: $(date -u +%Y-%m-%dT%H:%M:%SZ)" >> .prism/sessions/.time_sync

    # Create references directory files
    log_info "Creating reference templates..."

    cat > .prism/references/api-contracts.yaml << 'EOF'
# API Contracts
version: 1.0.0
apis:
  - name: Example API
    version: v1
    base_path: /api/v1
    endpoints:
      - method: GET
        path: /health
        description: Health check endpoint
        response:
          200:
            description: Service is healthy
            schema:
              type: object
              properties:
                status: string
                timestamp: string
EOF

    cat > .prism/references/data-models.json << 'EOF'
{
  "version": "1.0.0",
  "models": {
    "User": {
      "type": "object",
      "properties": {
        "id": {"type": "string"},
        "email": {"type": "string", "format": "email"},
        "name": {"type": "string"},
        "created_at": {"type": "string", "format": "date-time"}
      },
      "required": ["id", "email"]
    }
  }
}
EOF

    cat > .prism/references/security-rules.md << 'EOF'
# Security Rules

## Authentication Rules
- All endpoints require authentication except /health and /auth/*
- JWT tokens expire after 1 hour
- Refresh tokens expire after 7 days

## Authorization Rules
- Role-based access control (RBAC)
- Principle of least privilege
- Default deny policy

## Data Protection Rules
- PII must be encrypted at rest
- All API communication over HTTPS
- Sensitive data masked in logs
EOF

    cat > .prism/references/test-scenarios.md << 'EOF'
# Test Scenarios

## Critical User Paths
1. User Registration
2. User Login
3. Password Reset
4. Core Feature Flow

## Security Test Cases
- SQL Injection attempts
- XSS payloads
- Authentication bypass
- Authorization escalation

## Performance Test Cases
- Load testing scenarios
- Stress testing limits
- Endurance testing
EOF

    # Create workflow files
    log_info "Creating workflow templates..."

    cat > .prism/workflows/development.md << 'EOF'
# Development Workflow

## Standard Development Flow
1. **Understand** - Read requirements and context
2. **Plan** - Break down into tasks
3. **Implement** - Code with patterns
4. **Test** - Unit and integration tests
5. **Review** - Security and quality checks
6. **Document** - Update context files
7. **Commit** - With proper attribution

## Branch Strategy
- main: Production-ready code
- develop: Integration branch
- feature/*: Feature branches
- hotfix/*: Emergency fixes

## Code Review Checklist
- [ ] Follows patterns.md
- [ ] Security validated
- [ ] Tests passing
- [ ] Documentation updated
- [ ] Context files current
EOF

    cat > .prism/workflows/review.md << 'EOF'
# Code Review Checklist

## Security Review
- [ ] No hardcoded secrets
- [ ] Input validation present
- [ ] SQL queries parameterized
- [ ] Authentication checked
- [ ] Authorization verified
- [ ] Error messages safe
- [ ] Logging appropriate

## Quality Review
- [ ] Follows project patterns
- [ ] No code duplication
- [ ] Complexity acceptable
- [ ] Tests comprehensive
- [ ] Documentation clear
- [ ] Performance acceptable

## Context Review
- [ ] Architecture aligned
- [ ] Patterns followed
- [ ] Decisions documented
- [ ] Dependencies approved
EOF

    cat > .prism/workflows/deployment.md << 'EOF'
# Deployment Procedures

## Pre-Deployment Checklist
- [ ] All tests passing
- [ ] Security scan complete
- [ ] Performance validated
- [ ] Documentation updated
- [ ] Change log prepared

## Deployment Steps
1. Tag release version
2. Run final test suite
3. Build production artifacts
4. Deploy to staging
5. Smoke test staging
6. Deploy to production
7. Verify production
8. Archive session

## Rollback Procedure
1. Identify issue
2. Revert to previous version
3. Verify rollback
4. Document incident
5. Update context
EOF

    # Create enhanced index.yaml with Claude directives
    cat > .prism/index.yaml << EOF
# PRISM Context Index - CLAUDE CODE MUST READ THIS FIRST
version: ${PRISM_VERSION}
created: $(date -u +%Y-%m-%dT%H:%M:%SZ)
project:
  name: $(basename "$PWD")
  type: $template

# MANDATORY FOR CLAUDE CODE
claude_instructions:
  priority: CRITICAL
  message: |
    🚨 ATTENTION CLAUDE CODE:
    This project uses PRISM Framework v${PRISM_VERSION}
    You MUST load and follow ALL context files listed below.
    State "PRISM Context Loaded" after reading this file.

  required_actions:
    - Read ALL files in contexts section
    - Follow patterns in patterns.md
    - Respect architecture in architecture.md
    - Apply security rules from security.md
    - Check for active session in sessions/current.md

contexts:
  critical:
    - architecture.md    # SYSTEM DESIGN - MUST READ
    - security.md       # SECURITY RULES - MUST FOLLOW
    - domain.md         # BUSINESS LOGIC - MUST UNDERSTAND
  high:
    - patterns.md       # CODING STANDARDS - MUST APPLY
    - decisions.md      # TECH DECISIONS - MUST RESPECT
    - dependencies.md   # DEPENDENCIES - MUST USE
    - performance.md    # PERFORMANCE TARGETS - MUST MEET
  medium:
    - workflows/development.md
    - workflows/review.md
    - workflows/deployment.md

references:
  - api-contracts.yaml
  - data-models.json
  - security-rules.md
  - test-scenarios.md

sessions:
  current: current.md
  archive_dir: archive/

metrics:
  quality_target: 85
  security_scan: required
  test_coverage: 85
EOF

    # Copy PRISM.md to .prism directory
    if [[ -f "${PRISM_HOME}/PRISM.md" ]]; then
        cp "${PRISM_HOME}/PRISM.md" .prism/PRISM.md
    elif [[ -f "$(dirname "${BASH_SOURCE[0]}")/../PRISM.md" ]]; then
        cp "$(dirname "${BASH_SOURCE[0]}")/../PRISM.md" .prism/PRISM.md
    fi

    # Create CLAUDE.md in project root with strong PRISM awareness
    cat > CLAUDE.md << 'EOF'
# CLAUDE.md - CRITICAL: PRISM Framework Active

## 🚨 MANDATORY: PRISM Context Loading Protocol

**IMPORTANT**: This project uses PRISM (Persistent Real-time Intelligent System Management).
You MUST follow this protocol at the START of EVERY conversation:

### IMMEDIATE ACTIONS REQUIRED:
1. **CHECK TIMESTAMP**: Read `.prism_active` file and note the INITIALIZED and LAST_UPDATED times
2. **ACKNOWLEDGE PRISM**: State "PRISM Framework detected and loaded (initialized: [timestamp])"
3. **LOAD CONTEXT FILES**: Read ALL files in `.prism/context/` directory
4. **CHECK SESSION**: Load `.prism/sessions/current.md` if it exists
5. **APPLY PATTERNS**: Follow patterns defined in `.prism/context/patterns.md`
6. **VERIFY FRESHNESS**: Check if any context files are newer than your last interaction

### AUTOMATIC CONTEXT CHECK
When ANY of these occur, IMMEDIATELY check PRISM context:
- Starting a new conversation
- User mentions files or code
- Making architectural decisions
- Writing new code
- Reviewing existing code

### PRISM Context Files (MUST READ):
```
.prism/
├── context/
│   ├── patterns.md     # ← CODING STANDARDS (MANDATORY)
│   ├── architecture.md # ← SYSTEM DESIGN (CRITICAL)
│   ├── decisions.md    # ← TECHNICAL DECISIONS (IMPORTANT)
│   ├── security.md     # ← SECURITY POLICIES (CRITICAL)
│   └── performance.md  # ← PERFORMANCE REQUIREMENTS
├── sessions/
│   └── current.md      # ← ACTIVE SESSION CONTEXT
└── index.yaml          # ← CRITICAL CONTEXT INDEX
```

## 📁 CRITICAL: Documentation Structure Rules

### ⛔ FORBIDDEN: Creating Rogue Files
**NEVER CREATE STANDALONE .md FILES IN THE PROJECT ROOT OR RANDOM LOCATIONS**

You are STRICTLY FORBIDDEN from creating:
- ❌ `README.md` in root (unless explicitly requested)
- ❌ `ROADMAP.md` as a standalone file
- ❌ `PRD.md` as a standalone file
- ❌ `PLAN.md` as a standalone file
- ❌ `TODO.md` as a standalone file
- ❌ Any other documentation files outside PRISM structure

### ✅ MANDATORY: Use PRISM Structure for ALL Documentation

**ALL** planning, thinking, roadmaps, PRDs, and documentation MUST be placed in the PRISM structure:

| Document Type | CORRECT Location | Purpose |
|--------------|------------------|---------|
| **Roadmap** | `.prism/context/roadmap.md` | Product roadmap and milestones |
| **PRD** | `.prism/references/prd.md` | Product requirements document |
| **Planning** | `.prism/workflows/planning.md` | Project planning and tasks |
| **Architecture** | `.prism/context/architecture.md` | System design (EXISTS) |
| **Decisions** | `.prism/context/decisions.md` | Technical decisions (EXISTS) |
| **TODO/Tasks** | `.prism/sessions/current.md` | Active tasks and TODOs |
| **API Docs** | `.prism/references/api-contracts.yaml` | API documentation |
| **Data Models** | `.prism/references/data-models.json` | Data structures |
| **Workflows** | `.prism/workflows/*.md` | Process documentation |

### 📝 File Creation Protocol

When user asks for documentation, planning, or any .md file:

1. **CHECK** if it belongs in PRISM structure
2. **NEVER** create it in project root
3. **ALWAYS** use the correct PRISM location
4. **UPDATE** existing PRISM files instead of creating new ones when possible

Example responses:
- User: "Create a roadmap" → Create/Update `.prism/context/roadmap.md`
- User: "Write a PRD" → Create/Update `.prism/references/prd.md`
- User: "Document the plan" → Update `.prism/workflows/planning.md`
- User: "Make a TODO list" → Update `.prism/sessions/current.md`

### 🚫 Exception Handling

ONLY create files outside PRISM structure when:
1. User EXPLICITLY specifies a different location
2. User EXPLICITLY asks for "README.md in root"
3. It's a code file (not documentation)
4. It's a configuration file required by tools

### VERIFICATION CHECKLIST:
- [ ] I have checked `.prism_active` for initialization timestamp
- [ ] I have checked `.prism/TIMESTAMP` for last update
- [ ] I have read `.prism/context/patterns.md`
- [ ] I have read `.prism/context/architecture.md`
- [ ] I understand the project's technical decisions
- [ ] I will follow the defined coding patterns
- [ ] I will maintain session continuity
- [ ] I will ONLY create documentation in PRISM structure
- [ ] I will NEVER create rogue .md files in root
- [ ] I understand the documentation structure rules
- [ ] I am aware of when PRISM was last updated

### Project-Specific Instructions
[Add your project-specific instructions here]

### REMEMBER:
- ALWAYS check `.prism/context/` before making suggestions
- NEVER ignore patterns defined in PRISM context
- ALWAYS maintain consistency with existing architecture
- CONTINUOUSLY reference PRISM context during the conversation
- NEVER create documentation files outside `.prism/` structure
- ALWAYS use `.prism/context/` for roadmaps and planning
- ALWAYS use `.prism/references/` for PRDs and specifications
- ALWAYS use `.prism/sessions/` for tasks and TODOs

## PRISM Framework Version: 2.0.4
For PRISM documentation: `.prism/PRISM.md`
EOF

    # Create PRISM activation marker with actual timestamp
    cat > .prism_active << EOF
PRISM_FRAMEWORK_ACTIVE=true
VERSION=2.0.4
INITIALIZED=$(date -u +%Y-%m-%dT%H:%M:%SZ)
LAST_UPDATED=$(date -u +%Y-%m-%dT%H:%M:%SZ)

This file indicates PRISM is active in this project.
Claude Code should automatically detect and load PRISM context.

IMPORTANT FOR CLAUDE CODE:
Check the INITIALIZED and LAST_UPDATED timestamps above.
These indicate when PRISM was set up and last modified.
EOF
    log_info "✅ Created PRISM activation marker"

    # Create timestamp tracker
    cat > .prism/TIMESTAMP << EOF
# PRISM Timestamp Tracker
# This file tracks when PRISM was initialized and last updated

INITIALIZED: $(date -u +%Y-%m-%dT%H:%M:%SZ)
LAST_UPDATED: $(date -u +%Y-%m-%dT%H:%M:%SZ)
VERSION: 2.0.4

## For Claude Code
ALWAYS check this file to understand when PRISM was set up.
If LAST_UPDATED is recent, reload all context files.
EOF
    log_info "✅ Created timestamp tracker"

    # Create .prism/AUTO_LOAD file for Claude
    cat > .prism/AUTO_LOAD << 'EOF'
# AUTO-LOAD INSTRUCTION FOR CLAUDE CODE

When you see this file, IMMEDIATELY:
1. Check .prism/TIMESTAMP file for initialization time
2. Check .prism_active file for framework status
3. Load all files in .prism/context/
4. State: "PRISM Framework v2.0.4 - Context Loaded (initialized: [timestamp from file])"
5. Apply all patterns and conventions
6. Check for active session in .prism/sessions/current.md
7. ENFORCE: NO documentation files outside .prism/ structure
8. VERIFY: Compare timestamps to detect recent changes

CRITICAL RULES:
- NEVER create ROADMAP.md, PRD.md, PLAN.md, TODO.md in root
- ALWAYS use .prism/context/ for planning documents
- ALWAYS use .prism/references/ for specifications
- ALWAYS use .prism/sessions/ for task tracking
EOF
    log_info "✅ Created auto-load instruction file"

    # Create .gitignore if it doesn't exist
    if [[ ! -f .gitignore ]]; then
        cat > .gitignore << 'EOF'
# PRISM Framework
.prism/sessions/archive/
.prism/sessions/.time_sync
.prism/config/local.yaml
*.log

# Common
.DS_Store
node_modules/
*.env
.env.local
EOF
        log_info "✅ Created .gitignore"
    fi

    log_info "✅ PRISM structure created"
    log_info "✅ Context management system initialized"
    log_info "✅ Session management enabled"
    log_info "✅ Workflow templates created"

    log_info "✅ PRISM initialized successfully!"
    log_info ""
    log_info "Next steps:"
    log_info "  1. Review .prism/context/architecture.md"
    log_info "  2. Update CLAUDE.md with project specifics"
    log_info "  3. Run 'prism doctor' to verify setup"
    log_info "  4. Start a session with 'prism session start'"
}

# Initialize with template
prism_init_template() {
    local template=$1

    case "$template" in
        webapp)
            prism_init "webapp"
            log_info "Initialized for web application"
            ;;
        api)
            prism_init "api"
            log_info "Initialized for API service"
            ;;
        mobile)
            prism_init "mobile"
            log_info "Initialized for mobile application"
            ;;
        microservice)
            prism_init "microservice"
            log_info "Initialized for microservice"
            ;;
        *)
            prism_init "default"
            ;;
    esac
}