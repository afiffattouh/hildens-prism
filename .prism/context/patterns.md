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
