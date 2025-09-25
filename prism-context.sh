#!/bin/bash

# PRISM Context Management System
# Utility script for managing PRISM's persistent context

PRISM_DIR=".prism"
CLAUDE_DIR=".prism" # Compatibility alias
CONTEXT_DIR="$CLAUDE_DIR/context"
SESSIONS_DIR="$CLAUDE_DIR/sessions"
REFERENCES_DIR="$CLAUDE_DIR/references"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get accurate time from web
sync_time() {
    echo -e "${BLUE}Synchronizing system time...${NC}"

    # Get system time
    local system_time=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    echo "System UTC time: $system_time"

    # Note: In actual use, Claude would use WebSearch tool here
    # For shell script, we'll mark where web sync would occur
    echo -e "${YELLOW}Note: PRISM should WebSearch 'current UTC time' for accuracy${NC}"

    # Create time sync log
    local sync_file="$CLAUDE_DIR/.time_sync"
    cat > "$sync_file" << EOF
# Time Synchronization Log
Last Sync: $(date -Iseconds)
System Time: $system_time
Web Time: [Claude to fetch via WebSearch]
Timezone: $(date +%Z)
Offset: $(date +%z)

## Sync Instructions for PRISM
1. On init, WebSearch: "current UTC time"
2. Compare with system time
3. Use web time if drift >5 minutes
4. Update all timestamps accordingly
EOF

    echo -e "${GREEN}Time sync configuration created${NC}"
}

# Initialize context system
init_context() {
    echo -e "${GREEN}Initializing PRISM Context System...${NC}"

    # Sync time first
    sync_time

    # Create directory structure
    mkdir -p "$CONTEXT_DIR"
    mkdir -p "$SESSIONS_DIR/history"
    mkdir -p "$REFERENCES_DIR"

    # Create initial files if they don't exist
    [ ! -f "$CONTEXT_DIR/architecture.md" ] && echo "# Architecture Context" > "$CONTEXT_DIR/architecture.md"
    [ ! -f "$CONTEXT_DIR/patterns.md" ] && echo "# Code Patterns" > "$CONTEXT_DIR/patterns.md"
    [ ! -f "$CONTEXT_DIR/decisions.md" ] && echo "# Technical Decisions" > "$CONTEXT_DIR/decisions.md"
    [ ! -f "$CONTEXT_DIR/dependencies.md" ] && echo "# Dependencies" > "$CONTEXT_DIR/dependencies.md"
    [ ! -f "$CONTEXT_DIR/domain.md" ] && echo "# Domain Knowledge" > "$CONTEXT_DIR/domain.md"
    [ ! -f "$REFERENCES_DIR/api-contracts.yaml" ] && echo "# API Contracts" > "$REFERENCES_DIR/api-contracts.yaml"
    [ ! -f "$REFERENCES_DIR/data-models.json" ] && echo "{}" > "$REFERENCES_DIR/data-models.json"
    [ ! -f "$REFERENCES_DIR/security-rules.md" ] && echo "# Security Rules" > "$REFERENCES_DIR/security-rules.md"

    echo -e "${GREEN}Context system initialized!${NC}"
}

# Add context entry
add_context() {
    local file=$1
    local priority=$2
    local tags=$3
    local content=$4

    if [ -z "$file" ]; then
        echo -e "${RED}Error: Please specify a context file${NC}"
        exit 1
    fi

    echo -e "\n## New Entry - $(date -Iseconds)" >> "$CONTEXT_DIR/$file"
    echo "**Priority**: $priority" >> "$CONTEXT_DIR/$file"
    echo "**Tags**: [$tags]" >> "$CONTEXT_DIR/$file"
    echo "" >> "$CONTEXT_DIR/$file"
    echo "$content" >> "$CONTEXT_DIR/$file"

    echo -e "${GREEN}Context added to $file${NC}"
}

# Query context by tags
query_context() {
    local search_term=$1

    echo -e "${YELLOW}Searching for: $search_term${NC}"
    echo "---"

    # Search in all context files
    grep -r "$search_term" "$CLAUDE_DIR" --include="*.md" --include="*.yaml" -n
}

# Archive current session
archive_session() {
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local archive_file="$SESSIONS_DIR/history/session_$timestamp.md"

    if [ -f "$SESSIONS_DIR/current.md" ]; then
        mv "$SESSIONS_DIR/current.md" "$archive_file"
        echo -e "${GREEN}Session archived to $archive_file${NC}"

        # Create new current.md
        cat > "$SESSIONS_DIR/current.md" << EOF
# Current Session Context

**Session Started**: $(date -Iseconds)
**Last Activity**: $(date -Iseconds)
**Focus Area**: [Current work area]

## Active Tasks
<!-- What we're currently working on -->

## Key Decisions This Session
<!-- Important choices made -->

## Context Loaded
<!-- Which context files are in use -->

## Notes
<!-- Important information to remember -->

## Next Steps
<!-- What to do next -->

---
*This file is reset at the start of each session*
*Previous content is archived to history/*
EOF
    fi
}

# Prune old context
prune_context() {
    local days=${1:-30}

    echo -e "${YELLOW}Pruning context older than $days days...${NC}"

    # Find and remove old session files
    find "$SESSIONS_DIR/history" -name "*.md" -mtime +$days -delete

    echo -e "${GREEN}Context pruned${NC}"
}

# Export context for sharing
export_context() {
    local format=${1:-markdown}
    local output="claude_context_export_$(date +%Y%m%d).md"

    echo -e "${YELLOW}Exporting context to $output...${NC}"

    cat > "$output" << EOF
# Claude Context Export
**Exported**: $(date -Iseconds)
**Project**: $(basename "$PWD")

EOF

    # Combine all context files
    for file in "$CONTEXT_DIR"/*.md; do
        echo "---" >> "$output"
        echo "## $(basename "$file" .md | tr '[:lower:]' '[:upper:]')" >> "$output"
        echo "" >> "$output"
        cat "$file" >> "$output"
        echo "" >> "$output"
    done

    echo -e "${GREEN}Context exported to $output${NC}"
}

# Show context status
status() {
    echo -e "${YELLOW}Claude Context Status${NC}"
    echo "---"
    echo "Context Files:"
    ls -lh "$CONTEXT_DIR"/*.md 2>/dev/null | awk '{print $9 ": " $5}'
    echo ""
    echo "Session History:"
    ls "$SESSIONS_DIR/history" 2>/dev/null | wc -l | xargs echo "Archived sessions:"
    echo ""
    echo "References:"
    ls -lh "$REFERENCES_DIR"/* 2>/dev/null | awk '{print $9 ": " $5}'
}

# Main command handler
case "$1" in
    init)
        init_context
        ;;
    add)
        add_context "$2" "$3" "$4" "$5"
        ;;
    query)
        query_context "$2"
        ;;
    archive)
        archive_session
        ;;
    prune)
        prune_context "$2"
        ;;
    export)
        export_context "$2"
        ;;
    status)
        status
        ;;
    *)
        echo "PRISM Context Management System"
        echo "Usage: $0 {init|add|query|archive|prune|export|status}"
        echo ""
        echo "Commands:"
        echo "  init              - Initialize context system"
        echo "  add <file> <priority> <tags> <content> - Add context entry"
        echo "  query <term>      - Search context by term"
        echo "  archive           - Archive current session"
        echo "  prune [days]      - Remove old context (default: 30 days)"
        echo "  export [format]   - Export all context"
        echo "  status            - Show context status"
        exit 1
        ;;
esac