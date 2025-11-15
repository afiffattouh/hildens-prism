#!/bin/bash
# PRISM PRD & Task Management Library
# Provides PRD creation, amendment, and task generation with PRISM context integration

# Source dependencies
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/prism-core.sh"
source "$SCRIPT_DIR/prism-log.sh"
source "$SCRIPT_DIR/prism-context.sh"

# PRD directory setup
PRD_DIR="${PRISM_ROOT:-$HOME/.prism}/.prism/references"
TASKS_DIR="${PRISM_ROOT:-$HOME/.prism}/.prism/workflows"
TEMPLATES_DIR="${PRISM_ROOT:-$HOME/.prism}/.prism/templates"

# Ensure directories exist
mkdir -p "$PRD_DIR" "$TASKS_DIR" "$TEMPLATES_DIR"

#######################################
# Create a new PRD from template
# Arguments:
#   $1 - Feature name (kebab-case)
#   $2 - Interactive mode (optional, default: true)
# Returns:
#   Path to created PRD file
#######################################
prism_prd_create() {
    local feature_name="$1"
    local interactive="${2:-true}"

    if [[ -z "$feature_name" ]]; then
        log_error "Feature name required"
        echo "Usage: prism prd create <feature-name>"
        return 1
    fi

    # Normalize feature name to kebab-case
    feature_name=$(echo "$feature_name" | tr '[:upper:]' '[:lower:]' | tr '_' '-' | tr ' ' '-')

    local prd_file="$PRD_DIR/prd-${feature_name}.md"

    # Check if PRD already exists
    if [[ -f "$prd_file" ]]; then
        log_warn "PRD already exists: $prd_file"
        read -p "Overwrite existing PRD? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_info "Cancelled"
            return 1
        fi
    fi

    log_info "Creating PRD for feature: $feature_name"

    # Analyze PRISM context for relevant sections
    log_info "Analyzing PRISM context..."
    local context_summary=$(prism_prd_analyze_context "$feature_name")

    # Copy template
    local template="$TEMPLATES_DIR/prd-template.md"
    if [[ ! -f "$template" ]]; then
        log_error "PRD template not found: $template"
        return 1
    fi

    cp "$template" "$prd_file"

    # Replace placeholders in template
    local date=$(date +%Y-%m-%d)
    sed -i.bak "s/\[Feature Name\]/${feature_name}/g" "$prd_file"
    sed -i.bak "s/\[YYYY-MM-DD\]/${date}/g" "$prd_file"
    rm "${prd_file}.bak" 2>/dev/null

    # Add context summary if available
    if [[ -n "$context_summary" ]]; then
        log_info "Adding PRISM context references..."
        # Context will be added when Claude Code processes the template
    fi

    log_success "PRD template created: $prd_file"
    log_info ""
    log_info "Next steps:"
    log_info "1. Open the PRD file and fill in the sections"
    log_info "2. Reference PRISM context files as needed"
    log_info "3. When ready, generate tasks: prism tasks generate prd-${feature_name}.md"
    echo
    echo "$prd_file"

    return 0
}

#######################################
# Analyze PRISM context for relevant information
# Arguments:
#   $1 - Feature name
# Returns:
#   Summary of relevant context
#######################################
prism_prd_analyze_context() {
    local feature_name="$1"
    local context_dir="${PRISM_ROOT:-$HOME/.prism}/.prism/context"

    if [[ ! -d "$context_dir" ]]; then
        return 0
    fi

    local summary=""

    # Check architecture.md
    if [[ -f "$context_dir/architecture.md" ]]; then
        summary+="Architecture context available\n"
    fi

    # Check patterns.md
    if [[ -f "$context_dir/patterns.md" ]]; then
        summary+="Coding patterns available\n"
    fi

    # Check security.md
    if [[ -f "$context_dir/security.md" ]]; then
        summary+="Security policies available\n"
    fi

    # Check decisions.md
    if [[ -f "$context_dir/decisions.md" ]]; then
        summary+="Technical decisions available\n"
    fi

    echo -e "$summary"
}

#######################################
# Amend an existing PRD
# Arguments:
#   $1 - Feature name
#   $2 - Amendment description
# Returns:
#   0 on success, 1 on failure
#######################################
prism_prd_amend() {
    local feature_name="$1"
    local amendment="$2"

    if [[ -z "$feature_name" ]]; then
        log_error "Feature name required"
        return 1
    fi

    # Normalize feature name
    feature_name=$(echo "$feature_name" | tr '[:upper:]' '[:lower:]' | tr '_' '-' | tr ' ' '-')

    local prd_file="$PRD_DIR/prd-${feature_name}.md"

    if [[ ! -f "$prd_file" ]]; then
        log_error "PRD not found: $prd_file"
        log_info "Create it first with: prism prd create $feature_name"
        return 1
    fi

    log_info "Amending PRD: $feature_name"
    log_info "Amendment: $amendment"

    # Create backup
    local backup="${prd_file}.backup-$(date +%Y%m%d-%H%M%S)"
    cp "$prd_file" "$backup"
    log_info "Backup created: $backup"

    # Add amendment to revision history
    local date=$(date +%Y-%m-%d)
    local revision_entry="| $date | $(prism_prd_get_next_version "$prd_file") | User | Amendment: $amendment |"

    # Check if revision history section exists
    if grep -q "## 13. Revision History" "$prd_file"; then
        # Add after the header row
        sed -i.bak "/^| Date | Version | Author | Changes |$/a\\
$revision_entry" "$prd_file"
        rm "${prd_file}.bak" 2>/dev/null
    fi

    log_success "PRD amended successfully"
    log_info "Next steps:"
    log_info "1. Review and update the PRD file: $prd_file"
    log_info "2. Update affected sections based on the amendment"
    log_info "3. Regenerate tasks if needed: prism tasks generate prd-${feature_name}.md"
    echo
    echo "$prd_file"

    return 0
}

#######################################
# Get next version number for PRD
# Arguments:
#   $1 - PRD file path
# Returns:
#   Next version number
#######################################
prism_prd_get_next_version() {
    local prd_file="$1"

    # Extract latest version from revision history
    local latest_version=$(grep -E "^\| [0-9]{4}-[0-9]{2}-[0-9]{2} \|" "$prd_file" | \
        tail -1 | \
        awk -F'|' '{print $3}' | \
        tr -d ' ')

    if [[ -z "$latest_version" ]]; then
        echo "1.1"
        return 0
    fi

    # Increment minor version
    local major=$(echo "$latest_version" | cut -d'.' -f1)
    local minor=$(echo "$latest_version" | cut -d'.' -f2)
    minor=$((minor + 1))

    echo "${major}.${minor}"
}

#######################################
# List all PRDs
# Arguments:
#   None
# Returns:
#   List of PRD files with status
#######################################
prism_prd_list() {
    log_info "PRDs in $PRD_DIR:"
    echo

    if [[ ! -d "$PRD_DIR" ]] || [[ -z "$(ls -A "$PRD_DIR" 2>/dev/null)" ]]; then
        log_warn "No PRDs found"
        echo "Create one with: prism prd create <feature-name>"
        return 0
    fi

    local count=0
    for prd_file in "$PRD_DIR"/prd-*.md; do
        if [[ -f "$prd_file" ]]; then
            local feature_name=$(basename "$prd_file" .md | sed 's/^prd-//')
            local status=$(grep "^\*\*Status\*\*:" "$prd_file" | sed 's/.*: //' || echo "UNKNOWN")
            local date=$(grep "^\*\*Created\*\*:" "$prd_file" | sed 's/.*: //' || echo "Unknown")

            printf "  %-30s %-15s %s\n" "$feature_name" "$status" "$date"
            count=$((count + 1))
        fi
    done

    echo
    log_info "Total PRDs: $count"
}

#######################################
# Generate task list from PRD
# Arguments:
#   $1 - PRD filename (with or without path)
#   $2 - Output format (optional: markdown, json)
# Returns:
#   Path to created task file
#######################################
prism_tasks_generate() {
    local prd_input="$1"
    local output_format="${2:-markdown}"

    if [[ -z "$prd_input" ]]; then
        log_error "PRD file required"
        echo "Usage: prism tasks generate <prd-file>"
        return 1
    fi

    # Resolve PRD file path
    local prd_file="$prd_input"
    if [[ ! -f "$prd_file" ]]; then
        # Try in PRD_DIR
        prd_file="$PRD_DIR/$(basename "$prd_input")"
    fi

    if [[ ! -f "$prd_file" ]]; then
        log_error "PRD file not found: $prd_input"
        return 1
    fi

    # Extract feature name
    local feature_name=$(basename "$prd_file" .md | sed 's/^prd-//')
    local tasks_file="$TASKS_DIR/tasks-${feature_name}.md"

    log_info "Generating tasks for: $feature_name"
    log_info "Source PRD: $prd_file"

    # Check if task file already exists
    if [[ -f "$tasks_file" ]]; then
        log_warn "Task file already exists: $tasks_file"
        read -p "Overwrite existing tasks? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_info "Cancelled"
            return 1
        fi
    fi

    # Copy template
    local template="$TEMPLATES_DIR/tasks-template.md"
    if [[ ! -f "$template" ]]; then
        log_error "Task template not found: $template"
        return 1
    fi

    cp "$template" "$tasks_file"

    # Replace placeholders
    local date=$(date +%Y-%m-%d)
    sed -i.bak "s/\[Feature Name\]/${feature_name}/g" "$tasks_file"
    sed -i.bak "s/\[YYYY-MM-DD\]/${date}/g" "$tasks_file"
    sed -i.bak "s|prd-\[feature-name\].md|$(basename "$prd_file")|g" "$tasks_file"
    rm "${tasks_file}.bak" 2>/dev/null

    log_success "Task template created: $tasks_file"
    log_info ""
    log_info "Next steps:"
    log_info "1. Review the task template and customize based on PRD"
    log_info "2. Fill in task details, agent assignments, and verification criteria"
    log_info "3. Use tasks to guide implementation with PRISM agents"
    echo
    echo "$tasks_file"

    return 0
}

#######################################
# Show task status and progress
# Arguments:
#   $1 - Feature name or task file (optional)
# Returns:
#   Task completion summary
#######################################
prism_tasks_status() {
    local input="$1"

    if [[ -z "$input" ]]; then
        # Show all task files
        prism_tasks_list
        return 0
    fi

    # Resolve task file
    local tasks_file="$input"
    if [[ ! -f "$tasks_file" ]]; then
        # Try as feature name
        local feature_name=$(echo "$input" | tr '[:upper:]' '[:lower:]' | tr '_' '-' | tr ' ' '-')
        tasks_file="$TASKS_DIR/tasks-${feature_name}.md"
    fi

    if [[ ! -f "$tasks_file" ]]; then
        log_error "Task file not found: $input"
        return 1
    fi

    local feature_name=$(basename "$tasks_file" .md | sed 's/^tasks-//')

    log_info "Task Status: $feature_name"
    echo

    # Count tasks
    local pending_count
    pending_count=$(grep -c "^- \[ \]" "$tasks_file" 2>/dev/null) || pending_count=0
    local completed_count
    completed_count=$(grep -c "^- \[x\]" "$tasks_file" 2>/dev/null) || completed_count=0
    local total_tasks=$((pending_count + completed_count))
    local completed_tasks=$completed_count
    local pending_tasks=$pending_count

    # Calculate percentage
    local percentage=0
    if [[ $total_tasks -gt 0 ]]; then
        percentage=$((completed_tasks * 100 / total_tasks))
    fi

    echo "Progress: [$completed_tasks/$total_tasks] ($percentage%)"
    echo
    echo "  Completed: $completed_tasks"
    echo "  Pending:   $pending_tasks"
    echo "  Total:     $total_tasks"
    echo

    # Show pending tasks
    if [[ $pending_tasks -gt 0 ]]; then
        echo "Next pending tasks:"
        grep "^- \[ \]" "$tasks_file" | head -5 | while read -r line; do
            # Extract task number and title
            local task=$(echo "$line" | sed 's/^- \[ \] //')
            echo "  - $task"
        done
    else
        log_success "All tasks completed! 🎉"
    fi

    return 0
}

#######################################
# List all task files
# Arguments:
#   None
# Returns:
#   List of task files with progress
#######################################
prism_tasks_list() {
    log_info "Tasks in $TASKS_DIR:"
    echo

    if [[ ! -d "$TASKS_DIR" ]] || [[ -z "$(ls -A "$TASKS_DIR" 2>/dev/null)" ]]; then
        log_warn "No task files found"
        echo "Generate tasks with: prism tasks generate <prd-file>"
        return 0
    fi

    printf "  %-30s %-15s %s\n" "Feature" "Progress" "Status"
    printf "  %-30s %-15s %s\n" "-------" "--------" "------"

    for tasks_file in "$TASKS_DIR"/tasks-*.md; do
        if [[ -f "$tasks_file" ]]; then
            local feature_name=$(basename "$tasks_file" .md | sed 's/^tasks-//')

            # Count tasks
            local pending
            pending=$(grep -c "^- \[ \]" "$tasks_file" 2>/dev/null) || pending=0
            local completed
            completed=$(grep -c "^- \[x\]" "$tasks_file" 2>/dev/null) || completed=0
            local total=$((pending + completed))

            local percentage=0
            if [[ $total -gt 0 ]]; then
                percentage=$((completed * 100 / total))
            fi

            local status="IN_PROGRESS"
            if [[ $percentage -eq 100 ]]; then
                status="COMPLETED"
            elif [[ $percentage -eq 0 ]]; then
                status="NOT_STARTED"
            fi

            printf "  %-30s %-15s %s\n" "$feature_name" "[$completed/$total] $percentage%" "$status"
        fi
    done

    echo
}

#######################################
# Show PRD/Task help
# Arguments:
#   None
#######################################
prism_prd_help() {
    cat <<EOF
PRISM PRD & Task Management Commands

PRD Commands:
  prism prd create <feature-name>           Create new PRD from template
  prism prd amend <feature-name> "change"   Amend existing PRD
  prism prd list                            List all PRDs

Task Commands:
  prism tasks generate <prd-file>           Generate task list from PRD
  prism tasks status [feature-name]         Show task completion status
  prism tasks list                          List all task files

Examples:
  prism prd create user-authentication
  prism prd amend user-authentication "Add OAuth support"
  prism tasks generate prd-user-authentication.md
  prism tasks status user-authentication

Files:
  PRDs: .prism/references/prd-*.md
  Tasks: .prism/workflows/tasks-*.md
  Templates: .prism/templates/

For more information, see: .prism/context/prd-task-management.md
EOF
}

# Export functions
export -f prism_prd_create
export -f prism_prd_amend
export -f prism_prd_list
export -f prism_prd_analyze_context
export -f prism_prd_get_next_version
export -f prism_tasks_generate
export -f prism_tasks_status
export -f prism_tasks_list
export -f prism_prd_help
