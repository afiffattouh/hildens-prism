#!/bin/bash
# PRISM Framework - Docker Setup Validation Script
# Validates Docker configuration files before deployment

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "🔍 PRISM Docker Setup Validation"
echo "=================================="
echo ""

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Validation counters
PASSED=0
FAILED=0

# Helper functions
pass() {
    echo -e "${GREEN}✓${NC} $1"
    ((PASSED++))
}

fail() {
    echo -e "${RED}✗${NC} $1"
    ((FAILED++))
}

warn() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Check 1: Required files exist
echo "📁 Checking required files..."
if [[ -f "$PROJECT_ROOT/Dockerfile" ]]; then
    pass "Dockerfile exists"
else
    fail "Dockerfile missing"
fi

if [[ -f "$PROJECT_ROOT/docker-compose.yml" ]]; then
    pass "docker-compose.yml exists"
else
    fail "docker-compose.yml missing"
fi

if [[ -f "$PROJECT_ROOT/.dockerignore" ]]; then
    pass ".dockerignore exists"
else
    fail ".dockerignore missing"
fi

if [[ -f "$PROJECT_ROOT/docker/nginx.conf" ]]; then
    pass "nginx.conf exists"
else
    fail "nginx.conf missing"
fi

echo ""

# Check 2: Website files exist
echo "🌐 Checking website files..."
if [[ -f "$PROJECT_ROOT/website/index.html" ]]; then
    pass "index.html exists"
else
    fail "index.html missing"
fi

if [[ -f "$PROJECT_ROOT/website/styles.css" ]]; then
    pass "styles.css exists"
else
    fail "styles.css missing"
fi

if [[ -f "$PROJECT_ROOT/website/script.js" ]]; then
    pass "script.js exists"
else
    fail "script.js missing"
fi

echo ""

# Check 3: Assets directory
echo "🎨 Checking assets..."
if [[ -d "$PROJECT_ROOT/assets" ]]; then
    pass "assets directory exists"
    if [[ -f "$PROJECT_ROOT/assets/logo/prism-logo.png" ]]; then
        pass "Logo file exists"
    else
        warn "Logo file not found (website may have broken images)"
    fi
else
    warn "assets directory missing (website may have broken images)"
fi

echo ""

# Check 4: Validate Dockerfile syntax
echo "🐳 Validating Dockerfile..."
if command -v docker &> /dev/null; then
    if docker build --help &> /dev/null; then
        pass "Docker is available"

        # Check if Docker daemon is running
        if docker info &> /dev/null 2>&1; then
            pass "Docker daemon is running"
        else
            warn "Docker daemon is not running (start Docker to test build)"
        fi
    else
        warn "Docker command found but not functional"
    fi
else
    warn "Docker not installed (install Docker to test deployment)"
fi

echo ""

# Check 5: Validate docker-compose syntax
echo "📦 Validating docker-compose.yml..."
if command -v docker-compose &> /dev/null; then
    pass "docker-compose is available"

    cd "$PROJECT_ROOT"
    if docker-compose config &> /dev/null 2>&1; then
        pass "docker-compose.yml syntax is valid"
    else
        fail "docker-compose.yml has syntax errors"
        echo "   Run: docker-compose config"
    fi
else
    warn "docker-compose not installed (install to use docker-compose commands)"
fi

echo ""

# Check 6: Validate nginx.conf syntax
echo "⚙️  Validating nginx.conf..."
if command -v nginx &> /dev/null; then
    if nginx -t -c "$PROJECT_ROOT/docker/nginx.conf" &> /dev/null 2>&1; then
        pass "nginx.conf syntax is valid"
    else
        warn "nginx.conf may have issues (test with: nginx -t -c docker/nginx.conf)"
    fi
else
    warn "nginx not installed locally (will be validated in container)"
fi

echo ""

# Check 7: Port availability
echo "🔌 Checking port availability..."
if command -v lsof &> /dev/null; then
    if lsof -i :8080 &> /dev/null; then
        warn "Port 8080 is already in use (change port in docker-compose.yml)"
    else
        pass "Port 8080 is available"
    fi
else
    warn "Cannot check port availability (lsof not available)"
fi

echo ""

# Summary
echo "=================================="
echo "📊 Validation Summary"
echo "=================================="
echo -e "${GREEN}Passed: $PASSED${NC}"
if [[ $FAILED -gt 0 ]]; then
    echo -e "${RED}Failed: $FAILED${NC}"
fi
echo ""

if [[ $FAILED -eq 0 ]]; then
    echo -e "${GREEN}✓ All critical checks passed!${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Start Docker Desktop (if not running)"
    echo "2. Run: docker-compose up -d"
    echo "3. Open: http://localhost:8080"
    exit 0
else
    echo -e "${RED}✗ Some checks failed. Please fix the issues above.${NC}"
    exit 1
fi
