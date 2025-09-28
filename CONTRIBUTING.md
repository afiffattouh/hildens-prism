# Contributing to PRISM

Thank you for considering contributing to PRISM! We welcome contributions from the community.

## Code of Conduct

By participating in this project, you agree to abide by our principles:
- Be respectful and inclusive
- Welcome newcomers and help them get started
- Focus on constructive criticism
- Respect differing opinions

## How to Contribute

### Reporting Issues

Before creating an issue, please:
1. Search existing issues to avoid duplicates
2. Use issue templates when available
3. Provide clear reproduction steps
4. Include system information

### Suggesting Features

Feature requests are welcome! Please:
1. Check the roadmap and existing requests
2. Explain the use case clearly
3. Consider implementation complexity
4. Be open to alternatives

### Pull Requests

#### Getting Started

1. Fork the repository
2. Create a feature branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. Make your changes
4. Test thoroughly
5. Commit with clear messages

#### Commit Messages

Follow conventional commits:
```
feat: Add new feature
fix: Fix bug in component
docs: Update documentation
test: Add tests
refactor: Refactor code
style: Format code
chore: Update dependencies
```

#### Pull Request Process

1. Update documentation if needed
2. Add tests for new features
3. Ensure all tests pass
4. Update CHANGELOG.md
5. Request review from maintainers

### Development Setup

1. Clone your fork:
   ```bash
   git clone https://github.com/your-username/hildens-prism.git
   cd hildens-prism
   ```

2. Install development dependencies:
   ```bash
   ./install-secure.sh --dev
   ```

3. Run tests:
   ```bash
   ./bin/prism test
   ```

### Testing

- Write tests for new features
- Maintain test coverage above 80%
- Test on multiple platforms
- Include edge cases

### Code Style

- Follow existing code patterns
- Use meaningful variable names
- Comment complex logic
- Keep functions small and focused

#### Bash Guidelines

- Use `set -euo pipefail`
- Quote variables: `"${var}"`
- Check command existence before use
- Handle errors gracefully
- Add inline documentation

### Documentation

- Update README for user-facing changes
- Document new functions/commands
- Include examples
- Keep language clear and concise

## Review Process

1. Maintainers will review within 7 days
2. Address feedback constructively
3. Iterate until approval
4. Maintainers will merge approved PRs

## Recognition

Contributors will be:
- Listed in CONTRIBUTORS.md
- Mentioned in release notes
- Given credit in documentation

## Questions?

- Open a discussion for general questions
- Check existing documentation
- Ask in pull request comments
- Be patient with responses

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for helping make PRISM better! 🎉