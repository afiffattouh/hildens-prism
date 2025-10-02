#!/bin/bash
# Integration Test Suite for Claude Agent SDK Integration
# Tests prism-agent-executor.sh, prism-verification.sh, prism-swarms.sh

set -e  # Exit on error

# Test configuration
readonly TEST_DIR="/tmp/prism-test-$(date +%s)"
readonly LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)/lib"

# Colors for output (using different variable names to avoid conflicts with prism-log.sh)
readonly TEST_GREEN='\033[0;32m'
readonly TEST_RED='\033[0;31m'
readonly TEST_YELLOW='\033[1;33m'
readonly TEST_NC='\033[0m'

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Setup test environment
setup_test_env() {
    echo "=== Setting up test environment ==="
    mkdir -p "$TEST_DIR"
    cd "$TEST_DIR"

    # Create minimal PRISM structure
    mkdir -p .prism/{context,agents/{active,completed,logs,results,registry,swarms,messages},sessions}

    # Create test context files
    cat > .prism/context/patterns.md << 'EOF'
# PRISM Patterns
Test patterns for unit testing
EOF

    cat > .prism/context/architecture.md << 'EOF'
# Architecture
Test architecture context
EOF

    cat > .prism/context/security.md << 'EOF'
# Security
Test security context
EOF

    # Source PRISM libraries
    source "$LIB_DIR/prism-log.sh"
    source "$LIB_DIR/prism-agents.sh"
    source "$LIB_DIR/prism-agent-executor.sh"
    source "$LIB_DIR/prism-verification.sh"
    source "$LIB_DIR/prism-swarms.sh"

    echo "✅ Test environment setup complete: $TEST_DIR"
}

# Cleanup test environment
cleanup_test_env() {
    echo ""
    echo "=== Cleaning up test environment ==="
    cd /
    rm -rf "$TEST_DIR"
    echo "✅ Cleanup complete"
}

# Test assertion helpers
assert_equals() {
    local expected="$1"
    local actual="$2"
    local test_name="$3"

    TESTS_RUN=$((TESTS_RUN + 1))

    if [[ "$expected" == "$actual" ]]; then
        echo -e "${TEST_GREEN}✅ PASS${TEST_NC}: $test_name"
        TESTS_PASSED=$((TESTS_PASSED + 1))
        return 0
    else
        echo -e "${TEST_RED}❌ FAIL${TEST_NC}: $test_name"
        echo "   Expected: $expected"
        echo "   Actual: $actual"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        return 1
    fi
}

assert_file_exists() {
    local file="$1"
    local test_name="$2"

    TESTS_RUN=$((TESTS_RUN + 1))

    if [[ -f "$file" ]]; then
        echo -e "${TEST_GREEN}✅ PASS${TEST_NC}: $test_name"
        TESTS_PASSED=$((TESTS_PASSED + 1))
        return 0
    else
        echo -e "${TEST_RED}❌ FAIL${TEST_NC}: $test_name"
        echo "   File not found: $file"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        return 1
    fi
}

assert_dir_exists() {
    local dir="$1"
    local test_name="$2"

    TESTS_RUN=$((TESTS_RUN + 1))

    if [[ -d "$dir" ]]; then
        echo -e "${TEST_GREEN}✅ PASS${TEST_NC}: $test_name"
        TESTS_PASSED=$((TESTS_PASSED + 1))
        return 0
    else
        echo -e "${TEST_RED}❌ FAIL${TEST_NC}: $test_name"
        echo "   Directory not found: $dir"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        return 1
    fi
}

assert_contains() {
    local haystack="$1"
    local needle="$2"
    local test_name="$3"

    TESTS_RUN=$((TESTS_RUN + 1))

    if echo "$haystack" | grep -q "$needle"; then
        echo -e "${TEST_GREEN}✅ PASS${TEST_NC}: $test_name"
        TESTS_PASSED=$((TESTS_PASSED + 1))
        return 0
    else
        echo -e "${TEST_RED}❌ FAIL${TEST_NC}: $test_name"
        echo "   String not found: $needle"
        echo "   In: $haystack"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        return 1
    fi
}

# Test 1: Agent Creation
test_agent_creation() {
    echo ""
    echo "=== Test 1: Agent Creation ==="

    local agent_id=$(create_agent "coder" "test_coder" "Write a test function")

    assert_contains "$agent_id" "agent_test_coder" "Agent ID format"
    assert_dir_exists ".prism/agents/active/$agent_id" "Agent directory created"
    assert_file_exists ".prism/agents/active/$agent_id/config.yaml" "Agent config created"

    # Check config content
    local agent_type=$(grep "^type:" ".prism/agents/active/$agent_id/config.yaml" | awk '{print $2}')
    assert_equals "coder" "$agent_type" "Agent type in config"
}

# Test 2: Context Loading
test_context_loading() {
    echo ""
    echo "=== Test 2: Context Loading ==="

    # Create test agent
    local agent_id=$(create_agent "architect" "test_architect" "Design system" 2>/dev/null | tail -1)

    # Test context gathering
    gather_agent_context "$agent_id" 2>/dev/null

    assert_file_exists ".prism/agents/active/$agent_id/context.txt" "Context file created"

    local context_content=$(cat ".prism/agents/active/$agent_id/context.txt")
    assert_contains "$context_content" "PRISM Patterns" "Patterns context loaded"
    assert_contains "$context_content" "Architecture" "Architecture context loaded"
}

# Test 3: Verification System
test_verification_system() {
    echo ""
    echo "=== Test 3: Verification System ==="

    # Create test file
    cat > test_file.sh << 'EOF'
#!/bin/bash
# Test file for verification
echo "Hello World"
EOF

    # Create test agent for verification
    local agent_id=$(create_agent "reviewer" "test_reviewer" "Review code" 2>/dev/null | tail -1)

    # Run verification
    verify_code_quality "test_file.sh" "$agent_id" >/dev/null 2>&1

    assert_file_exists ".prism/agents/active/$agent_id/verification_report.md" "Verification report created"

    local report=$(cat ".prism/agents/active/$agent_id/verification_report.md")
    assert_contains "$report" "Verification Report" "Report header present"
    assert_contains "$report" "File Existence" "File existence check present"
}

# Test 4: Security Scanning
test_security_scanning() {
    echo ""
    echo "=== Test 4: Security Scanning ==="

    # Create test file with security issues
    cat > test_secure.sh << 'EOF'
#!/bin/bash
password="hardcoded123"
eval "echo test"
EOF

    local agent_id=$(create_agent "security" "test_security" "Scan for vulnerabilities" 2>/dev/null | tail -1)

    # Run security scan (will fail due to hardcoded password)
    scan_security "test_secure.sh" "$agent_id" >/dev/null 2>&1 || true

    assert_file_exists ".prism/agents/active/$agent_id/security_scan.md" "Security scan report created"

    local scan_report=$(cat ".prism/agents/active/$agent_id/security_scan.md")
    assert_contains "$scan_report" "Security Scan Report" "Security report header"
}

# Test 5: Swarm Creation
test_swarm_creation() {
    echo ""
    echo "=== Test 5: Swarm Creation ==="

    # Initialize swarm system
    init_swarm_system 2>/dev/null

    # Create a swarm
    local swarm_id=$(create_swarm "test_swarm" "pipeline" "Test swarm task" 2>/dev/null | tail -1)

    assert_contains "$swarm_id" "swarm_test_swarm" "Swarm ID format"
    assert_dir_exists ".prism/agents/swarms/active/$swarm_id" "Swarm directory created"
    assert_file_exists ".prism/agents/swarms/active/$swarm_id/config.yaml" "Swarm config created"

    # Check swarm topology
    local topology=$(grep "^topology:" ".prism/agents/swarms/active/$swarm_id/config.yaml" | awk '{print $2}')
    assert_equals "pipeline" "$topology" "Swarm topology in config"
}

# Test 6: Agent Tool Permissions
test_tool_permissions() {
    echo ""
    echo "=== Test 6: Agent Tool Permissions ==="

    # Test get_agent_tools function
    source "$LIB_DIR/prism-agent-executor.sh" 2>/dev/null

    # Check that tool permissions are defined via function
    local coder_tools="$(get_agent_tools "coder")"
    assert_contains "$coder_tools" "Write" "Coder has Write permission"
    assert_contains "$coder_tools" "Edit" "Coder has Edit permission"

    local reviewer_tools="$(get_agent_tools "reviewer")"
    assert_contains "$reviewer_tools" "Read" "Reviewer has Read permission"
}

# Test 7: State Management
test_state_management() {
    echo ""
    echo "=== Test 7: State Management ==="

    local agent_id=$(create_agent "tester" "test_state" "Test state changes" 2>/dev/null | tail -1)

    # Initial state should be idle
    local initial_state=$(grep "^state:" ".prism/agents/active/$agent_id/config.yaml" | awk '{print $2}')
    assert_equals "idle" "$initial_state" "Initial state is idle"

    # Update state to working
    update_agent_state "$agent_id" "working" 2>/dev/null

    local working_state=$(grep "^state:" ".prism/agents/active/$agent_id/config.yaml" | awk '{print $2}')
    assert_equals "working" "$working_state" "State updated to working"

    # Update state to completed
    update_agent_state "$agent_id" "completed" 2>/dev/null

    local completed_state=$(grep "^state:" ".prism/agents/active/$agent_id/config.yaml" | awk '{print $2}')
    assert_equals "completed" "$completed_state" "State updated to completed"
}

# Test 8: Logging System
test_logging_system() {
    echo ""
    echo "=== Test 8: Logging System ==="

    # Test log functions exist
    type log_info >/dev/null 2>&1
    assert_equals "0" "$?" "log_info function exists"

    type log_error >/dev/null 2>&1
    assert_equals "0" "$?" "log_error function exists"

    type log_success >/dev/null 2>&1
    assert_equals "0" "$?" "log_success function exists"

    type log_warning >/dev/null 2>&1
    assert_equals "0" "$?" "log_warning function exists"
}

# Test 9: File Size Verification
test_file_size_limits() {
    echo ""
    echo "=== Test 9: File Size Verification ==="

    # Create a large test file (400 lines, exceeds 300 limit)
    {
        for i in $(seq 1 400); do
            echo "# Line $i - test content"
        done
    } > large_file.sh

    local agent_id=$(create_agent "reviewer" "test_size" "Check file size" 2>/dev/null | tail -1)

    verify_code_quality "large_file.sh" "$agent_id" >/dev/null 2>&1 || true

    local report=$(cat ".prism/agents/active/$agent_id/verification_report.md")
    assert_contains "$report" "WARNING" "File size warning present for large file"
}

# Test 10: Integration - Full Agent Workflow
test_full_agent_workflow() {
    echo ""
    echo "=== Test 10: Full Agent Workflow Integration ==="

    # Create agent
    local agent_id=$(create_agent "planner" "test_workflow" "Plan a test project" 2>/dev/null | tail -1)

    # Gather context
    gather_agent_context "$agent_id" >/dev/null 2>&1
    assert_file_exists ".prism/agents/active/$agent_id/context.txt" "Workflow: Context gathered"

    # Generate action prompt
    execute_agent_action "$agent_id" >/dev/null 2>&1
    assert_file_exists ".prism/agents/active/$agent_id/action_prompt.md" "Workflow: Action prompt generated"

    # Check prompt content
    local prompt=$(cat ".prism/agents/active/$agent_id/action_prompt.md")
    assert_contains "$prompt" "PRISM Agent" "Workflow: Prompt has PRISM header"
    assert_contains "$prompt" "Available Tools" "Workflow: Prompt has tools section"
    assert_contains "$prompt" "Read Glob Grep" "Workflow: Planner has correct tools"
}

# Main test runner
main() {
    echo "╔════════════════════════════════════════════════════════╗"
    echo "║   PRISM Claude Agent SDK Integration Test Suite       ║"
    echo "╚════════════════════════════════════════════════════════╝"
    echo ""

    # Setup
    setup_test_env

    # Run all tests
    test_agent_creation
    test_context_loading
    test_verification_system
    test_security_scanning
    test_swarm_creation
    test_tool_permissions
    test_state_management
    test_logging_system
    test_file_size_limits
    test_full_agent_workflow

    # Cleanup
    cleanup_test_env

    # Print results
    echo ""
    echo "╔════════════════════════════════════════════════════════╗"
    echo "║                    TEST RESULTS                        ║"
    echo "╚════════════════════════════════════════════════════════╝"
    echo ""
    echo "Tests Run:    $TESTS_RUN"
    echo -e "Tests Passed: ${TEST_GREEN}$TESTS_PASSED${TEST_NC}"
    echo -e "Tests Failed: ${TEST_RED}$TESTS_FAILED${TEST_NC}"
    echo ""

    local pass_rate=0
    if [[ $TESTS_RUN -gt 0 ]]; then
        pass_rate=$((TESTS_PASSED * 100 / TESTS_RUN))
    fi

    echo "Pass Rate: ${pass_rate}%"
    echo ""

    if [[ $TESTS_FAILED -eq 0 ]]; then
        echo -e "${TEST_GREEN}✅ ALL TESTS PASSED!${TEST_NC}"
        exit 0
    else
        echo -e "${TEST_RED}❌ SOME TESTS FAILED${TEST_NC}"
        exit 1
    fi
}

# Run tests
main "$@"
