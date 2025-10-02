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
│   ├── patterns.md     # ← CODING STANDARDS (MANDATORY)
│   ├── architecture.md # ← SYSTEM DESIGN (CRITICAL)
│   ├── decisions.md    # ← TECHNICAL DECISIONS (IMPORTANT)
│   ├── security.md     # ← SECURITY POLICIES (CRITICAL)
│   └── performance.md  # ← PERFORMANCE REQUIREMENTS
├── sessions/
│   └── current.md      # ← ACTIVE SESSION CONTEXT
└── index.yaml          # ← CRITICAL CONTEXT INDEX
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
| **PRD** | `.prism/references/prd.md` | Product requirements document |
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
- User: "Write a PRD" → Create/Update `.prism/references/prd.md`
- User: "Document the plan" → Update `.prism/workflows/planning.md`
- User: "Make a TODO list" → Update `.prism/sessions/current.md`

### 🚫 Exception Handling

ONLY create files outside PRISM structure when:
1. User EXPLICITLY specifies a different location
2. User EXPLICITLY asks for "README.md in root"
3. It's a code file (not documentation)
4. It's a configuration file required by tools

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

### Project-Specific Instructions
[Add your project-specific instructions here]

### REMEMBER:
- ALWAYS check `.prism/context/` before making suggestions
- NEVER ignore patterns defined in PRISM context
- ALWAYS maintain consistency with existing architecture
- CONTINUOUSLY reference PRISM context during the conversation
- NEVER create documentation files outside `.prism/` structure
- ALWAYS use `.prism/context/` for roadmaps and planning
- ALWAYS use `.prism/references/` for PRDs and specifications
- ALWAYS use `.prism/sessions/` for tasks and TODOs

## PRISM Framework Version: 2.1.0
For PRISM documentation: `.prism/PRISM.md`
