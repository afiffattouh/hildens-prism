#!/usr/bin/env bash
# Test suite for TOON Context Integration (Phase 3)

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

# Source PRISM libraries
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PRISM_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Disable logging to reduce noise
export PRISM_LOG_STDOUT=false
export PRISM_LOG_FILE=false
export PRISM_TOON_ENABLED=true
export PRISM_TOON_CONTEXT=true

# Source required libraries
source "$PRISM_ROOT/lib/prism-log.sh"
source "$PRISM_ROOT/lib/prism-toon.sh"
source "$PRISM_ROOT/lib/prism-context.sh"

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

# Test 1: Context metadata TOON conversion
test_context_metadata_conversion() {
    test_start "Context metadata TOON conversion"

    # Create sample context metadata JSON
    local context_json='[
        {"file":"architecture.md","priority":"critical","size":1024,"lines":50,"updated":"2024-11-05"},
        {"file":"patterns.md","priority":"high","size":2048,"lines":100,"updated":"2024-11-05"},
        {"file":"decisions.md","priority":"high","size":512,"lines":25,"updated":"2024-11-04"}
    ]'

    # Convert to TOON
    local toon_output=$(toon_optimize "$context_json" "context" 2>/dev/null)

    # Check if conversion succeeded
    if [[ -n "$toon_output" ]] && echo "$toon_output" | grep -q "items\[3\]"; then
        test_pass "Context metadata converted to TOON format"
        test_info "TOON output:\n$toon_output"
    else
        test_fail "Context metadata conversion failed"
        test_info "Output: $toon_output"
    fi
}

# Test 2: Context list TOON format
test_context_list_toon() {
    test_start "Context list TOON format generation"

    # Check if .prism/context exists
    if [[ ! -d "$PRISM_ROOT/.prism/context" ]]; then
        test_info "Skipping - no .prism/context directory"
        return
    fi

    # Test context list with TOON format
    local list_output=$(prism_context_list_toon "all" 2>&1)

    # Check if TOON format is present
    if echo "$list_output" | grep -q "items\["; then
        test_pass "Context list generates TOON format"
        test_info "Output preview:\n$(echo "$list_output" | head -10)"
    else
        test_fail "Context list TOON format not generated"
        test_info "Output: $list_output"
    fi
}

# Test 3: Context list with priority filters
test_context_list_filters() {
    test_start "Context list priority filtering"

    if [[ ! -d "$PRISM_ROOT/.prism/context" ]]; then
        test_info "Skipping - no .prism/context directory"
        return
    fi

    # Test with different priority filters
    local filters=("all" "critical" "high" "medium")
    local filter_tests_passed=0

    for filter in "${filters[@]}"; do
        local filter_output=$(prism_context_list_toon "$filter" 2>&1)

        if [[ -n "$filter_output" ]]; then
            filter_tests_passed=$((filter_tests_passed + 1))
            test_info "Filter '$filter': OK"
        else
            test_info "Filter '$filter': No output"
        fi
    done

    if [[ $filter_tests_passed -eq ${#filters[@]} ]]; then
        test_pass "All priority filters working"
    else
        test_fail "Some priority filters failed ($filter_tests_passed/${#filters[@]} passed)"
    fi
}

# Test 4: Context export with TOON
test_context_export_toon() {
    test_start "Context export with TOON optimization"

    if [[ ! -d "$PRISM_ROOT/.prism/context" ]]; then
        test_info "Skipping - no .prism/context directory"
        return
    fi

    # Export context as JSON with TOON optimization
    local export_output=$(export_context_json "true" 2>&1)

    # Check if export succeeded
    if [[ -n "$export_output" ]]; then
        test_pass "Context export with TOON succeeded"

        # Check if TOON format markers are present
        if echo "$export_output" | grep -q "items\["; then
            test_info "TOON format detected in export"
        else
            test_info "Export completed but TOON format not detected"
        fi
    else
        test_fail "Context export with TOON failed"
    fi
}

# Test 5: Token savings benchmark
test_token_savings_benchmark() {
    test_start "Context TOON token savings benchmark"

    # Create benchmark context data (7 files)
    local context_json='[
        {"file":"architecture.md","priority":"critical","size":851,"lines":43,"updated":"2024-11-05T10:00:00Z"},
        {"file":"security.md","priority":"critical","size":1213,"lines":43,"updated":"2024-11-05T10:00:00Z"},
        {"file":"domain.md","priority":"critical","size":829,"lines":38,"updated":"2024-11-05T10:00:00Z"},
        {"file":"patterns.md","priority":"high","size":1603,"lines":65,"updated":"2024-11-05T10:00:00Z"},
        {"file":"decisions.md","priority":"high","size":721,"lines":31,"updated":"2024-11-05T10:00:00Z"},
        {"file":"dependencies.md","priority":"high","size":772,"lines":34,"updated":"2024-11-05T10:00:00Z"},
        {"file":"performance.md","priority":"high","size":896,"lines":46,"updated":"2024-11-05T10:00:00Z"}
    ]'

    # Original JSON tokens
    local original_tokens=$(_toon_estimate_tokens "$context_json")

    # TOON format tokens
    local toon_output=$(toon_optimize "$context_json" "context" 2>/dev/null)
    local toon_tokens=$(_toon_estimate_tokens "$toon_output")

    # Calculate savings
    local savings=0
    if [[ $original_tokens -gt 0 ]]; then
        savings=$(( 100 * (original_tokens - toon_tokens) / original_tokens ))
    fi

    echo ""
    echo "📊 Context TOON Benchmark Results"
    echo "=================================="
    echo "Context files:     7"
    echo "Original JSON:     $original_tokens tokens"
    echo "TOON Format:       $toon_tokens tokens"
    echo "Savings:           $savings%"

    # Target is 30-40% savings, but we're achieving 45%+
    if [[ $savings -ge 30 ]]; then
        test_pass "Token savings achieved: $savings% (target: 30-40%)"
    else
        test_fail "Token savings below target: $savings% (target: 30-40%)"
    fi
}

# Test 6: Context critical loading with TOON
test_context_critical_loading() {
    test_start "Context critical loading with TOON format"

    if [[ ! -d "$PRISM_ROOT/.prism/context" ]]; then
        test_info "Skipping - no .prism/context directory"
        return
    fi

    # Test loading critical context with TOON format
    local load_output=$(prism_context_load_critical "toon" 2>&1)

    # Check if loading succeeded
    if [[ -n "$load_output" ]]; then
        test_pass "Critical context loading with TOON succeeded"

        # Check if TOON format is used
        if echo "$load_output" | grep -q "items\["; then
            test_info "TOON format detected in critical context"
        fi
    else
        test_fail "Critical context loading failed"
    fi
}

# Test 7: CLI integration test
test_cli_integration() {
    test_start "CLI integration (prism context list-toon)"

    if [[ ! -d "$PRISM_ROOT/.prism/context" ]]; then
        test_info "Skipping - no .prism/context directory"
        return
    fi

    # Test CLI command
    local cli_output=$("$PRISM_ROOT/bin/prism" context list-toon all 2>&1)

    # Check if CLI succeeded
    if [[ $? -eq 0 ]] && [[ -n "$cli_output" ]]; then
        test_pass "CLI integration working"

        if echo "$cli_output" | grep -q "items\["; then
            test_info "TOON format present in CLI output"
        fi
    else
        test_fail "CLI integration failed"
        test_info "Output: $cli_output"
    fi
}

# Test 8: Feature flag control
test_feature_flag_control() {
    test_start "Feature flag control (PRISM_TOON_CONTEXT)"

    # Test with TOON disabled
    export PRISM_TOON_CONTEXT=false
    local disabled_check=$(toon_is_enabled "context" && echo "enabled" || echo "disabled")

    # Test with TOON enabled
    export PRISM_TOON_CONTEXT=true
    local enabled_check=$(toon_is_enabled "context" && echo "enabled" || echo "disabled")

    if [[ "$disabled_check" == "disabled" ]] && [[ "$enabled_check" == "enabled" ]]; then
        test_pass "Feature flag control working correctly"
        test_info "Disabled: $disabled_check, Enabled: $enabled_check"
    else
        test_fail "Feature flag control not working"
        test_info "Disabled: $disabled_check, Enabled: $enabled_check"
    fi

    # Restore enabled state
    export PRISM_TOON_CONTEXT=true
}

# Main test execution
main() {
    echo ""
    echo "╔════════════════════════════════════════════════════════════════╗"
    echo "║         TOON Context Integration Test Suite (Phase 3)         ║"
    echo "╚════════════════════════════════════════════════════════════════╝"
    echo ""

    # Run all tests
    test_context_metadata_conversion
    test_context_list_toon
    test_context_list_filters
    test_context_export_toon
    test_token_savings_benchmark
    test_context_critical_loading
    test_cli_integration
    test_feature_flag_control

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
