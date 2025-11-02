#!/bin/bash
# PRISM Skills Management Library
# Provides skill creation, listing, and management commands

# Source guard
if [[ -n "${_PRISM_SKILLS_SH_LOADED:-}" ]]; then
    return 0
fi
readonly _PRISM_SKILLS_SH_LOADED=1

# Source dependencies
# Use PRISM_ROOT if set, fallback to PRISM_HOME, then HOME/.prism
PRISM_LIB_ROOT="${PRISM_ROOT:-${PRISM_HOME:-$HOME/.prism}}"
source "${PRISM_LIB_ROOT}/lib/prism-log.sh" 2>/dev/null || true

# Skill creation interactive mode
skill_create() {
    echo "🎨 PRISM Skill Creator"
    echo "====================="
    echo ""

    # Get skill name
    read -p "Skill name (lowercase-with-hyphens): " skill_name

    # Validate name
    if [[ -z "$skill_name" ]]; then
        log_error "Skill name is required"
        return 1
    fi

    if [[ ! "$skill_name" =~ ^[a-z0-9-]+$ ]]; then
        log_error "Invalid name. Use lowercase letters, numbers, and hyphens only."
        return 1
    fi

    # Get description
    read -p "What does it do? " skill_desc

    if [[ -z "$skill_desc" ]]; then
        log_error "Description is required"
        return 1
    fi

    # Get triggers
    read -p "When should Claude use it? (keywords/phrases): " skill_triggers

    # Build full description
    if [[ -n "$skill_triggers" ]]; then
        full_desc="${skill_desc}. Use when ${skill_triggers}."
    else
        full_desc="${skill_desc}"
    fi

    # Get scope
    echo ""
    echo "Where should it live?"
    echo "  1. Personal (~/.prism/skills/) - just for you"
    echo "  2. Project (.claude/skills/) - for this project"
    read -p "Choice [1]: " scope_choice
    scope_choice="${scope_choice:-1}"

    if [[ "$scope_choice" == "2" ]]; then
        skill_dir=".claude/skills/${skill_name}"
    else
        skill_dir="${HOME}/.prism/skills/${skill_name}"
    fi

    # Check if exists
    if [[ -d "$skill_dir" ]]; then
        log_error "Skill already exists: $skill_dir"
        return 1
    fi

    # Create directory
    mkdir -p "$skill_dir"

    # PRISM-aware?
    read -p "Should it be PRISM-aware? (read/update context) [y/N]: " prism_aware

    # Generate SKILL.md
    cat > "$skill_dir/SKILL.md" << EOF
---
name: ${skill_name}
description: ${full_desc}
---

# ${skill_name^}

Brief description of what this skill does.

## Instructions

1. First step
2. Second step
3. Third step

## Examples

\`\`\`
User: "example request"
Assistant: *follows instructions* → shows result
\`\`\`

\`\`\`
User: "another example"
Assistant: *follows instructions* → shows result
\`\`\`

## Tips

- Keep instructions clear and actionable
- Include multiple examples
- Focus on what to do, not how to think
EOF

    echo "✓ Created: $skill_dir/SKILL.md"

    # Create .prism-hints if requested
    if [[ "$prism_aware" =~ ^[Yy] ]]; then
        cat > "$skill_dir/.prism-hints" << EOF
# PRISM context hints

context_files:
  - patterns.md

updates_context: false

tags:
  - custom
EOF
        echo "✓ Created: $skill_dir/.prism-hints"
    fi

    echo ""
    echo "🎉 Skill ready!"
    echo ""
    echo "📝 Edit: $skill_dir/SKILL.md"
    echo "🧪 Test: Ask Claude to use your skill"
    echo ""
}

# List all available skills
skill_list() {
    local show_details="${1:-false}"

    echo "=== Built-in Skills ==="
    if [[ -d "$HOME/.prism/lib/skills" ]]; then
        for skill in "$HOME/.prism/lib/skills"/*; do
            if [[ -f "$skill/SKILL.md" ]]; then
                skill_name=$(basename "$skill")
                if [[ "$show_details" == "true" ]]; then
                    desc=$(grep "^description:" "$skill/SKILL.md" | cut -d: -f2- | xargs)
                    printf "  %-20s %s\n" "$skill_name" "${desc:0:60}"
                else
                    echo "  $skill_name"
                fi
            fi
        done
    fi

    echo ""
    echo "=== Personal Skills ==="
    if [[ -d "$HOME/.prism/skills" ]]; then
        local count=0
        # Use find to avoid glob expansion issues
        while IFS= read -r -d '' skill; do
            if [[ -f "$skill/SKILL.md" ]]; then
                skill_name=$(basename "$skill")
                if [[ "$show_details" == "true" ]]; then
                    desc=$(grep "^description:" "$skill/SKILL.md" | cut -d: -f2- | xargs)
                    printf "  %-20s %s\n" "$skill_name" "${desc:0:60}"
                else
                    echo "  $skill_name"
                fi
                ((count++))
            fi
        done < <(find "$HOME/.prism/skills" -maxdepth 1 -mindepth 1 -type d -print0 2>/dev/null)
        if [[ $count -eq 0 ]]; then
            echo "  (none)"
        fi
    else
        echo "  (none)"
    fi

    echo ""
    echo "=== Project Skills ==="
    if [[ -d ".claude/skills" ]]; then
        local count=0
        # Use find to avoid glob expansion issues
        while IFS= read -r -d '' skill; do
            if [[ -f "$skill/SKILL.md" ]]; then
                skill_name=$(basename "$skill")
                if [[ "$show_details" == "true" ]]; then
                    desc=$(grep "^description:" "$skill/SKILL.md" | cut -d: -f2- | xargs)
                    printf "  %-20s %s\n" "$skill_name" "${desc:0:60}"
                else
                    echo "  $skill_name"
                fi
                ((count++))
            fi
        done < <(find ".claude/skills" -maxdepth 1 -mindepth 1 -type d -print0 2>/dev/null)
        if [[ $count -eq 0 ]]; then
            echo "  (none)"
        fi
    else
        echo "  (none)"
    fi
}

# Show detailed information about a skill
skill_info() {
    local skill_name="$1"

    if [[ -z "$skill_name" ]]; then
        log_error "Skill name is required"
        return 1
    fi

    # Search for skill
    local skill_file=""
    local skill_type=""

    if [[ -f "$HOME/.prism/lib/skills/$skill_name/SKILL.md" ]]; then
        skill_file="$HOME/.prism/lib/skills/$skill_name/SKILL.md"
        skill_type="Built-in"
    elif [[ -f "$HOME/.prism/skills/$skill_name/SKILL.md" ]]; then
        skill_file="$HOME/.prism/skills/$skill_name/SKILL.md"
        skill_type="Personal"
    elif [[ -f ".claude/skills/$skill_name/SKILL.md" ]]; then
        skill_file=".claude/skills/$skill_name/SKILL.md"
        skill_type="Project"
    else
        log_error "Skill not found: $skill_name"
        echo ""
        echo "Available skills:"
        skill_list
        return 1
    fi

    echo "=== $skill_type Skill: $skill_name ==="
    echo ""
    cat "$skill_file"
}

# Link PRISM skills to Claude Code directory
skill_link_claude() {
    local claude_dir="$HOME/.claude/skills"
    local prism_dir="$HOME/.prism/skills"

    # First, symlink built-in skills to personal skills directory
    local builtin_dir="$HOME/.prism/lib/skills"
    if [[ -d "$builtin_dir" ]]; then
        log_info "Symlinking built-in skills to ~/.prism/skills/"
        mkdir -p "$prism_dir"
        while IFS= read -r -d '' skill; do
            local skill_name=$(basename "$skill")
            if [[ ! -e "$prism_dir/$skill_name" ]]; then
                ln -sf "$skill" "$prism_dir/$skill_name"
                log_info "  ✓ $skill_name"
            fi
        done < <(find "$builtin_dir" -maxdepth 1 -mindepth 1 -type d -print0 2>/dev/null)
    fi

    if [[ -L "$claude_dir" ]]; then
        local target=$(readlink "$claude_dir")
        if [[ "$target" == "$prism_dir" ]]; then
            log_info "Already linked: ~/.claude/skills → ~/.prism/skills"
            return 0
        else
            log_warn "~/.claude/skills is linked to different location: $target"
            return 1
        fi
    fi

    if [[ -d "$claude_dir" ]]; then
        log_warn "~/.claude/skills already exists as directory"
        read -p "Move contents to ~/.prism/skills and create symlink? [y/N]: " confirm
        if [[ "$confirm" =~ ^[Yy] ]]; then
            # Move existing skills
            if [[ -n "$(ls -A "$claude_dir" 2>/dev/null)" ]]; then
                mv "$claude_dir"/* "$prism_dir/" 2>/dev/null
                log_info "Moved existing skills to ~/.prism/skills/"
            fi
            rmdir "$claude_dir"
            ln -s "$prism_dir" "$claude_dir"
            log_info "✓ Linked: ~/.claude/skills → ~/.prism/skills"
        else
            log_info "Skipped linking"
            return 1
        fi
    else
        ln -s "$prism_dir" "$claude_dir"
        log_info "✓ Linked: ~/.claude/skills → ~/.prism/skills"
    fi
}

# Show skill statistics
skill_stats() {
    local builtin_count=0
    local personal_count=0
    local project_count=0

    if [[ -d "$HOME/.prism/lib/skills" ]]; then
        builtin_count=$(find "$HOME/.prism/lib/skills" -name "SKILL.md" | wc -l | xargs)
    fi

    if [[ -d "$HOME/.prism/skills" ]]; then
        personal_count=$(find "$HOME/.prism/skills" -name "SKILL.md" | wc -l | xargs)
    fi

    if [[ -d ".claude/skills" ]]; then
        project_count=$(find ".claude/skills" -name "SKILL.md" | wc -l | xargs)
    fi

    echo "📊 PRISM Skills Statistics"
    echo "=========================="
    echo ""
    printf "  Built-in:  %2d skills\n" "$builtin_count"
    printf "  Personal:  %2d skills\n" "$personal_count"
    printf "  Project:   %2d skills\n" "$project_count"
    echo "  ────────────────"
    printf "  Total:     %2d skills\n" $((builtin_count + personal_count + project_count))
    echo ""
}

# Main skills command dispatcher
prism_skills() {
    local subcmd="${1:-help}"
    shift || true

    case "$subcmd" in
        create)
            skill_create
            ;;
        list)
            if [[ "${1:-}" == "-v" || "${1:-}" == "--verbose" ]]; then
                skill_list true
            else
                skill_list false
            fi
            ;;
        info|show)
            skill_info "${1:-}"
            ;;
        link-claude|link)
            skill_link_claude
            ;;
        stats)
            skill_stats
            ;;
        help|--help|-h)
            cat << 'HELP'
PRISM Skills Management

Usage:
  prism skill <command> [options]

Commands:
  create              Create a new skill interactively
  list [-v]          List all available skills (verbose with descriptions)
  info <name>        Show detailed information about a skill
  link-claude        Link ~/.prism/skills to ~/.claude/skills
  stats              Show skills statistics
  help               Show this help message

Examples:
  prism skill create              # Interactive skill creation
  prism skill list -v             # List all skills with descriptions
  prism skill info test-runner    # Show test-runner skill details
  prism skill link-claude         # Set up Claude Code integration

Built-in Skills:
  test-runner       Run project tests automatically
  context-summary   Show PRISM project context
  session-save      Save current work session
  skill-create      Create new skills interactively
  prism-init        Initialize PRISM in a project

HELP
            ;;
        *)
            log_error "Unknown command: $subcmd"
            echo "Run 'prism skill help' for usage information"
            return 1
            ;;
    esac
}
