# TOON Best Practices Guide
**Version**: 2.4.0
**Created**: 2024-11-05
**Status**: PRODUCTION READY
**Tags**: [toon, best-practices, optimization, guidelines]

## Executive Summary

This guide provides comprehensive best practices for using TOON (Token-Oriented Object Notation) in PRISM Framework to achieve optimal token savings (40-50%) while maintaining code quality and system reliability.

**Key Principles:**
- 🎯 Use TOON for structured data, not prose
- 📊 Leverage tabular arrays for uniform records
- ⚡ Enable feature flags for component-level control
- 🔄 Maintain backward compatibility with human formats
- ✅ Validate conversions before production use

## Table of Contents

1. [When to Use TOON](#when-to-use-toon)
2. [When NOT to Use TOON](#when-not-to-use-toon)
3. [Format Selection Guidelines](#format-selection-guidelines)
4. [Performance Optimization](#performance-optimization)
5. [Feature Flag Management](#feature-flag-management)
6. [Testing and Validation](#testing-and-validation)
7. [Troubleshooting](#troubleshooting)
8. [Production Deployment](#production-deployment)

---

## 1. When to Use TOON

### ✅ Ideal Use Cases

#### Agent Configurations
**Token Savings**: 40-53%

```bash
# Perfect for agent lists with consistent fields
agents[3]{id,type,status,priority}:
 agent_001,architect,active,high
 agent_002,coder,idle,medium
 agent_003,tester,active,high
```

**Why**: Uniform structure, repetitive field names, high frequency.

#### Context Metadata
**Token Savings**: 49%

```bash
# Excellent for context file listings
contexts.critical[3]{file,priority,action}:
 architecture.md,CRITICAL,MUST_READ
 security.md,CRITICAL,MUST_FOLLOW
 domain.md,CRITICAL,MUST_UNDERSTAND
```

**Why**: Consistent schema, many records, frequent Claude interactions.

#### Session History
**Token Savings**: 44%

```bash
# Great for session tracking
sessions[5]{id,status,started,operations}:
 20241105-100000,ARCHIVED,2024-11-05T10:00:00Z,25
 20241105-110000,ARCHIVED,2024-11-05T11:00:00Z,30
 20241105-120000,ACTIVE,2024-11-05T12:00:00Z,15
```

**Why**: Tabular structure, repeated access patterns.

#### Skills Metadata
**Token Savings**: 30-40%

```bash
# Useful for skill listings
skills[5]{name,category,enabled,priority}:
 test-runner,testing,true,high
 context-summary,documentation,true,medium
 session-save,workflow,true,high
```

**Why**: Consistent format, frequent queries.

### Decision Criteria Checklist

Use TOON if data meets **3+ of these criteria**:

- [ ] Array of 3+ objects with uniform structure
- [ ] Same fields across all records
- [ ] Frequent transmission to Claude
- [ ] Simple scalar values (not deeply nested objects)
- [ ] Token count > 100 tokens in JSON format
- [ ] Performance-critical operation

---

## 2. When NOT to Use TOON

### ❌ Avoid TOON For

#### Prose and Documentation
```markdown
# ❌ BAD: Don't convert markdown/prose to TOON
patterns.md content stays as readable markdown
NOT as TOON-encoded text blocks
```

**Why**: TOON optimized for structured data, not natural language.

#### Irregular/Nested Structures
```json
// ❌ BAD: Highly variable structure
{
  "agent_001": {"type": "architect", "tasks": {...}},
  "agent_002": {"status": "idle", "metrics": {...}},
  "agent_003": {"priority": "high", "config": {...}}
}
```

**Why**: Non-uniform fields defeat TOON's compression advantages.

#### Single Records
```bash
# ❌ BAD: Single record doesn't benefit from TOON
agent:
 id: agent_001
 type: architect
 status: active
```

**Why**: Minimal token savings, added complexity not worth it.

#### Deeply Nested Hierarchies
```json
// ❌ BAD: Complex nesting
{
  "level1": {
    "level2": {
      "level3": {
        "level4": ["data"]
      }
    }
  }
}
```

**Why**: TOON best for flat/simple nesting, not deep hierarchies.

#### One-Time Data
**Token Savings**: Not applicable

**Why**: Conversion overhead > benefit for single-use data.

### Avoidance Criteria Checklist

DO NOT use TOON if data has **2+ of these**:

- [ ] Prose, documentation, or natural language
- [ ] Single record or < 3 items
- [ ] Highly variable structure across records
- [ ] Deeply nested (4+ levels)
- [ ] Used only once
- [ ] Performance not critical

---

## 3. Format Selection Guidelines

### Automatic Format Detection

PRISM TOON library includes intelligent format detection:

```bash
# Automatic detection example
toon_detect_format "$json_data"
# Returns: toon_tabular | toon_nested | keep_original
```

**Detection Logic:**
1. **toon_tabular**: Array of 3+ uniform objects → Best savings (40-60%)
2. **toon_nested**: Some structure, moderate uniformity → Good savings (25-40%)
3. **keep_original**: Irregular, prose, or single records → No conversion

### Manual Format Override

```bash
# Force TOON conversion (use cautiously)
toon_optimize "$data" "agent" --force

# Disable TOON for specific operation
export PRISM_TOON_ENABLED=false
prism agent list  # Uses original format
```

### Format Selection Decision Tree

```
Data Structure
    │
    ├─ Array of uniform objects? ────YES──▶ toon_tabular (Excellent)
    │   (3+ items, same fields)
    │
    ├─ Regular nested structure? ────YES──▶ toon_nested (Good)
    │   (Consistent patterns)
    │
    ├─ Irregular/variable? ──────────YES──▶ keep_original (No benefit)
    │   (Mixed fields, deep nesting)
    │
    └─ Prose/documentation? ─────────YES──▶ keep_original (Wrong use case)
        (Natural language text)
```

---

## 4. Performance Optimization

### Target Performance Benchmarks

| Operation Type | Target | Status |
|----------------|--------|--------|
| Standard conversions (3-10 items) | < 50ms | ✅ Achieved |
| Large datasets (50+ items) | < 100ms | ✅ Achieved |
| Format detection | < 10ms | ✅ Achieved |
| End-to-end pipeline | < 50ms | ✅ Achieved (26ms avg) |

### Cache Strategy

**Automatic Caching:**
```bash
# Cache directory (automatic)
$PRISM_HOME/.prism/.toon-cache/

# Clear cache manually
prism toon clear-cache
```

**When to Clear Cache:**
- After updating TOON library
- When experiencing conversion errors
- During development/testing
- Monthly maintenance (recommended)

### Lazy Conversion Pattern

```bash
# ✅ GOOD: Convert only when sending to Claude
generate_agent_prompt() {
    # Keep data in original format internally
    local agent_config=$(load_agent_config "$agent_id")

    # Convert to TOON only at prompt generation
    local toon_config=$(toon_optimize "$agent_config" "agent")

    # Embed in prompt for Claude
    echo "Agent Config: $toon_config"
}
```

**Why**: Internal processing uses native formats; TOON only for Claude interactions.

### Batch Conversion Optimization

```bash
# ✅ GOOD: Batch similar conversions
toon_optimize_batch "$agent_list" "$context_list" "$session_list"

# ❌ BAD: Individual conversions in loop
for agent in $agent_list; do
    toon_optimize "$agent" "agent"  # Inefficient
done
```

### Performance Monitoring

```bash
# Check TOON usage statistics
prism toon stats

# Output example:
# ────────────────────────────────────
# Component         Token Savings
# ────────────────────────────────────
# Agents            40-53%
# Context           49%
# Sessions          44%
# Average           41-49%
# ────────────────────────────────────
```

---

## 5. Feature Flag Management

### Available Feature Flags

```bash
# Global TOON enable/disable
export PRISM_TOON_ENABLED=true|false

# Component-specific flags
export PRISM_TOON_AGENTS=true|false
export PRISM_TOON_CONTEXT=true|false
export PRISM_TOON_SESSION=true|false

# Development mode flags
export PRISM_TOON_DEBUG=true     # Show both formats
export PRISM_TOON_VALIDATE=true  # Extra validation
```

### Recommended Configuration

#### Production Environment
```bash
# Enable all production-ready components
export PRISM_TOON_ENABLED=true
export PRISM_TOON_AGENTS=true
export PRISM_TOON_CONTEXT=true
export PRISM_TOON_SESSION=true
export PRISM_TOON_DEBUG=false
```

#### Development Environment
```bash
# Enable with debugging
export PRISM_TOON_ENABLED=true
export PRISM_TOON_DEBUG=true
export PRISM_TOON_VALIDATE=true
```

#### Testing/Staging
```bash
# Gradual rollout
export PRISM_TOON_ENABLED=true
export PRISM_TOON_AGENTS=true     # Phase 2 stable
export PRISM_TOON_CONTEXT=false   # Testing phase
export PRISM_TOON_SESSION=false   # Testing phase
```

### Feature Flag Best Practices

1. **Start Disabled**: New users should start with `PRISM_TOON_ENABLED=false`
2. **Gradual Enablement**: Enable one component at a time
3. **Monitor Impact**: Check token usage before/after enablement
4. **Document Decisions**: Note why flags are set in team docs
5. **Consistent Environments**: Keep flags consistent across dev/staging/prod

### Rollback Strategy

```bash
# Quick rollback if issues detected
export PRISM_TOON_ENABLED=false

# Or per-component rollback
export PRISM_TOON_AGENTS=false  # Disable only agents

# Verify rollback
prism toon stats  # Should show TOON disabled
```

---

## 6. Testing and Validation

### Pre-Deployment Validation

**1. Format Validation**
```bash
# Validate TOON syntax before use
prism toon validate output.toon

# Output:
# ✅ TOON syntax valid
# ✅ Field counts match declarations
# ✅ Indentation consistent
```

**2. Token Savings Benchmark**
```bash
# Measure actual savings
prism toon benchmark input.json

# Output:
# Original: 150 tokens
# TOON:     75 tokens
# Savings:  50%
```

**3. Round-Trip Testing**
```bash
# Verify data integrity
original=$(cat data.json)
toon_version=$(toon_optimize "$original" "generic")
reconstructed=$(toon_deserialize "$toon_version")

# Compare (should be identical)
diff <(echo "$original" | jq -S) <(echo "$reconstructed" | jq -S)
```

### Integration Testing

**Run Phase-Specific Tests:**
```bash
# Test all TOON integrations
./tests/toon/test-toon-agents.sh      # Phase 2
./tests/toon/test-toon-context.sh     # Phase 3
./tests/toon/test-toon-cli.sh         # Phase 4
./tests/toon/test-toon-session.sh     # Phase 5
./tests/toon/test-toon-performance.sh # Phase 6

# All tests should pass 100%
```

### Continuous Monitoring

```bash
# Periodic validation (recommended: weekly)
prism toon stats          # Check usage patterns
prism toon clear-cache    # Refresh conversions
prism toon validate all   # Validate all cached TOON
```

---

## 7. Troubleshooting

### Common Issues and Solutions

#### Issue 1: Conversion Errors

**Symptom:** `toon_optimize` fails or returns empty

**Diagnosis:**
```bash
# Enable debug mode
export PRISM_TOON_DEBUG=true
toon_optimize "$data" "agent"  # See detailed error
```

**Solutions:**
- Check data is valid JSON/YAML
- Verify data structure is uniform
- Try `toon_detect_format` to check suitability
- Use `toon_safe_convert` for automatic fallback

#### Issue 2: Poor Token Savings

**Symptom:** Token savings < 20%

**Diagnosis:**
```bash
# Benchmark specific data
prism toon benchmark input.json

# Check format detection
toon_detect_format "$data"
# Should return: toon_tabular or toon_nested
```

**Solutions:**
- Verify data has uniform structure (3+ items, same fields)
- Check for deeply nested objects (flatten if possible)
- Consider if data is suitable for TOON (see "When NOT to Use")

#### Issue 3: Cache Issues

**Symptom:** Stale or incorrect TOON output

**Solutions:**
```bash
# Clear TOON cache
prism toon clear-cache

# Verify cache cleared
ls -la $PRISM_HOME/.prism/.toon-cache/  # Should be empty

# Re-run conversion
toon_optimize "$data" "agent"
```

#### Issue 4: Feature Flag Not Working

**Symptom:** TOON still active after setting `PRISM_TOON_ENABLED=false`

**Diagnosis:**
```bash
# Check effective flags
env | grep PRISM_TOON

# Verify in code
toon_is_enabled "agent"  # Should return false
```

**Solutions:**
- Export flags (not just set): `export PRISM_TOON_ENABLED=false`
- Check component-specific flags override global flag
- Restart shell session to clear old exports

#### Issue 5: Performance Degradation

**Symptom:** Operations slower than expected (> 50ms)

**Diagnosis:**
```bash
# Run performance tests
./tests/toon/test-toon-performance.sh

# Check for large datasets (> 100 items)
echo "$data" | jq 'length'
```

**Solutions:**
- Use caching for frequently converted data
- Consider batch conversion for multiple operations
- Split very large datasets (> 100 items) into chunks
- Verify Python3 is available for performance measurements

### Debug Mode Output

```bash
# Enable comprehensive debugging
export PRISM_TOON_DEBUG=true
export PRISM_TOON_VALIDATE=true

# Example debug output
toon_optimize "$data" "agent"
# ───────────────────────────────────
# 🔍 TOON Debug Mode
# ───────────────────────────────────
# Input format: JSON
# Detected structure: toon_tabular
# Field count: 4 (id, type, status, priority)
# Record count: 3
# Original tokens: 89
# TOON tokens: 35
# Savings: 61%
# ───────────────────────────────────
```

---

## 8. Production Deployment

### Pre-Deployment Checklist

#### Phase 1: Validation ✅
- [ ] All integration tests passing (100%)
- [ ] Performance benchmarks meet targets (< 50ms avg)
- [ ] Token savings validated (40-50% avg)
- [ ] Round-trip testing successful (no data loss)
- [ ] Cache system functional

#### Phase 2: Configuration ✅
- [ ] Feature flags configured correctly
- [ ] Environment variables documented
- [ ] Rollback plan prepared and tested
- [ ] Monitoring alerts configured
- [ ] Team trained on TOON usage

#### Phase 3: Deployment Strategy
```bash
# Week 1: Development environment
export PRISM_TOON_ENABLED=true
export PRISM_TOON_AGENTS=true
# Monitor for issues, gather feedback

# Week 2: Staging environment
export PRISM_TOON_CONTEXT=true
# Validate with staging workloads

# Week 3: Production (10% traffic)
export PRISM_TOON_ENABLED=true  # 10% users
# Monitor performance, error rates, user feedback

# Week 4: Production (100% traffic)
export PRISM_TOON_ENABLED=true  # All users
# Full rollout with continued monitoring
```

### Deployment Best Practices

#### 1. Gradual Rollout
- Enable one component at a time
- Monitor each phase for 3-7 days
- Validate metrics before next phase

#### 2. Monitoring Metrics
```bash
# Key metrics to track
- Token usage: Should decrease 40-50%
- Conversion errors: Should be < 0.1%
- Performance: Should be < 50ms avg
- User satisfaction: No degradation
- Claude accuracy: Maintain or improve
```

#### 3. Rollback Triggers

Rollback if any of these occur:
- Conversion error rate > 1%
- Performance degradation > 20%
- User-reported issues > 5% increase
- Claude accuracy decrease > 5%
- Critical bug in TOON library

#### 4. Success Criteria

TOON deployment successful if:
- ✅ Token savings: 40-50% achieved
- ✅ Performance: < 50ms conversions
- ✅ Error rate: < 0.1%
- ✅ User satisfaction: No decrease
- ✅ System stability: No regressions

### Post-Deployment Operations

#### Daily
- Monitor error logs for TOON-related issues
- Check performance metrics dashboard

#### Weekly
- Review token usage statistics (`prism toon stats`)
- Validate cache effectiveness
- Check for stale cache entries

#### Monthly
- Clear TOON cache (`prism toon clear-cache`)
- Re-run comprehensive test suites
- Review and update best practices based on learnings

---

## Summary: Quick Reference

### ✅ DO

1. **Use TOON for:**
   - Agent configurations (40-53% savings)
   - Context metadata (49% savings)
   - Session history (44% savings)
   - Uniform data arrays (3+ items)

2. **Enable feature flags:**
   - `PRISM_TOON_ENABLED=true` (global)
   - Component-specific as needed

3. **Test before production:**
   - Run integration tests
   - Benchmark token savings
   - Validate conversions

4. **Monitor performance:**
   - Check `prism toon stats` regularly
   - Clear cache monthly
   - Track error rates

### ❌ DON'T

1. **Avoid TOON for:**
   - Prose and documentation
   - Single records (< 3 items)
   - Irregular/nested structures
   - One-time data

2. **Don't skip:**
   - Validation testing
   - Gradual rollout
   - Performance monitoring
   - Rollback planning

3. **Don't assume:**
   - All data suits TOON
   - Conversions are instant
   - Cache is always fresh
   - Feature flags propagate immediately

### Performance Targets

| Metric | Target | Status |
|--------|--------|--------|
| Token Savings (avg) | 40-50% | ✅ 41-49% |
| Conversion Time | < 50ms | ✅ 26ms avg |
| Error Rate | < 0.1% | ✅ 0% |
| Test Pass Rate | 100% | ✅ 100% |

---

## Appendix: Command Reference

### CLI Commands

```bash
# Conversion
prism toon convert <input> [output]   # Convert JSON/YAML to TOON
prism toon benchmark <input>          # Show token savings
prism toon validate <toon-file>       # Validate TOON syntax

# Management
prism toon clear-cache                # Clear conversion cache
prism toon stats                      # Show usage statistics
prism toon help                       # Complete help system
prism toon demo                       # Interactive examples

# Component-Specific
prism agent list --toon               # Agent list in TOON
prism context list-toon               # Context list in TOON
prism session status --toon           # Session status in TOON
prism session list-toon [max]         # Session history in TOON
```

### Library Functions

```bash
# Format Detection
toon_detect_format "$json_data"       # Auto-detect best format

# Optimization
toon_optimize "$data" "type"          # Convert to TOON
toon_safe_convert "$data"             # With fallback

# Validation
toon_is_enabled "component"           # Check feature flag
toon_validate "$toon_data"            # Validate TOON syntax

# Utilities
toon_estimate_tokens "$data"          # Estimate token count
```

---

## Support and Resources

### Documentation
- Design Doc: `.prism/context/toon-integration-design.md`
- Phase Summaries: `.prism/context/toon-phase{2-5}-summary.md`
- Test Suites: `tests/toon/test-toon-*.sh`

### Getting Help
1. Review this best practices guide
2. Check troubleshooting section above
3. Run `prism toon help` for command reference
4. Review phase summaries for implementation details
5. Check test suites for usage examples

### Contributing
- Report issues with TOON conversion
- Suggest improvements to detection algorithms
- Share new use cases and patterns
- Contribute test cases for edge conditions

---

**Version History:**
- v2.4.0 (2024-11-05): Initial production release with Phase 2-6 complete
- Phase 2: Agent Integration (40-53% savings)
- Phase 3: Context Integration (49% savings)
- Phase 4: CLI & Tools (7 commands)
- Phase 5: Session Integration (44% savings)
- Phase 6: Optimization & Polish (best practices)

**Maintained by**: PRISM Framework Team
**Last Updated**: 2024-11-05
**Status**: ✅ Production Ready
