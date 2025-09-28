#!/bin/bash
# PRISM Session Management Library

# Start new session
prism_session_start() {
    local description=${1:-"Development session"}

    log_info "Starting new session: $description"

    # Check if PRISM is initialized
    if [[ ! -d ".prism" ]]; then
        log_error "PRISM not initialized. Run 'prism init' first."
        return 1
    fi

    # Archive current session if exists
    if [[ -f ".prism/sessions/current.md" ]]; then
        prism_session_archive
    fi

    # Generate session ID
    local session_id="$(date +%Y%m%d-%H%M%S)"

    # Create new session file
    cat > .prism/sessions/current.md << EOF
# Current Session
**Session ID**: $session_id
**Started**: $(date -u +%Y-%m-%dT%H:%M:%SZ)
**Status**: ACTIVE
**Description**: $description

## Context Loaded
$(load_priority_contexts)

## Current Task
- Description: $description
- Type: Development
- Priority: MEDIUM

## Operations Log
1. $(date -u +%H:%M:%S) - Session started

## Metrics
- Operations: 1
- Errors: 0
- Warnings: 0
- Duration: 0m

## Notes
- Session started with: prism session start "$description"
EOF

    # Update time sync
    echo "Session $session_id started: $(date -u +%Y-%m-%dT%H:%M:%SZ)" >> .prism/sessions/.time_sync

    log_info "✅ Session $session_id started"
    log_info "Context loaded from .prism/index.yaml"
}

# Check session status
prism_session_status() {
    log_info "Checking session status..."

    if [[ ! -f ".prism/sessions/current.md" ]]; then
        log_info "No active session"
        return 1
    fi

    # Extract session info
    local session_id=$(grep "Session ID:" .prism/sessions/current.md | cut -d: -f2- | tr -d ' ')
    local started=$(grep "Started:" .prism/sessions/current.md | cut -d: -f2-)
    local status=$(grep "Status:" .prism/sessions/current.md | head -1 | cut -d: -f2- | tr -d ' ')

    echo "Session ID: $session_id"
    echo "Started: $started"
    echo "Status: $status"

    # Calculate duration
    local start_time=$(date -j -f "%Y-%m-%dT%H:%M:%SZ" "$started" +%s 2>/dev/null || date -d "$started" +%s 2>/dev/null)
    local now=$(date +%s)
    local duration=$((now - start_time))
    local hours=$((duration / 3600))
    local minutes=$(((duration % 3600) / 60))

    echo "Duration: ${hours}h ${minutes}m"

    # Show metrics
    echo ""
    echo "Metrics:"
    grep -A3 "## Metrics" .prism/sessions/current.md | tail -3
}

# Archive current session
prism_session_archive() {
    log_info "Archiving current session..."

    if [[ ! -f ".prism/sessions/current.md" ]]; then
        log_warn "No active session to archive"
        return 1
    fi

    # Get session ID
    local session_id=$(grep "Session ID:" .prism/sessions/current.md | cut -d: -f2- | tr -d ' ')

    # Update session end time and status
    local temp_file=$(mktemp)
    sed "s/Status: ACTIVE/Status: ARCHIVED/" .prism/sessions/current.md > "$temp_file"
    echo "" >> "$temp_file"
    echo "**Ended**: $(date -u +%Y-%m-%dT%H:%M:%SZ)" >> "$temp_file"

    # Generate summary
    echo "" >> "$temp_file"
    echo "## Summary" >> "$temp_file"
    echo "- Total operations: $(grep -c "^[0-9]" .prism/sessions/current.md || echo 0)" >> "$temp_file"
    echo "- Session archived: $(date -u +%Y-%m-%dT%H:%M:%SZ)" >> "$temp_file"

    # Archive file
    mv "$temp_file" ".prism/sessions/archive/${session_id}.md"

    # Clear current session
    rm -f .prism/sessions/current.md

    log_info "✅ Session $session_id archived"
}

# Restore previous session
prism_session_restore() {
    local session_id=$1

    if [[ -z "$session_id" ]]; then
        log_error "Session ID required"
        echo "Available sessions:"
        ls -1 .prism/sessions/archive/*.md 2>/dev/null | xargs -n1 basename | sed 's/.md$//'
        return 1
    fi

    local archive_file=".prism/sessions/archive/${session_id}.md"

    if [[ ! -f "$archive_file" ]]; then
        log_error "Session $session_id not found"
        return 1
    fi

    log_info "Restoring session $session_id..."

    # Archive current if exists
    if [[ -f ".prism/sessions/current.md" ]]; then
        prism_session_archive
    fi

    # Restore session
    cp "$archive_file" .prism/sessions/current.md

    # Update status to RESTORED
    sed -i '' 's/Status: ARCHIVED/Status: RESTORED/' .prism/sessions/current.md

    # Add restoration note
    echo "" >> .prism/sessions/current.md
    echo "**Restored**: $(date -u +%Y-%m-%dT%H:%M:%SZ)" >> .prism/sessions/current.md

    log_info "✅ Session $session_id restored"
}

# Export session report
prism_session_export() {
    local format=${1:-markdown}
    local session_id=${2:-current}

    log_info "Exporting session report..."

    local source_file
    if [[ "$session_id" == "current" ]]; then
        source_file=".prism/sessions/current.md"
    else
        source_file=".prism/sessions/archive/${session_id}.md"
    fi

    if [[ ! -f "$source_file" ]]; then
        log_error "Session not found"
        return 1
    fi

    local output="prism-session-${session_id}.${format}"

    case "$format" in
        markdown|md)
            cp "$source_file" "$output"
            ;;
        html)
            if command -v pandoc &> /dev/null; then
                pandoc "$source_file" -o "$output"
            else
                log_error "pandoc required for HTML export"
                return 1
            fi
            ;;
        txt)
            sed 's/^#*//g; s/\*\*//g' "$source_file" > "$output"
            ;;
        *)
            log_error "Unknown format: $format"
            return 1
            ;;
    esac

    log_info "✅ Session exported to $output"
}

# Clean old sessions
prism_session_clean() {
    local days=${1:-30}

    log_info "Cleaning sessions older than $days days..."

    if [[ ! -d ".prism/sessions/archive" ]]; then
        log_info "No archived sessions to clean"
        return 0
    fi

    # Find and remove old sessions
    local count=0
    find .prism/sessions/archive -name "*.md" -mtime +$days -type f | while read file; do
        rm -f "$file"
        ((count++))
    done

    log_info "✅ Cleaned $count old sessions"
}

# Refresh session (for context corruption)
prism_session_refresh() {
    log_info "Refreshing session context..."

    if [[ ! -f ".prism/sessions/current.md" ]]; then
        log_error "No active session"
        return 1
    fi

    # Reload context from index
    local temp_file=$(mktemp)

    # Preserve session header
    sed -n '1,/## Context Loaded/p' .prism/sessions/current.md > "$temp_file"

    # Reload contexts
    load_priority_contexts >> "$temp_file"

    # Preserve rest of session
    sed -n '/## Current Task/,$p' .prism/sessions/current.md >> "$temp_file"

    # Update session
    mv "$temp_file" .prism/sessions/current.md

    # Add refresh note
    echo "$(date -u +%H:%M:%S) - Session context refreshed" >> .prism/sessions/current.md

    log_info "✅ Session context refreshed"
}

# Load priority contexts (helper function)
load_priority_contexts() {
    if [[ ! -f ".prism/index.yaml" ]]; then
        echo "- No context index found"
        return
    fi

    # Load critical contexts
    grep -A10 "critical:" .prism/index.yaml | grep "    - " | sed 's/    - /- /' | sed 's/$/ (CRITICAL)/'

    # Load high priority contexts
    grep -A10 "high:" .prism/index.yaml | grep "    - " | sed 's/    - /- /' | sed 's/$/ (HIGH)/'
}

# Add operation to session log
prism_session_log() {
    local operation=$1

    if [[ ! -f ".prism/sessions/current.md" ]]; then
        return
    fi

    # Add to operations log
    local op_num=$(grep -c "^[0-9]\+\." .prism/sessions/current.md || echo 0)
    ((op_num++))

    # Find operations log section and append
    sed -i '' "/## Operations Log/a\\
$op_num. $(date -u +%H:%M:%S) - $operation" .prism/sessions/current.md
}