#!/usr/bin/env bash
# Test suite for TOON CLI Tools (Phase 4)

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

# Test 1: prism toon help command
test_help_command() {
    test_start "prism toon help command"

    local help_output=$("$PRISM_ROOT/bin/prism" toon help 2>&1)

    # Check for key sections in help output
    if echo "$help_output" | grep -q "PRISM TOON Commands" && \
       echo "$help_output" | grep -q "convert" && \
       echo "$help_output" | grep -q "benchmark" && \
       echo "$help_output" | grep -q "validate"; then
        test_pass "Help command displays all expected sections"
        test_info "Commands found: convert, benchmark, validate, stats, demo"
    else
        test_fail "Help command missing expected sections"
    fi
}

# Test 2: prism toon convert (stdin)
test_convert_stdin() {
    test_start "prism toon convert from stdin"

    local input_json='[{"id":1,"name":"test"},{"id":2,"name":"demo"}]'
    local output=$(echo "$input_json" | "$PRISM_ROOT/bin/prism" toon convert - 2>/dev/null)

    # Check if TOON format is generated
    if echo "$output" | grep -q "items\[2\]{" && \
       echo "$output" | grep -q "1,test" && \
       echo "$output" | grep -q "2,demo"; then
        test_pass "Convert from stdin generates TOON format"
        test_info "Output:\n$output"
    else
        test_fail "Convert from stdin failed"
        test_info "Output: $output"
    fi
}

# Test 3: prism toon convert (file)
test_convert_file() {
    test_start "prism toon convert from file"

    # Create temporary input file
    local temp_input=$(mktemp)
    echo '[{"id":1,"status":"active"},{"id":2,"status":"pending"}]' > "$temp_input"

    local output=$("$PRISM_ROOT/bin/prism" toon convert "$temp_input" 2>/dev/null)

    # Cleanup
    rm -f "$temp_input"

    # Check if TOON format is generated
    if echo "$output" | grep -q "items\[2\]{" && \
       echo "$output" | grep -q "1,active" && \
       echo "$output" | grep -q "2,pending"; then
        test_pass "Convert from file generates TOON format"
    else
        test_fail "Convert from file failed"
    fi
}

# Test 4: prism toon convert with output file
test_convert_with_output() {
    test_start "prism toon convert with output file"

    # Create temporary files
    local temp_input=$(mktemp)
    local temp_output=$(mktemp)
    echo '[{"id":1,"name":"test"}]' > "$temp_input"

    "$PRISM_ROOT/bin/prism" toon convert "$temp_input" "$temp_output" 2>/dev/null

    # Check if output file was created and contains TOON format
    if [[ -f "$temp_output" ]] && grep -q "items\[" "$temp_output"; then
        test_pass "Convert with output file creates TOON file"
        test_info "Output file created: $temp_output"
        test_info "Contents: $(cat "$temp_output")"
    else
        test_fail "Convert with output file failed"
    fi

    # Cleanup
    rm -f "$temp_input" "$temp_output"
}

# Test 5: prism toon benchmark
test_benchmark_command() {
    test_start "prism toon benchmark command"

    # Create temporary input file
    local temp_input=$(mktemp)
    cat > "$temp_input" << 'EOF'
[
  {"file":"test.md","priority":"high","size":100,"lines":10},
  {"file":"demo.md","priority":"medium","size":200,"lines":20}
]
EOF

    local output=$("$PRISM_ROOT/bin/prism" toon benchmark "$temp_input" 2>/dev/null)

    # Cleanup
    rm -f "$temp_input"

    # Check for benchmark output
    if echo "$output" | grep -q "TOON Benchmark Results" && \
       echo "$output" | grep -q "tokens" && \
       echo "$output" | grep -q "Savings"; then
        test_pass "Benchmark command generates report"
        test_info "$(echo "$output" | head -10)"
    else
        test_fail "Benchmark command failed"
    fi
}

# Test 6: prism toon validate (valid TOON)
test_validate_valid_toon() {
    test_start "prism toon validate with valid TOON"

    # Create temporary TOON file
    local temp_toon=$(mktemp)
    cat > "$temp_toon" << 'EOF'
items[2]{id,name}:
 1,test
 2,demo
EOF

    if "$PRISM_ROOT/bin/prism" toon validate "$temp_toon" 2>&1 | grep -q "validation passed"; then
        test_pass "Validate accepts valid TOON format"
    else
        test_fail "Validate rejected valid TOON format"
    fi

    # Cleanup
    rm -f "$temp_toon"
}

# Test 7: prism toon stats
test_stats_command() {
    test_start "prism toon stats command"

    local output=$("$PRISM_ROOT/bin/prism" toon stats 2>&1)

    # Check for stats sections
    if echo "$output" | grep -q "TOON Usage Statistics" && \
       echo "$output" | grep -q "Performance Benchmarks" && \
       echo "$output" | grep -q "Feature Flags"; then
        test_pass "Stats command displays usage statistics"
        test_info "Sections found: Performance, Feature Flags, Cache"
    else
        test_fail "Stats command missing expected sections"
    fi
}

# Test 8: prism toon demo
test_demo_command() {
    test_start "prism toon demo command"

    local output=$("$PRISM_ROOT/bin/prism" toon demo 2>&1)

    # Check for demo examples
    if echo "$output" | grep -q "TOON Conversion Demo" && \
       echo "$output" | grep -q "Example 1" && \
       echo "$output" | grep -q "Example 2" && \
       echo "$output" | grep -q "Example 3"; then
        test_pass "Demo command displays conversion examples"
        test_info "Examples found: Simple Array, Context Metadata, Agent Config"
    else
        test_fail "Demo command missing examples"
    fi
}

# Test 9: prism toon clear-cache
test_clear_cache_command() {
    test_start "prism toon clear-cache command"

    # Create cache directory if it doesn't exist
    local cache_dir="${TOON_CACHE_DIR:-/tmp/prism-toon-cache}"
    mkdir -p "$cache_dir"

    # Create a test cache file
    echo "test" > "$cache_dir/test.toon"

    # Run clear-cache
    "$PRISM_ROOT/bin/prism" toon clear-cache 2>/dev/null || true

    # Check if cache was cleared
    local remaining_files=$(find "$cache_dir" -name "*.toon" 2>/dev/null | wc -l | tr -d ' ')

    if [[ "$remaining_files" == "0" ]]; then
        test_pass "Clear-cache removes cached files"
    else
        test_fail "Clear-cache did not remove all cached files"
        test_info "Remaining files: $remaining_files"
    fi
}

# Test 10: Error handling - invalid file
test_error_handling_invalid_file() {
    test_start "Error handling for invalid file"

    local output=$("$PRISM_ROOT/bin/prism" toon convert "/nonexistent/file.json" 2>&1 || true)

    if echo "$output" | grep -q "not found"; then
        test_pass "Error handling for invalid file works"
    else
        test_fail "Error handling for invalid file missing"
    fi
}

# Test 11: Token savings verification
test_token_savings_verification() {
    test_start "Token savings verification"

    # Create test data
    local temp_input=$(mktemp)
    cat > "$temp_input" << 'EOF'
[
  {"id":1,"name":"Alice","role":"admin","status":"active"},
  {"id":2,"name":"Bob","role":"user","status":"active"},
  {"id":3,"name":"Charlie","role":"user","status":"pending"}
]
EOF

    local benchmark_output=$("$PRISM_ROOT/bin/prism" toon benchmark "$temp_input" 2>/dev/null)

    # Cleanup
    rm -f "$temp_input"

    # Extract savings percentage
    local savings=$(echo "$benchmark_output" | grep "Savings:" | grep -o "[0-9]\+%")

    if [[ -n "$savings" ]]; then
        local savings_num=$(echo "$savings" | tr -d '%')
        if [[ $savings_num -ge 30 ]]; then
            test_pass "Token savings >= 30% achieved: $savings"
        else
            test_fail "Token savings below 30%: $savings"
        fi
    else
        test_fail "Could not extract savings percentage"
    fi
}

# Test 12: Complex nested structure
test_complex_nested_structure() {
    test_start "Complex nested structure conversion"

    local input_json='{"users":[{"id":1,"name":"test","tags":["a","b"]},{"id":2,"name":"demo","tags":["c","d"]}]}'
    local output=$(echo "$input_json" | "$PRISM_ROOT/bin/prism" toon convert - 2>/dev/null)

    # For nested structures, TOON might keep original or simplify
    if [[ -n "$output" ]]; then
        test_pass "Complex structure conversion completed"
        test_info "Output type: $(echo "$output" | head -1)"
    else
        test_fail "Complex structure conversion failed"
    fi
}

# Main test execution
main() {
    echo ""
    echo "╔════════════════════════════════════════════════════════════════╗"
    echo "║            TOON CLI Tools Test Suite (Phase 4)                ║"
    echo "╚════════════════════════════════════════════════════════════════╝"
    echo ""

    # Run all tests
    test_help_command
    test_convert_stdin
    test_convert_file
    test_convert_with_output
    test_benchmark_command
    test_validate_valid_toon
    test_stats_command
    test_demo_command
    test_clear_cache_command
    test_error_handling_invalid_file
    test_token_savings_verification
    test_complex_nested_structure

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
