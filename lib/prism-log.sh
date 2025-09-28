#!/bin/bash
# PRISM Logging Library - Logging functions for PRISM framework
# Version: 2.0.0

# Logging configuration
readonly LOG_LEVELS=(TRACE DEBUG INFO WARN ERROR FATAL)
readonly DEFAULT_LOG_LEVEL="${PRISM_LOG_LEVEL:-INFO}"
readonly LOG_FILE="${PRISM_LOG:-$HOME/.claude/prism.log}"
readonly LOG_MAX_SIZE="${PRISM_LOG_MAX_SIZE:-10485760}"  # 10MB
readonly LOG_MAX_FILES="${PRISM_LOG_MAX_FILES:-5}"
readonly LOG_TO_STDOUT="${PRISM_LOG_STDOUT:-true}"
readonly LOG_TO_FILE="${PRISM_LOG_FILE:-true}"
readonly LOG_DATE_FORMAT="${PRISM_LOG_DATE_FORMAT:-%Y-%m-%d %H:%M:%S}"

# Get numeric value for log level
get_log_level_num() {
    local level=$1
    case "${level^^}" in
        TRACE) echo 0 ;;
        DEBUG) echo 1 ;;
        INFO)  echo 2 ;;
        WARN)  echo 3 ;;
        ERROR) echo 4 ;;
        FATAL) echo 5 ;;
        *)     echo 2 ;;  # Default to INFO
    esac
}

# Current log level
CURRENT_LOG_LEVEL=$(get_log_level_num "$DEFAULT_LOG_LEVEL")

# Initialize logging
init_logging() {
    # Create log directory if needed
    local log_dir=$(dirname "$LOG_FILE")
    if [[ ! -d "$log_dir" ]]; then
        mkdir -p "$log_dir"
    fi

    # Rotate logs if needed
    rotate_logs
}

# Rotate log files
rotate_logs() {
    if [[ ! -f "$LOG_FILE" ]]; then
        return
    fi

    local file_size=$(stat -f%z "$LOG_FILE" 2>/dev/null || stat -c%s "$LOG_FILE" 2>/dev/null || echo 0)

    if [[ $file_size -gt $LOG_MAX_SIZE ]]; then
        # Rotate existing logs
        for i in $(seq $((LOG_MAX_FILES-1)) -1 1); do
            if [[ -f "${LOG_FILE}.$i" ]]; then
                mv "${LOG_FILE}.$i" "${LOG_FILE}.$((i+1))"
            fi
        done

        # Move current log to .1
        mv "$LOG_FILE" "${LOG_FILE}.1"

        # Remove oldest log if it exists
        if [[ -f "${LOG_FILE}.${LOG_MAX_FILES}" ]]; then
            rm "${LOG_FILE}.${LOG_MAX_FILES}"
        fi
    fi
}

# Core logging function
log() {
    local level=$1
    shift
    local message="$*"

    # Get level numbers
    local msg_level=$(get_log_level_num "$level")

    # Check if we should log this message
    if [[ $msg_level -lt $CURRENT_LOG_LEVEL ]]; then
        return
    fi

    # Format timestamp
    local timestamp=$(date +"$LOG_DATE_FORMAT")

    # Format log message
    local log_msg="[$timestamp] [$level] $message"

    # Add color for terminal output
    local colored_msg="$log_msg"
    if [[ "$LOG_TO_STDOUT" == "true" ]] && [[ -t 1 ]] && [[ "${NO_COLOR:-}" != "1" ]]; then
        case "${level^^}" in
            TRACE) colored_msg="${GRAY}${log_msg}${NC}" ;;
            DEBUG) colored_msg="${BLUE}${log_msg}${NC}" ;;
            INFO)  colored_msg="${GREEN}${log_msg}${NC}" ;;
            WARN)  colored_msg="${YELLOW}${log_msg}${NC}" ;;
            ERROR) colored_msg="${RED}${log_msg}${NC}" ;;
            FATAL) colored_msg="${BOLD}${RED}${log_msg}${NC}" ;;
        esac
    fi

    # Output to stdout
    if [[ "$LOG_TO_STDOUT" == "true" ]]; then
        if [[ $msg_level -ge 4 ]]; then  # ERROR and FATAL to stderr
            echo -e "$colored_msg" >&2
        else
            echo -e "$colored_msg"
        fi
    fi

    # Output to file
    if [[ "$LOG_TO_FILE" == "true" ]]; then
        echo "$log_msg" >> "$LOG_FILE"

        # Check if rotation is needed
        rotate_logs
    fi

    # Exit on FATAL
    if [[ "${level^^}" == "FATAL" ]]; then
        exit 1
    fi
}

# Convenience logging functions
log_trace() { log TRACE "$@"; }
log_debug() { log DEBUG "$@"; }
log_info()  { log INFO  "$@"; }
log_warn()  { log WARN  "$@"; }
log_error() { log ERROR "$@"; }
log_fatal() { log FATAL "$@"; }

# Log with context
log_context() {
    local level=$1
    local context=$2
    shift 2
    local message="$*"

    log "$level" "[$context] $message"
}

# Log command execution
log_command() {
    local command="$*"
    log_debug "Executing: $command"

    local output
    local exit_code

    if output=$("$@" 2>&1); then
        exit_code=0
        log_trace "Command output: $output"
    else
        exit_code=$?
        log_error "Command failed with exit code $exit_code: $command"
        log_error "Output: $output"
    fi

    return $exit_code
}

# Log file operations
log_file_operation() {
    local operation=$1
    local file=$2
    shift 2
    local details="$*"

    log_debug "File $operation: $file $details"
}

# Progress logging
log_progress() {
    local current=$1
    local total=$2
    local message=${3:-"Progress"}

    local percentage=$((current * 100 / total))
    log_info "$message: $current/$total ($percentage%)"
}

# Structured logging (JSON-like)
log_structured() {
    local level=$1
    shift

    local json="{"
    local first=true

    while [[ $# -gt 0 ]]; do
        if [[ "$first" != "true" ]]; then
            json="$json, "
        fi
        json="$json\"$1\":\"$2\""
        first=false
        shift 2
    done

    json="$json}"

    log "$level" "$json"
}

# Log separator for visual clarity
log_separator() {
    local char=${1:-"-"}
    local width=${2:-60}
    local separator=$(printf '%*s' "$width" | tr ' ' "$char")
    log_info "$separator"
}

# Log header
log_header() {
    local title=$1
    log_separator "="
    log_info "$title"
    log_separator "="
}

# Log section
log_section() {
    local title=$1
    log_separator "-"
    log_info "$title"
    log_separator "-"
}

# Set log level dynamically
set_log_level() {
    local level=$1
    CURRENT_LOG_LEVEL=$(get_log_level_num "$level")
    log_debug "Log level set to: $level"
}

# Get current log level name
get_log_level_name() {
    case "$CURRENT_LOG_LEVEL" in
        0) echo "TRACE" ;;
        1) echo "DEBUG" ;;
        2) echo "INFO" ;;
        3) echo "WARN" ;;
        4) echo "ERROR" ;;
        5) echo "FATAL" ;;
        *) echo "UNKNOWN" ;;
    esac
}

# Initialize logging on source
init_logging

# Export functions
export -f log
export -f log_trace
export -f log_debug
export -f log_info
export -f log_warn
export -f log_error
export -f log_fatal
export -f log_context
export -f log_command
export -f log_file_operation
export -f log_progress
export -f log_structured
export -f log_separator
export -f log_header
export -f log_section
export -f set_log_level
export -f get_log_level_name