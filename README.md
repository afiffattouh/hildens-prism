# PRISM Framework - Persistent Real-time Intelligent System Management

> **Enhanced AI-assisted development with persistent context management for Claude Code**

## 🚀 Quick Install (One Command)

```bash
curl -sSL https://raw.githubusercontent.com/afiffattouh/hildens-prism/main/install-prism.sh | bash
```

## 🎯 What is PRISM?

PRISM transforms Claude Code into an intelligent development assistant that remembers your project context across sessions:

- 🧠 **Persistent Memory** - Never explain your project architecture twice
- 📝 **Decision Tracking** - All technical decisions documented automatically
- 🔍 **Pattern Learning** - Applies your coding patterns consistently
- ⚡ **Instant Context** - No more repetitive explanations
- 🛡️ **Security First** - Built-in OWASP compliance and vulnerability scanning

## 📦 Installation

### Method 1: Automatic Installation (Recommended)
```bash
# Install PRISM globally
curl -sSL https://raw.githubusercontent.com/afiffattouh/hildens-prism/main/install-prism.sh | bash

# Add to PATH (add to your .bashrc/.zshrc)
export PATH="$PATH:$HOME/.claude"

# Initialize in any project
cd your-project
prism init
```

### Method 2: Manual Installation
```bash
# Clone the repository
git clone https://github.com/afiffattouh/hildens-prism.git
cd hildens-prism

# Run the installer
./install-prism.sh
```

## 🏁 Getting Started

### 1. Initialize PRISM in Your Project
```bash
cd your-project
~/.claude/prism-init.sh  # or 'prism init' if PATH is set
```

This creates:
```
your-project/
├── .prism/
│   ├── context/         # Persistent memory
│   │   ├── architecture.md
│   │   ├── patterns.md
│   │   ├── decisions.md
│   │   └── domain.md
│   ├── sessions/        # Session tracking
│   └── references/      # Documentation
└── PRISM.md            # Project config
```

### 2. Start Using Claude Code
PRISM automatically:
- Syncs time on session start via WebSearch
- Loads your project context
- Applies learned patterns
- Tracks decisions

## 💡 Key Features

### Persistent Context Management
```bash
# Context is automatically maintained in .prism/
.prism/context/
├── architecture.md     # System design decisions
├── patterns.md        # Code patterns & conventions
├── decisions.md       # Technical decisions log
├── dependencies.md    # External libraries
└── domain.md         # Business logic & rules
```

### Automatic Time Synchronization
On every session start, PRISM:
1. WebSearches for current UTC time
2. Validates against system time
3. Uses accurate timestamps for all operations

### Security Standards
Built-in security validation:
- OWASP Top 10 scanning
- SQL injection prevention
- XSS protection
- Authentication review
- Input validation

### Quality Gates
```yaml
coverage:
  unit_tests: 85%
  security_paths: 100%
complexity:
  cyclomatic: <10
performance:
  api_response: <200ms
```

## 📋 Development Workflow

### Task Decomposition Pattern
```yaml
Task: "Implement user authentication"
PRISM Decomposes:
  1. Define API contracts
  2. Create data models
  3. Implement auth logic
  4. Add security validation
  5. Write tests (85% coverage)
  6. Document decisions
```

### Progressive Enhancement
1. **Basic** → Working functionality
2. **Secure** → Input validation, error handling
3. **Optimize** → Performance profiling
4. **Test** → Comprehensive coverage
5. **Refactor** → Maintainability

## 🔧 Context Management Commands

```bash
# Check status
./prism-context.sh status

# Add context
./prism-context.sh add decisions.md HIGH "auth,security" "Chose JWT for stateless auth"

# Query context
./prism-context.sh query "authentication"

# Archive session
./prism-context.sh archive
```

## 🔄 Updating PRISM

```bash
# Check for updates
./prism-update.sh --check

# Install updates (preserves your context)
./prism-update.sh
```

### Protected Files (Never Modified)
- `.prism/context/` - Your architecture, patterns, decisions
- `.prism/sessions/` - Your session history
- `.prism/references/` - Your API specs and rules

## 📊 Success Metrics

Track these KPIs:
```yaml
quality:
  defect_rate: <5%
  coverage: >85%
velocity:
  time_to_market: -25%
  review_time: -70%
ai_effectiveness:
  success_rate: >80%
```

## 🚨 When NOT to Use AI

Never use AI generation for:
- ❌ Cryptographic implementations
- ❌ Financial calculations
- ❌ Regulatory compliance
- ❌ Safety-critical systems
- ❌ PII handling (without review)

## 🤝 Share with Your Team

Share PRISM with one command:
```bash
curl -sSL https://raw.githubusercontent.com/afiffattouh/hildens-prism/main/install-prism.sh | bash
```

Or share this repository:
```
https://github.com/afiffattouh/hildens-prism
```

## 📚 Documentation

- [Installation Guide](PRISM-INSTALL.md)
- [Framework Documentation](PRISM.md)
- [Setup New Project](SETUP_NEW_PROJECT.md)

## 🛠️ Requirements

- macOS, Linux, or WSL
- Claude Code installed
- curl or wget

## 📝 License

Open source - adapt to your organization's needs while maintaining core security principles.

---

**PRISM Framework** - Making AI development truly intelligent with persistent context
*Version 1.0.0*