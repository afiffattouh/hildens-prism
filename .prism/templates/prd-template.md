# PRD Template - PRISM Enhanced

**Purpose**: This template guides AI in generating comprehensive Product Requirement Documents (PRDs) with PRISM context integration.

---

## Instructions for AI

Before generating the PRD, you should:

1. **Analyze PRISM Context**:
   - Read `.prism/context/architecture.md` for system design constraints
   - Read `.prism/context/patterns.md` for coding standards
   - Read `.prism/context/security.md` for security requirements
   - Read `.prism/context/decisions.md` for existing technical decisions

2. **Ask Clarifying Questions** (limit to 3-5 critical questions):
   - What problem does this feature solve?
   - What are the core user actions?
   - What is explicitly out of scope?
   - How will success be measured?
   - Are there specific PRISM context constraints to consider?

3. **Question Format**: Use numbered options for efficiency
   ```
   1. Authentication method?
      A) JWT tokens  B) Session cookies  C) OAuth  D) Other
   2. Storage approach?
      A) PostgreSQL  B) MongoDB  C) Redis  D) Other
   ```
   User responds: `1A, 2A` for quick selection.

4. **Generate PRD** using the structure below, auto-populating PRISM context references.

---

## PRD Structure

# PRD: [Feature Name]

**Created**: [YYYY-MM-DD]
**Status**: DRAFT | IN_REVIEW | APPROVED | IN_PROGRESS | COMPLETED
**Priority**: CRITICAL | HIGH | MEDIUM | LOW
**Owner**: [Name/Team]

---

## 1. PRISM Context References

> Auto-populate from `.prism/context/` analysis

**Architecture Constraints**:
- [Reference to relevant architecture.md sections]
- [System design patterns to follow]
- [Integration points with existing systems]

**Coding Patterns**:
- [Reference to patterns.md standards]
- [Language/framework conventions]
- [Code organization requirements]

**Security Requirements**:
- [Reference to security.md policies]
- [Authentication/authorization patterns]
- [Data protection requirements]

**Technical Decisions**:
- [Reference to decisions.md that impact this feature]
- [Technology choices already made]
- [Constraints from previous decisions]

**Related Context Files**:
- Architecture: `.prism/context/architecture.md#[section]`
- Patterns: `.prism/context/patterns.md#[section]`
- Security: `.prism/context/security.md#[section]`
- Decisions: `.prism/context/decisions.md#[decision-id]`

---

## 2. Introduction / Overview

**Problem Statement**:
[Clear description of the problem this feature solves]

**Feature Summary**:
[Brief 2-3 sentence description of the feature and its value]

**Target Users**:
- [User persona 1 and their needs]
- [User persona 2 and their needs]

**Business Value**:
[Why this feature matters, impact on users/business]

---

## 3. Goals

**Primary Goals**:
1. [Specific, measurable objective 1]
2. [Specific, measurable objective 2]
3. [Specific, measurable objective 3]

**Secondary Goals**:
- [Nice-to-have objective]
- [Future enhancement opportunity]

---

## 4. User Stories

**Core User Journeys**:

```
As a [user type],
I want to [action],
So that [benefit].

Acceptance Criteria:
- [ ] [Specific, testable criterion 1]
- [ ] [Specific, testable criterion 2]
- [ ] [Specific, testable criterion 3]
```

[Repeat for 3-5 core user stories]

---

## 5. Functional Requirements

> Number each requirement for traceability

**REQ-1**: [Clear, explicit requirement]
- **Context**: [Link to relevant .prism/context/ section]
- **Priority**: MUST_HAVE | SHOULD_HAVE | NICE_TO_HAVE
- **Complexity**: LOW | MEDIUM | HIGH

**REQ-2**: [Next requirement]
- **Context**: [Context reference]
- **Priority**: [Priority level]
- **Complexity**: [Complexity level]

[Continue numbering all functional requirements]

---

## 6. Non-Goals (Out of Scope)

**Explicitly Excluded**:
- [Feature/functionality that will NOT be included]
- [Boundary clarification - what this feature does NOT do]
- [Future considerations that are out of scope for this iteration]

**Rationale**:
[Why these are excluded - scope management, resource constraints, etc.]

---

## 7. Design Considerations

**User Interface/Experience**:
- [UI requirements and mockup references if available]
- [User flow descriptions]
- [Accessibility requirements (WCAG compliance, etc.)]

**Data Models**:
```
[Preliminary data structures or schema if applicable]
```

**API Design** (if applicable):
```
[Endpoint definitions, request/response formats]
```

**Mockups/Wireframes**:
- [Link to design files or attach images]
- [Location: `.prism/references/designs/[feature-name]/`]

---

## 8. Technical Considerations

**Technology Stack**:
- [Languages/frameworks from PRISM context]
- [Libraries/dependencies to be used]
- [Infrastructure requirements]

**Constraints**:
- [Performance requirements]
- [Scalability considerations]
- [Browser/platform compatibility]
- [Resource limitations]

**Dependencies**:
- [External services/APIs]
- [Internal system dependencies]
- [Third-party library requirements]

**Integration Points**:
- [How this feature integrates with existing systems]
- [APIs or services to be consumed]
- [Data flow between components]

**PRISM Agent Suggestions**:
> Based on requirements, these agent types are recommended:
- **Architect**: For [specific architecture tasks]
- **Coder**: For [implementation tasks]
- **Security**: For [security-critical components]
- **Tester**: For [testing requirements]

---

## 9. Success Metrics

**Key Performance Indicators (KPIs)**:
1. [Measurable metric 1 with target value]
2. [Measurable metric 2 with target value]
3. [Measurable metric 3 with target value]

**Validation Criteria**:
- [ ] [How to verify requirement REQ-1 is met]
- [ ] [How to verify requirement REQ-2 is met]
- [ ] [How to verify requirement REQ-3 is met]

**Acceptance Testing**:
- [Testing approach and validation methodology]
- [Link to test plan: `.prism/workflows/test-plan-[feature].md`]

---

## 10. Implementation Phases

**Phase 1**: [Initial milestone]
- [Deliverables]
- [Timeline estimate]

**Phase 2**: [Next milestone]
- [Deliverables]
- [Timeline estimate]

**Phase 3**: [Final milestone]
- [Deliverables]
- [Timeline estimate]

---

## 11. Open Questions

**Unresolved Items**:
1. [Question that needs clarification]
   - **Impact**: [What decisions depend on this]
   - **Owner**: [Who should answer]
   - **Deadline**: [When answer is needed]

2. [Next question]
   - **Impact**: [Decision impact]
   - **Owner**: [Responsible party]
   - **Deadline**: [Timeline]

---

## 12. References

**Related PRDs**:
- [Link to related PRD files]

**External Documentation**:
- [Links to external resources, API docs, etc.]

**Meeting Notes**:
- [Links to relevant discussion documents]

---

## 13. Revision History

| Date | Version | Author | Changes |
|------|---------|--------|---------|
| YYYY-MM-DD | 1.0 | [Name] | Initial draft |
| YYYY-MM-DD | 1.1 | [Name] | [Changes made] |

---

## Output Instructions

**File Location**: `.prism/references/prd-[feature-name].md`

**Naming Convention**: Use kebab-case for feature names
- Good: `prd-user-authentication.md`
- Good: `prd-payment-integration.md`
- Avoid: `prd-UserAuth.md`, `PRD_payment.md`

**Completeness**: All sections should be filled. Use "TBD" or "N/A" if information is not yet available, but include the section.

**Context Linking**: Always reference specific `.prism/context/` files and sections where relevant.

**Clarity**: Write for a junior developer - be explicit, avoid jargon, provide context.
