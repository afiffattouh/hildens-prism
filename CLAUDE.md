# CLAUDE.md - CRITICAL: PRISM Framework Active

## 🚨 MANDATORY: PRISM Context Loading Protocol

**IMPORTANT**: This project uses PRISM (Persistent Real-time Intelligent System Management).
You MUST follow this protocol at the START of EVERY conversation:

### IMMEDIATE ACTIONS REQUIRED:
1. **CHECK TIMESTAMP**: Read `.prism_active` file and note the INITIALIZED and LAST_UPDATED times
2. **ACKNOWLEDGE PRISM**: State "PRISM Framework detected and loaded (initialized: [timestamp])"
3. **LOAD CONTEXT FILES**: Read ALL files in `.prism/context/` directory
4. **CHECK SESSION**: Load `.prism/sessions/current.md` if it exists
5. **APPLY PATTERNS**: Follow patterns defined in `.prism/context/patterns.md`
6. **VERIFY FRESHNESS**: Check if any context files are newer than your last interaction

### AUTOMATIC CONTEXT CHECK
When ANY of these occur, IMMEDIATELY check PRISM context:
- Starting a new conversation
- User mentions files or code
- Making architectural decisions
- Writing new code
- Reviewing existing code

### PRISM Context Files (MUST READ):
```
.prism/
├── context/
│   ├── patterns.md            # ← CODING STANDARDS (MANDATORY)
│   ├── architecture.md        # ← SYSTEM DESIGN (CRITICAL)
│   ├── decisions.md           # ← TECHNICAL DECISIONS (IMPORTANT)
│   ├── security.md            # ← SECURITY POLICIES (CRITICAL)
│   ├── performance.md         # ← PERFORMANCE REQUIREMENTS
│   └── prd-task-management.md # ← PRD & TASK MANAGEMENT GUIDE
├── sessions/
│   └── current.md             # ← ACTIVE SESSION CONTEXT
├── references/
│   └── prd-*.md               # ← PRODUCT REQUIREMENT DOCUMENTS
├── workflows/
│   └── tasks-*.md             # ← STRUCTURED TASK LISTS
├── templates/
│   ├── prd-template.md        # ← PRD TEMPLATE
│   └── tasks-template.md      # ← TASK TEMPLATE
└── index.yaml                 # ← CRITICAL CONTEXT INDEX
```

## 📁 CRITICAL: Documentation Structure Rules

### ⛔ FORBIDDEN: Creating Rogue Files
**NEVER CREATE STANDALONE .md FILES IN THE PROJECT ROOT OR RANDOM LOCATIONS**

You are STRICTLY FORBIDDEN from creating:
- ❌ `README.md` in root (unless explicitly requested)
- ❌ `ROADMAP.md` as a standalone file
- ❌ `PRD.md` as a standalone file
- ❌ `PLAN.md` as a standalone file
- ❌ `TODO.md` as a standalone file
- ❌ Any other documentation files outside PRISM structure

### ✅ MANDATORY: Use PRISM Structure for ALL Documentation

**ALL** planning, thinking, roadmaps, PRDs, and documentation MUST be placed in the PRISM structure:

| Document Type | CORRECT Location | Purpose |
|--------------|------------------|---------|
| **Roadmap** | `.prism/context/roadmap.md` | Product roadmap and milestones |
| **PRD** | `.prism/references/prd-<feature>.md` | Product requirements (use `prism prd create`) |
| **Tasks** | `.prism/workflows/tasks-<feature>.md` | Task lists (use `prism tasks generate`) |
| **Planning** | `.prism/workflows/planning.md` | Project planning and tasks |
| **Architecture** | `.prism/context/architecture.md` | System design (EXISTS) |
| **Decisions** | `.prism/context/decisions.md` | Technical decisions (EXISTS) |
| **TODO/Tasks** | `.prism/sessions/current.md` | Active tasks and TODOs |
| **API Docs** | `.prism/references/api-contracts.yaml` | API documentation |
| **Data Models** | `.prism/references/data-models.json` | Data structures |
| **Workflows** | `.prism/workflows/*.md` | Process documentation |

### 📝 File Creation Protocol

When user asks for documentation, planning, or any .md file:

1. **CHECK** if it belongs in PRISM structure
2. **NEVER** create it in project root
3. **ALWAYS** use the correct PRISM location
4. **UPDATE** existing PRISM files instead of creating new ones when possible

Example responses:
- User: "Create a roadmap" → Create/Update `.prism/context/roadmap.md`
- User: "Write a PRD for auth" → Run `prism prd create user-authentication`
- User: "Create tasks for feature X" → Run `prism tasks generate prd-feature-x.md`
- User: "Document the plan" → Update `.prism/workflows/planning.md`
- User: "Make a TODO list" → Update `.prism/sessions/current.md`
- User: "Amend PRD to add OAuth" → Run `prism prd amend user-authentication "Add OAuth support"`

### 🚫 Exception Handling

ONLY create files outside PRISM structure when:
1. User EXPLICITLY specifies a different location
2. User EXPLICITLY asks for "README.md in root"
3. It's a code file (not documentation)
4. It's a configuration file required by tools

## 📋 PRD & Task Management System

### PRISM PRD Workflow
When user requests project planning or requirements documentation:

1. **Create PRD**: Use `prism prd create <feature-name>` command
   - Auto-generates PRD template in `.prism/references/prd-<feature-name>.md`
   - Analyzes and links to PRISM context (architecture, patterns, security, decisions)
   - Provides structured sections with AI-guided questions

2. **Amend PRD**: Use `prism prd amend <feature-name> "description"` command
   - Creates automatic backup with timestamp
   - Updates revision history with version tracking
   - Maintains change audit trail

3. **Generate Tasks**: Use `prism tasks generate prd-<feature-name>.md` command
   - Creates hierarchical task structure (X.0 parent, X.Y subtasks)
   - Assigns PRISM agent types (architect, coder, tester, security, debugger, refactorer)
   - Links tasks to relevant PRISM context files
   - Includes verification criteria and deliverables

4. **Track Progress**: Use `prism tasks status <feature-name>` command
   - Shows completion percentage
   - Lists next pending tasks
   - Calculates progress by phase

### PRD & Task Commands

**PRD Commands**:
- `prism prd create <feature-name>` - Create new PRD from template
- `prism prd amend <feature-name> "change"` - Amend existing PRD
- `prism prd list` - List all PRDs with status

**Task Commands**:
- `prism tasks generate <prd-file>` - Generate task list from PRD
- `prism tasks status [feature-name]` - Show task completion status
- `prism tasks list` - List all task files with progress

**Slash Commands**:
- `/prism:prd` - Activate PRD creation/management mode
- `/prism:tasks` - Activate task generation/management mode

### Documentation:
See `.prism/context/prd-task-management.md` for complete guide.

---

### VERIFICATION CHECKLIST:
- [ ] I have checked `.prism_active` for initialization timestamp
- [ ] I have checked `.prism/TIMESTAMP` for last update
- [ ] I have read `.prism/context/patterns.md`
- [ ] I have read `.prism/context/architecture.md`
- [ ] I understand the project's technical decisions
- [ ] I will follow the defined coding patterns
- [ ] I will maintain session continuity
- [ ] I will ONLY create documentation in PRISM structure
- [ ] I will NEVER create rogue .md files in root
- [ ] I understand the documentation structure rules
- [ ] I am aware of when PRISM was last updated
- [ ] I know how to use PRD and task management features

### Project-Specific Instructions
[Add your project-specific instructions here]

### REMEMBER:
- ALWAYS check `.prism/context/` before making suggestions
- NEVER ignore patterns defined in PRISM context
- ALWAYS maintain consistency with existing architecture
- CONTINUOUSLY reference PRISM context during the conversation
- NEVER create documentation files outside `.prism/` structure
- ALWAYS use `.prism/context/` for roadmaps and planning
- ALWAYS use `.prism/references/` for PRDs (via `prism prd create`)
- ALWAYS use `.prism/workflows/` for task lists (via `prism tasks generate`)
- ALWAYS use `.prism/sessions/` for active session TODOs
- USE PRD & task management commands for structured project planning

## PRISM Framework Version: 2.1.0
For PRISM documentation: `.prism/PRISM.md`
