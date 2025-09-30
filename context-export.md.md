# PRISM Context Export
**Exported**: 2025-09-30T09:44:33Z

---
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

---
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

---
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

---
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

---
# Implement OAuth2 authentication
**Last Updated**: 2025-09-30T09:44:25Z
**Priority**: HIGH
**Tags**: [security]
**Status**: ACTIVE

## Summary
[Add summary here]

## Details
[Add details here]

## Decisions
[Document decisions]

## Related
[List related files]

## AI Instructions
[Specific instructions for AI]

---
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

---
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

---
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

