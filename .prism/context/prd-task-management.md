# PRD & Task Management - PRISM Feature Documentation

**Feature**: Product Requirement Document (PRD) creation and hierarchical task management
**Version**: 1.0
**Status**: IMPLEMENTED
**Date**: 2025-11-15

---

## Overview

PRISM now includes comprehensive PRD and task management capabilities that integrate deeply with PRISM context files, agent system, and workflows. This feature enables structured software development from requirements definition through implementation execution.

### Key Capabilities

1. **PRD Creation**: Interactive PRD generation with PRISM context awareness
2. **PRD Amendment**: Update existing PRDs and track revision history
3. **Task Generation**: Convert PRDs into hierarchical, agent-assigned task lists
4. **Progress Tracking**: Monitor task completion and project status
5. **Context Integration**: Automatic linking to architecture, patterns, security, and decisions

---

## Commands

### CLI Commands (via `prism`)

```bash
# PRD Management
prism prd create <feature-name>              # Create new PRD
prism prd amend <feature-name> "description" # Amend existing PRD
prism prd list                               # List all PRDs

# Task Management
prism tasks generate <prd-file>              # Generate tasks from PRD
prism tasks status [feature-name]            # Show completion status
prism tasks list                             # List all task files
```

### Claude Code Slash Commands

```bash
# Within Claude Code conversation
/prism:prd create <feature-name>             # Interactive PRD creation
/prism:prd amend <feature-name>              # Interactive PRD amendment
/prism:prd list                              # List PRDs

/prism:tasks generate <prd-file>             # Generate task hierarchy
/prism:tasks status <feature-name>           # Show progress
/prism:tasks list                            # List task files
```

---

## File Structure

```
.prism/
├── templates/
│   ├── prd-template.md                      # Enhanced PRD template
│   └── tasks-template.md                    # Enhanced task template
│
├── references/
│   ├── prd-user-authentication.md           # Generated PRDs
│   ├── prd-payment-integration.md
│   └── ...
│
├── workflows/
│   ├── tasks-user-authentication.md         # Generated task lists
│   ├── tasks-payment-integration.md
│   └── ...
│
└── context/
    ├── prd-task-management.md              # This file
    ├── architecture.md                      # Referenced by PRDs
    ├── patterns.md                          # Referenced by tasks
    ├── security.md                          # Referenced by both
    └── decisions.md                         # Referenced by both
```

---

## Workflows

### Workflow 1: New Feature Development

**Step 1: Create PRD**
```bash
# Via CLI
prism prd create user-authentication

# Or via Claude Code
/prism:prd create user-authentication
```

**What Happens**:
1. PRISM analyzes context files (architecture, security, patterns, decisions)
2. PRD template is loaded
3. Claude asks clarifying questions based on context
4. PRD is generated with context references
5. File saved to `.prism/references/prd-user-authentication.md`

**Step 2: Generate Tasks**
```bash
# Via CLI
prism tasks generate prd-user-authentication.md

# Or via Claude Code
/prism:tasks generate prd-user-authentication.md
```

**What Happens**:
1. PRD requirements are analyzed
2. Tasks are organized into 5 phases
3. Agents are auto-assigned based on task type
4. Context links are added to each task
5. File saved to `.prism/workflows/tasks-user-authentication.md`

**Step 3: Execute Tasks**
```bash
# Create feature branch (task 0.0)
git checkout -b feature/user-authentication

# Work through tasks sequentially
# Mark checkboxes in task file as complete

# Check progress
prism tasks status user-authentication
```

**Step 4: Track Progress**
```bash
# Via CLI
prism tasks status user-authentication

# Via Claude Code
/prism:tasks status user-authentication
```

**Output**:
- Percentage complete
- Phase-by-phase breakdown
- Next pending tasks
- Current focus area

---

### Workflow 2: Amending Requirements Mid-Development

**Scenario**: User needs OAuth support added to authentication

**Step 1: Amend PRD**
```bash
# Via CLI
prism prd amend user-authentication "Add OAuth Google support"

# Or via Claude Code
/prism:prd amend user-authentication
# Claude will ask for details interactively
```

**What Happens**:
1. Existing PRD is loaded
2. Amendment is analyzed for impact
3. Affected sections are identified
4. PRD is updated with new requirements
5. Revision history is updated
6. Version number incremented (e.g., 1.2 → 1.3)

**Step 2: Regenerate Tasks**
```bash
prism tasks generate prd-user-authentication.md
# Overwrite existing task file with updated tasks
```

**What Happens**:
1. New requirements generate additional tasks
2. Existing completed tasks are preserved (manual merge)
3. New tasks are added to appropriate phases
4. Dependencies are updated

**Step 3: Continue Development**
- Review new tasks
- Update implementation plan
- Execute new tasks

---

### Workflow 3: Multiple Feature Coordination

**Managing multiple features simultaneously**:

```bash
# List all PRDs
prism prd list

# Output:
# user-authentication      APPROVED      2025-11-01
# payment-integration      IN_PROGRESS   2025-11-05
# admin-dashboard          DRAFT         2025-11-12

# Check status of each
prism tasks status user-authentication    # 67% complete
prism tasks status payment-integration    # 23% complete
prism tasks status admin-dashboard        # 0% complete (not started)

# Work on highest priority
# Tasks are independent, can work on multiple features
```

---

## PRD Template Structure

### Sections Overview

1. **PRISM Context References**: Auto-populated from context files
2. **Introduction/Overview**: Problem statement and feature summary
3. **Goals**: Primary and secondary objectives
4. **User Stories**: User journeys with acceptance criteria
5. **Functional Requirements**: Numbered requirements (REQ-1, REQ-2, ...)
6. **Non-Goals**: Explicitly out of scope items
7. **Design Considerations**: UI/UX, data models, API design
8. **Technical Considerations**: Technology stack, constraints, dependencies
9. **Success Metrics**: KPIs and validation criteria
10. **Implementation Phases**: Milestone breakdown
11. **Open Questions**: Unresolved items requiring clarification
12. **References**: Related documentation and resources
13. **Revision History**: Version tracking

### Context Integration

**Automatic Context Population**:

The PRD template automatically references relevant PRISM context:

```markdown
## 1. PRISM Context References

**Architecture Constraints** (`.prism/context/architecture.md#microservices`):
- Microservices architecture pattern
- REST API communication
- PostgreSQL database

**Security Requirements** (`.prism/context/security.md#authentication`):
- JWT token authentication
- bcrypt password hashing (cost factor 12)
- Rate limiting: 100 req/min

**Coding Patterns** (`.prism/context/patterns.md#nodejs`):
- MVC pattern
- async/await
- 80% test coverage minimum

**Technical Decisions** (`.prism/context/decisions.md#DEC-003`):
- PostgreSQL chosen for ACID compliance
- Node.js backend framework
```

This ensures all PRDs are consistent with PRISM standards and existing decisions.

---

## Task Template Structure

### Task Hierarchy

**Format**: `X.Y` where X = phase, Y = subtask number

```
0.0 - Setup phase
1.0 - Architecture & Design phase
  1.1 - First design subtask
  1.2 - Second design subtask
2.0 - Implementation phase
  2.1 - First implementation subtask
  2.2 - Second implementation subtask
3.0 - Testing phase
4.0 - Quality & Security phase
5.0 - Deployment phase
```

### Task Metadata

Each task includes:

```markdown
- [ ] **1.1 Design authentication flow**
  - **Agent**: architect
  - **Context**: `.prism/context/security.md#jwt-tokens`
  - **Skill**: N/A (or specific skill name)
  - **Priority**: HIGH | MEDIUM | LOW
  - **Complexity**: LOW | MEDIUM | HIGH
  - **Description**: [What this task accomplishes]
  - **Deliverable**: [Specific output file or artifact]
  - **Verification**:
    - [ ] [Specific test 1]
    - [ ] [Specific test 2]
  - **Dependencies**: [Which tasks must complete first]
  - **Notes**: [Additional context or guidance]
```

### Agent Assignment

**Automatic Agent Selection**:

| Task Type | Agent | Typical Tasks |
|-----------|-------|---------------|
| Design, Architecture, Planning | `architect` | System design, API design, schema design |
| Implementation, Coding | `coder` | Writing code, business logic, features |
| Testing, QA | `tester` | Unit tests, integration tests, E2E tests |
| Security, Auth | `security` | Security audits, vulnerability scans |
| Debugging, Fixes | `debugger` | Bug fixes, troubleshooting |
| Refactoring, Optimization | `refactorer` | Code cleanup, performance tuning |

**Pattern Matching**:
- Task title contains "Design" → architect
- Task title contains "Implement" → coder
- Task title contains "Test" → tester
- Task title contains "Security" → security

---

## Integration with PRISM Features

### 1. Context System Integration

**PRDs automatically reference**:
- `.prism/context/architecture.md` for system design
- `.prism/context/patterns.md` for coding standards
- `.prism/context/security.md` for security policies
- `.prism/context/decisions.md` for technical decisions

**Tasks automatically link**:
- Architecture tasks → `architecture.md` sections
- Implementation tasks → `patterns.md` sections
- Security tasks → `security.md` sections

### 2. Agent System Integration

**Agents can be linked to tasks**:
```bash
# Future enhancement (Phase 2 - Beads integration)
prism agent create coder --task bd-a1b2
# Agent executes specific task from task list
```

**Agents reference task context**:
- Agent reads task metadata
- Agent loads linked context files
- Agent understands verification criteria
- Agent knows deliverable requirements

### 3. Session Integration

**Session tracking includes**:
```markdown
# In .prism/sessions/current.md

## Active Feature
- **Feature**: user-authentication
- **PRD**: .prism/references/prd-user-authentication.md
- **Tasks**: .prism/workflows/tasks-user-authentication.md
- **Progress**: 67% (12/18 tasks)
- **Current Phase**: Phase 3 (Testing)
- **Next Task**: 3.3 Integration tests
```

### 4. TOON Optimization

**PRD and task data can be serialized in TOON format**:

```bash
# Future enhancement
prism tasks status user-authentication --toon

# Output in TOON format (50% fewer tokens)
feature: user-authentication
prd: prd-user-authentication.md
total: 18
completed: 12
percentage: 67

phases[6]{id,name,completed,total,percentage}:
 0,Setup,1,1,100
 1,Architecture,4,4,100
 2,Implementation,5,5,100
 3,Testing,2,4,50
 4,Quality,0,3,0
 5,Deployment,0,2,0
```

---

## Best Practices

### PRD Creation

**1. Context First**
- Always review PRISM context files before creating PRD
- Ensure alignment with architecture decisions
- Follow existing security patterns
- Adhere to coding standards

**2. Clear Requirements**
- Use SMART criteria (Specific, Measurable, Achievable, Relevant, Time-bound)
- Write for junior developer comprehension
- Include testable acceptance criteria
- Number all requirements (REQ-1, REQ-2, ...)

**3. Explicit Scope**
- Clearly state what IS included
- Explicitly state what is NOT included (non-goals)
- Define boundaries and limitations

**4. Success Metrics**
- Define measurable KPIs
- Specify validation criteria
- Include acceptance testing approach

### Task Management

**1. Sequential Execution**
- Always start with task 0.0 (create feature branch)
- Complete subtasks before marking parent complete
- Respect dependencies between phases

**2. Verification Discipline**
- Check all verification criteria before marking task complete
- Run tests mentioned in verification
- Ensure deliverables are created

**3. Context Reference**
- Always consult linked context files before starting task
- Follow patterns from context
- Apply security policies from context

**4. Progress Tracking**
- Update checkboxes immediately after task completion
- Run `prism tasks status` regularly to track progress
- Keep task file synchronized with actual work

### Amendment Management

**1. Version Control**
- Always add to revision history when amending
- Increment version numbers appropriately
- Document rationale for changes

**2. Impact Analysis**
- Identify affected tasks when PRD changes
- Regenerate task list if requirements significantly change
- Communicate changes to team

**3. Backwards Compatibility**
- Consider impact on existing implementation
- Mark deprecated requirements clearly
- Plan migration path if needed

---

## Examples

### Example 1: Complete Workflow

```bash
# 1. Create PRD
prism prd create user-authentication

# Claude asks questions:
# 1. Authentication method? A) JWT B) Session C) OAuth
# User responds: A

# 2. Storage? A) New tables B) Extend existing
# User responds: A

# PRD created: .prism/references/prd-user-authentication.md

# 2. Generate tasks
prism tasks generate prd-user-authentication.md

# Tasks created: .prism/workflows/tasks-user-authentication.md
# 18 tasks organized into 5 phases
# Agents assigned: architect (5), coder (7), tester (4), security (2)

# 3. Execute tasks
git checkout -b feature/user-authentication  # Task 0.0

# Work through tasks 1.1, 1.2, etc.
# Mark checkboxes in task file

# 4. Track progress
prism tasks status user-authentication
# Output: 67% complete (12/18)

# 5. Amend if needed
prism prd amend user-authentication "Add OAuth Google support"

# 6. Regenerate tasks
prism tasks generate prd-user-authentication.md
# New tasks added for OAuth integration

# 7. Complete development
# ... continue until all tasks complete ...

# 8. Final status
prism tasks status user-authentication
# Output: 100% complete (18/18) ✅
```

### Example 2: Multiple Features

```bash
# Create multiple PRDs
prism prd create user-authentication
prism prd create payment-integration
prism prd create admin-dashboard

# Generate tasks for each
prism tasks generate prd-user-authentication.md
prism tasks generate prd-payment-integration.md
prism tasks generate prd-admin-dashboard.md

# Work on highest priority feature first
prism tasks status user-authentication
# Focus development here until complete or blocked

# Switch to another feature when needed
prism tasks status payment-integration
# Continue with this feature

# Overview of all features
prism prd list
prism tasks list
```

---

## Troubleshooting

### Common Issues

**Issue**: PRD template not found
```
Error: PRD template not found: .prism/templates/prd-template.md

Solution:
1. Ensure PRISM is properly initialized
2. Check templates directory exists
3. Reinstall PRISM if needed
```

**Issue**: Task generation fails
```
Error: PRD file not found

Solution:
1. Verify PRD file exists in .prism/references/
2. Use full filename: prd-feature-name.md
3. Check file permissions
```

**Issue**: Agent assignments seem incorrect
```
Task shows "coder" but should be "architect"

Solution:
1. Manually edit task file
2. Change agent assignment
3. Pattern matching is heuristic, customize as needed
```

**Issue**: Context links broken
```
Context references show 404 or file not found

Solution:
1. Ensure context files exist in .prism/context/
2. Update links to match actual file structure
3. Create missing context files if needed
```

---

## Future Enhancements (Roadmap)

### Phase 2: Beads Integration
- Convert tasks to Beads issues automatically
- Persistent task tracking with dependency graphs
- Query ready work: `prism task ready`
- Agent auto-execution from task queue

### Phase 3: Full Workflow Automation
- Auto-generate tasks from PRD (no manual step)
- Auto-assign agents to tasks based on type
- Agent orchestration: agents execute tasks autonomously
- PRD amendment auto-updates task graph

### Phase 4: Advanced Features
- Task templates for common feature types
- PRD diff visualization
- Task dependency visualization
- Progress dashboards
- Integration with git commits (link commits to tasks)

---

## API Reference

### Library Functions (`lib/prism-prd.sh`)

```bash
# PRD Functions
prism_prd_create <feature-name>              # Create new PRD
prism_prd_amend <feature-name> <amendment>   # Amend existing PRD
prism_prd_list                               # List all PRDs
prism_prd_analyze_context <feature-name>     # Analyze PRISM context
prism_prd_get_next_version <prd-file>        # Get next version number

# Task Functions
prism_tasks_generate <prd-file>              # Generate tasks from PRD
prism_tasks_status [feature-name]            # Show task status
prism_tasks_list                             # List all task files

# Help
prism_prd_help                               # Show command help
```

### Environment Variables

```bash
PRD_DIR="${PRISM_ROOT}/.prism/references"    # PRD storage directory
TASKS_DIR="${PRISM_ROOT}/.prism/workflows"   # Task storage directory
TEMPLATES_DIR="${PRISM_ROOT}/.prism/templates" # Template directory
```

---

## Summary

The PRD & Task Management feature provides:

✅ **Structured Requirements**: PRDs with PRISM context integration
✅ **Hierarchical Tasks**: Organized, agent-assigned task lists
✅ **Progress Tracking**: Real-time completion monitoring
✅ **Context Awareness**: Automatic linking to architecture, patterns, security
✅ **Agent Integration**: Smart agent assignment based on task type
✅ **Amendment Support**: Version-controlled requirement updates
✅ **CLI & Slash Commands**: Flexible interaction via terminal or Claude Code

This feature bridges the gap between requirements definition and implementation execution, providing a complete workflow from idea to code.
