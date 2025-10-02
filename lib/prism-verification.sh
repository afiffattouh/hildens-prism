#!/bin/bash
# PRISM Verification System
# Implements formal verification loops following Anthropic's Claude Agent SDK principles

# Source guard - prevent multiple sourcing
if [[ -n "${_PRISM_PRISM_VERIFICATION_LOADED:-}" ]]; then
    return 0
fi
readonly _PRISM_PRISM_VERIFICATION_LOADED=1


# Source dependencies
source "$(dirname "${BASH_SOURCE[0]}")/prism-log.sh"

# Verification thresholds (from PRISM.md quality gates)
readonly MAX_CYCLOMATIC_COMPLEXITY=10
readonly MAX_COGNITIVE_COMPLEXITY=15
readonly MAX_NESTING_DEPTH=4
readonly MAX_FILE_LINES=300
readonly MAX_FUNCTION_LINES=50
readonly MIN_TEST_COVERAGE=85

# Comprehensive verification function
verify_code_quality() {
    local file_path="$1"
    local agent_id="${2:-unknown}"

    log_info "[VERIFY] Checking code quality for: $file_path"

    local verification_report=".prism/agents/active/$agent_id/verification_report.md"
    local all_checks_passed=true

    # Initialize report
    cat > "$verification_report" << EOF
# Verification Report
**File**: $file_path
**Agent**: $agent_id
**Timestamp**: $(date -u +%Y-%m-%dT%H:%M:%SZ)

## Checks Performed

EOF

    # Check 1: File exists and is readable
    if [[ ! -f "$file_path" ]]; then
        log_error "[VERIFY] File not found: $file_path"
        echo "❌ **File Existence**: FAILED - File not found" >> "$verification_report"
        return 1
    fi

    echo "✅ **File Existence**: PASSED" >> "$verification_report"

    # Check 2: File size (lines)
    local file_lines=$(wc -l < "$file_path")
    echo "" >> "$verification_report"
    echo "### File Size Check" >> "$verification_report"
    echo "- Lines: $file_lines" >> "$verification_report"
    echo "- Threshold: $MAX_FILE_LINES" >> "$verification_report"

    if [[ $file_lines -gt $MAX_FILE_LINES ]]; then
        log_warning "[VERIFY] File too large: $file_lines lines (max: $MAX_FILE_LINES)"
        echo "- **Status**: ⚠️ WARNING - Consider splitting into smaller files" >> "$verification_report"
        # Warning only, not a failure
    else
        echo "- **Status**: ✅ PASSED" >> "$verification_report"
    fi

    # Check 3: Security patterns (basic scan)
    echo "" >> "$verification_report"
    echo "### Security Scan" >> "$verification_report"

    local security_issues=0

    # Check for common security anti-patterns
    if grep -qE "(eval|exec|system|shell_exec|passthru)" "$file_path" 2>/dev/null; then
        log_warning "[VERIFY] Potential security risk: dangerous function found"
        echo "- ⚠️ WARNING: Dangerous function detected (eval/exec/system)" >> "$verification_report"
        security_issues=$((security_issues + 1))
    fi

    if grep -qE "(password|secret|api_key|private_key).*=.*['\"][^'\"]+['\"]" "$file_path" 2>/dev/null; then
        log_error "[VERIFY] CRITICAL: Hardcoded credentials detected"
        echo "- ❌ CRITICAL: Hardcoded credentials detected" >> "$verification_report"
        all_checks_passed=false
        security_issues=$((security_issues + 1))
    fi

    if grep -qiE "^TODO.*security|FIXME.*auth|HACK.*password" "$file_path" 2>/dev/null; then
        log_warning "[VERIFY] Security-related TODOs found"
        echo "- ⚠️ WARNING: Security-related TODOs found" >> "$verification_report"
        security_issues=$((security_issues + 1))
    fi

    if [[ $security_issues -eq 0 ]]; then
        echo "- **Status**: ✅ PASSED - No obvious security issues" >> "$verification_report"
    else
        echo "- **Status**: ⚠️ $security_issues issue(s) found" >> "$verification_report"
    fi

    # Check 4: Code quality markers
    echo "" >> "$verification_report"
    echo "### Code Quality Markers" >> "$verification_report"

    local todo_count=$(grep -ciE "TODO|FIXME|HACK|XXX" "$file_path" 2>/dev/null || echo 0)
    echo "- TODOs/FIXMEs: $todo_count" >> "$verification_report"

    if [[ $todo_count -gt 5 ]]; then
        log_warning "[VERIFY] High number of TODO markers: $todo_count"
        echo "- **Status**: ⚠️ WARNING - Too many TODOs ($todo_count)" >> "$verification_report"
    else
        echo "- **Status**: ✅ PASSED" >> "$verification_report"
    fi

    # Check 5: Error handling patterns
    echo "" >> "$verification_report"
    echo "### Error Handling" >> "$verification_report"

    local has_error_handling=false
    if grep -qE "(try|catch|except|Error|Exception|throw)" "$file_path" 2>/dev/null; then
        has_error_handling=true
    fi

    if $has_error_handling; then
        echo "- **Status**: ✅ PASSED - Error handling detected" >> "$verification_report"
    else
        log_warning "[VERIFY] No error handling found"
        echo "- **Status**: ⚠️ WARNING - No error handling detected" >> "$verification_report"
    fi

    # Check 6: Documentation
    echo "" >> "$verification_report"
    echo "### Documentation" >> "$verification_report"

    local comment_lines=$(grep -cE "^\s*(#|//|/\*|\*)" "$file_path" 2>/dev/null || echo 0)
    local code_lines=$((file_lines - comment_lines))
    local comment_ratio=0

    if [[ $code_lines -gt 0 ]]; then
        comment_ratio=$((comment_lines * 100 / code_lines))
    fi

    echo "- Comment lines: $comment_lines" >> "$verification_report"
    echo "- Code lines: $code_lines" >> "$verification_report"
    echo "- Comment ratio: ${comment_ratio}%" >> "$verification_report"

    if [[ $comment_ratio -lt 10 && $code_lines -gt 50 ]]; then
        log_warning "[VERIFY] Low documentation coverage: ${comment_ratio}%"
        echo "- **Status**: ⚠️ WARNING - Consider adding more comments" >> "$verification_report"
    else
        echo "- **Status**: ✅ PASSED" >> "$verification_report"
    fi

    # Final summary
    echo "" >> "$verification_report"
    echo "## Summary" >> "$verification_report"

    if $all_checks_passed; then
        echo "**Overall Status**: ✅ VERIFICATION PASSED" >> "$verification_report"
        log_success "[VERIFY] All checks passed for: $file_path"
        return 0
    else
        echo "**Overall Status**: ❌ VERIFICATION FAILED" >> "$verification_report"
        echo "" >> "$verification_report"
        echo "**Action Required**: Fix critical issues before proceeding" >> "$verification_report"
        log_error "[VERIFY] Verification failed for: $file_path"
        return 1
    fi
}

# Language-specific linting
run_linter() {
    local file_path="$1"
    local agent_id="${2:-unknown}"

    log_info "[LINT] Running linter for: $file_path"

    # Detect language and run appropriate linter
    case "$file_path" in
        *.js|*.jsx)
            if command -v eslint >/dev/null 2>&1; then
                local output exit_code
                output=$(eslint "$file_path" 2>&1)
                exit_code=$?
                echo "$output" | tee ".prism/agents/active/$agent_id/lint_results.txt" >/dev/null
                return $exit_code
            else
                log_warning "[LINT] ESLint not available, skipping JavaScript linting"
                return 0
            fi
            ;;
        *.ts|*.tsx)
            if command -v tslint >/dev/null 2>&1; then
                local output exit_code
                output=$(tslint "$file_path" 2>&1)
                exit_code=$?
                echo "$output" | tee ".prism/agents/active/$agent_id/lint_results.txt" >/dev/null
                return $exit_code
            elif command -v eslint >/dev/null 2>&1; then
                local output exit_code
                output=$(eslint "$file_path" 2>&1)
                exit_code=$?
                echo "$output" | tee ".prism/agents/active/$agent_id/lint_results.txt" >/dev/null
                return $exit_code
            else
                log_warning "[LINT] No TypeScript linter available, skipping"
                return 0
            fi
            ;;
        *.py)
            if command -v pylint >/dev/null 2>&1; then
                local output exit_code
                output=$(pylint "$file_path" 2>&1)
                exit_code=$?
                echo "$output" | tee ".prism/agents/active/$agent_id/lint_results.txt" >/dev/null
                return $exit_code
            elif command -v flake8 >/dev/null 2>&1; then
                local output exit_code
                output=$(flake8 "$file_path" 2>&1)
                exit_code=$?
                echo "$output" | tee ".prism/agents/active/$agent_id/lint_results.txt" >/dev/null
                return $exit_code
            else
                log_warning "[LINT] No Python linter available, skipping"
                return 0
            fi
            ;;
        *.go)
            if command -v golint >/dev/null 2>&1; then
                local output exit_code
                output=$(golint "$file_path" 2>&1)
                exit_code=$?
                echo "$output" | tee ".prism/agents/active/$agent_id/lint_results.txt" >/dev/null
                return $exit_code
            else
                log_warning "[LINT] golint not available, skipping Go linting"
                return 0
            fi
            ;;
        *.sh)
            if command -v shellcheck >/dev/null 2>&1; then
                local output exit_code
                output=$(shellcheck "$file_path" 2>&1)
                exit_code=$?
                echo "$output" | tee ".prism/agents/active/$agent_id/lint_results.txt" >/dev/null
                return $exit_code
            else
                log_warning "[LINT] shellcheck not available, skipping shell linting"
                return 0
            fi
            ;;
        *)
            log_info "[LINT] No linter configured for this file type, using basic checks"
            verify_code_quality "$file_path" "$agent_id"
            return $?
            ;;
    esac
}

# Security-specific scanning
scan_security() {
    local file_or_dir="$1"
    local agent_id="${2:-unknown}"

    log_info "[SECURITY] Running security scan on: $file_or_dir"

    local security_report=".prism/agents/active/$agent_id/security_scan.md"

    cat > "$security_report" << EOF
# Security Scan Report
**Target**: $file_or_dir
**Timestamp**: $(date -u +%Y-%m-%dT%H:%M:%SZ)

## OWASP Top 10 Check

EOF

    local issues_found=0

    # 1. Injection vulnerabilities
    if find "$file_or_dir" -type f -exec grep -l "eval\|exec\|system" {} \; 2>/dev/null | head -1; then
        echo "❌ **A03:2021 - Injection**: Dangerous functions found" >> "$security_report"
        issues_found=$((issues_found + 1))
    else
        echo "✅ **A03:2021 - Injection**: PASSED" >> "$security_report"
    fi

    # 2. Broken authentication
    if find "$file_or_dir" -type f -exec grep -l "password.*=.*['\"]" {} \; 2>/dev/null | head -1; then
        echo "❌ **A07:2021 - Auth Failures**: Hardcoded credentials found" >> "$security_report"
        issues_found=$((issues_found + 1))
    else
        echo "✅ **A07:2021 - Auth Failures**: PASSED" >> "$security_report"
    fi

    # 3. Sensitive data exposure
    if find "$file_or_dir" -type f -exec grep -li "api.key\|secret\|token.*=" {} \; 2>/dev/null | head -1; then
        echo "❌ **A02:2021 - Crypto Failures**: Potential secrets exposed" >> "$security_report"
        issues_found=$((issues_found + 1))
    else
        echo "✅ **A02:2021 - Crypto Failures**: PASSED" >> "$security_report"
    fi

    # Summary
    echo "" >> "$security_report"
    if [[ $issues_found -eq 0 ]]; then
        echo "## Summary: ✅ No critical security issues detected" >> "$security_report"
        log_success "[SECURITY] Security scan passed"
        return 0
    else
        echo "## Summary: ❌ $issues_found critical issue(s) detected" >> "$security_report"
        log_error "[SECURITY] Security scan found $issues_found issue(s)"
        return 1
    fi
}

# Complexity analysis (basic version)
check_complexity() {
    local file_path="$1"
    local agent_id="${2:-unknown}"

    log_info "[COMPLEXITY] Analyzing: $file_path"

    local complexity_report=".prism/agents/active/$agent_id/complexity_report.txt"

    # Basic complexity heuristics
    local nesting_depth=$(grep -oE '{' "$file_path" | wc -l)
    local function_count=$(grep -cE "function|def |func " "$file_path" 2>/dev/null || echo 0)

    echo "Complexity Analysis for $file_path" > "$complexity_report"
    echo "Nesting indicators: $nesting_depth" >> "$complexity_report"
    echo "Function count: $function_count" >> "$complexity_report"

    # Rough estimate - if too many nested braces, likely high complexity
    if [[ $nesting_depth -gt 50 && $function_count -lt 5 ]]; then
        log_warning "[COMPLEXITY] High complexity suspected (deep nesting)"
        echo "Status: ⚠️ WARNING - High complexity suspected" >> "$complexity_report"
        return 1
    else
        echo "Status: ✅ PASSED" >> "$complexity_report"
        return 0
    fi
}

# Performance check (basic version)
check_performance() {
    local file_path="$1"
    local agent_id="${2:-unknown}"

    log_info "[PERFORMANCE] Checking: $file_path"

    # Check for common performance anti-patterns
    local perf_issues=0

    # Nested loops indicator
    if grep -qE "for.*for|while.*while" "$file_path" 2>/dev/null; then
        log_warning "[PERFORMANCE] Nested loops detected (potential O(n²))"
        perf_issues=$((perf_issues + 1))
    fi

    # Synchronous I/O in async contexts
    if grep -qE "readFileSync|writeFileSync" "$file_path" 2>/dev/null; then
        log_warning "[PERFORMANCE] Synchronous file I/O detected"
        perf_issues=$((perf_issues + 1))
    fi

    if [[ $perf_issues -eq 0 ]]; then
        log_success "[PERFORMANCE] No obvious performance issues"
        return 0
    else
        log_warning "[PERFORMANCE] $perf_issues potential performance issue(s) found"
        return 1
    fi
}

# Export functions
export -f verify_code_quality
export -f run_linter
export -f scan_security
export -f check_complexity
export -f check_performance
