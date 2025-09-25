# 🚀 Setting Up PRISM Framework for a New Project

## Quick Setup (< 2 minutes)

### Option 1: Copy Framework Files

```bash
# 1. Navigate to your new project
cd /path/to/your/new-project

# 2. Copy framework files from this directory
cp /Users/afif/Coding\ FW/PRISM.md .
cp /Users/afif/Coding\ FW/prism-context.sh .
cp -r /Users/afif/Coding\ FW/.prism .

# 3. Initialize the context system
./prism-context.sh init

# 4. Your project is ready!
```

### Option 2: Use Setup Script

```bash
# Run the automated setup script (created below)
bash /Users/afif/Coding\ FW/setup-new-project.sh /path/to/your/new-project
```

## 📋 Step-by-Step Manual Setup

### Step 1: Prepare Your Project Directory

```bash
# Create your new project
mkdir my-awesome-app
cd my-awesome-app

# Initialize git (optional but recommended)
git init
```

### Step 2: Install Framework Files

```bash
# Copy the framework configuration
cp ~/path/to/framework/PRISM.md .

# Copy context management script
cp ~/path/to/framework/prism-context.sh .
chmod +x prism-context.sh

# Copy the entire .claude directory structure
cp -r ~/path/to/framework/.prism .
```

### Step 3: Initialize Context System

```bash
# Run initialization
./prism-context.sh init

# This will:
# - Create directory structure
# - Set up time synchronization
# - Initialize context files
# - Create session management
```

### Step 4: Customize for Your Project

#### Update Architecture Context
Edit `.claude/context/architecture.md`:

```markdown
# Architecture Context

**Last Updated**: [timestamp]
**Priority**: CRITICAL
**Tags**: [your-tech-stack]

## System Overview
- **Architecture Style**: [Microservices | Monolithic | Serverless]
- **Primary Stack**: [React, Node.js, PostgreSQL, etc.]
- **Deployment Target**: [AWS | Azure | Vercel | etc.]

## Key Components
### Frontend
- **Framework**: React 18 with TypeScript
- **State Management**: Redux Toolkit
- **UI Library**: Material-UI

### Backend
- **Runtime**: Node.js 20
- **Framework**: Express.js
- **Database**: PostgreSQL 15
- **Cache**: Redis

### Infrastructure
- **Hosting**: AWS ECS
- **CDN**: CloudFront
- **CI/CD**: GitHub Actions
```

#### Set Project Patterns
Edit `.claude/context/patterns.md`:

```markdown
# Code Patterns & Conventions

## Project-Specific Patterns

### File Structure
```
src/
├── components/     # React components
├── services/       # API services
├── utils/         # Utility functions
├── types/         # TypeScript types
└── tests/         # Test files
```

### Naming Conventions
- **Components**: PascalCase (UserProfile.tsx)
- **Utilities**: camelCase (formatDate.ts)
- **Types**: PascalCase with 'I' prefix (IUser)
- **Files**: kebab-case (user-service.ts)
```

#### Define Initial Dependencies
Edit `.claude/context/dependencies.md`:

```markdown
# Dependencies

## Core Dependencies
- react: ^18.2.0 - UI framework
- typescript: ^5.0.0 - Type safety
- axios: ^1.6.0 - HTTP client
- express: ^4.18.0 - Web framework

## Dev Dependencies
- jest: ^29.0.0 - Testing
- eslint: ^8.0.0 - Linting
- prettier: ^3.0.0 - Formatting
```

### Step 5: Configure for Your Tech Stack

#### For React Projects
```bash
# Add to .claude/context/patterns.md
echo "## React Patterns
- Functional components only
- Custom hooks in hooks/ directory
- Context for global state
- Lazy loading for routes" >> .claude/context/patterns.md
```

#### For Node.js Backend
```bash
# Add to .claude/context/architecture.md
echo "## API Structure
- RESTful endpoints
- JWT authentication
- Request validation middleware
- Error handling middleware" >> .claude/context/architecture.md
```

#### For Python Projects
```bash
# Update patterns for Python
echo "## Python Patterns
- PEP 8 compliance
- Type hints everywhere
- pytest for testing
- Black for formatting" >> .claude/context/patterns.md
```

### Step 6: Create First Session

When you start coding with Claude:

```markdown
# Claude will automatically:
1. WebSearch for accurate time
2. Load your project context
3. Understand your patterns
4. Follow your conventions
```

## 🎯 Project-Specific Configurations

### For Different Project Types

#### Web Application
```yaml
# .claude/index.yaml - add under features:
features:
  authentication:
    priority: CRITICAL
    tags: [auth, security, jwt]

  user_management:
    priority: HIGH
    tags: [users, crud, profile]

  api:
    priority: CRITICAL
    tags: [rest, endpoints, validation]
```

#### Mobile App (React Native)
```yaml
features:
  navigation:
    priority: CRITICAL
    tags: [routing, screens, navigation]

  offline_mode:
    priority: HIGH
    tags: [sync, storage, cache]

  push_notifications:
    priority: MEDIUM
    tags: [notifications, firebase, push]
```

#### CLI Tool
```yaml
features:
  commands:
    priority: CRITICAL
    tags: [cli, commands, arguments]

  configuration:
    priority: HIGH
    tags: [config, settings, env]
```

## 📝 First Development Session

### 1. Start with Context
```bash
# Tell Claude about your project
"This is a [type] application using [stack].
Check .claude/context/ for our patterns and architecture."
```

### 2. Use Framework Commands
```bash
# When making decisions
./prism-context.sh add decisions.md HIGH "database,choice" "Chose PostgreSQL for ACID compliance"

# When establishing patterns
./prism-context.sh add patterns.md HIGH "api,rest" "Using REST with /api/v1 prefix"

# Query existing decisions
./prism-context.sh query "authentication"
```

### 3. Let Claude Learn Your Style
```markdown
# First few sessions:
- Claude reads your context files
- Learns your patterns
- Adapts to your style
- Suggests improvements
```

## 🔧 Customization Tips

### 1. Add Project-Specific Rules
Edit `CLAUDE.md` and add a section:

```markdown
## 🏢 Project-Specific Rules

### Our Standards
- **Code Style**: [Your style guide]
- **Git Flow**: [Your branching strategy]
- **PR Process**: [Your review process]
- **Deployment**: [Your deployment process]

### Our Conventions
- **API Versioning**: /api/v{number}
- **Error Format**: { error: { code, message, details } }
- **Date Format**: ISO 8601 always
- **Testing**: Minimum 90% coverage
```

### 2. Create Domain Knowledge
```bash
# Add business logic to domain.md
echo "## Business Rules
- User emails must be verified
- Passwords require 2FA
- Sessions expire after 24 hours
- Rate limit: 100 requests/minute" >> .claude/context/domain.md
```

### 3. Set Security Requirements
```bash
# Add to security-rules.md
echo "## Security Requirements
- All APIs require authentication
- PII must be encrypted at rest
- Audit log all data access
- GDPR compliance required" >> .claude/references/security-rules.md
```

## ✅ Verification Checklist

After setup, verify:

- [ ] `./prism-context.sh init` runs successfully
- [ ] `.claude/` directory structure created
- [ ] `CLAUDE.md` present in project root
- [ ] Time sync configured (check `.claude/.time_sync`)
- [ ] Architecture documented in `.claude/context/architecture.md`
- [ ] Patterns defined in `.claude/context/patterns.md`
- [ ] Dependencies listed in `.claude/context/dependencies.md`

## 🎉 Ready to Code!

Your project now has:
- ✅ AI-assisted development framework
- ✅ Persistent context management
- ✅ Security-first guidelines
- ✅ Quality gates and standards
- ✅ Time synchronization
- ✅ Session management

Start coding with Claude, and the framework will:
- Maintain context across sessions
- Follow your patterns
- Enforce security standards
- Track decisions
- Ensure quality

## 💡 Pro Tips

1. **Update Context Immediately**: When you make architectural decisions, add them right away
2. **Use Tags**: Tag everything for easy retrieval
3. **Archive Sessions**: Run `./prism-context.sh archive` at day's end
4. **Review Weekly**: Check context files weekly and prune outdated info
5. **Share with Team**: Export context with `./prism-context.sh export` for team alignment

---

*Now Claude will understand your project deeply and maintain consistency across all development sessions!*