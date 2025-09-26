# Cursor Rules Framework for PRISM AI-Assisted Development

This comprehensive framework integrates with the PRISM (Persistent Real-time Intelligent Security Management) system to provide structured AI-assisted development using Cursor IDE, ensuring code quality, security, and maintainability across all projects.

## Framework Overview

The framework consists of 8 focused rule sets that integrate with the PRISM system to moderate and guide AI-assisted development:

### 📋 Rule Sets

| Rule File | Purpose | Applies To |
|-----------|---------|------------|
| `core-development-principles.mdc` | PRISM architecture-first development and evidence-based decisions | All code files + PRISM |
| `security-standards.mdc` | PRISM security requirements and OWASP Top 10 prevention | All code files + SQL + PRISM |
| `quality-performance-standards.mdc` | Code quality metrics and performance benchmarks | All code files |
| `testing-requirements.mdc` | Test coverage minimums and TDD practices | All files including tests |
| `documentation-standards.mdc` | PRISM documentation and commit message standards | All files + markdown + PRISM |
| `code-generation-workflow.mdc` | PRISM structured AI-assisted development process | All code files + PRISM |
| `emergency-protocols.mdc` | PRISM response procedures for quality/security/time-sync issues | All files + PRISM |
| `prism-integration.mdc` | **NEW**: PRISM framework integration and context management | PRISM files + scripts |

## Key Features

### 🧠 PRISM Integration
- **Time Synchronization**: WebSearch for accurate UTC time on session start
- **Persistent Context**: `.prism/` directory for cross-session knowledge retention
- **Shell Integration**: `prism-context.sh` commands for context management
- **Session Tracking**: Continuous session logging and archival

### 🛡️ Security-First Approach
- **OWASP Top 10** vulnerability prevention with PRISM context awareness
- **Manual security reviews** for all authentication code (logged in `.prism/references/security-rules.md`)
- **Input validation** and sanitization requirements
- **45% vulnerability rate** awareness with mandatory review processes

### 📊 Quality Metrics
- **85% minimum** test coverage for AI-generated code
- **100% coverage** for security-critical paths
- **Cyclomatic complexity** <10 for all functions
- **Maintainability index** >60 requirement

### ⚡ Performance Standards
- **<200ms** API response times
- **<3s** page load requirements
- **O(n) preferred** over O(n²) algorithms
- **Load testing** and scalability validation

### 📝 Documentation Requirements
- **Strategic commenting** (1 comment per 3-5 lines of complex logic)
- **AI attribution** in commit messages and code
- **Architecture Decision Records** for significant decisions
- **API documentation** for all endpoints

## Getting Started

### 1. PRISM + Cursor Framework Installation
```bash
# Copy both PRISM and Cursor frameworks to your project
cp -r /path/to/framework/.cursor /your/project/root/
cp -r /path/to/framework/.prism /your/project/root/
cp /path/to/framework/PRISM.md /your/project/root/
cp /path/to/framework/prism-context.sh /your/project/root/
chmod +x /your/project/root/prism-context.sh

# Or use the automated setup script
./setup-new-project.sh /your/project/root/

# Verify installation
ls -la .cursor/rules/
ls -la .prism/
./prism-context.sh status
```

### 2. PRISM + Cursor Configuration
1. **Initialize PRISM**: Run `./prism-context.sh init` to set up context system
2. **Open in Cursor**: Open your project in Cursor IDE
3. **Verify Rules**: Navigate to `Cursor Settings > Rules` and verify project rules are active
4. **Check Integration**: Verify PRISM integration with `./prism-context.sh status`
5. **Time Sync**: Confirm time synchronization is working (check `.prism/.time_sync`)
6. **Test Generation**: Test with a simple code generation task

### 3. PRISM Workflow Integration
Follow the **PRISM-enhanced qnew-qplan-qcode-qcheck-qgit** workflow:

- **qnew**: WebSearch time sync, load PRISM context, check session continuity
- **qplan**: Review architecture/patterns from `.prism/context/`, update session plan
- **qcode**: Log decisions with `prism-context.sh add`, update patterns, track session
- **qcheck**: Validate against PRISM context, log findings, verify architecture alignment
- **qgit**: Archive session with `prism-context.sh archive`, commit with PRISM attribution

## Progressive Enhancement Pattern

All AI-assisted development follows this structured approach:

### Phase 1: Basic Functionality
✅ Core requirements only  
✅ Happy path scenarios  
✅ End-to-end functionality  

### Phase 2: Error Handling
✅ Edge cases and validations  
✅ Meaningful error messages  
✅ Graceful degradation  

### Phase 3: Security Implementation
✅ Input sanitization  
✅ Authentication/authorization  
✅ Rate limiting  

### Phase 4: Performance Optimization
✅ Profile and optimize  
✅ Caching strategies  
✅ Database optimization  

### Phase 5: Comprehensive Testing
✅ Unit tests (≥85% coverage)  
✅ Integration tests  
✅ Security tests  

### Phase 6: Refactoring
✅ Code maintainability  
✅ Documentation  
✅ Pattern consistency  

## Multi-Layer Review Process

Every AI-generated code goes through:

1. **🤖 AI Review**: Automated scanning and pattern validation
2. **🔒 Security Check**: Manual security validation (required for auth code)
3. **⚡ Performance Audit**: Complexity analysis and benchmarking
4. **🏗️ Architecture Alignment**: System design consistency check
5. **👤 Human Approval**: Final review by senior developer

## Emergency Protocols

### Context Corruption
**Signs**: Inconsistent patterns, quality degradation, nonsensical output
**Response**: Stop immediately → Clear context → Document issues → Restart with constraints

### Security Incidents
**Level 1 (Critical)**: Stop deployments → Isolate systems → Notify security team
**Level 2 (Configuration)**: Fix in place → Add monitoring → Enhanced review
**Level 3 (Best Practices)**: Document → Plan fix → Update training

### Quality Degradation
**High Severity**: Immediate rollback → Fresh generation → Enhanced validation
**Medium Severity**: Refactor in place → Add tests → Mandatory review
**Low Severity**: Document → Fix during next cycle

## Usage Examples

### Starting a New Feature with PRISM
```
PRISM Initialization:
1. WebSearch: "current UTC time" (automatic)
2. Load context from .prism/context/architecture.md
3. Check previous decisions: ./prism-context.sh query "authentication"
4. Update session: .prism/sessions/current.md

Context: Senior developer working on Node.js e-commerce API
Architecture: RESTful API, Express.js, PostgreSQL, Redis cache (from .prism/context/)
Task: Implement user authentication with JWT tokens
Requirements: OWASP compliant, 85% test coverage, <200ms response time
Constraints: Use patterns from .prism/context/patterns.md, bcrypt for passwords
Previous Decisions: Check .prism/context/decisions.md for auth-related choices
```

### PRISM Commit Message Format
```
feat: Add JWT-based user authentication (AI-assisted)

- Generated with: Claude Code v3.5.0
- PRISM Session: 2024-01-15T14:30:00Z logged in .prism/sessions/history/
- Reviewed by: Jane Smith
- Modified: Added rate limiting and improved error messages
- Security review: Completed - logged in .prism/references/security-rules.md
- Test coverage: 92% (exceeds 85% requirement)
- Context updated: .prism/context/decisions.md, .prism/context/patterns.md

PRISM Integration:
- Architecture: Follows .prism/context/architecture.md patterns
- Decisions: JWT choice logged in .prism/context/decisions.md
- Security: Rules updated in .prism/references/security-rules.md
- Time: WebSearch synchronized at session start

AI-Tool: Claude Code
Prompt: "Create secure JWT authentication with proper validation, 
rate limiting, and comprehensive error handling"

Closes #123
```

## Customization

### PRISM + Project-Specific Rules
Create additional rules and customize PRISM context:
```
project/
  .cursor/rules/           # Global project rules
  .prism/context/          # PRISM context files
    architecture.md        # Customize for your architecture
    patterns.md           # Add your code patterns
    dependencies.md       # Track your tech stack
    decisions.md          # Log technical decisions
  backend/
    .cursor/rules/         # Backend-specific rules
  frontend/
    .cursor/rules/         # Frontend-specific rules
```

### Glob Pattern Examples
```yaml
globs: ["**/*.js", "**/*.ts"]          # JavaScript/TypeScript files
globs: ["**/api/**/*.py"]              # Python API files only  
globs: ["**/components/**/*.jsx"]      # React components only
globs: ["**/*.test.*", "**/*.spec.*"] # Test files only
```

## PRISM Monitoring and Metrics

### Track These KPIs
- **AI Effectiveness**: >80% success rate, <20% intervention rate
- **Development Velocity**: 25% time-to-market improvement with PRISM context
- **Code Quality**: Complexity <10, maintainability >60
- **Bug Rates**: <5% defect escape rate for AI-generated code
- **PRISM Context Accuracy**: How well context reflects project reality
- **Session Continuity**: Effectiveness of session archival/restoration
- **Time Sync Accuracy**: WebSearch vs system time drift monitoring

### PRISM-Specific Commands
```bash
# Check system health
./prism-context.sh status

# Add decisions during development
./prism-context.sh add decisions.md CRITICAL "auth,jwt" "JWT tokens expire after 24h"

# Query existing context
./prism-context.sh query "authentication"

# Archive session when switching tasks
./prism-context.sh archive

# Export context for team sharing
./prism-context.sh export
```

### Regular Reviews
- **Daily**: Update `.prism/sessions/current.md`, check time sync
- **Weekly**: Archive sessions with `./prism-context.sh archive`, code pattern analysis
- **Monthly**: Security and performance audit, update `.prism/references/` files
- **Quarterly**: Rules updates based on lessons learned, export context for team
- **Annually**: Comprehensive framework assessment, prune old context

## Red Flags - When NOT to Use AI

❌ **NEVER** use AI for:
- Cryptographic implementations
- Financial calculations requiring precision  
- Regulatory compliance code
- Safety-critical systems
- PII handling without human review

## Support and Updates

### PRISM Framework Maintenance
- Keep rules updated with latest security standards
- Monitor industry best practices and incorporate changes
- Regular team training on PRISM framework usage
- Document lessons learned in `.prism/context/decisions.md`
- Maintain time sync accuracy and context file health
- Update setup scripts for new project types

### PRISM Troubleshooting
- **Time Sync Issues**: Check `.prism/.time_sync`, ensure WebSearch works
- **Context Corruption**: Use `./prism-context.sh prune 0` and reinitialize
- **Shell Script Issues**: Check permissions with `chmod +x prism-context.sh`
- **Session Problems**: Archive current session and start fresh

### Getting Help
- Review emergency protocols for immediate issues
- Consult security team for vulnerability concerns
- Escalate quality issues through proper channels
- Document and share learnings with the team

---

**Version**: 2.0 (PRISM Integrated)  
**Last Updated**: Check `.prism/.time_sync` for accurate timestamp  
**Maintainer**: [Your Name/Team]  
**PRISM Version**: 1.0.0  

This integrated PRISM + Cursor framework is designed to evolve with your team's needs and industry best practices. The PRISM context system ensures persistent knowledge across sessions while Cursor rules provide real-time guidance. Regular updates and team feedback are essential for maintaining its effectiveness.

### Quick Reference
```bash
# Setup new project with PRISM + Cursor
./setup-new-project.sh /path/to/project

# Daily workflow commands
./prism-context.sh status           # Check system
./prism-context.sh add [file] [pri] [tags] "[content]"  # Log decisions  
./prism-context.sh query "[term]"   # Search context
./prism-context.sh archive          # End session
```
