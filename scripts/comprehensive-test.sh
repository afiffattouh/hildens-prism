#!/bin/bash
# PRISM Framework - Comprehensive Testing Suite
# Tests all functionality from installation to advanced features

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TEST_DIR="/tmp/prism-test-$(date +%s)"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# Test results array
declare -a TEST_RESULTS

# Helper functions
log_section() {
    echo ""
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
}

pass() {
    echo -e "${GREEN}✓${NC} $1"
    ((PASSED_TESTS++))
    ((TOTAL_TESTS++))
    TEST_RESULTS+=("PASS: $1")
}

fail() {
    echo -e "${RED}✗${NC} $1"
    ((FAILED_TESTS++))
    ((TOTAL_TESTS++))
    TEST_RESULTS+=("FAIL: $1")
}

warn() {
    echo -e "${YELLOW}⚠${NC} $1"
}

test_command() {
    local description="$1"
    local command="$2"
    local expected_exit="${3:-0}"

    if eval "$command" &>/dev/null; then
        if [ "$expected_exit" -eq 0 ]; then
            pass "$description"
            return 0
        else
            fail "$description (expected failure but succeeded)"
            return 1
        fi
    else
        if [ "$expected_exit" -ne 0 ]; then
            pass "$description (expected failure)"
            return 0
        else
            fail "$description"
            return 1
        fi
    fi
}

# Start testing
echo -e "${BLUE}"
echo "╔════════════════════════════════════════════════════════════╗"
echo "║         PRISM Framework Comprehensive Test Suite          ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# =============================================================================
# TEST 1: Installation and Setup
# =============================================================================
log_section "TEST 1: Installation and Setup"

test_command "PRISM installation exists" "[ -d ~/.prism ]"
test_command "PRISM bin exists" "[ -f ~/bin/prism ]"
test_command "PRISM is executable" "[ -x ~/bin/prism ]"
test_command "PRISM is in PATH" "command -v prism"

# =============================================================================
# TEST 2: Core CLI Commands
# =============================================================================
log_section "TEST 2: Core CLI Commands"

test_command "prism --help works" "prism --help"
test_command "prism help works" "prism help"
test_command "prism --version works" "prism --version"
test_command "prism version works" "prism version"
test_command "prism doctor works" "prism doctor"

# =============================================================================
# TEST 3: Library Loading
# =============================================================================
log_section "TEST 3: Library Loading"

LIBS=(
    "prism-core.sh"
    "prism-log.sh"
    "prism-security.sh"
    "prism-context.sh"
    "prism-session.sh"
    "prism-agents.sh"
    "prism-skills.sh"
    "prism-init.sh"
)

for lib in "${LIBS[@]}"; do
    test_command "Library $lib exists" "[ -f ~/.prism/lib/$lib ]"
done

# =============================================================================
# TEST 4: Project Initialization
# =============================================================================
log_section "TEST 4: Project Initialization"

mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

test_command "Initialize PRISM in test directory" "prism init"
test_command ".prism directory created" "[ -d .prism ]"
test_command ".prism/context created" "[ -d .prism/context ]"
test_command ".prism/agents created" "[ -d .prism/agents ]"
test_command ".prism/sessions created" "[ -d .prism/sessions ]"
test_command "CLAUDE.md created" "[ -f CLAUDE.md ]"
test_command ".gitignore created or updated" "[ -f .gitignore ]"

# =============================================================================
# TEST 5: Context Management
# =============================================================================
log_section "TEST 5: Context Management"

test_command "Context add HIGH priority" "prism context add HIGH security"
test_command "Context add MEDIUM priority" "prism context add MEDIUM performance"
test_command "Security context file created" "[ -f .prism/context/security.md ]"
test_command "Performance context file created" "[ -f .prism/context/performance.md ]"
test_command "Context query works" "prism context query security"

# =============================================================================
# TEST 6: Skills System
# =============================================================================
log_section "TEST 6: Skills System"

test_command "Skills list works" "prism skill list"
test_command "Skills stats works" "prism skill stats"
test_command "Built-in skills exist" "[ -d ~/.prism/lib/skills ]"
test_command "test-runner skill exists" "[ -d ~/.prism/lib/skills/test-runner ]"
test_command "context-summary skill exists" "[ -d ~/.prism/lib/skills/context-summary ]"
test_command "session-save skill exists" "[ -d ~/.prism/lib/skills/session-save ]"
test_command "skill-create skill exists" "[ -d ~/.prism/lib/skills/skill-create ]"
test_command "prism-init skill exists" "[ -d ~/.prism/lib/skills/prism-init ]"

# Test skill info command for each skill
for skill in test-runner context-summary session-save skill-create prism-init; do
    test_command "Skill info for $skill works" "prism skill info $skill"
done

# =============================================================================
# TEST 7: Agent System
# =============================================================================
log_section "TEST 7: Agent System"

test_command "Agent system init works" "prism agent init"
test_command "Agent list works" "prism agent list"
test_command "Agents directory initialized" "[ -d .prism/agents/active ]"
test_command "Agents results directory exists" "[ -d .prism/agents/results ]"

# Test agent creation for each type
AGENT_TYPES=(
    "architect"
    "coder"
    "tester"
    "reviewer"
    "documenter"
    "security"
    "performance"
    "refactorer"
    "debugger"
    "planner"
    "ui-designer"
    "sparc"
)

echo ""
echo "Testing agent creation for all 12 types..."
for agent_type in "${AGENT_TYPES[@]}"; do
    if prism agent create "$agent_type" "test_${agent_type}" "Test task for $agent_type" &>/dev/null; then
        pass "Create $agent_type agent"
    else
        fail "Create $agent_type agent"
    fi
done

# =============================================================================
# TEST 8: Session Management
# =============================================================================
log_section "TEST 8: Session Management"

test_command "Session start works" "prism session start 'Test session'"
test_command "Session status works" "prism session status"
test_command "Current session file created" "[ -f .prism/sessions/current.md ]"

# =============================================================================
# TEST 9: Maintenance Commands
# =============================================================================
log_section "TEST 9: Maintenance Commands"

if [ -f "$PROJECT_ROOT/scripts/prism-maintenance.sh" ]; then
    test_command "Maintenance status works" "$PROJECT_ROOT/scripts/prism-maintenance.sh status"
    test_command "Maintenance validate works" "$PROJECT_ROOT/scripts/prism-maintenance.sh validate"
else
    warn "Maintenance script not found (optional)"
fi

# =============================================================================
# TEST 10: Skills Claude Code Integration
# =============================================================================
log_section "TEST 10: Skills Claude Code Integration"

test_command "Skills link-claude works" "prism skill link-claude"
test_command "Claude skills directory created" "[ -d ~/.claude/skills ]"
test_command "Claude skills symlink exists" "[ -L ~/.claude/skills ]"

# Check if built-in skills are accessible via Claude
if [ -L ~/.claude/skills ]; then
    LINKED_COUNT=$(find ~/.prism/skills -mindepth 1 -maxdepth 1 -type l 2>/dev/null | wc -l)
    if [ "$LINKED_COUNT" -ge 5 ]; then
        pass "Built-in skills linked to Claude (found $LINKED_COUNT)"
    else
        fail "Built-in skills not properly linked (found only $LINKED_COUNT, expected 5)"
    fi
fi

# =============================================================================
# TEST 11: Error Handling
# =============================================================================
log_section "TEST 11: Error Handling"

test_command "Invalid command returns error" "! prism invalid-command"
test_command "Missing arguments handled" "! prism context add"

# =============================================================================
# TEST 12: File Permissions and Security
# =============================================================================
log_section "TEST 12: File Permissions and Security"

test_command "PRISM bin has correct permissions" "[ -x ~/bin/prism ]"
test_command "Library files readable" "[ -r ~/.prism/lib/prism-core.sh ]"
test_command "Config files exist" "[ -d ~/.prism ]"

# =============================================================================
# Cleanup
# =============================================================================
log_section "Cleanup"

cd /
rm -rf "$TEST_DIR"
pass "Test directory cleaned up"

# =============================================================================
# Test Summary
# =============================================================================
echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}TEST SUMMARY${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "Total Tests:  ${TOTAL_TESTS}"
echo -e "${GREEN}Passed:       ${PASSED_TESTS}${NC}"
if [ "$FAILED_TESTS" -gt 0 ]; then
    echo -e "${RED}Failed:       ${FAILED_TESTS}${NC}"
else
    echo -e "Failed:       ${FAILED_TESTS}"
fi
echo ""

# Calculate percentage
if [ "$TOTAL_TESTS" -gt 0 ]; then
    PASS_PERCENTAGE=$(awk "BEGIN {printf \"%.1f\", ($PASSED_TESTS / $TOTAL_TESTS) * 100}")
    echo -e "Pass Rate:    ${PASS_PERCENTAGE}%"
else
    echo -e "Pass Rate:    N/A"
fi

echo ""

# Show failed tests if any
if [ "$FAILED_TESTS" -gt 0 ]; then
    echo -e "${RED}Failed Tests:${NC}"
    for result in "${TEST_RESULTS[@]}"; do
        if [[ $result == FAIL:* ]]; then
            echo -e "${RED}  - ${result#FAIL: }${NC}"
        fi
    done
    echo ""
fi

# Final result
echo -e "${BLUE}========================================${NC}"
if [ "$FAILED_TESTS" -eq 0 ]; then
    echo -e "${GREEN}✓ ALL TESTS PASSED!${NC}"
    echo -e "${GREEN}PRISM Framework is fully operational.${NC}"
    exit 0
else
    echo -e "${RED}✗ SOME TESTS FAILED${NC}"
    echo -e "${YELLOW}Please review failed tests above.${NC}"
    exit 1
fi
