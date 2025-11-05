#!/usr/bin/env bash
# Test suite for TOON Session Integration (Phase 5)

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Script and root directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PRISM_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Disable logging to reduce noise
export PRISM_LOG_STDOUT=false
export PRISM_LOG_FILE=false
export PRISM_TOON_ENABLED=true
export PRISM_TOON_SESSION=true

# Source required libraries
source "$PRISM_ROOT/lib/prism-log.sh"
source "$PRISM_ROOT/lib/prism-toon.sh"
source "$PRISM_ROOT/lib/prism-session.sh"

# Test helper functions
test_start() {
    echo ""
    echo -e "${BLUE}▶ TEST: $1${NC}"
    TESTS_RUN=$((TESTS_RUN + 1))
}

test_pass() {
    echo -e "${GREEN}✅ PASS: $1${NC}"
    TESTS_PASSED=$((TESTS_PASSED + 1))
}

test_fail() {
    echo -e "${RED}❌ FAIL: $1${NC}"
    TESTS_FAILED=$((TESTS_FAILED + 1))
}

test_info() {
    echo -e "${YELLOW}ℹ️  INFO: $1${NC}"
}

# Create test session for testing
setup_test_session() {
    mkdir -p .prism/sessions/archive

    # Create a test session file
    cat > .prism/sessions/current.md << 'EOF'
# Current Session
**Session ID**: 20241105-150000
**Started**: 2024-11-05T15:00:00Z
**Status**: ACTIVE
**Description**: Test session for TOON integration

## Context Loaded
- architecture.md (CRITICAL)
- security.md (CRITICAL)
- patterns.md (HIGH)

## Current Task
- Description: Test session for TOON integration
- Type: Development
- Priority: MEDIUM

## Operations Log
1. 15:00:00 - Session started
2. 15:05:00 - TOON integration testing
3. 15:10:00 - Running test suite

## Metrics
- Operations: 3
- Errors: 0
- Warnings: 0
- Duration: 15m

## Notes
- Session created for testing purposes
EOF
}

# Cleanup test session
cleanup_test_session() {
    rm -f .prism/sessions/current.md
    rm -rf .prism/sessions/archive/test_*
}

# Test 1: Session status TOON conversion
test_session_status_toon() {
    test_start "Session status TOON conversion"

    setup_test_session

    # Get session status in TOON format
    local toon_output=$(prism_session_status "toon" 2>&1)

    # Cleanup
    cleanup_test_session

    # Check if TOON format is generated
    if echo "$toon_output" | grep -q "Session Status (TOON Format)"; then
        test_pass "Session status converts to TOON format"
        test_info "Output preview:\n$(echo "$toon_output" | tail -5)"
    else
        test_fail "Session status TOON conversion failed"
        test_info "Output: $toon_output"
    fi
}

# Test 2: Session metadata JSON to TOON
test_session_metadata_conversion() {
    test_start "Session metadata JSON to TOON conversion"

    local session_json='{"session_id":"20241105-150000","started":"2024-11-05T15:00:00Z","status":"ACTIVE","duration_hours":0,"duration_minutes":15,"operations":3,"errors":0,"warnings":0}'

    local toon_output=$(toon_optimize "$session_json" "session" 2>/dev/null)

    # Check if conversion succeeded
    if [[ -n "$toon_output" ]]; then
        test_pass "Session metadata converts to TOON"
        test_info "TOON output:\n$toon_output"
    else
        test_fail "Session metadata conversion failed"
    fi
}

# Test 3: Session list TOON format
test_session_list_toon() {
    test_start "Session list TOON format"

    # Create test archive sessions
    mkdir -p .prism/sessions/archive

    for i in 1 2 3; do
        cat > ".prism/sessions/archive/test_session_00$i.md" << EOF
# Session
**Session ID**: test_session_00$i
**Started**: 2024-11-05T1${i}:00:00Z
**Status**: ARCHIVED
**Ended**: 2024-11-05T1${i}:30:00Z

## Summary
- Total operations: $((i * 5))
EOF
    done

    # Test list-toon command
    local list_output=$(prism_session_list_toon 3 2>&1)

    # Cleanup
    rm -f .prism/sessions/archive/test_session_*.md

    # Check if TOON format is generated
    if echo "$list_output" | grep -q "Session History (TOON Format)"; then
        test_pass "Session list generates TOON format"
        test_info "Output preview:\n$(echo "$list_output" | grep -A5 "Session History")"
    else
        test_fail "Session list TOON format not generated"
        test_info "Output: $list_output"
    fi
}

# Test 4: Session array TOON optimization
test_session_array_optimization() {
    test_start "Session array TOON optimization"

    local sessions_json='[
        {"session_id":"session_001","status":"ACTIVE","started":"2024-11-05T10:00:00Z","operations":5},
        {"session_id":"session_002","status":"ARCHIVED","started":"2024-11-05T11:00:00Z","operations":10},
        {"session_id":"session_003","status":"ARCHIVED","started":"2024-11-05T12:00:00Z","operations":15}
    ]'

    local toon_output=$(toon_optimize "$sessions_json" "session" 2>/dev/null)

    # Check if TOON tabular format is used
    if echo "$toon_output" | grep -q "items\[3\]{" && \
       echo "$toon_output" | grep -q "session_001" && \
       echo "$toon_output" | grep -q "session_003"; then
        test_pass "Session array optimized to TOON tabular format"
        test_info "TOON output:\n$toon_output"
    else
        test_fail "Session array optimization failed"
        test_info "Output: $toon_output"
    fi
}

# Test 5: Token savings benchmark
test_token_savings_benchmark() {
    test_start "Session token savings benchmark"

    local sessions_json='[
        {"session_id":"20241105-100000","status":"ARCHIVED","started":"2024-11-05T10:00:00Z","ended":"2024-11-05T11:00:00Z","operations":25},
        {"session_id":"20241105-110000","status":"ARCHIVED","started":"2024-11-05T11:00:00Z","ended":"2024-11-05T12:00:00Z","operations":30},
        {"session_id":"20241105-120000","status":"ARCHIVED","started":"2024-11-05T12:00:00Z","ended":"2024-11-05T13:00:00Z","operations":35},
        {"session_id":"20241105-130000","status":"ARCHIVED","started":"2024-11-05T13:00:00Z","ended":"2024-11-05T14:00:00Z","operations":40},
        {"session_id":"20241105-140000","status":"ACTIVE","started":"2024-11-05T14:00:00Z","ended":"unknown","operations":20}
    ]'

    # Original JSON tokens
    local original_tokens=$(_toon_estimate_tokens "$sessions_json")

    # TOON format tokens
    local toon_output=$(toon_optimize "$sessions_json" "session" 2>/dev/null)
    local toon_tokens=$(_toon_estimate_tokens "$toon_output")

    # Calculate savings
    local savings=0
    if [[ $original_tokens -gt 0 ]]; then
        savings=$(( 100 * (original_tokens - toon_tokens) / original_tokens ))
    fi

    echo ""
    echo "📊 Session TOON Benchmark Results"
    echo "=================================="
    echo "Sessions:          5"
    echo "Original JSON:     $original_tokens tokens"
    echo "TOON Format:       $toon_tokens tokens"
    echo "Savings:           $savings%"

    # Target is 35-45% savings
    if [[ $savings -ge 35 ]]; then
        test_pass "Token savings achieved: $savings% (target: 35-45%)"
    else
        test_fail "Token savings below target: $savings% (target: 35-45%)"
    fi
}

# Test 6: CLI integration test
test_cli_integration() {
    test_start "CLI integration (prism session)"

    setup_test_session

    # Test session status with --toon flag
    local cli_output=$("$PRISM_ROOT/bin/prism" session status --toon 2>&1)

    # Cleanup
    cleanup_test_session

    # Check if CLI succeeded
    if [[ $? -eq 0 ]] && [[ -n "$cli_output" ]]; then
        test_pass "CLI session status --toon working"

        if echo "$cli_output" | grep -q "Session Status (TOON Format)"; then
            test_info "TOON format present in CLI output"
        fi
    else
        test_fail "CLI integration failed"
        test_info "Output: $cli_output"
    fi
}

# Test 7: Feature flag control
test_feature_flag_control() {
    test_start "Feature flag control (PRISM_TOON_SESSION)"

    # Test with TOON disabled
    export PRISM_TOON_SESSION=false
    local disabled_check=$(toon_is_enabled "session" && echo "enabled" || echo "disabled")

    # Test with TOON enabled
    export PRISM_TOON_SESSION=true
    local enabled_check=$(toon_is_enabled "session" && echo "enabled" || echo "disabled")

    if [[ "$disabled_check" == "disabled" ]] && [[ "$enabled_check" == "enabled" ]]; then
        test_pass "Feature flag control working correctly"
        test_info "Disabled: $disabled_check, Enabled: $enabled_check"
    else
        test_fail "Feature flag control not working"
        test_info "Disabled: $disabled_check, Enabled: $enabled_check"
    fi

    # Restore enabled state
    export PRISM_TOON_SESSION=true
}

# Test 8: Session status human format (backwards compatibility)
test_session_status_human() {
    test_start "Session status human format (backwards compatibility)"

    setup_test_session

    # Get session status in human format
    local human_output=$(prism_session_status "human" 2>&1)

    # Cleanup
    cleanup_test_session

    # Check if human format is generated
    if echo "$human_output" | grep -q "Session ID:" && \
       echo "$human_output" | grep -q "Status:" && \
       echo "$human_output" | grep -q "Duration:"; then
        test_pass "Session status human format works (backwards compatible)"
    else
        test_fail "Session status human format failed"
    fi
}

# Main test execution
main() {
    echo ""
    echo "╔════════════════════════════════════════════════════════════════╗"
    echo "║       TOON Session Integration Test Suite (Phase 5)           ║"
    echo "╚════════════════════════════════════════════════════════════════╝"
    echo ""

    # Run all tests
    test_session_status_toon
    test_session_metadata_conversion
    test_session_list_toon
    test_session_array_optimization
    test_token_savings_benchmark
    test_cli_integration
    test_feature_flag_control
    test_session_status_human

    # Summary
    echo ""
    echo "╔════════════════════════════════════════════════════════════════╗"
    echo "║                         Test Summary                           ║"
    echo "╚════════════════════════════════════════════════════════════════╝"
    echo ""
    echo "Tests Run:    $TESTS_RUN"
    echo -e "${GREEN}Tests Passed: $TESTS_PASSED${NC}"
    if [[ $TESTS_FAILED -gt 0 ]]; then
        echo -e "${RED}Tests Failed: $TESTS_FAILED${NC}"
    else
        echo "Tests Failed: $TESTS_FAILED"
    fi

    # Calculate pass rate
    local pass_rate=0
    if [[ $TESTS_RUN -gt 0 ]]; then
        pass_rate=$((100 * TESTS_PASSED / TESTS_RUN))
    fi
    echo "Pass Rate:    $pass_rate%"
    echo ""

    if [[ $TESTS_FAILED -eq 0 ]]; then
        echo -e "${GREEN}✅ All tests passed!${NC}"
        return 0
    else
        echo -e "${RED}❌ Some tests failed${NC}"
        return 1
    fi
}

# Run tests
main "$@"
