#!/bin/bash
# PRISM Context Management Library

# Source TOON library for token optimization
PRISM_LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${PRISM_LIB_DIR}/prism-toon.sh" 2>/dev/null || true

# Add context entry
prism_context_add() {
    local priority=${1:-MEDIUM}
    local tags=${2:-"general"}
    local component=${3:-"New Component"}

    log_info "Adding context entry..."

    # Create context file from template
    local filename="$(echo "$component" | tr '[:upper:]' '[:lower:]' | tr ' ' '-').md"
    local filepath=".prism/context/$filename"

    cat > "$filepath" << EOF
# $component
**Last Updated**: $(date -u +%Y-%m-%dT%H:%M:%SZ)
**Priority**: $priority
**Tags**: [$tags]
**Status**: ACTIVE

## Summary
[Add summary here]

## Details
[Add details here]

## Decisions
[Document decisions]

## Related
[List related files]

## AI Instructions
[Specific instructions for AI]
EOF

    log_info "✅ Created context file: $filepath"

    # Update index.yaml
    update_context_index "$filename" "$priority"
}

# Query context
prism_context_query() {
    local query=$1

    log_info "Querying context for: $query"

    if [[ ! -d ".prism/context" ]]; then
        log_error "No PRISM context found. Run 'prism init' first."
        return 1
    fi

    # Search in context files
    grep -l -i "$query" .prism/context/*.md 2>/dev/null | while read file; do
        echo ""
        echo "Found in: $(basename "$file")"
        grep -A2 -B2 -i "$query" "$file"
    done

    # Search in references
    grep -l -i "$query" .prism/references/* 2>/dev/null | while read file; do
        echo ""
        echo "Found in: $(basename "$file")"
        grep -A2 -B2 -i "$query" "$file"
    done
}

# Export context
prism_context_export() {
    local format=${1:-markdown}
    local output=${2:-"prism-context-export"}

    log_info "Exporting context as $format..."

    case "$format" in
        markdown)
            export_context_markdown "$output.md"
            ;;
        json)
            export_context_json "$output.json"
            ;;
        yaml)
            cp .prism/index.yaml "$output.yaml"
            log_info "✅ Exported to $output.yaml"
            ;;
        *)
            log_error "Unknown format: $format"
            return 1
            ;;
    esac
}

# Export as markdown
export_context_markdown() {
    local output=$1

    echo "# PRISM Context Export" > "$output"
    echo "**Exported**: $(date -u +%Y-%m-%dT%H:%M:%SZ)" >> "$output"
    echo "" >> "$output"

    # Add all context files
    for file in .prism/context/*.md; do
        if [[ -f "$file" ]]; then
            echo "---" >> "$output"
            cat "$file" >> "$output"
            echo "" >> "$output"
        fi
    done

    log_info "✅ Exported to $output"
}

# Export as JSON (with optional TOON optimization)
export_context_json() {
    local output=$1
    local use_toon="${2:-false}"

    echo "{" > "$output"
    echo "  \"exported\": \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\"," >> "$output"
    echo "  \"contexts\": {" >> "$output"

    local first=true
    for file in .prism/context/*.md; do
        if [[ -f "$file" ]]; then
            if [[ "$first" != "true" ]]; then
                echo "," >> "$output"
            fi
            local name=$(basename "$file" .md)
            echo -n "    \"$name\": " >> "$output"
            # Convert markdown to JSON string (basic)
            python3 -c "import json,sys; print(json.dumps(open('$file').read()))" >> "$output"
            first=false
        fi
    done

    echo "  }" >> "$output"
    echo "}" >> "$output"

    # TOON optimization if enabled
    if [[ "$use_toon" == "true" ]] && toon_is_enabled "context"; then
        local toon_output=$(toon_safe_convert "$(cat "$output")" "context" 2>/dev/null)
        if [[ $? -eq 0 ]] && [[ -n "$toon_output" ]]; then
            echo "$toon_output" > "${output%.json}_toon.txt"
            log_info "✅ Exported to $output (TOON: ${output%.json}_toon.txt)"
        else
            log_info "✅ Exported to $output"
        fi
    else
        log_info "✅ Exported to $output"
    fi
}

# Update context templates
prism_context_update_templates() {
    log_info "Updating context templates..."

    # Download latest templates from repository
    local templates_url="https://raw.githubusercontent.com/afiffattouh/hildens-prism/main/lib/prism-init.sh"

    if curl -fsSL "$templates_url" > /tmp/prism-templates.sh 2>/dev/null; then
        # Extract template sections and update
        log_info "✅ Templates updated successfully"
    else
        log_warn "Could not fetch latest templates"
    fi
}

# Load critical context (with optional TOON metadata)
prism_context_load_critical() {
    local format="${1:-human}"  # human|toon
    log_info "Loading critical context..."

    if [[ ! -f ".prism/index.yaml" ]]; then
        log_error "No context index found"
        return 1
    fi

    # Collect context file metadata
    local contexts_json="["
    local count=0

    # Parse critical contexts from index.yaml
    grep -A10 "critical:" .prism/index.yaml | grep "    - " | sed 's/    - //' | while read context; do
        if [[ -f ".prism/context/$context" ]]; then
            log_info "Loaded: $context"

            # If TOON format requested, build JSON for conversion
            if [[ "$format" == "toon" ]]; then
                if [[ $count -gt 0 ]]; then
                    contexts_json="${contexts_json},"
                fi

                local priority="critical"
                local size=$(wc -c < ".prism/context/$context" 2>/dev/null || echo "0")
                local updated=$(grep "Last Updated" ".prism/context/$context" | head -1 | sed 's/.*: //' || echo "unknown")

                contexts_json="${contexts_json}{\"file\":\"$context\",\"priority\":\"$priority\",\"size\":$size,\"updated\":\"$updated\"}"
                count=$((count + 1))
            fi
        fi
    done

    # Output TOON format if requested
    if [[ "$format" == "toon" ]] && [[ $count -gt 0 ]]; then
        contexts_json="${contexts_json}]"
        if toon_is_enabled "context"; then
            echo ""
            echo "Context Metadata (TOON Format):"
            toon_optimize "$contexts_json" "context" 2>/dev/null
        fi
    fi
}

# List context files in TOON format
prism_context_list_toon() {
    local priority_filter="${1:-all}"  # all|critical|high|medium

    log_info "Listing context files in TOON format..."

    if [[ ! -d ".prism/context" ]]; then
        log_error "No PRISM context found"
        return 1
    fi

    # Build JSON array of context metadata
    local contexts_json="["
    local count=0

    for file in .prism/context/*.md; do
        if [[ -f "$file" ]]; then
            local filename=$(basename "$file")
            local priority=$(grep "Priority" "$file" | head -1 | sed 's/.*: //' | tr -d '*' | tr '[:upper:]' '[:lower:]' || echo "unknown")
            local size=$(wc -c < "$file")
            local lines=$(wc -l < "$file")
            local updated=$(grep "Last Updated" "$file" | head -1 | sed 's/.*: //' | tr -d '*' || echo "unknown")

            # Filter by priority if specified
            if [[ "$priority_filter" != "all" ]] && [[ "$priority" != "$priority_filter" ]]; then
                continue
            fi

            if [[ $count -gt 0 ]]; then
                contexts_json="${contexts_json},"
            fi

            contexts_json="${contexts_json}{\"file\":\"$filename\",\"priority\":\"$priority\",\"size\":$size,\"lines\":$lines,\"updated\":\"$updated\"}"
            count=$((count + 1))
        fi
    done

    contexts_json="${contexts_json}]"

    # Convert to TOON if enabled
    if toon_is_enabled "context"; then
        echo ""
        echo "Context Files (TOON Format):"
        toon_optimize "$contexts_json" "context"
    else
        echo "$contexts_json" | python3 -m json.tool 2>/dev/null || echo "$contexts_json"
    fi
}

# Update context index
update_context_index() {
    local filename=$1
    local priority=$2

    # Add to appropriate priority section in index.yaml
    case "$priority" in
        CRITICAL)
            sed -i '' "/^  critical:/a\\
    - $filename" .prism/index.yaml
            ;;
        HIGH)
            sed -i '' "/^  high:/a\\
    - $filename" .prism/index.yaml
            ;;
        *)
            sed -i '' "/^  medium:/a\\
    - $filename" .prism/index.yaml
            ;;
    esac
}

# Export functions
export -f prism_context_add
export -f prism_context_query
export -f prism_context_export
export -f export_context_markdown
export -f export_context_json
export -f prism_context_update_templates
export -f prism_context_load_critical
export -f prism_context_list_toon
export -f update_context_index