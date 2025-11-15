# /prism:tasks - Task Management Command

**Purpose**: Generate, manage, and track hierarchical task lists from PRDs with PRISM agent integration.

---

## Command Behavior

When the user types `/prism:tasks`, you should activate task generation/management mode with PRISM context awareness and agent coordination.

### Triggers
- `/prism:tasks generate [prd-file]` - Generate task list from PRD
- `/prism:tasks status [feature-name]` - Show task completion status
- `/prism:tasks list` - List all task files
- `/prism:tasks` (no args) - Show tasks help/guidance

---

## Mode Activation Protocol

### Step 1: Load Task Template

Read the task template:
```bash
.prism/templates/tasks-template.md
```

This template provides:
- Hierarchical task structure (parent.child format)
- PRISM agent type assignments
- Context file linking
- Verification criteria format
- Completion tracking

### Step 2: Analyze Source PRD

**For `/prism:tasks generate [prd-file]`**:

1. **Load PRD**:
   ```
   📋 Generating tasks from PRD

   Reading PRD...
   ✓ File: .prism/references/prd-user-authentication.md
   ✓ Requirements: 8 identified
   ✓ PRISM context: Referenced
   ```

2. **Extract Requirements**:
   - Parse all REQ-* items
   - Identify functional requirements
   - Note technical constraints
   - Review success metrics

3. **Analyze Complexity**:
   ```
   📊 Analyzing requirements complexity...

   Simple tasks (LOW):     3
   Moderate tasks (MEDIUM): 4
   Complex tasks (HIGH):    1

   Estimated total: 5 parent tasks, ~15-20 subtasks
   ```

### Step 3: Generate Hierarchical Tasks

**Task Hierarchy Rules**:
- Parent tasks: `0.0`, `1.0`, `2.0`, etc.
- Subtasks: `1.1`, `1.2`, `2.1`, `2.2`, etc.
- Always start with `0.0 Create feature branch`
- Group by implementation phase

**Phase Structure**:
```
Phase 0: Setup (0.0)
Phase 1: Architecture & Design (1.0, 1.1, 1.2...)
Phase 2: Implementation (2.0, 2.1, 2.2...)
Phase 3: Testing (3.0, 3.1, 3.2...)
Phase 4: Quality & Security (4.0, 4.1, 4.2...)
Phase 5: Deployment (5.0, 5.1, 5.2...)
```

**Agent Assignment Logic**:
```
Task contains "Design"|"Architecture"|"Plan" → architect
Task contains "Implement"|"Build"|"Create" → coder
Task contains "Test"|"Verify"|"Validate" → tester
Task contains "Security"|"Auth"|"Encrypt" → security
Task contains "Debug"|"Fix"|"Troubleshoot" → debugger
Task contains "Refactor"|"Optimize"|"Cleanup" → refactorer
Default → coder
```

**Context Linking**:
- Link tasks to relevant `.prism/context/` sections
- Reference architecture for design tasks
- Reference patterns for implementation tasks
- Reference security for auth/encryption tasks

### Step 4: Generate Task File

1. **Create Task File**:
   ```markdown
   # Tasks: user-authentication

   **Source PRD**: `.prism/references/prd-user-authentication.md`
   **Created**: 2025-11-15
   **Total Tasks**: 18
   **Completed**: 0 / 18

   ## Phase 0: Setup

   - [ ] **0.0 Create feature branch**
     - **Agent**: architect
     - **Context**: `.prism/context/patterns.md#git-workflow`
     - **Priority**: HIGH
     - **Complexity**: LOW
     - **Deliverable**: Feature branch `feature/user-authentication`
     - **Verification**:
       - [ ] Branch exists
       - [ ] Checked out successfully
     - **Dependencies**: None

   ## Phase 1: Architecture & Design

   - [ ] **1.0 Authentication System Architecture**
     - **Agent**: architect
     - **Context**: `.prism/context/architecture.md#authentication`
     - **Priority**: HIGH
     - **Complexity**: HIGH
     - **Dependencies**: 0.0

     - [ ] **1.1 Design authentication flow**
       - **Agent**: architect
       - **Context**: `.prism/context/security.md#jwt-tokens`
       - **Priority**: HIGH
       - **Complexity**: MEDIUM
       - **Deliverable**: Flow diagrams and sequence diagrams
       - **Verification**:
         - [ ] Login flow documented
         - [ ] Token refresh flow documented
         - [ ] Error handling defined

     - [ ] **1.2 Database schema design**
       - **Agent**: architect
       - **Context**: `.prism/context/architecture.md#database`
       - **Priority**: HIGH
       - **Complexity**: MEDIUM
       - **Deliverable**: SQL schema file
       - **Verification**:
         - [ ] Users table defined
         - [ ] Indexes created
         - [ ] Migrations ready

   ## Phase 2: Implementation

   - [ ] **2.0 Core Authentication Implementation**
     - **Agent**: coder
     - **Context**: `.prism/context/patterns.md#nodejs`
     - **Priority**: HIGH
     - **Complexity**: HIGH
     - **Dependencies**: 1.0

     - [ ] **2.1 User registration endpoint**
       - **Agent**: coder
       - **Context**: `.prism/context/patterns.md#api-design`
       - **Priority**: HIGH
       - **Complexity**: MEDIUM
       - **Deliverable**: POST /api/auth/register
       - **Verification**:
         - [ ] Endpoint responds correctly
         - [ ] Validation works
         - [ ] Password hashed with bcrypt
         - [ ] User created in database

     - [ ] **2.2 JWT token generation**
       - **Agent**: coder
       - **Context**: `.prism/context/security.md#jwt-tokens`
       - **Priority**: HIGH
       - **Complexity**: MEDIUM
       - **Deliverable**: JWT utility module
       - **Verification**:
         - [ ] Tokens generated correctly
         - [ ] Expiration set (24h)
         - [ ] Signing key secure

   [... and so on for all phases]
   ```

2. **Save Task File**:
   ```bash
   .prism/workflows/tasks-[feature-name].md
   ```

3. **Summary Output**:
   ```
   ✅ Tasks generated successfully!

   📄 File: .prism/workflows/tasks-user-authentication.md

   📊 Task Breakdown:
   Phase 0 (Setup):         1 task
   Phase 1 (Architecture):  1 parent, 3 subtasks
   Phase 2 (Implementation): 1 parent, 5 subtasks
   Phase 3 (Testing):       1 parent, 4 subtasks
   Phase 4 (Quality):       1 parent, 3 subtasks
   Phase 5 (Deployment):    1 parent, 2 subtasks

   Total: 5 parent tasks, 18 subtasks

   👥 Agent Assignments:
   - architect: 5 tasks
   - coder: 8 tasks
   - tester: 4 tasks
   - security: 3 tasks

   📚 Context References:
   - architecture.md: 6 links
   - patterns.md: 8 links
   - security.md: 5 links

   🎯 Next Steps:
   1. Review generated tasks
   2. Customize task details as needed
   3. Start with task 0.0 (create branch)
   4. Execute tasks sequentially with agents
   5. Mark checkboxes as tasks complete

   💡 Quick Start:
   # Create feature branch
   git checkout -b feature/user-authentication

   # Start first architecture task
   Work on task 1.1: Design authentication flow
   ```

---

## Task Status Tracking

**For `/prism:tasks status [feature-name]`**:

1. **Load Task File**:
   ```bash
   .prism/workflows/tasks-[feature-name].md
   ```

2. **Count Completion**:
   - Total tasks: Count all `- [ ]` and `- [x]`
   - Completed: Count `- [x]`
   - Pending: Count `- [ ]`
   - Calculate percentage

3. **Display Status**:
   ```
   📊 Task Status: user-authentication

   Progress: [12/18] (67%)

   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   ████████████████████████░░░░░░░░░░░░░░░  67%
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

   Breakdown by Phase:
   ✅ Phase 0 (Setup):         [1/1]  100%
   ✅ Phase 1 (Architecture):  [4/4]  100%
   ✅ Phase 2 (Implementation): [5/5]  100%
   🔄 Phase 3 (Testing):       [2/4]   50%
   ⏳ Phase 4 (Quality):       [0/3]    0%
   ⏳ Phase 5 (Deployment):    [0/2]    0%

   📝 Next Pending Tasks:
   - [ ] 3.3 Integration tests
   - [ ] 3.4 E2E user journey tests
   - [ ] 4.1 Security audit
   - [ ] 4.2 Documentation update

   🎯 Current Focus:
   Phase 3 (Testing) - 50% complete
   Next task: 3.3 Integration tests (Agent: tester)

   💡 Tip: Mark tasks complete by changing [ ] to [x] in:
   .prism/workflows/tasks-user-authentication.md
   ```

**For `/prism:tasks list`**:

```
📋 Task Files

.prism/workflows/:
  user-authentication      [12/18] 67%    IN_PROGRESS
  payment-integration      [5/22]  23%    IN_PROGRESS
  admin-dashboard          [0/15]  0%     NOT_STARTED

Total: 3 features

Use: /prism:tasks status <feature> for details
```

---

## Key Behaviors

### 1. Hierarchical Organization

**Parent-Child Relationship**:
- Parent tasks (X.0) represent phases/major milestones
- Subtasks (X.Y) are actionable items to complete parent
- Complete all subtasks before marking parent complete

**Sequential Dependencies**:
- Phase 1 depends on Phase 0
- Phase 2 depends on Phase 1
- Document dependencies explicitly

### 2. Agent-Task Alignment

**Smart Agent Selection**:
```bash
# Pattern matching for agent assignment
analyze_task_title() {
    case "$task_title" in
        *"Design"*|*"Architecture"*|*"Plan"*)
            echo "architect" ;;
        *"Implement"*|*"Build"*|*"Create"*|*"Code"*)
            echo "coder" ;;
        *"Test"*|*"Verify"*|*"Validate"*)
            echo "tester" ;;
        *"Security"*|*"Auth"*|*"Encrypt"*)
            echo "security" ;;
        *"Debug"*|*"Fix"*)
            echo "debugger" ;;
        *"Refactor"*|*"Optimize"*)
            echo "refactorer" ;;
        *)
            echo "coder" ;;
    esac
}
```

### 3. Context Integration

**Automatic Context Linking**:
- Architecture tasks → `architecture.md`
- Implementation tasks → `patterns.md`
- Security tasks → `security.md`
- Testing tasks → `patterns.md#testing`

### 4. Verification Criteria

**Every task must have**:
- Clear deliverable
- Verification checklist
- Completion criteria
- Quality gates

**Example**:
```markdown
- [ ] **2.1 User registration endpoint**
  - **Deliverable**: POST /api/auth/register endpoint
  - **Verification**:
    - [ ] Endpoint returns 201 on success
    - [ ] Returns 400 on invalid input
    - [ ] Password hashed (not plain text)
    - [ ] User saved to database
    - [ ] Unit tests pass
    - [ ] Integration tests pass
```

---

## Error Handling

**Error: PRD not found**
```
❌ PRD file not found: prd-unknown-feature.md

Available PRDs:
- prd-user-authentication.md
- prd-payment-integration.md

Usage: /prism:tasks generate <prd-file>
```

**Error: Task file already exists**
```
⚠️ Task file already exists: tasks-user-authentication.md

Options:
A) Overwrite (regenerate from PRD)
B) Keep existing (cancel operation)
C) View status of existing tasks

What would you like to do?
```

---

## Examples

### Example 1: Generate Tasks
```
User: /prism:tasks generate prd-user-authentication.md

Claude:
📋 Generating tasks from PRD

Reading PRD...
✓ .prism/references/prd-user-authentication.md
✓ 8 requirements identified
✓ PRISM context loaded

Analyzing complexity...
✓ Estimated: 5 phases, 18 tasks

Creating task hierarchy...
✓ Phase 0: Setup (1 task)
✓ Phase 1: Architecture (4 tasks)
✓ Phase 2: Implementation (6 tasks)
✓ Phase 3: Testing (4 tasks)
✓ Phase 4: Quality (3 tasks)

Assigning agents...
✓ architect: 5 tasks
✓ coder: 7 tasks
✓ tester: 4 tasks
✓ security: 2 tasks

Linking PRISM context...
✓ 19 context references added

✅ Tasks generated: .prism/workflows/tasks-user-authentication.md

[Full task list output...]
```

### Example 2: Check Status
```
User: /prism:tasks status user-authentication

Claude:
📊 Task Status: user-authentication

Progress: [8/18] (44%)

Phase breakdown...
[Status display as shown above]
```

---

## Integration with PRD Workflow

**Complete Workflow**:
```
1. /prism:prd create user-authentication
   → Creates PRD with requirements

2. /prism:tasks generate prd-user-authentication.md
   → Generates hierarchical tasks from PRD

3. Execute tasks sequentially:
   - Start with 0.0 (create branch)
   - Work through phases in order
   - Mark tasks complete as you go

4. /prism:tasks status user-authentication
   → Track progress

5. If PRD changes:
   /prism:prd amend user-authentication "changes"
   /prism:tasks generate prd-user-authentication.md
   → Regenerate tasks with updates
```

---

## Quality Standards

**Task Quality Checklist**:
- ✅ Every task has agent assignment
- ✅ Every task has context link
- ✅ Every task has verification criteria
- ✅ Every task has clear deliverable
- ✅ Dependencies documented
- ✅ Complexity estimated
- ✅ Priority assigned

**PRISM Compliance**:
- ✅ Follows PRISM context patterns
- ✅ Aligned with architecture decisions
- ✅ Security requirements included
- ✅ Testing standards applied
- ✅ Agent capabilities matched to tasks
