#!/bin/bash
# PRISM TOON Library - Basic Unit Tests
# Tests core TOON serialization, deserialization, and validation

# Test framework setup
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PRISM_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Source the TOON library
source "$PRISM_ROOT/lib/prism-core.sh"
source "$PRISM_ROOT/lib/prism-log.sh"
source "$PRISM_ROOT/lib/prism-toon.sh"

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Test assertion functions
assert_equals() {
    local expected="$1"
    local actual="$2"
    local test_name="$3"

    TESTS_RUN=$((TESTS_RUN + 1))

    if [[ "$expected" == "$actual" ]]; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        echo "✅ PASS: $test_name"
        return 0
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo "❌ FAIL: $test_name"
        echo "  Expected: $expected"
        echo "  Actual:   $actual"
        return 1
    fi
}

assert_contains() {
    local haystack="$1"
    local needle="$2"
    local test_name="$3"

    TESTS_RUN=$((TESTS_RUN + 1))

    if echo "$haystack" | grep -q "$needle"; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        echo "✅ PASS: $test_name"
        return 0
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo "❌ FAIL: $test_name"
        echo "  Haystack: $haystack"
        echo "  Needle:   $needle"
        return 1
    fi
}

assert_success() {
    local command="$1"
    local test_name="$2"

    TESTS_RUN=$((TESTS_RUN + 1))

    if eval "$command" &>/dev/null; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        echo "✅ PASS: $test_name"
        return 0
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo "❌ FAIL: $test_name"
        echo "  Command failed: $command"
        return 1
    fi
}

# ============================================================================
# Format Detection Tests
# ============================================================================

test_detect_tabular_format() {
    local json='[{"id":1,"name":"test"},{"id":2,"name":"demo"}]'
    local format=$(toon_detect_format "$json")

    assert_equals "toon_tabular" "$format" "Detect tabular array format"
}

test_detect_non_array() {
    local json='{"id":1,"name":"test"}'
    local format=$(toon_detect_format "$json")

    assert_equals "keep_original" "$format" "Detect non-array format"
}

test_detect_small_array() {
    local json='[{"id":1}]'
    local format=$(toon_detect_format "$json")

    # Arrays smaller than TOON_MIN_ARRAY_SIZE should be kept original
    assert_equals "keep_original" "$format" "Detect small array (below threshold)"
}

# ============================================================================
# Tabular Array Serialization Tests
# ============================================================================

test_serialize_basic_array() {
    local json='[{"id":1,"name":"Alice"},{"id":2,"name":"Bob"}]'
    local toon=$(_toon_tabular_array "$json")

    # Check for TOON structure
    assert_contains "$toon" "items\[2\]{id,name}:" "Basic array serialization - header"
    assert_contains "$toon" "1,Alice" "Basic array serialization - first row"
    assert_contains "$toon" "2,Bob" "Basic array serialization - second row"
}

test_serialize_with_special_chars() {
    local json='[{"id":1,"name":"Test, User"}]'
    local toon=$(_toon_tabular_array "$json")

    # Values with commas should be quoted
    assert_contains "$toon" '"Test, User"' "Serialize with special characters (quoted)"
}

test_serialize_empty_array() {
    local json='[]'
    local toon=$(_toon_tabular_array "$json")

    # Empty arrays should return original
    assert_equals "$json" "$toon" "Serialize empty array"
}

# ============================================================================
# Deserialization Tests
# ============================================================================

test_deserialize_basic_toon() {
    local toon='items[2]{id,name}:
 1,Alice
 2,Bob'

    local json=$(toon_deserialize "$toon")

    # Check if JSON is valid and contains expected data
    assert_contains "$json" "Alice" "Deserialize basic TOON - contains Alice"
    assert_contains "$json" "Bob" "Deserialize basic TOON - contains Bob"
}

# ============================================================================
# Validation Tests
# ============================================================================

test_validate_valid_toon() {
    local toon='items[2]{id,name}:
 1,Alice
 2,Bob'

    assert_success "toon_validate '$toon'" "Validate valid TOON format"
}

test_validate_scalar_data() {
    local toon='version: 2.3.1
project: test'

    # Scalar data (no arrays) should pass validation
    assert_success "toon_validate '$toon'" "Validate scalar TOON data"
}

# ============================================================================
# Optimization Tests
# ============================================================================

test_optimize_suitable_data() {
    local json='[{"id":1,"name":"test"},{"id":2,"name":"demo"}]'
    local optimized=$(toon_optimize "$json" "generic")

    # Should be converted to TOON
    assert_contains "$optimized" "items\[" "Optimize suitable data"
}

test_optimize_unsuitable_data() {
    local json='{"single":"object"}'
    local optimized=$(toon_optimize "$json" "generic")

    # Should keep original format
    assert_equals "$json" "$optimized" "Keep original format for unsuitable data"
}

# ============================================================================
# Feature Flag Tests
# ============================================================================

test_toon_enabled_default() {
    # TOON should be enabled by default
    assert_success "toon_is_enabled" "TOON enabled by default"
}

test_toon_disabled_globally() {
    PRISM_TOON_ENABLED=false

    if toon_is_enabled; then
        TESTS_RUN=$((TESTS_RUN + 1))
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo "❌ FAIL: TOON global disable"
    else
        TESTS_RUN=$((TESTS_RUN + 1))
        TESTS_PASSED=$((TESTS_PASSED + 1))
        echo "✅ PASS: TOON global disable"
    fi

    # Reset
    PRISM_TOON_ENABLED=true
}

test_toon_component_flags() {
    # Test component-specific flags
    PRISM_TOON_AGENTS=false

    if toon_is_enabled "agent"; then
        TESTS_RUN=$((TESTS_RUN + 1))
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo "❌ FAIL: TOON agent disable"
    else
        TESTS_RUN=$((TESTS_RUN + 1))
        TESTS_PASSED=$((TESTS_PASSED + 1))
        echo "✅ PASS: TOON agent disable"
    fi

    # Reset
    PRISM_TOON_AGENTS=true
}

# ============================================================================
# Safe Conversion Tests
# ============================================================================

test_safe_convert_success() {
    local json='[{"id":1,"name":"test"}]'
    local result=$(toon_safe_convert "$json" "generic")

    # Should succeed without errors
    TESTS_RUN=$((TESTS_RUN + 1))
    if [[ -n "$result" ]]; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        echo "✅ PASS: Safe convert with valid data"
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo "❌ FAIL: Safe convert with valid data"
    fi
}

test_safe_convert_with_disabled_flag() {
    PRISM_TOON_ENABLED=false

    local json='[{"id":1,"name":"test"}]'
    local result=$(toon_safe_convert "$json" "generic")

    # Should return original when disabled
    assert_equals "$json" "$result" "Safe convert respects disabled flag"

    # Reset
    PRISM_TOON_ENABLED=true
}

# ============================================================================
# Run All Tests
# ============================================================================

echo "🧪 PRISM TOON Library - Basic Unit Tests"
echo "=========================================="
echo ""

# Format Detection Tests
echo "📋 Format Detection Tests"
test_detect_tabular_format
test_detect_non_array
test_detect_small_array
echo ""

# Serialization Tests
echo "📝 Serialization Tests"
test_serialize_basic_array
test_serialize_with_special_chars
test_serialize_empty_array
echo ""

# Deserialization Tests
echo "🔄 Deserialization Tests"
test_deserialize_basic_toon
echo ""

# Validation Tests
echo "✔️  Validation Tests"
test_validate_valid_toon
test_validate_scalar_data
echo ""

# Optimization Tests
echo "⚡ Optimization Tests"
test_optimize_suitable_data
test_optimize_unsuitable_data
echo ""

# Feature Flag Tests
echo "🚩 Feature Flag Tests"
test_toon_enabled_default
test_toon_disabled_globally
test_toon_component_flags
echo ""

# Safe Conversion Tests
echo "🛡️  Safe Conversion Tests"
test_safe_convert_success
test_safe_convert_with_disabled_flag
echo ""

# Summary
echo "=========================================="
echo "📊 Test Results"
echo "=========================================="
echo "Total tests:  $TESTS_RUN"
echo "Passed:       $TESTS_PASSED"
echo "Failed:       $TESTS_FAILED"
echo ""

if [[ $TESTS_FAILED -eq 0 ]]; then
    echo "✅ All tests passed!"
    exit 0
else
    echo "❌ Some tests failed"
    exit 1
fi
