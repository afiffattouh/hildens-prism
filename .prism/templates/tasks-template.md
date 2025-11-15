# Task List Template - PRISM Enhanced

**Purpose**: This template guides AI in converting PRDs into detailed, hierarchical task lists with PRISM integration for agent coordination and context awareness.

---

## Instructions for AI

Before generating the task list, you should:

1. **Analyze the PRD**:
   - Read the source PRD file thoroughly
   - Identify all functional requirements (REQ-*)
   - Note PRISM context references
   - Understand dependencies and integration points

2. **Determine Task Hierarchy**:
   - Create ~5 high-level parent tasks (X.0)
   - Break each parent into 2-5 actionable subtasks (X.Y)
   - Ensure logical progression and dependencies
   - Consider PRISM agent capabilities

3. **Assign PRISM Metadata**:
   - **Agent Type**: Match task to appropriate agent (architect, coder, tester, security, etc.)
   - **Context Links**: Reference specific `.prism/context/` sections
   - **Skills**: Suggest relevant PRISM skills if applicable
   - **Priority**: Based on PRD requirements (HIGH, MEDIUM, LOW)
   - **Complexity**: Estimate effort (LOW, MEDIUM, HIGH)

4. **Task Numbering**:
   - Parent tasks: `0.0`, `1.0`, `2.0`, etc.
   - Subtasks: `1.1`, `1.2`, `2.1`, `2.2`, etc.
   - Maintain sequential order

5. **First Task**:
   - **Always** start with `0.0 Create feature branch` unless user specifically requests otherwise
   - Link to git workflow from PRISM patterns

---

## Task List Structure

# Tasks: [Feature Name]

**Source PRD**: `.prism/references/prd-[feature-name].md`
**Created**: [YYYY-MM-DD]
**Status**: NOT_STARTED | IN_PROGRESS | COMPLETED
**Total Tasks**: [Count]
**Completed**: [Count] / [Total]

---

## PRISM Context Summary

**Relevant Context Files**:
- Architecture: `.prism/context/architecture.md#[sections]`
- Patterns: `.prism/context/patterns.md#[sections]`
- Security: `.prism/context/security.md#[sections]`

**Agent Types Needed**:
- [ ] Architect (design, planning)
- [ ] Coder (implementation)
- [ ] Tester (quality assurance)
- [ ] Security (security validation)
- [ ] Other: [specify]

---

## Task Hierarchy

### Phase 0: Setup

- [ ] **0.0 Create feature branch**
  - **Agent**: architect
  - **Context**: `.prism/context/patterns.md#git-workflow`
  - **Skill**: N/A
  - **Priority**: HIGH
  - **Complexity**: LOW
  - **Deliverable**: Feature branch created from main/master
  - **Verification**:
    - [ ] Branch exists: `git branch --list feature/[name]`
    - [ ] Branch is checked out
  - **Dependencies**: None (first task)

---

### Phase 1: [Architecture & Design / Planning / Analysis]

- [ ] **1.0 [Parent Task Title]**
  - **Agent**: architect
  - **Context**: `.prism/context/architecture.md#[section]`
  - **Skill**: [prism-skill if applicable]
  - **Priority**: HIGH | MEDIUM | LOW
  - **Complexity**: LOW | MEDIUM | HIGH
  - **Description**: [What this parent task accomplishes]
  - **Dependencies**: 0.0 (must complete first)

  - [ ] **1.1 [Specific subtask]**
    - **Agent**: architect
    - **Context**: `.prism/context/[file].md#[section]`
    - **Priority**: HIGH
    - **Complexity**: MEDIUM
    - **Description**: [Detailed action to take]
    - **Deliverable**: [Specific output - file, diagram, document]
    - **Verification**:
      - [ ] [Specific test/check 1]
      - [ ] [Specific test/check 2]
    - **Notes**: [Additional guidance or context]

  - [ ] **1.2 [Next subtask]**
    - **Agent**: [agent-type]
    - **Context**: `.prism/context/[file].md#[section]`
    - **Priority**: [level]
    - **Complexity**: [level]
    - **Description**: [Action]
    - **Deliverable**: [Output]
    - **Verification**:
      - [ ] [Check 1]
      - [ ] [Check 2]

  - [ ] **1.3 [Additional subtask if needed]**
    - [Same structure...]

---

### Phase 2: [Implementation / Core Features]

- [ ] **2.0 [Parent Task Title]**
  - **Agent**: coder
  - **Context**: `.prism/context/patterns.md#[section]`
  - **Skill**: [skill if applicable]
  - **Priority**: HIGH
  - **Complexity**: HIGH
  - **Description**: [Implementation goals]
  - **Dependencies**: 1.0 (architecture must be complete)

  - [ ] **2.1 [Implementation subtask 1]**
    - **Agent**: coder
    - **Context**: `.prism/context/patterns.md#[coding-standard]`
    - **Priority**: HIGH
    - **Complexity**: MEDIUM
    - **Description**: [Specific code to write]
    - **Deliverable**: [Files created/modified]
    - **Code References**: [Expected file locations]
    - **Verification**:
      - [ ] Code follows `.prism/context/patterns.md` standards
      - [ ] [Functional test passes]
      - [ ] [No linting errors]
    - **Security**: [Any security considerations from security.md]

  - [ ] **2.2 [Implementation subtask 2]**
    - [Same structure...]

  - [ ] **2.3 [Implementation subtask 3]**
    - [Same structure...]

---

### Phase 3: [Testing / Validation / Quality Assurance]

- [ ] **3.0 [Testing Phase]**
  - **Agent**: tester
  - **Context**: `.prism/context/patterns.md#testing`
  - **Skill**: test-runner
  - **Priority**: HIGH
  - **Complexity**: MEDIUM
  - **Description**: [Testing objectives]
  - **Dependencies**: 2.0 (implementation must be complete)

  - [ ] **3.1 [Unit tests]**
    - **Agent**: tester
    - **Context**: `.prism/context/patterns.md#unit-testing`
    - **Priority**: HIGH
    - **Complexity**: MEDIUM
    - **Description**: Create comprehensive unit tests
    - **Deliverable**: Test files with >80% coverage
    - **Test Coverage**: [Components/functions to test]
    - **Verification**:
      - [ ] All unit tests pass
      - [ ] Coverage meets threshold
      - [ ] Tests follow PRISM testing patterns

  - [ ] **3.2 [Integration tests]**
    - **Agent**: tester
    - **Context**: `.prism/context/patterns.md#integration-testing`
    - **Priority**: MEDIUM
    - **Complexity**: HIGH
    - **Description**: Test component interactions
    - **Deliverable**: Integration test suite
    - **Verification**:
      - [ ] All integration tests pass
      - [ ] Edge cases covered

  - [ ] **3.3 [E2E tests]** (if applicable)
    - **Agent**: tester
    - **Context**: `.prism/context/patterns.md#e2e-testing`
    - **Priority**: MEDIUM
    - **Complexity**: HIGH
    - **Description**: End-to-end user journey tests
    - **Deliverable**: E2E test scenarios
    - **Verification**:
      - [ ] User journeys validated
      - [ ] Cross-browser testing (if web)

---

### Phase 4: [Security / Performance / Documentation]

- [ ] **4.0 [Quality & Security Review]**
  - **Agent**: security
  - **Context**: `.prism/context/security.md`
  - **Skill**: N/A
  - **Priority**: HIGH
  - **Complexity**: MEDIUM
  - **Description**: Security validation and performance checks
  - **Dependencies**: 3.0 (tests must pass first)

  - [ ] **4.1 [Security audit]**
    - **Agent**: security
    - **Context**: `.prism/context/security.md#[relevant-policy]`
    - **Priority**: HIGH
    - **Complexity**: MEDIUM
    - **Description**: Review for security vulnerabilities
    - **Security Checklist**:
      - [ ] Input validation implemented
      - [ ] Authentication/authorization correct
      - [ ] No sensitive data exposure
      - [ ] HTTPS/encryption used where required
      - [ ] OWASP Top 10 considerations addressed
    - **Deliverable**: Security review report
    - **Verification**:
      - [ ] No critical vulnerabilities found
      - [ ] All security checks pass

  - [ ] **4.2 [Documentation]**
    - **Agent**: coder
    - **Context**: `.prism/context/patterns.md#documentation`
    - **Priority**: MEDIUM
    - **Complexity**: LOW
    - **Description**: Update project documentation
    - **Deliverable**:
      - Updated README.md
      - API documentation (if applicable)
      - Code comments and docstrings
    - **Verification**:
      - [ ] Documentation complete and accurate
      - [ ] Examples provided

  - [ ] **4.3 [Performance validation]** (if applicable)
    - **Agent**: coder
    - **Context**: `.prism/context/performance.md`
    - **Priority**: MEDIUM
    - **Complexity**: MEDIUM
    - **Description**: Verify performance requirements met
    - **Deliverable**: Performance metrics report
    - **Verification**:
      - [ ] Meets performance criteria from PRD
      - [ ] No performance regressions

---

### Phase 5: [Deployment / Finalization]

- [ ] **5.0 [Deployment Preparation]**
  - **Agent**: coder
  - **Context**: `.prism/context/patterns.md#deployment`
  - **Skill**: N/A
  - **Priority**: MEDIUM
  - **Complexity**: LOW
  - **Description**: Prepare for deployment
  - **Dependencies**: 4.0 (quality checks must pass)

  - [ ] **5.1 [Code review]**
    - **Agent**: architect
    - **Priority**: HIGH
    - **Complexity**: LOW
    - **Description**: Final code review
    - **Deliverable**: Approved pull request
    - **Verification**:
      - [ ] All PR checks pass
      - [ ] Code reviewed and approved
      - [ ] No merge conflicts

  - [ ] **5.2 [Merge to main]**
    - **Agent**: coder
    - **Priority**: MEDIUM
    - **Complexity**: LOW
    - **Description**: Merge feature branch to main
    - **Deliverable**: Merged code
    - **Verification**:
      - [ ] Branch merged successfully
      - [ ] CI/CD pipeline passes
      - [ ] No breaking changes

  - [ ] **5.3 [Post-deployment validation]**
    - **Agent**: tester
    - **Priority**: HIGH
    - **Complexity**: MEDIUM
    - **Description**: Validate feature in production/staging
    - **Deliverable**: Validation report
    - **Verification**:
      - [ ] Feature works as expected
      - [ ] Success metrics being captured
      - [ ] No errors in logs

---

## Task Execution Guidelines

### For AI Agents:
1. **Work sequentially**: Complete subtasks in order (1.1 before 1.2)
2. **Check dependencies**: Don't start task 2.0 until 1.0 is complete
3. **Update checkboxes**: Mark `- [x]` when subtask complete
4. **Reference context**: Always consult linked `.prism/context/` files
5. **Create discovered tasks**: If you find additional work needed, add it to the list
6. **Verify completion**: Check all verification criteria before marking done

### For Humans:
1. **Review each subtask**: Check AI-generated code before marking complete
2. **Run tests**: Verify all test checkboxes are accurate
3. **Context validation**: Ensure work follows PRISM patterns and standards
4. **Progress tracking**: Update task status in this file regularly

---

## Completion Tracking

**Progress Summary**:
```
Phase 0 (Setup):        [0/1]  (0%)
Phase 1 (Architecture): [0/X]  (0%)
Phase 2 (Implementation):[0/X]  (0%)
Phase 3 (Testing):      [0/X]  (0%)
Phase 4 (Quality):      [0/X]  (0%)
Phase 5 (Deployment):   [0/X]  (0%)

TOTAL: [0/XX] (0% complete)
```

**Update this summary as tasks complete**

---

## Notes & Discoveries

**Issues Found**:
- [Log any blockers or issues discovered during execution]

**Additional Tasks Discovered**:
- [Add tasks found during implementation that weren't in original PRD]

**Context Updates Needed**:
- [Note if any `.prism/context/` files need updates based on this work]

---

## Output Instructions

**File Location**: `.prism/workflows/tasks-[feature-name].md`

**Naming Convention**: Match the PRD filename
- PRD: `prd-user-authentication.md` → Tasks: `tasks-user-authentication.md`

**Maintenance**: Update checkboxes and progress summary as work progresses

**Agent Assignment**: Use PRISM agent types:
- `architect`: Design, planning, architecture
- `coder`: Implementation, coding
- `tester`: Testing, QA
- `security`: Security audits, vulnerability checks
- `debugger`: Bug fixes, troubleshooting
- `refactorer`: Code cleanup, optimization
- `planner`: High-level planning, roadmapping

**Complexity Estimates**:
- **LOW**: < 1 hour
- **MEDIUM**: 1-4 hours
- **HIGH**: 4+ hours or multiple sessions
