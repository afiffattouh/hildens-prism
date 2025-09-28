#!/bin/bash
# PRISM Initialization Library

# Initialize PRISM in current directory
prism_init() {
    local template=${1:-default}
    local minimal=${2:-false}

    log_info "============================================================"
    log_info "Initializing PRISM Framework"
    log_info "============================================================"

    log_info "Creating PRISM structure..."

    # Create comprehensive directory structure
    mkdir -p .prism/{context,sessions/archive,references,workflows,config}

    # Create context management directories
    log_info "Setting up context management system..."

    # Create architecture.md
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

## AI Instructions
- Always follow established patterns
- Maintain consistency across codebase
- Use existing utilities and helpers
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

    # Create index.yaml
    cat > .prism/index.yaml << EOF
# PRISM Context Index
version: ${PRISM_VERSION}
created: $(date -u +%Y-%m-%dT%H:%M:%SZ)
project:
  name: $(basename "$PWD")
  type: $template

contexts:
  critical:
    - architecture.md
    - security.md
    - domain.md
  high:
    - patterns.md
    - decisions.md
    - dependencies.md
    - performance.md
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

    # Copy PRISM.md to project root
    if [[ -f "${PRISM_HOME}/PRISM.md" ]]; then
        cp "${PRISM_HOME}/PRISM.md" .prism/PRISM.md
    elif [[ -f "$(dirname "${BASH_SOURCE[0]}")/../PRISM.md" ]]; then
        cp "$(dirname "${BASH_SOURCE[0]}")/../PRISM.md" .prism/PRISM.md
    fi

    # Create CLAUDE.md in project root
    cat > CLAUDE.md << 'EOF'
# CLAUDE.md - Project Context for Claude Code

This project uses the PRISM framework for AI-assisted development.

## Quick Start
When starting a session with this project:
1. Check `.prism/index.yaml` for critical context
2. Load `.prism/sessions/current.md` for session continuity
3. Review `.prism/context/patterns.md` for coding standards
4. Follow `.prism/context/security.md` for security requirements

## Project-Specific Instructions
[Add your project-specific instructions here]

## PRISM Framework
See `.prism/PRISM.md` for complete development workflow and best practices.
EOF

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