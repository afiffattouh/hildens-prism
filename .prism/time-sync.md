# Time Synchronization Protocol

## Purpose
Ensure accurate timestamps across all development activities by synchronizing with web-based time sources during initialization.

## Why This Matters
- **Accurate Logging**: Precise timestamps for debugging and audit trails
- **Session Management**: Correct ordering of session archives
- **Collaboration**: Synchronized timestamps across team members
- **Compliance**: Accurate time records for regulatory requirements
- **Context Expiry**: Proper pruning of outdated context

## Synchronization Process

### 1. On Initialization
```yaml
claude_init_commands:
  - WebSearch: "current UTC time"
  - WebSearch: "current time [timezone]"
  - Compare: web_time vs system_time
  - Decision: use_most_accurate_source
```

### 2. Time Source Priority
1. **Primary**: Web search result for current UTC time
2. **Secondary**: NTP server response (if available)
3. **Fallback**: System time (with drift warning)

### 3. Drift Detection
```yaml
drift_thresholds:
  acceptable: <1 minute
  warning: 1-5 minutes
  critical: >5 minutes

on_drift_detected:
  warning: Log discrepancy, use web time
  critical: Alert user, require confirmation
```

## Implementation in Claude

### During Session Start
```markdown
# Claude should automatically:
1. Perform WebSearch: "current UTC time"
2. Parse result to extract accurate timestamp
3. Compare with system time from environment
4. If drift >5 minutes, alert user
5. Use web time for all subsequent timestamps
```

### Example Web Search Pattern
```
Query: "current UTC time"
Expected: "Current UTC time is 2024-XX-XX HH:MM:SS"
Parse: Extract ISO 8601 format
Store: .claude/.time_sync
```

### Timestamp Format Standards
```yaml
format: ISO 8601
pattern: "YYYY-MM-DDTHH:mm:ssZ"
timezone: Always include offset
storage: UTC internally, local for display
```

## Usage in Context Files

### All context files should include:
```markdown
**Last Updated**: [Web-synchronized timestamp]
**Created**: [Web-synchronized timestamp]
**Session**: [Session ID with timestamp]
```

### Session Archives:
```markdown
sessions/history/session_[YYYYMMDD]_[HHMMSS].md
```

### Audit Trail:
```markdown
.claude/audit/[YYYY]/[MM]/[DD]/activity.log
```

## Validation Commands

### Check Time Sync Status
```bash
# In shell script
./claude-context.sh status
# Shows last sync time and any drift warnings
```

### Manual Time Sync
```bash
# Force resync
./claude-context.sh sync-time
```

## Error Handling

### If Web Search Fails:
1. Retry with alternative query: "what time is it UTC"
2. Try timezone-specific: "current time New York"
3. Fall back to system time with warning
4. Log failure in .claude/.time_sync_errors

### If Large Drift Detected:
1. Alert user immediately
2. Show both times for comparison
3. Ask which source to trust
4. Document decision in context

## Best Practices

1. **Always sync on init** - Never skip time synchronization
2. **Log all timestamps** - Use synchronized time for all logs
3. **Check drift periodically** - Re-sync if session >4 hours
4. **Document timezone** - Always include timezone in timestamps
5. **Archive with precision** - Use full timestamp in archive names

## Integration with Development

### Commit Messages:
```bash
# Include synchronized timestamp
git commit -m "feat: add feature (AI-assisted)

Timestamp: [Web-synchronized ISO 8601]
Session: [Session ID]"
```

### Code Comments:
```javascript
// Last modified: [Web-synchronized timestamp]
// Session: [Session ID]
```

### Documentation:
```markdown
<!-- Updated: [Web-synchronized timestamp] -->
<!-- Verified: [Web-synchronized timestamp] -->
```

---

*This protocol ensures all timestamps in the Claude framework are accurate and synchronized with real-world time.*