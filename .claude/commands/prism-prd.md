# /prism:prd - PRD Management Command

**Purpose**: Create, amend, and manage Product Requirement Documents (PRDs) with PRISM context integration.

---

## Command Behavior

When the user types `/prism:prd`, you should activate PRD creation/management mode with PRISM context awareness.

### Triggers
- `/prism:prd create [feature-name]` - Create new PRD
- `/prism:prd amend [feature-name]` - Amend existing PRD
- `/prism:prd list` - List all PRDs
- `/prism:prd` (no args) - Show PRD help/guidance

---

## Mode Activation Protocol

### Step 1: Analyze PRISM Context

Before creating or amending a PRD, you MUST:

1. **Read PRISM Context Files**:
   ```bash
   # Read these files first
   .prism/context/architecture.md
   .prism/context/patterns.md
   .prism/context/security.md
   .prism/context/decisions.md
   ```

2. **Identify Relevant Sections**:
   - Extract sections relevant to the feature
   - Note constraints, patterns, and decisions that apply
   - Prepare context references for PRD

### Step 2: Load PRD Template

Read the PRD template:
```bash
.prism/templates/prd-template.md
```

This template provides:
- Complete PRD structure with all required sections
- Placeholders for PRISM context integration
- Instructions for AI-guided PRD creation
- Question format for user clarification

### Step 3: Interactive PRD Creation

**For `/prism:prd create [feature-name]`**:

1. **Analyze Context First**:
   ```
   📋 Creating PRD for: [feature-name]

   Analyzing PRISM context...
   ✓ Architecture patterns identified
   ✓ Security policies loaded
   ✓ Coding standards reviewed
   ✓ Technical decisions noted
   ```

2. **Ask Clarifying Questions** (limit to 3-5):
   ```
   I'll help you create a comprehensive PRD for [feature-name].

   Based on PRISM context analysis, I have a few clarifying questions:

   1. Authentication method?
      A) JWT tokens (aligns with security.md)
      B) Session cookies
      C) OAuth integration
      D) Other

   2. Storage approach?
      A) New tables in PostgreSQL (from architecture.md)
      B) Extend existing schema
      C) Separate database

   3. Implementation priority?
      A) MVP - core features only
      B) Full - all requirements
      C) Phased - incremental rollout

   Please respond: 1A, 2A, 3B
   ```

3. **Generate PRD** using template structure:
   - Fill in all sections based on user responses
   - Auto-populate PRISM context references
   - Link to specific `.prism/context/` sections
   - Suggest agent types for implementation phases
   - Include technical constraints from context

4. **Create PRD File**:
   ```bash
   # Create file at:
   .prism/references/prd-[feature-name].md
   ```

5. **Summary & Next Steps**:
   ```
   ✅ PRD created successfully!

   📄 File: .prism/references/prd-[feature-name].md

   📚 PRISM Context Referenced:
   - Architecture: microservices pattern, REST API
   - Security: JWT authentication, bcrypt hashing
   - Patterns: coding standards, testing requirements
   - Decisions: PostgreSQL for data, Node.js backend

   🎯 Next Steps:
   1. Review and customize the PRD
   2. Generate implementation tasks:
      /prism:tasks generate prd-[feature-name].md
   3. Start development with PRISM agents

   💡 Suggested Agents:
   - architect: System design and API planning
   - coder: Implementation
   - security: Security review
   - tester: Testing and QA
   ```

**For `/prism:prd amend [feature-name]`**:

1. **Load Existing PRD**:
   ```
   📋 Amending PRD: [feature-name]

   Loading existing PRD...
   ✓ Current version: 1.2
   ✓ Last updated: 2025-11-10
   ✓ Status: IN_PROGRESS
   ```

2. **Ask About Amendment**:
   ```
   What changes would you like to make?

   Options:
   A) Add new requirements
   B) Modify existing requirements
   C) Update technical approach
   D) Change scope/priorities
   E) Update success metrics

   Please describe the amendment:
   ```

3. **Analyze Impact**:
   ```
   📊 Analyzing amendment impact...

   Affected Sections:
   - Functional Requirements (REQ-3, REQ-5)
   - Technical Considerations
   - Success Metrics

   PRISM Context Implications:
   - May require security policy update
   - Aligns with existing architecture

   Task Impact:
   - 3 existing tasks affected
   - 2 new tasks may be needed
   ```

4. **Update PRD**:
   - Edit relevant sections
   - Add entry to revision history
   - Update version number
   - Refresh context references if needed

5. **Confirmation**:
   ```
   ✅ PRD amended successfully!

   📝 Changes Summary:
   - Added: OAuth Google support (REQ-7)
   - Modified: Authentication flow (REQ-3)
   - Updated: Success metrics

   📈 Revision: v1.2 → v1.3

   ⚠️ Impact Assessment:
   - Existing tasks: 3 need review
   - New tasks: 2 recommended
   - Context updates: security.md may need OAuth section

   🎯 Next Steps:
   1. Review updated PRD sections
   2. Regenerate tasks if needed:
      /prism:tasks generate prd-[feature-name].md
   3. Update affected implementation
   ```

**For `/prism:prd list`**:

```
📋 Product Requirement Documents

.prism/references/:
  user-authentication      APPROVED      2025-11-01
  payment-integration      IN_PROGRESS   2025-11-05
  admin-dashboard          DRAFT         2025-11-12

Total PRDs: 3

Use: /prism:prd create <name> to create new PRD
```

---

## Key Behaviors

### 1. PRISM Context Integration

**Always reference context files**:

```markdown
## 1. PRISM Context References

**Architecture Constraints** (`.prism/context/architecture.md#microservices`):
- Feature must follow microservices architecture
- Use REST API for inter-service communication
- Deploy as independent containerized service
- Database: PostgreSQL with connection pooling

**Security Requirements** (`.prism/context/security.md#authentication`):
- All endpoints require JWT authentication
- Tokens expire after 24 hours
- Use bcrypt (cost factor 12) for password hashing
- Implement rate limiting: 100 requests/minute

**Coding Patterns** (`.prism/context/patterns.md#nodejs`):
- Follow MVC pattern
- Use async/await for asynchronous operations
- ESLint configuration: .eslintrc.json
- Test coverage minimum: 80%

**Technical Decisions** (`.prism/context/decisions.md#DEC-003`):
- Decision: Use PostgreSQL for user data
- Rationale: ACID compliance, relational data model
- Alternatives considered: MongoDB (rejected - need transactions)
```

### 2. Agent Type Suggestions

Analyze requirements and suggest PRISM agents:

```markdown
## PRISM Implementation Plan

**Phase 1: Architecture & Design** (Estimated: 1-2 days)
- **Agent**: architect
- **Tasks**:
  - Design authentication flow and sequence diagrams
  - Define API endpoints and data models
  - Create database schema
  - Document architecture decisions

**Phase 2: Core Implementation** (Estimated: 3-5 days)
- **Agent**: coder
- **Tasks**:
  - Implement user registration and login
  - JWT token generation and validation
  - Password hashing and verification
  - API endpoints implementation

**Phase 3: Security Hardening** (Estimated: 1-2 days)
- **Agent**: security
- **Tasks**:
  - Security audit and vulnerability assessment
  - Input validation and sanitization review
  - Rate limiting implementation
  - OWASP Top 10 compliance check

**Phase 4: Testing & QA** (Estimated: 2-3 days)
- **Agent**: tester
- **Tasks**:
  - Unit tests (target: 80%+ coverage)
  - Integration tests
  - End-to-end user journey tests
  - Performance testing
```

### 3. Quality Standards

**PRD Completeness Checklist**:
- ✅ All template sections filled (use "TBD" if pending)
- ✅ Requirements are SMART (Specific, Measurable, Achievable, Relevant, Time-bound)
- ✅ Written for junior developer comprehension level
- ✅ Specific, testable acceptance criteria
- ✅ Clear success metrics defined
- ✅ Out-of-scope items explicitly stated

**PRISM Compliance Checklist**:
- ✅ References to all relevant `.prism/context/` files
- ✅ Alignment with existing technical decisions
- ✅ Adherence to architectural patterns
- ✅ Security policies incorporated
- ✅ Coding standards acknowledged
- ✅ Agent suggestions included

---

## Error Handling

### Common Errors

**Error: PRD already exists**
```
⚠️ PRD already exists: .prism/references/prd-[name].md

Options:
A) Overwrite existing PRD
B) Amend existing PRD instead
C) Choose different feature name

What would you like to do?
```

**Error: Missing PRISM context**
```
⚠️ PRISM context incomplete

Missing files:
- .prism/context/architecture.md

Recommendation:
1. Initialize PRISM: prism init
2. Or create context manually
3. Then retry PRD creation
```

**Error: Invalid feature name**
```
❌ Invalid feature name: "User Auth 123!"

Requirements:
- Use kebab-case
- Alphanumeric and hyphens only
- Example: user-authentication

Please try again with valid name.
```

---

## Examples

### Example 1: Create Authentication PRD
```
User: /prism:prd create user-authentication