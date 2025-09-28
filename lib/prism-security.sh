#!/bin/bash
# PRISM Security Library - Security functions for PRISM framework
# Version: 2.0.0

# Dependencies are loaded by the main script
# If running standalone, source them
if [[ -z "${PRISM_VERSION:-}" ]]; then
    source "$(dirname "${BASH_SOURCE[0]}")/prism-core.sh"
    source "$(dirname "${BASH_SOURCE[0]}")/prism-log.sh"
fi

# Security configuration
readonly PRISM_VERIFY_DOWNLOADS="${PRISM_VERIFY_DOWNLOADS:-true}"
readonly PRISM_CHECKSUM_URL="${PRISM_REPO}/releases/download/v${PRISM_VERSION}/checksums.txt"
readonly PRISM_SIGNATURE_URL="${PRISM_REPO}/releases/download/v${PRISM_VERSION}/checksums.txt.sig"
readonly PRISM_GPG_KEY="${PRISM_GPG_KEY:-}"

# Input validation patterns
readonly PATTERN_FILENAME='^[a-zA-Z0-9._-]+$'
readonly PATTERN_PATH='^[a-zA-Z0-9./_-]+$'
readonly PATTERN_VERSION='^[0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9]+)?$'
readonly PATTERN_URL='^https?://[a-zA-Z0-9.-]+(/[a-zA-Z0-9./_-]*)?$'

# Sanitize input based on type
sanitize_input() {
    local input=$1
    local type=${2:-text}

    case "$type" in
        filename)
            # Allow only alphanumeric, dots, underscores, and hyphens
            echo "$input" | sed 's/[^a-zA-Z0-9._-]//g'
            ;;
        path)
            # Allow path characters but prevent traversal
            echo "$input" | sed 's/[^a-zA-Z0-9./_-]//g' | sed 's/\.\.//g'
            ;;
        text)
            # Remove dangerous characters for shell execution
            echo "$input" | sed 's/[<>&|;`$(){}]//g'
            ;;
        url)
            # Basic URL sanitization
            echo "$input" | sed 's/[^a-zA-Z0-9.:/_?&=-]//g'
            ;;
        version)
            # Version string sanitization
            echo "$input" | sed 's/[^0-9a-zA-Z.-]//g'
            ;;
        *)
            log_warn "Unknown sanitization type: $type"
            echo "$input" | sed 's/[^a-zA-Z0-9._-]//g'
            ;;
    esac
}

# Validate input against patterns
validate_input() {
    local input=$1
    local type=$2

    case "$type" in
        filename)
            [[ "$input" =~ $PATTERN_FILENAME ]]
            ;;
        path)
            [[ "$input" =~ $PATTERN_PATH ]] && [[ "$input" != *".."* ]]
            ;;
        version)
            [[ "$input" =~ $PATTERN_VERSION ]]
            ;;
        url)
            [[ "$input" =~ $PATTERN_URL ]]
            ;;
        email)
            [[ "$input" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]
            ;;
        *)
            log_warn "Unknown validation type: $type"
            return 1
            ;;
    esac
}

# Validate and resolve path (prevent traversal)
validate_path() {
    local path=$1
    local base_dir=${2:-$PWD}

    # Remove any .. sequences
    path=$(echo "$path" | sed 's/\.\.//g')

    # Make absolute if relative
    if [[ "$path" != /* ]]; then
        path="${base_dir}/${path}"
    fi

    # Resolve to real path
    if command -v realpath &> /dev/null; then
        path=$(realpath "$path" 2>/dev/null) || return 1
    fi

    # Ensure path is within allowed directory
    if [[ -n "$base_dir" ]]; then
        if [[ "$path" != "$base_dir"* ]]; then
            log_error "Path traversal detected: $path is outside $base_dir"
            return 1
        fi
    fi

    echo "$path"
}

# Calculate checksum of file
calculate_checksum() {
    local file=$1
    local algorithm=${2:-sha256}

    if [[ ! -f "$file" ]]; then
        log_error "File not found for checksum: $file"
        return 1
    fi

    case "$algorithm" in
        sha256)
            if command -v sha256sum &> /dev/null; then
                sha256sum "$file" | cut -d' ' -f1
            elif command -v shasum &> /dev/null; then
                shasum -a 256 "$file" | cut -d' ' -f1
            else
                log_error "No SHA256 command available"
                return 1
            fi
            ;;
        md5)
            if command -v md5sum &> /dev/null; then
                md5sum "$file" | cut -d' ' -f1
            elif command -v md5 &> /dev/null; then
                md5 -q "$file"
            else
                log_error "No MD5 command available"
                return 1
            fi
            ;;
        *)
            log_error "Unsupported checksum algorithm: $algorithm"
            return 1
            ;;
    esac
}

# Verify file checksum
verify_checksum() {
    local file=$1
    local expected_hash=$2
    local algorithm=${3:-sha256}

    local actual_hash
    actual_hash=$(calculate_checksum "$file" "$algorithm")

    if [[ "$actual_hash" != "$expected_hash" ]]; then
        log_error "Checksum verification failed for $file"
        log_error "Expected: $expected_hash"
        log_error "Actual: $actual_hash"
        return 1
    fi

    log_info "✅ Checksum verified: $(basename "$file")"
    return 0
}

# Download file with verification
secure_download() {
    local url=$1
    local output=$2
    local expected_hash=${3:-}

    # Validate URL
    if ! validate_input "$url" "url"; then
        log_error "Invalid URL: $url"
        return 1
    fi

    # Create temporary file
    local temp_file
    temp_file=$(mktemp)

    # Download file
    log_info "Downloading: $url"
    if ! curl -fsSL --max-time 300 "$url" -o "$temp_file"; then
        log_error "Download failed: $url"
        rm -f "$temp_file"
        return 1
    fi

    # Verify checksum if provided
    if [[ -n "$expected_hash" ]]; then
        if ! verify_checksum "$temp_file" "$expected_hash"; then
            rm -f "$temp_file"
            return 1
        fi
    else
        log_warn "No checksum provided for verification"
    fi

    # Move to final location
    mv "$temp_file" "$output"
    log_info "✅ Downloaded: $(basename "$output")"
    return 0
}

# Verify GPG signature
verify_signature() {
    local file=$1
    local signature=$2

    # Check if GPG is available
    if ! command -v gpg &> /dev/null; then
        log_warn "GPG not available, skipping signature verification"
        return 0
    fi

    # Import PRISM GPG key if specified
    if [[ -n "$PRISM_GPG_KEY" ]]; then
        echo "$PRISM_GPG_KEY" | gpg --import 2>/dev/null
    fi

    # Verify signature
    if gpg --verify "$signature" "$file" 2>/dev/null; then
        log_info "✅ GPG signature verified"
        return 0
    else
        log_error "❌ GPG signature verification failed"
        return 1
    fi
}

# Download and verify PRISM checksums
download_checksums() {
    local checksums_file="${PRISM_HOME}/checksums.txt"
    local signature_file="${PRISM_HOME}/checksums.txt.sig"

    # Download checksums
    if ! secure_download "$PRISM_CHECKSUM_URL" "$checksums_file"; then
        return 1
    fi

    # Download signature (optional)
    if [[ -n "$PRISM_GPG_KEY" ]]; then
        if secure_download "$PRISM_SIGNATURE_URL" "$signature_file"; then
            verify_signature "$checksums_file" "$signature_file"
        fi
    fi

    echo "$checksums_file"
}

# Get expected checksum from checksums file
get_expected_checksum() {
    local filename=$1
    local checksums_file=$2

    if [[ ! -f "$checksums_file" ]]; then
        log_error "Checksums file not found: $checksums_file"
        return 1
    fi

    # Extract checksum for specific file
    grep "$(basename "$filename")" "$checksums_file" | cut -d' ' -f1
}

# Secure script execution
secure_execute() {
    local script=$1
    shift
    local args=("$@")

    # Validate script path
    script=$(validate_path "$script") || return 1

    # Check script exists and is readable
    if [[ ! -r "$script" ]]; then
        log_error "Script not found or not readable: $script"
        return 1
    fi

    # Check for suspicious patterns
    if grep -qE '(rm -rf /|dd if=/dev/zero|:(){ :|:&}|wget.*\|.*sh)' "$script"; then
        log_error "Suspicious patterns detected in script: $script"
        return 1
    fi

    # Execute in restricted environment
    (
        # Restrict PATH
        PATH="/usr/local/bin:/usr/bin:/bin"

        # Clear dangerous environment variables
        unset LD_PRELOAD
        unset LD_LIBRARY_PATH
        unset DYLD_INSERT_LIBRARIES

        # Execute script
        bash "$script" "${args[@]}"
    )
}

# Check for security vulnerabilities
security_scan() {
    local target=$1
    local errors=0

    log_info "🔍 Running security scan on: $target"

    # Check for world-writable files
    if find "$target" -type f -perm -002 2>/dev/null | grep -q .; then
        log_warn "Found world-writable files in $target"
        ((errors++))
    fi

    # Check for setuid/setgid files
    if find "$target" -type f \( -perm -4000 -o -perm -2000 \) 2>/dev/null | grep -q .; then
        log_warn "Found setuid/setgid files in $target"
        ((errors++))
    fi

    # Check for sensitive data patterns
    if grep -rE '(password|secret|token|api_key)\s*=\s*["\x27][^\x27"]+["\x27]' "$target" 2>/dev/null | grep -q .; then
        log_warn "Potential sensitive data found in $target"
        ((errors++))
    fi

    if [[ $errors -eq 0 ]]; then
        log_info "✅ Security scan passed"
    else
        log_warn "⚠️ Security scan found $errors issues"
    fi

    return $errors
}

# Generate secure random string
generate_random_string() {
    local length=${1:-32}

    if command -v openssl &> /dev/null; then
        openssl rand -hex "$((length/2))"
    elif [[ -f /dev/urandom ]]; then
        tr -dc 'a-zA-Z0-9' < /dev/urandom | head -c "$length"
    else
        # Fallback to less secure method
        date +%s%N | sha256sum | head -c "$length"
    fi
}

# Encrypt sensitive data
encrypt_data() {
    local data=$1
    local key=${2:-$PRISM_ENCRYPTION_KEY}

    if [[ -z "$key" ]]; then
        log_error "No encryption key provided"
        return 1
    fi

    if command -v openssl &> /dev/null; then
        echo "$data" | openssl enc -aes-256-cbc -salt -pass pass:"$key" -base64
    else
        log_warn "OpenSSL not available, storing data unencrypted"
        echo "$data"
    fi
}

# Decrypt sensitive data
decrypt_data() {
    local encrypted=$1
    local key=${2:-$PRISM_ENCRYPTION_KEY}

    if [[ -z "$key" ]]; then
        log_error "No decryption key provided"
        return 1
    fi

    if command -v openssl &> /dev/null; then
        echo "$encrypted" | openssl enc -aes-256-cbc -d -salt -pass pass:"$key" -base64
    else
        echo "$encrypted"
    fi
}

# Export functions
export -f sanitize_input
export -f validate_input
export -f validate_path
export -f calculate_checksum
export -f verify_checksum
export -f secure_download
export -f verify_signature
export -f download_checksums
export -f get_expected_checksum
export -f secure_execute
export -f security_scan
export -f generate_random_string
export -f encrypt_data
export -f decrypt_data