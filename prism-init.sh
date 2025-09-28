#!/bin/bash

# PRISM Framework Initialization Script
# Initializes PRISM framework in a new project directory

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Header
echo -e "${BOLD}${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${BOLD}${BLUE}           PRISM Framework Initialization${NC}"
echo -e "${BOLD}${BLUE}═══════════════════════════════════════════════════════${NC}"
echo ""

# Function to create directory structure
create_prism_structure() {
    echo -e "${BLUE}Creating PRISM directory structure...${NC}"

    # Create main directories
    mkdir -p .prism/context
    mkdir -p .prism/sessions/archive
    mkdir -p .prism/references
    mkdir -p .prism/backups

    echo -e "${GREEN}✓ Directory structure created${NC}"
}

# Function to create context files
create_context_files() {
    echo -e "${BLUE}Creating context management files...${NC}"

    # Create architecture.md
    cat > .prism/context/architecture.md << 'EOF'
# System Architecture
**Last Updated**: $(date -Iseconds)
**Priority**: CRITICAL
**Tags**: [architecture, system-design, core]

## Summary
Core architectural decisions and system design patterns for this project.

## System Components
<!-- Define your system components here -->

## Design Patterns
<!-- Document architectural patterns used -->

## Technology Stack
<!-- List core technologies and frameworks -->

## Related
- patterns.md - Implementation patterns
- decisions.md - Decision log
EOF

    # Create patterns.md
    cat > .prism/context/patterns.md << 'EOF'
# Code Patterns & Conventions
**Last Updated**: $(date -Iseconds)
**Priority**: HIGH
**Tags**: [patterns, conventions, standards]

## Summary
Established code patterns and conventions for consistent development.

## Naming Conventions
<!-- Define naming standards -->

## Code Organization
<!-- Document file/folder structure patterns -->

## Common Patterns
<!-- List frequently used patterns -->

## Anti-Patterns to Avoid
<!-- Document what NOT to do -->

## Related
- architecture.md - System architecture
- decisions.md - Pattern decisions
EOF

    # Create decisions.md
    cat > .prism/context/decisions.md << 'EOF'
# Technical Decisions Log
**Last Updated**: $(date -Iseconds)
**Priority**: HIGH
**Tags**: [decisions, rationale, history]

## Summary
Log of technical decisions with rationale and trade-offs.

## Decision Template
```
### [Date] - [Decision Title]
**Context**: What prompted this decision
**Decision**: What was decided
**Rationale**: Why this approach
**Trade-offs**: What we're accepting/rejecting
**Alternatives**: Other options considered
```

## Decisions

<!-- Add decisions here using the template above -->

## Related
- architecture.md - Architectural impact
- patterns.md - Pattern implications
EOF

    # Create dependencies.md
    cat > .prism/context/dependencies.md << 'EOF'
# Dependencies & Versions
**Last Updated**: $(date -Iseconds)
**Priority**: MEDIUM
**Tags**: [dependencies, packages, versions]

## Summary
External dependencies, versions, and update policies.

## Core Dependencies
<!-- List main dependencies with versions -->

## Development Dependencies
<!-- List dev-only dependencies -->

## Security Considerations
<!-- Note any security concerns with dependencies -->

## Update Policy
<!-- Define when/how to update dependencies -->

## Related
- architecture.md - Dependency decisions
- security-rules.md - Security requirements
EOF

    # Create domain.md
    cat > .prism/context/domain.md << 'EOF'
# Business Domain & Rules
**Last Updated**: $(date -Iseconds)
**Priority**: HIGH
**Tags**: [domain, business-logic, rules]

## Summary
Business domain knowledge, rules, and constraints.

## Domain Entities
<!-- Define key business entities -->

## Business Rules
<!-- Document business logic and constraints -->

## Workflows
<!-- Describe business processes -->

## Validation Rules
<!-- List validation requirements -->

## Related
- architecture.md - Technical implementation
- patterns.md - Domain patterns
EOF

    echo -e "${GREEN}✓ Context files created${NC}"
}

# Function to create session files
create_session_files() {
    echo -e "${BLUE}Creating session management files...${NC}"

    # Create current session file
    cat > .prism/sessions/current.md << 'EOF'
# Current Session Context
**Started**: $(date -Iseconds)
**Status**: Active

## Session Goals
<!-- What are we trying to accomplish -->

## Current Task
<!-- What we're working on right now -->

## Context Loaded
<!-- Which context files are in use -->

## Decisions Made
<!-- Decisions made this session -->

## Patterns Applied
<!-- Patterns used/discovered -->

## Next Steps
<!-- What comes next -->
EOF

    echo -e "${GREEN}✓ Session files created${NC}"
}

# Function to create reference files
create_reference_files() {
    echo -e "${BLUE}Creating reference files...${NC}"

    # Create security rules
    cat > .prism/references/security-rules.md << 'EOF'
# Security Requirements
**Last Updated**: $(date -Iseconds)
**Priority**: CRITICAL
**Tags**: [security, compliance, critical]

## Security Standards
- [ ] Input validation on all user inputs
- [ ] SQL injection prevention (parameterized queries)
- [ ] XSS prevention (output encoding)
- [ ] CSRF protection
- [ ] Secure session management
- [ ] Proper authentication & authorization
- [ ] Sensitive data encryption
- [ ] Security headers configured
- [ ] Error messages don't leak information
- [ ] Dependencies regularly updated

## OWASP Top 10 Checklist
- [ ] Injection
- [ ] Broken Authentication
- [ ] Sensitive Data Exposure
- [ ] XML External Entities (XXE)
- [ ] Broken Access Control
- [ ] Security Misconfiguration
- [ ] Cross-Site Scripting (XSS)
- [ ] Insecure Deserialization
- [ ] Using Components with Known Vulnerabilities
- [ ] Insufficient Logging & Monitoring

## Compliance Requirements
<!-- Add any compliance requirements (GDPR, HIPAA, etc.) -->

## Security Review Process
1. Code review for security issues
2. Dependency vulnerability scan
3. Security testing
4. Penetration testing (if applicable)
EOF

    echo -e "${GREEN}✓ Reference files created${NC}"
}

# Function to create index file
create_index_file() {
    echo -e "${BLUE}Creating context index...${NC}"

    cat > .prism/index.yaml << 'EOF'
# PRISM Context Index
# Auto-generated index for fast context retrieval

version: 1.0.0
last_updated: $(date -Iseconds)

# Priority contexts loaded on every session
critical_context:
  - path: context/architecture.md
    tags: [architecture, system-design, core]
    summary: Core architectural decisions and system design

  - path: references/security-rules.md
    tags: [security, compliance, critical]
    summary: Security requirements and compliance rules

# High priority contexts for common tasks
high_priority:
  - path: context/patterns.md
    tags: [patterns, conventions, standards]
    summary: Code patterns and conventions

  - path: context/decisions.md
    tags: [decisions, rationale, history]
    summary: Technical decisions log

  - path: context/domain.md
    tags: [domain, business-logic, rules]
    summary: Business domain knowledge

# Medium priority contexts
medium_priority:
  - path: context/dependencies.md
    tags: [dependencies, packages, versions]
    summary: External dependencies and versions

# Session management
sessions:
  current: sessions/current.md
  archive_path: sessions/archive/

# Reference documents
references:
  - path: references/security-rules.md
    tags: [security, compliance]
    summary: Security standards and requirements
EOF

    echo -e "${GREEN}✓ Index file created${NC}"
}

# Function to create main PRISM.md file
create_prism_md() {
    echo -e "${BLUE}Creating PRISM.md configuration file...${NC}"

    # Copy from global if exists, otherwise create new
    if [ -f "$HOME/.claude/PRISM.md" ]; then
        cp "$HOME/.claude/PRISM.md" ./PRISM.md
        echo -e "${GREEN}✓ PRISM.md copied from global configuration${NC}"
    else
        cat > PRISM.md << 'EOF'
# PRISM Framework - Project Configuration

This project uses the PRISM (Persistent Real-time Intelligent System Management) framework.

## Quick Start
- Context files: `.prism/context/`
- Current session: `.prism/sessions/current.md`
- Security rules: `.prism/references/security-rules.md`

## Project-Specific Configuration
<!-- Add any project-specific PRISM configuration here -->

For full PRISM documentation, see ~/.claude/PRISM.md
EOF
        echo -e "${GREEN}✓ PRISM.md created${NC}"
    fi
}

# Function to create CLAUDE.md file for Claude Code instructions
create_claude_md() {
    echo -e "${BLUE}Creating CLAUDE.md for Claude Code instructions...${NC}"

    # Get project name from current directory
    PROJECT_NAME=$(basename "$PWD")

    cat > CLAUDE.md << EOF
# CLAUDE.md

This file provides guidance to Claude Code when working with code in this repository.

## 🎯 CRITICAL: PRISM Framework Integration

**MANDATORY**: This project uses the PRISM (Persistent Real-time Intelligent System Management) framework. You MUST:

### 1. Check PRISM Context First
Before any operation, always check \`.prism/context/\` for:
- \`architecture.md\` - System design decisions
- \`patterns.md\` - Established code patterns
- \`decisions.md\` - Technical decisions log
- \`dependencies.md\` - Dependency management
- \`domain.md\` - Business logic and rules

### 2. Maintain Session Continuity
- Read \`.prism/sessions/current.md\` at session start
- Update session state during work
- Archive sessions when appropriate

### 3. Update Context in Real-Time
- Document new patterns in \`.prism/context/patterns.md\`
- Log decisions in \`.prism/context/decisions.md\`
- Update architecture documentation when changes are made

### 4. Use Context Management Tool
- Run \`./prism-context.sh status\` to check framework health
- Use \`./prism-context.sh show [file]\` to review context
- Update context files as patterns emerge

### 5. Reference Project Configuration
- Always consult \`PRISM.md\` for project-specific settings
- Follow quality gates and standards defined there
- Maintain ≥90% context retention across operations

## Project Overview

**Project Name**: ${PROJECT_NAME}
**Framework**: PRISM-enabled
**Created**: $(date -Iseconds)

This project is configured with PRISM for persistent context management. Update this section as the project architecture develops.

## Development Commands

\`\`\`bash
# To be added as the project structure is defined
# npm start
# npm test
# npm build
\`\`\`

## Architecture & Structure

\`\`\`
${PROJECT_NAME}/
├── .prism/              # PRISM context management
│   ├── context/         # Persistent project knowledge
│   ├── sessions/        # Session tracking
│   └── references/      # API specs and documentation
├── src/                 # Source code (to be created)
├── tests/               # Test files (to be created)
└── docs/                # Documentation (to be created)
\`\`\`

## PRISM Framework Commands

### Essential PRISM Operations
\`\`\`bash
# Check framework status
./prism-context.sh status

# View context files
./prism-context.sh show architecture
./prism-context.sh show patterns
./prism-context.sh show decisions
./prism-context.sh show dependencies
./prism-context.sh show domain

# Update context
./prism-context.sh add [file] [priority] [tags] "[content]"

# Query context
./prism-context.sh query "[search term]"

# Session management
./prism-context.sh archive  # Archive current session
\`\`\`

## Important Reminders

### On Every Session Start:
1. ✅ Read \`.prism/sessions/current.md\` to understand session context
2. ✅ Check \`.prism/context/decisions.md\` for recent technical decisions
3. ✅ Review \`.prism/context/patterns.md\` for established patterns
4. ✅ Verify PRISM status with \`./prism-context.sh status\`

### During Development:
1. 📝 Update \`.prism/context/patterns.md\` when new patterns emerge
2. 📝 Log all technical decisions in \`.prism/context/decisions.md\`
3. 📝 Keep \`.prism/context/architecture.md\` current with design changes
4. 📝 Track dependencies in \`.prism/context/dependencies.md\`
5. 📝 Document domain knowledge in \`.prism/context/domain.md\`

### Before Session End:
1. 💾 Update \`.prism/sessions/current.md\` with session summary
2. 💾 Archive important sessions with \`./prism-context.sh archive\`
3. 💾 Ensure all context files are updated with new learnings

## Quality Gates

\`\`\`yaml
# PRISM enforces these standards
coverage:
  unit_tests: ≥85%
  security_paths: 100%
complexity:
  cyclomatic: <10
  cognitive: <15
performance:
  api_response: <200ms
  page_load: <3s
security:
  owasp_scan: passed
  vulnerabilities: 0 CRITICAL
\`\`\`

## Notes

- ⚠️ This repository uses PRISM framework for persistent context management
- ⚠️ ALL architectural decisions and patterns MUST be documented in PRISM
- ⚠️ Context persistence is CRITICAL for project continuity
- ⚠️ Never skip reading PRISM context at session start

### Update this file when:
- Build tools and dependencies are added
- Core architecture decisions are made (also update PRISM context)
- Development workflows are established
- Testing frameworks are configured
- New team members join the project

---

**PRISM Framework Active** - Context persistence enabled
*Last Updated*: $(date -Iseconds)
EOF

    echo -e "${GREEN}✓ CLAUDE.md created${NC}"
}

# Function to create prism-context.sh if not exists
create_context_script() {
    if [ ! -f "prism-context.sh" ]; then
        echo -e "${BLUE}Creating context management script...${NC}"

        # Download from repository or create basic version
        if command -v curl &> /dev/null; then
            curl -s -f -o prism-context.sh "https://raw.githubusercontent.com/afiffattouh/hildens-prism/main/prism-context.sh"
            if [ $? -eq 0 ]; then
                chmod +x prism-context.sh
                echo -e "${GREEN}✓ prism-context.sh downloaded${NC}"
            else
                echo -e "${YELLOW}⚠ Could not download prism-context.sh${NC}"
            fi
        fi
    fi
}

# Function to create .gitignore entries
update_gitignore() {
    echo -e "${BLUE}Updating .gitignore...${NC}"

    # Check if .gitignore exists
    if [ ! -f .gitignore ]; then
        touch .gitignore
    fi

    # Check if PRISM entries exist
    if ! grep -q "# PRISM Framework" .gitignore; then
        cat >> .gitignore << 'EOF'

# PRISM Framework
.prism/sessions/current.md
.prism/sessions/archive/
.prism/backups/
.prism/.time_sync
.prism/.last_update
EOF
        echo -e "${GREEN}✓ .gitignore updated${NC}"
    else
        echo -e "${YELLOW}⚠ .gitignore already has PRISM entries${NC}"
    fi
}

# Function to create time sync file
create_time_sync() {
    echo -e "${BLUE}Creating time sync file...${NC}"

    cat > .prism/.time_sync << EOF
# PRISM Time Synchronization Log
Last Sync: $(date -Iseconds)
System Time: $(date)
UTC Time: $(date -u)
Timezone: $(date +%Z)
EOF

    echo -e "${GREEN}✓ Time sync file created${NC}"
}

# Main initialization function
initialize_prism() {
    # Check if already initialized
    if [ -d ".prism" ]; then
        echo -e "${YELLOW}⚠ PRISM appears to be already initialized in this project${NC}"
        read -p "Do you want to reinitialize? This will preserve your context files. (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo -e "${BLUE}Initialization cancelled${NC}"
            exit 0
        fi

        # Backup existing context
        if [ -d ".prism/context" ]; then
            backup_dir=".prism/backups/$(date +%Y%m%d_%H%M%S)"
            mkdir -p "$backup_dir"
            cp -r .prism/context "$backup_dir/"
            echo -e "${GREEN}✓ Existing context backed up to $backup_dir${NC}"
        fi
    fi

    # Create structure
    create_prism_structure

    # Only create new files if they don't exist
    if [ ! -f ".prism/context/architecture.md" ]; then
        create_context_files
    else
        echo -e "${YELLOW}⚠ Context files already exist, skipping creation${NC}"
    fi

    create_session_files

    if [ ! -f ".prism/references/security-rules.md" ]; then
        create_reference_files
    else
        echo -e "${YELLOW}⚠ Reference files already exist, skipping creation${NC}"
    fi

    create_index_file
    create_prism_md
    create_claude_md
    create_context_script
    update_gitignore
    create_time_sync

    # Final message
    echo ""
    echo -e "${BOLD}${GREEN}═══════════════════════════════════════════════════════${NC}"
    echo -e "${BOLD}${GREEN}        PRISM Framework Initialized Successfully!${NC}"
    echo -e "${BOLD}${GREEN}═══════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${BLUE}Project Structure Created:${NC}"
    echo "  .prism/"
    echo "  ├── context/          # Persistent context files"
    echo "  ├── sessions/         # Session management"
    echo "  ├── references/       # Reference documents"
    echo "  └── index.yaml        # Context index"
    echo ""
    echo -e "${YELLOW}Next Steps:${NC}"
    echo "  1. Update .prism/context/architecture.md with your system design"
    echo "  2. Document patterns in .prism/context/patterns.md as you code"
    echo "  3. Log decisions in .prism/context/decisions.md"
    echo "  4. Run './prism-context.sh status' to verify setup"
    echo ""
    echo -e "${GREEN}PRISM is now active in this project!${NC}"
}

# Parse arguments
case "${1:-}" in
    --help|-h)
        echo "PRISM Framework Initialization"
        echo ""
        echo "Usage: $0 [options]"
        echo ""
        echo "Options:"
        echo "  --help, -h     Show this help message"
        echo "  --force, -f    Force reinitialization"
        echo ""
        echo "This script initializes the PRISM framework in your project,"
        echo "creating all necessary directories and context files."
        exit 0
        ;;
    --force|-f)
        echo -e "${YELLOW}Force initialization mode${NC}"
        rm -rf .prism
        ;;
esac

# Run initialization
initialize_prism