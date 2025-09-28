# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 2.0.x   | :white_check_mark: |
| 1.x.x   | :x:                |

## Security Features

### Input Validation
- All user inputs are sanitized before processing
- Path traversal attempts are blocked
- Command injection prevented through proper escaping

### Secure Installation
- Checksum verification for downloads
- HTTPS-only downloads
- No execution of remote scripts without verification

### File Operations
- Atomic file operations to prevent corruption
- Proper permission handling
- Secure temporary file creation

## Reporting a Vulnerability

If you discover a security vulnerability in PRISM, please:

1. **DO NOT** open a public issue
2. Email security concerns to: [Create a security contact]
3. Include:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

## Security Checklist

Before deployment, ensure:

- [ ] Latest version installed
- [ ] File permissions correctly set
- [ ] No sensitive data in logs
- [ ] Input validation enabled
- [ ] Error messages don't leak system information

## Best Practices

### For Users
- Keep PRISM updated to latest version
- Review scripts before execution
- Use secure installation method
- Regularly run `prism doctor` for health checks

### For Contributors
- Follow secure coding guidelines
- Include security tests with changes
- Document security implications
- Never commit sensitive data

## Security Updates

Security updates are released as:
- **Critical**: Immediate patch releases
- **High**: Within 7 days
- **Medium**: Within 30 days
- **Low**: Next regular release

## Acknowledgments

We appreciate responsible disclosure and will acknowledge security researchers who:
- Report issues responsibly
- Allow time for patches
- Don't exploit vulnerabilities

---

For questions about this policy, open a discussion in our GitHub repository.