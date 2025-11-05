#!/bin/bash
# PRISM TOON Agent Integration Tests
# Tests TOON optimization in agent orchestration workflow

# Test framework setup
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PRISM_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Source required libraries
source "$PRISM_ROOT/lib/prism-core.sh"
source "$PRISM_ROOT/lib/prism-log.sh"
source "$PRISM_ROOT/lib/prism-toon.sh"
source "$PRISM_ROOT/lib/prism-agents.sh"
source "$PRISM_ROOT/lib/prism-resource-management.sh"
source "$PRISM_ROOT/lib/prism-agent-executor.sh"

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

assert_file_exists() {
    local file_path="$1"
    local test_name="$2"

    TESTS_RUN=$((TESTS_RUN + 1))

    if [[ -f "$file_path" ]]; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        echo "✅ PASS: $test_name"
        return 0
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo "❌ FAIL: $test_name"
        echo "  File not found: $file_path"
        return 1
    fi
}

# ============================================================================
# Agent Configuration TOON Tests
# ============================================================================

test_agent_config_toon_conversion() {
    # Create a test agent
    local test_dir=$(mktemp -d)
    cd "$test_dir"

    init_agent_system "."

    local agent_id=$(create_agent "architect" "test_toon" "Design authentication system" 2>/dev/null | tail -n 1)

    assert_contains "$agent_id" "agent_test_toon" "Agent created successfully"

    # Verify config file exists
    local config_file=".prism/agents/active/$agent_id/config.yaml"
    assert_file_exists "$config_file" "Agent config file created"

    # Test TOON conversion of agent config
    local agent_config=$(cat "$config_file")

    # Convert to JSON first
    local agent_json=$(echo "$agent_config" | python3 -c "
import yaml, json, sys
try:
    data = yaml.safe_load(sys.stdin)
    print(json.dumps(data))
except:
    sys.exit(1)
" 2>/dev/null)

    if [[ $? -eq 0 ]]; then
        local toon_output=$(toon_optimize "$agent_json" "agent" 2>/dev/null)

        # Check if TOON conversion worked
        if [[ -n "$toon_output" ]]; then
            echo "✅ PASS: Agent config converts to TOON format"
            TESTS_RUN=$((TESTS_RUN + 1))
            TESTS_PASSED=$((TESTS_PASSED + 1))

            # Calculate token savings
            local original_tokens=$(_toon_estimate_tokens "$agent_json")
            local toon_tokens=$(_toon_estimate_tokens "$toon_output")
            local savings=0
            if [[ $original_tokens -gt 0 ]]; then
                savings=$(( 100 * (original_tokens - toon_tokens) / original_tokens ))
            fi

            echo "  Original: $original_tokens tokens"
            echo "  TOON:     $toon_tokens tokens"
            echo "  Savings:  $savings%"
        else
            echo "❌ FAIL: Agent config TOON conversion"
            TESTS_RUN=$((TESTS_RUN + 1))
            TESTS_FAILED=$((TESTS_FAILED + 1))
        fi
    else
        echo "⚠️  SKIP: Failed to parse YAML to JSON"
    fi

    # Cleanup
    cd - > /dev/null
    rm -rf "$test_dir"
}

test_agent_list_toon_format() {
    # Create test directory with multiple agents
    local test_dir=$(mktemp -d)
    cd "$test_dir"

    init_agent_system "." 2>/dev/null

    # Create 3 test agents
    create_agent "architect" "agent1" "Design system" 2>/dev/null >/dev/null
    create_agent "coder" "agent2" "Implement feature" 2>/dev/null >/dev/null
    create_agent "tester" "agent3" "Write tests" 2>/dev/null >/dev/null

    # Get agent list in TOON format (capture both stdout and stderr)
    local toon_list=$(list_active_agents "toon" 2>&1)

    # Check if TOON format is present
    if echo "$toon_list" | grep -q "items\["; then
        echo "✅ PASS: Agent list produces TOON format"
        TESTS_RUN=$((TESTS_RUN + 1))
        TESTS_PASSED=$((TESTS_PASSED + 1))

        echo "  TOON Output Preview:"
        echo "$toon_list" | grep "items\[" | head -5
    else
        echo "❌ FAIL: Agent list TOON format generation"
        TESTS_RUN=$((TESTS_RUN + 1))
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo "  Debug output:"
        echo "$toon_list" | head -10
    fi

    # Cleanup
    cd - > /dev/null
    rm -rf "$test_dir"
}

test_agent_executor_toon_integration() {
    # Test that agent executor generates TOON config
    local test_dir=$(mktemp -d)
    cd "$test_dir"

    init_agent_system "."

    # Enable TOON for agents
    export PRISM_TOON_ENABLED=true
    export PRISM_TOON_AGENTS=true

    # Create and execute agent
    local agent_id=$(create_agent "planner" "test_executor" "Plan project architecture" 2>/dev/null | tail -n 1)

    # Gather context (first phase)
    gather_agent_context "$agent_id" 2>/dev/null

    # Execute action (generates TOON config)
    execute_agent_action "$agent_id" 2>/dev/null

    # Check if TOON config was generated
    local toon_config_file=".prism/agents/active/$agent_id/config_toon.txt"

    if [[ -f "$toon_config_file" ]]; then
        echo "✅ PASS: Agent executor generates TOON config"
        TESTS_RUN=$((TESTS_RUN + 1))
        TESTS_PASSED=$((TESTS_PASSED + 1))

        echo "  TOON Config Preview:"
        head -5 "$toon_config_file"
    else
        echo "❌ FAIL: Agent executor TOON config generation"
        TESTS_RUN=$((TESTS_RUN + 1))
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi

    # Cleanup
    cd - > /dev/null
    rm -rf "$test_dir"
}

# ============================================================================
# Token Savings Benchmarks
# ============================================================================

test_multi_agent_benchmark() {
    echo ""
    echo "📊 Multi-Agent TOON Benchmark"
    echo "=============================="

    # Create benchmark data
    local agents_json='[
        {"id":"agent_arch_001","type":"architect","state":"active","task":"Design authentication system"},
        {"id":"agent_code_002","type":"coder","state":"working","task":"Implement JWT middleware"},
        {"id":"agent_test_003","type":"tester","state":"idle","task":"Write integration tests"},
        {"id":"agent_sec_004","type":"security","state":"active","task":"Security audit"},
        {"id":"agent_perf_005","type":"performance","state":"completed","task":"Optimize queries"}
    ]'

    # Original JSON
    local original_tokens=$(_toon_estimate_tokens "$agents_json")

    # TOON format
    local toon_output=$(toon_optimize "$agents_json" "agent" 2>/dev/null)
    local toon_tokens=$(_toon_estimate_tokens "$toon_output")

    # Calculate savings
    local savings=$(( 100 * (original_tokens - toon_tokens) / original_tokens ))

    echo "Original JSON: $original_tokens tokens"
    echo "TOON Format:   $toon_tokens tokens"
    echo "Savings:       $savings%"
    echo ""

    echo "Original Format:"
    echo "$agents_json" | python3 -m json.tool 2>/dev/null | head -10

    echo ""
    echo "TOON Format:"
    echo "$toon_output"

    if [[ $savings -ge 30 ]]; then
        echo "✅ PASS: Multi-agent TOON achieves >30% savings"
        TESTS_RUN=$((TESTS_RUN + 1))
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo "❌ FAIL: Multi-agent TOON savings below threshold"
        TESTS_RUN=$((TESTS_RUN + 1))
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
}

# ============================================================================
# Run All Tests
# ============================================================================

echo "🧪 PRISM TOON Agent Integration Tests"
echo "======================================"
echo ""

# Set up test environment
export PRISM_LOG_STDOUT=false

echo "📋 Agent Configuration Tests"
test_agent_config_toon_conversion
test_agent_list_toon_format
test_agent_executor_toon_integration
echo ""

echo "⚡ Performance Benchmarks"
test_multi_agent_benchmark
echo ""

# Summary
echo "======================================"
echo "📊 Test Results"
echo "======================================"
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
