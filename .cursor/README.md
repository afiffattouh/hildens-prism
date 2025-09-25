# Cursor Rules Framework for AI-Assisted Development

This comprehensive framework provides a structured approach to AI-assisted development using Cursor IDE, ensuring code quality, security, and maintainability across all projects.

## Framework Overview

The framework consists of 7 focused rule sets that work together to moderate and guide AI-assisted development:

### 📋 Rule Sets

| Rule File | Purpose | Applies To |
|-----------|---------|------------|
| `core-development-principles.mdc` | Architecture-first development and evidence-based decisions | All code files |
| `security-standards.mdc` | Security requirements and OWASP Top 10 prevention | All code files + SQL |
| `quality-performance-standards.mdc` | Code quality metrics and performance benchmarks | All code files |
| `testing-requirements.mdc` | Test coverage minimums and TDD practices | All files including tests |
| `documentation-standards.mdc` | Code documentation and commit message standards | All files + markdown |
| `code-generation-workflow.mdc` | Structured AI-assisted development process | All code files |
| `emergency-protocols.mdc` | Response procedures for quality/security issues | All files |

## Key Features

### 🛡️ Security-First Approach
- **OWASP Top 10** vulnerability prevention
- **Manual security reviews** for all authentication code
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

### 1. Framework Installation
```bash
# Clone or copy the .cursor directory to your project root
cp -r /path/to/cursor-framework/.cursor /your/project/root/

# Verify installation
ls -la .cursor/rules/
```

### 2. Cursor Configuration
1. Open your project in Cursor IDE
2. Navigate to `Cursor Settings > Rules`
3. Verify that project rules are detected and active
4. Test with a simple code generation task

### 3. Workflow Integration
Follow the **qnew-qplan-qcode-qcheck-qgit** workflow:

- **qnew**: Clear context, start fresh session
- **qplan**: Create detailed implementation plan
- **qcode**: Follow progressive enhancement pattern
- **qcheck**: Run quality validation
- **qgit**: Commit with proper attribution

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

### Starting a New Feature
```
Context: Senior developer working on Node.js e-commerce API
Architecture: RESTful API, Express.js, PostgreSQL, Redis cache
Task: Implement user authentication with JWT tokens
Requirements: OWASP compliant, 85% test coverage, <200ms response time
Constraints: Use existing auth patterns, bcrypt for passwords
```

### Commit Message Format
```
feat: Add JWT-based user authentication (AI-assisted)

- Generated with: Claude Code v3.5.0
- Reviewed by: Jane Smith
- Modified: Added rate limiting and improved error messages
- Security review: Completed - no issues found
- Test coverage: 92% (exceeds 85% requirement)

AI-Tool: Claude Code
Prompt: "Create secure JWT authentication with proper validation, 
rate limiting, and comprehensive error handling"

Closes #123
```

## Customization

### Project-Specific Rules
Create additional rules in subdirectories:
```
project/
  .cursor/rules/           # Global project rules
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

## Monitoring and Metrics

### Track These KPIs
- **AI Effectiveness**: >80% success rate, <20% intervention rate
- **Development Velocity**: 25% time-to-market improvement
- **Code Quality**: Complexity <10, maintainability >60
- **Bug Rates**: <5% defect escape rate for AI-generated code

### Regular Reviews
- **Weekly**: Code pattern analysis
- **Monthly**: Security and performance audit  
- **Quarterly**: Rules updates based on lessons learned
- **Annually**: Comprehensive framework assessment

## Red Flags - When NOT to Use AI

❌ **NEVER** use AI for:
- Cryptographic implementations
- Financial calculations requiring precision  
- Regulatory compliance code
- Safety-critical systems
- PII handling without human review

## Support and Updates

### Framework Maintenance
- Keep rules updated with latest security standards
- Monitor industry best practices and incorporate changes
- Regular team training on framework usage
- Document lessons learned and update protocols

### Getting Help
- Review emergency protocols for immediate issues
- Consult security team for vulnerability concerns
- Escalate quality issues through proper channels
- Document and share learnings with the team

---

**Version**: 1.0  
**Last Updated**: [Current Date]  
**Maintainer**: [Your Name/Team]  

This framework is designed to evolve with your team's needs and industry best practices. Regular updates and team feedback are essential for maintaining its effectiveness.
