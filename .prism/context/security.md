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
