# PRISM Framework - Core Files Repository

This repository contains ONLY the core PRISM framework files.

## Core Framework Components

### Executables
- `bin/prism` - Main PRISM CLI

### Libraries (`lib/`)
- `prism-core.sh` - Core framework functions
- `prism-log.sh` - Logging system
- `prism-security.sh` - Security utilities
- `prism-context.sh` - Context management
- `prism-session.sh` - Session management
- `prism-agents.sh` - Agent system (base)
- `prism-agents-enhanced.sh` - Enhanced agent prompts
- `prism-claude-agents.sh` - Claude Agent SDK integration
- `prism-agent-executor.sh` - Agent execution engine
- `prism-agent-prompts.sh` - Agent prompt templates
- `prism-swarms.sh` - Multi-agent swarm coordination
- `prism-skills.sh` - Skills system
- `prism-init.sh` - Project initialization
- `prism-update.sh` - Framework updates
- `prism-doctor.sh` - System diagnostics
- `prism-verification.sh` - Quality verification
- `prism-resource-management.sh` - Resource management

### Scripts (`scripts/`)
- `prism-maintenance.sh` - Maintenance utilities
- `diagnose-prism.sh` - Diagnostic tools
- `update-version.sh` - Version management

### Installation
- `install.sh` - Standard installation script
- `install-secure.sh` - Security-focused installation

### Documentation
- `README.md` - Main documentation
- `PRISM.md` - Framework overview
- `CHANGELOG.md` - Version history
- `SECURITY.md` - Security policy
- `CONTRIBUTING.md` - Contribution guidelines
- `LICENSE` - MIT License
- `CLAUDE.md` - Claude Code integration instructions

### Configuration
- `VERSION` - Current version
- `config/README.md` - Configuration guide
- `.prism_active` - Framework status marker

### PRISM Context (`.prism/`)
- `context/` - Project context files
- `agents/` - Agent configurations and results
- `sessions/` - Session management (excluded: history)
- `index.yaml` - PRISM index
- `AUTO_LOAD` - Auto-load instructions
- `PRISM.md` - Framework documentation
- `TIMESTAMP` - Last update timestamp

## Excluded Files (Not in Repository)

### Website & Deployment
- `website/` - Landing page and documentation site
- `docker/` - Docker configurations
- `Dockerfile` - Container definition
- `docker-compose.yml` - Orchestration
- `DEPLOYMENT.md` - Deployment guide
- `TROUBLESHOOTING.md` - Docker troubleshooting

### Documentation & Examples
- `docs/` - Extended documentation
- `examples/` - Usage examples
- `legacy/` - Legacy versions
- `assets/` - Images and logos

### Reference & Testing
- `.prism/references/` - Implementation references
- `.prism/workflows/` - Workflow documentation
- `.prism/testing/` - Test reports
- `.prism/TEST_REPORT*.md` - Test results

## Why Core Files Only?

This repository focuses on the **PRISM framework** itself - the tools, libraries, and systems that make PRISM work. Deployment configurations, websites, and extended documentation are kept separate to:

1. **Simplify Installation**: Users get only what's needed for PRISM
2. **Reduce Repository Size**: Faster clones and updates
3. **Clear Focus**: Framework development vs. deployment/documentation
4. **Easier Maintenance**: Core framework changes don't affect deployment configs

## Getting Started

```bash
# Install PRISM Framework
curl -fsSL https://raw.githubusercontent.com/afiffattouh/hildens-prism/main/install.sh | bash

# Or clone and install manually
git clone https://github.com/afiffattouh/hildens-prism.git
cd hildens-prism
./install.sh
```

## Local Development

All excluded files (website, Docker configs, etc.) remain in your local directory. They're just not tracked in git. You can still use them locally for:

- Website development (`website/`)
- Docker deployment testing (`docker-compose up`)
- Extended documentation (`docs/`)

---

**PRISM Framework v2.3.0**
*Core framework files only*
