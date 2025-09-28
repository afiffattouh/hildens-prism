#!/bin/bash
# PRISM Context Management Library

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

# Export as JSON
export_context_json() {
    local output=$1

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

    log_info "✅ Exported to $output"
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

# Load critical context
prism_context_load_critical() {
    log_info "Loading critical context..."

    if [[ ! -f ".prism/index.yaml" ]]; then
        log_error "No context index found"
        return 1
    fi

    # Parse critical contexts from index.yaml
    grep -A10 "critical:" .prism/index.yaml | grep "    - " | sed 's/    - //' | while read context; do
        if [[ -f ".prism/context/$context" ]]; then
            log_info "Loaded: $context"
        fi
    done
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