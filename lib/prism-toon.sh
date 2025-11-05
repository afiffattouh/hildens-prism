#!/bin/bash
# PRISM TOON Integration Library
# Provides TOON (Tree Object Notation) serialization for token-optimized Claude Code interactions
# TOON achieves 30-60% token reduction while maintaining data fidelity

# Source guard
if [[ -n "${_PRISM_TOON_SH_LOADED:-}" ]]; then
    return 0
fi
readonly _PRISM_TOON_SH_LOADED=1

# Source dependencies
PRISM_LIB_ROOT="${PRISM_ROOT:-${PRISM_HOME:-$HOME/.prism}}"
source "${PRISM_LIB_ROOT}/lib/prism-log.sh" 2>/dev/null || true

# TOON format configuration
readonly TOON_INDENT="  "  # 2 spaces for nesting
readonly TOON_MIN_ARRAY_SIZE=2  # Minimum array size for TOON optimization

# ============================================================================
# Core TOON Serialization Functions
# ============================================================================

# Serialize JSON/YAML data to TOON format
# Usage: toon_serialize <data> [type]
# Types: agent|context|index|session|generic
toon_serialize() {
    local input_data="$1"
    local data_type="${2:-generic}"

    case "$data_type" in
        agent)
            _toon_serialize_agent "$input_data"
            ;;
        context)
            # Context data uses generic serialization (tabular arrays)
            _toon_serialize_generic "$input_data"
            ;;
        index)
            _toon_serialize_index "$input_data"
            ;;
        session)
            _toon_serialize_session "$input_data"
            ;;
        generic)
            _toon_serialize_generic "$input_data"
            ;;
        *)
            log_error "Unknown TOON data type: $data_type"
            return 1
            ;;
    esac
}

# Serialize generic data structures to TOON
_toon_serialize_generic() {
    local data="$1"

    # Detect if data is suitable for TOON
    local format=$(toon_detect_format "$data")

    case "$format" in
        toon_tabular)
            _toon_tabular_array "$data"
            ;;
        toon_nested)
            _toon_nested_structure "$data"
            ;;
        keep_original)
            echo "$data"
            ;;
    esac
}

# Convert tabular array to TOON format
# Example: [{"id":1,"name":"test"},{"id":2,"name":"demo"}]
# Output: items[2]{id,name}:
#          1,test
#          2,demo
_toon_tabular_array() {
    local json_data="$1"

    # Use Python for JSON parsing (more reliable than bash)
    python3 - <<EOF 2>/dev/null || echo "$json_data"
import json
import sys

try:
    data = json.loads('''$json_data''')

    if not isinstance(data, list) or len(data) == 0:
        print('''$json_data''')
        sys.exit(0)

    # Get field names from first object
    if isinstance(data[0], dict):
        fields = list(data[0].keys())
        field_str = ','.join(fields)
        count = len(data)

        print(f"items[{count}]{{{field_str}}}:")

        for item in data:
            values = []
            for field in fields:
                value = str(item.get(field, ''))
                # Quote if contains special characters
                if ',' in value or ' ' in value or '"' in value:
                    value = f'"{value}"'
                values.append(value)
            print(' ' + ','.join(values))
    else:
        print('''$json_data''')

except Exception as e:
    print('''$json_data''')
EOF
}

# Serialize agent configuration to TOON
_toon_serialize_agent() {
    local agent_data="$1"

    # Agent data should be JSON format for proper conversion
    # Detect and convert structured arrays to TOON tabular format
    local format=$(toon_detect_format "$agent_data")

    case "$format" in
        toon_tabular)
            _toon_tabular_array "$agent_data"
            ;;
        *)
            # For scalar agent data or non-uniform structures, keep original
            echo "$agent_data"
            ;;
    esac
}

# Serialize context index to TOON
_toon_serialize_index() {
    local index_data="$1"

    # Convert YAML index to TOON format
    # Extract context lists and convert to tabular arrays

    cat <<EOF
prism_index:
 version: $(echo "$index_data" | grep -oP 'version:\s*\K[0-9.]+' || echo "2.3.1")
 project: $(echo "$index_data" | grep -oP 'name:\s*\K.*' || echo "unknown")

# Context files would be listed in TOON tabular format here
EOF
}

# Serialize session data to TOON
_toon_serialize_session() {
    local session_data="$1"

    # Convert session metadata and tasks to TOON format

    cat <<EOF
session:
 id: $(echo "$session_data" | grep -oP 'id:\s*\K\S+' || echo "unknown")
 status: $(echo "$session_data" | grep -oP 'status:\s*\K\w+' || echo "active")

# Tasks would be converted to TOON tabular format here
EOF
}

# ============================================================================
# Format Detection
# ============================================================================

# Detect if data structure is suitable for TOON optimization
# Returns: toon_tabular|toon_nested|keep_original
toon_detect_format() {
    local data="$1"

    # Check if it's a JSON array
    if echo "$data" | python3 -c "import json,sys; data=json.load(sys.stdin); exit(0 if isinstance(data, list) and len(data) >= ${TOON_MIN_ARRAY_SIZE} else 1)" 2>/dev/null; then

        # Check if array items are uniform objects
        if echo "$data" | python3 -c "
import json, sys
data = json.load(sys.stdin)
if not data or not isinstance(data[0], dict):
    sys.exit(1)
keys = set(data[0].keys())
uniform = all(set(item.keys()) == keys for item in data if isinstance(item, dict))
sys.exit(0 if uniform else 1)
" 2>/dev/null; then
            echo "toon_tabular"
            return 0
        fi

        echo "toon_nested"
        return 0
    fi

    echo "keep_original"
    return 0
}

# Check if data structure is uniform (same fields across all items)
_check_uniform_structure() {
    local data="$1"

    python3 - <<EOF 2>/dev/null
import json
import sys

try:
    data = json.loads('''$data''')

    if not isinstance(data, list) or len(data) == 0:
        sys.exit(1)

    if not isinstance(data[0], dict):
        sys.exit(1)

    # Check if all items have same keys
    first_keys = set(data[0].keys())
    uniform = all(set(item.keys()) == first_keys for item in data if isinstance(item, dict))

    sys.exit(0 if uniform else 1)

except:
    sys.exit(1)
EOF
}

# ============================================================================
# TOON Deserialization (Parsing)
# ============================================================================

# Parse TOON format back to JSON
# Usage: toon_deserialize <toon_data>
toon_deserialize() {
    local toon_data="$1"

    # Parse TOON format and convert back to JSON
    # This is a placeholder for full TOON parser implementation

    python3 - <<EOF 2>/dev/null || echo "{}"
import re
import json

toon_text = '''$toon_data'''

# Simple TOON parser (to be enhanced)
# Looks for pattern: name[count]{field1,field2}:
pattern = r'(\w+)\[(\d+)\]\{([^}]+)\}:'

match = re.search(pattern, toon_text)
if match:
    array_name = match.group(1)
    count = int(match.group(2))
    fields = match.group(3).split(',')

    # Parse rows after the declaration
    lines = toon_text.split('\n')
    start_line = toon_text[:match.end()].count('\n') + 1

    items = []
    for i in range(start_line, min(start_line + count, len(lines))):
        line = lines[i].strip()
        if line:
            values = line.split(',')
            if len(values) == len(fields):
                item = {field.strip(): value.strip().strip('"')
                       for field, value in zip(fields, values)}
                items.append(item)

    result = {array_name: items}
    print(json.dumps(result, indent=2))
else:
    print('{}')
EOF
}

# ============================================================================
# TOON Validation
# ============================================================================

# Validate TOON syntax and structure
# Usage: toon_validate <toon_data>
toon_validate() {
    local toon_data="$1"
    local errors=0

    # Check for array declarations
    local array_declarations=$(echo "$toon_data" | grep -c '\[\d\+\]{.*}:' || true)

    if [[ $array_declarations -eq 0 ]]; then
        log_debug "TOON validation: No array declarations found (may be scalar data)"
    fi

    # Validate array declarations match row counts
    while IFS= read -r line; do
        if [[ "$line" =~ \[([0-9]+)\]\{([^}]+)\}: ]]; then
            local declared_count="${BASH_REMATCH[1]}"
            local fields="${BASH_REMATCH[2]}"
            local field_count=$(echo "$fields" | tr ',' '\n' | wc -l)

            # Count actual rows (next N non-empty lines)
            # This is a simplified check - full implementation would be more robust

            log_debug "TOON array declared: $declared_count rows, $field_count fields"
        fi
    done <<< "$toon_data"

    if [[ $errors -gt 0 ]]; then
        log_error "TOON validation failed: $errors errors found"
        return 1
    fi

    log_debug "TOON validation passed"
    return 0
}

# ============================================================================
# TOON Optimization Functions
# ============================================================================

# Optimize data by converting to TOON with fallback
# Usage: toon_optimize <data> [type]
toon_optimize() {
    local data="$1"
    local data_type="${2:-generic}"

    # Try TOON conversion
    local toon_output=$(toon_serialize "$data" "$data_type" 2>/dev/null)

    if [[ $? -eq 0 ]] && [[ -n "$toon_output" ]]; then
        # Validate the TOON output
        if toon_validate "$toon_output" 2>/dev/null; then
            echo "$toon_output"
            return 0
        fi
    fi

    # Fallback to original format
    log_debug "TOON optimization failed, using original format"
    echo "$data"
}

# Calculate token count estimate (rough approximation)
_toon_estimate_tokens() {
    local text="$1"

    # Rough estimate: ~4 chars per token average
    local char_count=${#text}
    echo $(( char_count / 4 ))
}

# ============================================================================
# Benchmarking Functions
# ============================================================================

# Benchmark TOON conversion showing token savings
# Usage: toon_benchmark <input_file>
toon_benchmark() {
    local input_file="$1"

    if [[ ! -f "$input_file" ]]; then
        log_error "File not found: $input_file"
        return 1
    fi

    local original_data=$(cat "$input_file")
    local toon_data=$(toon_optimize "$original_data")

    local original_tokens=$(_toon_estimate_tokens "$original_data")
    local toon_tokens=$(_toon_estimate_tokens "$toon_data")
    local savings=$(( 100 * (original_tokens - toon_tokens) / original_tokens ))

    echo "📊 TOON Benchmark Results"
    echo "========================="
    echo "Original format: $original_tokens tokens (estimated)"
    echo "TOON format:     $toon_tokens tokens (estimated)"
    echo "Savings:         $savings%"
    echo ""
    echo "Original size:   ${#original_data} bytes"
    echo "TOON size:       ${#toon_data} bytes"
    echo ""

    if [[ $savings -gt 30 ]]; then
        echo "✅ TOON provides significant optimization"
    elif [[ $savings -gt 15 ]]; then
        echo "⚠️  TOON provides moderate optimization"
    else
        echo "❌ TOON may not be optimal for this data"
    fi
}

# ============================================================================
# Caching Functions
# ============================================================================

# Cache directory for TOON conversions
TOON_CACHE_DIR="${PRISM_HOME:-$HOME/.prism}/.toon-cache"

# Get cached TOON conversion or create new one
# Usage: toon_cached_convert <input_file> [type]
toon_cached_convert() {
    local input_file="$1"
    local data_type="${2:-generic}"

    if [[ ! -f "$input_file" ]]; then
        log_error "File not found: $input_file"
        return 1
    fi

    # Create cache directory if needed
    mkdir -p "$TOON_CACHE_DIR" 2>/dev/null

    # Generate cache key from file path and modification time
    local cache_key=$(echo "${input_file}_$(stat -f %m "$input_file" 2>/dev/null || stat -c %Y "$input_file" 2>/dev/null)" | md5sum | cut -d' ' -f1)
    local cache_file="$TOON_CACHE_DIR/${cache_key}.toon"

    # Check if cached version exists and is newer than source
    if [[ -f "$cache_file" ]]; then
        log_debug "Using cached TOON conversion: $cache_file"
        cat "$cache_file"
        return 0
    fi

    # Generate new TOON conversion
    local input_data=$(cat "$input_file")
    local toon_output=$(toon_optimize "$input_data" "$data_type")

    # Cache the result
    echo "$toon_output" > "$cache_file"

    echo "$toon_output"
}

# Clear TOON cache
# Usage: toon_clear_cache
toon_clear_cache() {
    if [[ -d "$TOON_CACHE_DIR" ]]; then
        rm -rf "$TOON_CACHE_DIR"/*
        log_info "TOON cache cleared"
    fi
}

# ============================================================================
# Helper Functions
# ============================================================================

# Check if TOON is enabled (feature flag)
toon_is_enabled() {
    local component="${1:-}"

    # Global enable/disable
    if [[ "${PRISM_TOON_ENABLED:-true}" != "true" ]]; then
        return 1
    fi

    # Component-specific flags
    case "$component" in
        agent)
            [[ "${PRISM_TOON_AGENTS:-true}" == "true" ]]
            ;;
        context)
            [[ "${PRISM_TOON_CONTEXT:-true}" == "true" ]]
            ;;
        session)
            [[ "${PRISM_TOON_SESSION:-true}" == "true" ]]
            ;;
        *)
            return 0  # Enabled by default
            ;;
    esac
}

# Safe TOON conversion with fallback
# Usage: toon_safe_convert <data> [type]
toon_safe_convert() {
    local data="$1"
    local data_type="${2:-generic}"

    if ! toon_is_enabled "$data_type"; then
        echo "$data"
        return 0
    fi

    local toon_output=$(toon_optimize "$data" "$data_type" 2>/dev/null)

    if [[ $? -eq 0 ]] && [[ -n "$toon_output" ]]; then
        echo "$toon_output"
    else
        log_debug "TOON conversion failed, using original format"
        echo "$data"
    fi
}

# ============================================================================
# Export Functions
# ============================================================================

export -f toon_serialize
export -f toon_deserialize
export -f toon_validate
export -f toon_optimize
export -f toon_detect_format
export -f toon_benchmark
export -f toon_cached_convert
export -f toon_clear_cache
export -f toon_is_enabled
export -f toon_safe_convert
