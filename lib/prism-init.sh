#!/bin/bash
# PRISM Initialization Library
# Version: 2.0.1

# Initialize PRISM in current directory
prism_init() {
    local template=${1:-default}
    local minimal=${2:-false}

    log_info "Creating PRISM structure..."

    # Create directories
    mkdir -p .prism/{context,sessions,references,config}
    mkdir -p .claude

    # Create context files
    cat > .prism/context/patterns.md << 'EOF'
# Patterns

This file contains learned patterns and best practices for this project.

## Code Patterns
- Document patterns as they emerge

## Architecture Patterns
- Record architectural decisions

## Testing Patterns
- Note testing strategies
EOF

    cat > .prism/context/architecture.md << 'EOF'
# Architecture

This file documents the system architecture.

## Overview
- System purpose and goals

## Components
- Major system components

## Data Flow
- How data moves through the system

## Technologies
- Tech stack and dependencies
EOF

    cat > .prism/context/decisions.md << 'EOF'
# Decisions

Record important technical decisions.

## Decision Log

### Date: [YYYY-MM-DD]
**Decision**: What was decided
**Rationale**: Why this decision was made
**Consequences**: Expected impact
EOF

    # Create PRISM.md
    cat > PRISM.md << 'EOF'
# PRISM Configuration

This project uses PRISM (Persistent Real-time Intelligent System Management).

## Project Context
- **Type**: [Project type]
- **Started**: $(date +%Y-%m-%d)
- **Status**: Active

## Key Patterns
See `.prism/context/patterns.md`

## Architecture
See `.prism/context/architecture.md`

## Decisions
See `.prism/context/decisions.md`
EOF

    # Create CLAUDE.md
    cat > CLAUDE.md << 'EOF'
# CLAUDE.md

## 🎯 CRITICAL: PRISM Framework Integration

**MANDATORY**: This project uses the PRISM framework. You MUST:

### 1. Check PRISM Context First
Before making ANY changes, review:
- `.prism/context/patterns.md` - Established patterns
- `.prism/context/architecture.md` - System architecture
- `.prism/context/decisions.md` - Technical decisions

### 2. Maintain Context
Update relevant context files when:
- Establishing new patterns
- Making architectural changes
- Making significant decisions

### 3. Session Awareness
This project tracks development sessions for continuity.

## Project-Specific Instructions
[Add your project-specific instructions here]
EOF

    # Create index file
    cat > .prism/index.yaml << 'EOF'
# PRISM Index
version: 2.0.1
created: $(date -u +%Y-%m-%dT%H:%M:%SZ)
project:
  name: $(basename "$PWD")
  type: $template

context:
  patterns: .prism/context/patterns.md
  architecture: .prism/context/architecture.md
  decisions: .prism/context/decisions.md

sessions:
  active: null
  directory: .prism/sessions/
EOF

    log_info "✅ PRISM structure created"

    # Create gitignore entries
    if [[ -f .gitignore ]]; then
        if ! grep -q "^.prism/sessions/" .gitignore; then
            echo "" >> .gitignore
            echo "# PRISM" >> .gitignore
            echo ".prism/sessions/" >> .gitignore
            echo ".prism/config/local.yaml" >> .gitignore
            log_info "✅ Updated .gitignore"
        fi
    else
        cat > .gitignore << 'EOF'
# PRISM
.prism/sessions/
.prism/config/local.yaml
EOF
        log_info "✅ Created .gitignore"
    fi

    return 0
}