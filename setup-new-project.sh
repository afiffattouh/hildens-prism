#!/bin/bash

# PRISM Framework Setup Script for New Projects
# Usage: ./setup-new-project.sh /path/to/new/project

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Get the directory where this script is located
FRAMEWORK_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Check if project path was provided
if [ $# -eq 0 ]; then
    echo -e "${RED}Error: Please provide the path to your new project${NC}"
    echo "Usage: $0 /path/to/new/project"
    exit 1
fi

PROJECT_DIR="$1"

# Header
echo -e "${BOLD}${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${BOLD}${BLUE}    PRISM AI-Assisted Development Framework Setup${NC}"
echo -e "${BOLD}${BLUE}═══════════════════════════════════════════════════════${NC}"
echo ""

# Create project directory if it doesn't exist
if [ ! -d "$PROJECT_DIR" ]; then
    echo -e "${YELLOW}Creating project directory: $PROJECT_DIR${NC}"
    mkdir -p "$PROJECT_DIR"
fi

# Navigate to project directory
cd "$PROJECT_DIR" || exit

echo -e "${GREEN}Setting up PRISM Framework in: $(pwd)${NC}"
echo ""

# Step 1: Copy framework files
echo -e "${BLUE}Step 1: Copying framework files...${NC}"

# Copy PRISM.md
if cp "$FRAMEWORK_DIR/PRISM.md" .; then
    echo -e "  ✅ PRISM.md copied"
else
    echo -e "  ${RED}❌ Failed to copy PRISM.md${NC}"
fi

# Copy and make executable the context script
if cp "$FRAMEWORK_DIR/prism-context.sh" .; then
    chmod +x prism-context.sh
    echo -e "  ✅ prism-context.sh copied and made executable"
else
    echo -e "  ${RED}❌ Failed to copy prism-context.sh${NC}"
fi

# Copy .prism directory
if cp -r "$FRAMEWORK_DIR/.prism" .; then
    echo -e "  ✅ .prism/ directory structure copied"
else
    echo -e "  ${RED}❌ Failed to copy .prism directory${NC}"
fi

# Don't copy setup files or README - they're not needed in the new project

echo ""

# Step 2: Initialize context system
echo -e "${BLUE}Step 2: Initializing context system...${NC}"
if ./prism-context.sh init; then
    echo -e "  ✅ Context system initialized"
else
    echo -e "  ${RED}❌ Failed to initialize context system${NC}"
fi

echo ""

# Step 3: Detect project type and customize
echo -e "${BLUE}Step 3: Detecting project type...${NC}"

# Check for various project indicators
if [ -f "package.json" ]; then
    echo -e "  📦 Node.js/JavaScript project detected"
    PROJECT_TYPE="node"

    # Check for specific frameworks
    if grep -q "react" package.json; then
        echo -e "  ⚛️  React framework detected"
        PROJECT_TYPE="react"
    elif grep -q "vue" package.json; then
        echo -e "  🖖 Vue framework detected"
        PROJECT_TYPE="vue"
    elif grep -q "angular" package.json; then
        echo -e "  🅰️  Angular framework detected"
        PROJECT_TYPE="angular"
    elif grep -q "express" package.json; then
        echo -e "  🚂 Express backend detected"
        PROJECT_TYPE="express"
    fi
elif [ -f "requirements.txt" ] || [ -f "pyproject.toml" ] || [ -f "setup.py" ]; then
    echo -e "  🐍 Python project detected"
    PROJECT_TYPE="python"
elif [ -f "Gemfile" ]; then
    echo -e "  💎 Ruby project detected"
    PROJECT_TYPE="ruby"
elif [ -f "go.mod" ]; then
    echo -e "  🐹 Go project detected"
    PROJECT_TYPE="go"
elif [ -f "Cargo.toml" ]; then
    echo -e "  🦀 Rust project detected"
    PROJECT_TYPE="rust"
elif [ -f "pom.xml" ] || [ -f "build.gradle" ]; then
    echo -e "  ☕ Java project detected"
    PROJECT_TYPE="java"
else
    echo -e "  📁 Generic project (no specific framework detected)"
    PROJECT_TYPE="generic"
fi

echo ""

# Step 4: Customize context based on project type
echo -e "${BLUE}Step 4: Customizing context for $PROJECT_TYPE project...${NC}"

# Add project-specific patterns
case $PROJECT_TYPE in
    react)
        cat >> .prism/context/patterns.md << 'EOF'

## React-Specific Patterns

### Component Structure
- Functional components with hooks
- Component files: ComponentName.tsx
- Style files: ComponentName.module.css
- Test files: ComponentName.test.tsx

### State Management
- Context API for global state
- Custom hooks for logic reuse
- Local state with useState/useReducer

### Best Practices
- Lazy loading for routes
- Memoization for expensive computations
- Error boundaries for fault tolerance
EOF
        echo -e "  ✅ React patterns added"
        ;;

    python)
        cat >> .prism/context/patterns.md << 'EOF'

## Python-Specific Patterns

### Code Style
- PEP 8 compliance
- Type hints for all functions
- Docstrings for modules, classes, functions

### Project Structure
```
project/
├── src/
│   └── project_name/
├── tests/
├── docs/
└── requirements.txt
```

### Testing
- pytest for unit tests
- Coverage minimum: 80%
- Fixtures for test data
EOF
        echo -e "  ✅ Python patterns added"
        ;;

    express)
        cat >> .prism/context/patterns.md << 'EOF'

## Express-Specific Patterns

### API Structure
- Routes in /routes directory
- Controllers in /controllers
- Middleware in /middleware
- Models in /models

### Best Practices
- Async/await for all async operations
- Error handling middleware
- Request validation with Joi/express-validator
- JWT for authentication
EOF
        echo -e "  ✅ Express patterns added"
        ;;

    *)
        echo -e "  ℹ️  Using generic patterns"
        ;;
esac

echo ""

# Step 5: Create initial session file
echo -e "${BLUE}Step 5: Creating initial session...${NC}"

cat > .prism/sessions/current.md << EOF
# Current Session Context

**Session Started**: $(date -Iseconds)
**Project Type**: $PROJECT_TYPE
**Project Path**: $(pwd)
**Framework Version**: 1.0.0

## Project Setup
- Framework initialized on $(date +"%Y-%m-%d")
- Project type detected: $PROJECT_TYPE
- Ready for AI-assisted development

## Next Steps
1. Review and customize .prism/context/architecture.md
2. Update .prism/context/dependencies.md with your libraries
3. Define business rules in .prism/context/domain.md
4. Start coding with PRISM!

## Notes
- Run ./prism-context.sh status to check system
- Run ./prism-context.sh archive to save sessions
- Update context files as project evolves

---
*Auto-generated by setup script*
EOF

echo -e "  ✅ Initial session created"
echo ""

# Step 6: Git integration (if applicable)
if [ -d ".git" ] || git rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "${BLUE}Step 6: Setting up Git integration...${NC}"

    # Add .prism to .gitignore if it doesn't exist
    if [ ! -f ".gitignore" ]; then
        touch .gitignore
    fi

    if ! grep -q "^.prism/sessions/" .gitignore 2>/dev/null; then
        echo -e "\n# PRISM Framework (sensitive session data)" >> .gitignore
        echo ".prism/sessions/current.md" >> .gitignore
        echo ".prism/sessions/history/" >> .gitignore
        echo ".prism/.time_sync" >> .gitignore
        echo -e "  ✅ Added Claude session files to .gitignore"
    fi
else
    echo -e "${YELLOW}Step 6: No Git repository detected (skipping Git integration)${NC}"
fi

echo ""

# Step 7: Create quick reference
echo -e "${BLUE}Step 7: Creating quick reference...${NC}"

cat > PRISM_QUICK_REFERENCE.md << 'EOF'
# PRISM Quick Reference

## Essential Commands

```bash
# Check status
./prism-context.sh status

# Add context
./prism-context.sh add [file] [priority] [tags] "[content]"

# Search context
./prism-context.sh query "[search term]"

# Archive session
./prism-context.sh archive

# Export for team
./prism-context.sh export
```

## Key Files to Customize

1. `.prism/context/architecture.md` - Your system design
2. `.prism/context/patterns.md` - Your coding patterns
3. `.prism/context/dependencies.md` - Your tech stack
4. `.prism/context/domain.md` - Your business logic
5. `.prism/context/decisions.md` - Your technical decisions

## When Coding with PRISM

1. Claude automatically syncs time on start
2. Claude loads your context from `.prism/`
3. Claude follows patterns in `PRISM.md`
4. Update context as you make decisions
5. Archive sessions for history

## Framework Principles

- 🛡️ Security first (45% of AI code has vulnerabilities)
- ✅ 85% test coverage minimum
- 📋 Progressive enhancement pattern
- 🔄 Multi-agent workflows (automatic)
- 🧠 Persistent context across sessions

---
*Generated during setup - see PRISM.md for complete framework*
EOF

echo -e "  ✅ Quick reference created"
echo ""

# Final summary
echo -e "${BOLD}${GREEN}═══════════════════════════════════════════════════════${NC}"
echo -e "${BOLD}${GREEN}    ✅ Framework Setup Complete!${NC}"
echo -e "${BOLD}${GREEN}═══════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${GREEN}Project configured at: $(pwd)${NC}"
echo -e "${GREEN}Project type: $PROJECT_TYPE${NC}"
echo ""
echo -e "${BOLD}Next Steps:${NC}"
echo -e "  1. Review ${BLUE}PRISM.md${NC} for framework guidelines"
echo -e "  2. Customize ${BLUE}.prism/context/architecture.md${NC}"
echo -e "  3. Update ${BLUE}.prism/context/dependencies.md${NC}"
echo -e "  4. Start coding with PRISM!"
echo ""
echo -e "${YELLOW}Tip: Run ${BOLD}./prism-context.sh status${NC}${YELLOW} to verify setup${NC}"
echo ""

# Test the setup
echo -e "${BLUE}Testing setup...${NC}"
if ./prism-context.sh status > /dev/null 2>&1; then
    echo -e "  ✅ Context system working correctly"
else
    echo -e "  ${RED}⚠️  Issue with context system - run ./prism-context.sh init${NC}"
fi

echo ""
echo -e "${BOLD}${GREEN}Happy coding with PRISM! 🚀${NC}"