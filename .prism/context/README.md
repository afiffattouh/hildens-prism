# Claude Context Management System

This directory maintains persistent context for Claude Code throughout your project development.

## Quick Start

1. **Initialize Context**: Run the setup script to create initial structure
2. **Add Context**: Document decisions, patterns, and critical information
3. **Query Context**: Claude will automatically reference these files
4. **Maintain Context**: Update as project evolves

## File Purposes

### Core Context Files

- **architecture.md**: System design, component relationships, data flows
- **patterns.md**: Code conventions, established patterns, anti-patterns to avoid
- **decisions.md**: Technical decisions with rationale and trade-offs
- **dependencies.md**: External libraries, versions, and why they were chosen
- **domain.md**: Business logic, domain rules, terminology

### Priority Levels

- **CRITICAL**: Must be loaded every session (auth, security, core architecture)
- **HIGH**: Important for most development tasks
- **MEDIUM**: Useful for specific features
- **LOW**: Historical reference, rarely needed

## Best Practices

1. **Keep entries concise** - Bullet points over paragraphs
2. **Use semantic tags** - Makes retrieval faster
3. **Link related items** - Cross-reference between files
4. **Update immediately** - Don't let context go stale
5. **Review weekly** - Prune outdated information

## Context Query Examples

```yaml
# Find all security-related context
tags: [security, auth, encryption]

# Get critical architecture decisions
priority: CRITICAL
file: architecture.md

# Find API-related patterns
tags: [api, rest, graphql]
file: patterns.md
```

## Maintenance Schedule

- **Daily**: Update current.md with session notes
- **Weekly**: Review and consolidate session history
- **Monthly**: Prune outdated context (>30 days)
- **Quarterly**: Major context reorganization

---

*Last Updated: Initial Setup*
*Version: 1.0.0*