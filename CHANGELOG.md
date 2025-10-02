# Changelog

All notable changes to the PRISM Framework will be documented in this file.

## [2.2.0] - 2025-10-02

### Added
- **Enhanced Agent Prompt System** (`lib/prism-agent-prompts.sh`)
  - **11 Specialized Agent Types** with comprehensive, context-aware prompts:
    - 🏗️ **Architect Agent**: System architecture and design specialist
    - 💻 **Coder Agent**: Clean code implementation expert
    - 🧪 **Tester Agent**: Quality assurance and test strategy specialist
    - 🔍 **Reviewer Agent**: Code review and quality analysis expert
    - 📚 **Documenter Agent**: Technical documentation specialist
    - 🛡️ **Security Agent**: Security analysis and OWASP Top 10 expert
    - ⚡ **Performance Agent**: Performance optimization specialist
    - 🔧 **Refactorer Agent**: Code refactoring and quality improvement expert
    - 🐛 **Debugger Agent**: Bug fixing and root cause analysis specialist
    - 📋 **Planner Agent**: Task decomposition and orchestration expert
    - ⚡ **SPARC Agent**: Full SPARC methodology orchestrator

  - **Each agent includes**:
    - Detailed role description and expertise areas
    - Comprehensive 4-phase workflow (Analysis → Design → Implementation → Validation)
    - Quality standards and checklists
    - Output format specifications
    - Tool usage guidance
    - PRISM context integration instructions

- **Agent Prompt Integration**
  - Enhanced `execute_agent_action()` to use specialized prompts
  - Automatic context loading based on agent type
  - Tool permissions mapped to agent capabilities
  - Seamless integration with existing agent executor

### Improved
- **Agent System**: All 11 agent types now generate detailed, role-specific prompts
- **Context Awareness**: Each agent type loads relevant PRISM context automatically
- **Documentation**: README updated with comprehensive agent type table and capabilities
- **User Experience**: Enhanced prompts provide clear guidance and better task execution

## [2.1.0] - 2025-10-02

### Added
- **Resource Management System** - Complete safeguards for production use
  - Timeout mechanisms for agents (default: 300s) and swarms (default: 1800s)
  - Concurrent agent limits (configurable, default: 10)
  - Concurrent swarm limits (configurable, default: 3)
  - Disk space monitoring and quotas (default: 1GB)
  - Automatic cleanup policies (configurable retention period)
  - Resource tracking and status reporting
  - Force cleanup when disk usage is critical

- **PRISM Maintenance Utility** (`scripts/prism-maintenance.sh`)
  - Resource status monitoring
  - Automated cleanup with configurable retention
  - Disk optimization (compression, deduplication)
  - Resource counter reset
  - PRISM installation validation
  - Full maintenance mode
  - Dry-run support for safe testing

- **Claude Agent SDK Integration** (Enhanced)
  - Bash 3.x full compatibility (macOS tested)
  - Source guards preventing double-loading
  - Function-based tool permissions (no associative arrays)
  - File existence checks in context loading
  - Comprehensive error handling

### Fixed
- **Critical**: Bash 3.x PIPESTATUS compatibility in verification system
- **Critical**: Bash 3.x associative array compatibility in agent executor
- **High Priority**: Added missing log_success function to prism-log.sh
- **High Priority**: Added missing color constants for terminal output
- **Medium Priority**: Standardized sed syntax across all files (sed -i.bak)
- **Medium Priority**: Added file existence validation before loading contexts
- **Source Guards**: Prevented readonly variable conflicts on multiple sourcing

### Improved
- Agent execution workflow with timeout support
- Swarm orchestration with resource validation
- Cleanup on exit handlers for proper resource tracking
- Process monitoring with elapsed time logging
- Background process management with graceful termination

### Documentation
- Comprehensive code review document (15,000+ words)
- Test results summary with production readiness assessment
- Integration test suite (10 test cases, 481 lines)
- Maintenance utility usage guide
- Resource management configuration guide

### Testing
- Integration test framework created
- All 5 library files pass bash syntax validation
- Bash 3.2.57 compatibility confirmed (macOS)
- Resource management functionality validated

### Metrics
- Code Quality: B+ (Good)
- Anthropic Alignment: 92% (Excellent, up from 78%)
- Bash 3.x Compatibility: 100%
- Test Coverage: Integration framework implemented
- Critical Issues: 0 (all resolved)

## [2.0.8] - 2025-09-30

### Changed
- Updated version to 2.0.8

## [2.0.7] - 2025-09-29

### Changed
- Updated version to 2.0.7

## [2.0.6] - 2025-09-29

### Added
- **Complete Agent Orchestration System** - Multi-agent coordination for complex development tasks
- Specialized agents: architect, coder, tester, reviewer, security-auditor, performance-optimizer, refactorer, debugger, documenter, devops, ui-designer, data-modeler
- SPARC methodology integration (Specification, Pseudocode, Architecture, Refinement, Code)
- Four swarm topologies: parallel, pipeline, hierarchical, and mesh execution patterns
- Claude Code integration templates and context-aware agent instructions
- Agent capability matrix and intelligent task routing
- Comprehensive agent orchestration commands (`prism agent init/create/execute/list/cleanup`)
- Swarm management commands for coordinated multi-agent workflows
- Task decomposition engine for automatic agent assignment
- Agent communication protocols and message passing
- Examples and workflow patterns for agent orchestration

### Improved
- Enhanced PRISM binary with full agent command support
- Bash 3.2 compatibility for macOS systems (removed associative arrays)
- Agent system integration with existing PRISM context and configuration
- Documentation with comprehensive agent orchestration examples

### Fixed
- Infinite recursion in agent command dispatcher
- Missing agent library sourcing in main PRISM binary
- Force parameter passing in initialization commands

## [2.0.5] - 2025-09-29

### Added
- Selective overwrite feature for `prism init --force` command
- User prompts for overwriting modified context files during force initialization
- Protection for user-customized files in `.prism/context/` directory

### Fixed
- Force parameter not being passed correctly to prism_init function
- Missing force mode handling in initialization process

### Improved
- Force initialization now intelligently preserves user modifications
- Added file size detection to identify potentially modified files
- Core PRISM files update automatically while user files prompt for confirmation

## [2.0.4] - 2025-09-29

### Added
- Enhanced PRISM initialization for automatic Claude Code awareness
- PRISM activation markers (.prism_active and AUTO_LOAD files)
- Documentation structure enforcement preventing rogue .md files
- Troubleshooting guide (TROUBLESHOOTING_PRISM.md)
- Diagnostic script (scripts/diagnose-prism.sh)

### Improved
- CLAUDE.md template with mandatory PRISM directives
- Context files with automatic triggers and acknowledgment requirements
- index.yaml with Claude-specific instructions
- Comprehensive documentation location mapping

### Fixed
- PRISM.md location discrepancy (now correctly in .prism/ directory)
- README project structure documentation accuracy
- Timestamp tracking for Claude Code awareness
- Added .prism/TIMESTAMP file for tracking initialization and updates
- Fixed .prism_active to use actual timestamps instead of placeholder

## [2.0.3] - 2025-09-29

### Added
- Comprehensive README documentation with complete command reference
- Automated version update script (scripts/update-version.sh)
- UPDATE_ROUTINE.md for version management process
- Documentation structure enforcement in CLAUDE.md
- Strict rules preventing rogue .md files outside PRISM structure
- Clear documentation location mapping for all file types

### Improved
- Enhanced documentation coverage for all PRISM features
- Better command examples and usage instructions
- PRISM initialization now enforces documentation structure
- AUTO_LOAD file includes documentation structure rules
- CLAUDE.md explicitly forbids creating standalone documentation files

### Fixed
- Corrected PRISM.md location discrepancy in documentation
- PRISM.md now correctly placed in .prism/ directory, not project root
- Updated README to show accurate project structure

## [2.0.2] - 2025-09-29

### Changed
- Updated version number to 2.0.2

### Added
- Comprehensive README documentation covering all PRISM features
- Complete command reference with examples
- Detailed documentation for all command options and flags
- Configuration hierarchy and format documentation
- Common workflows and troubleshooting guide
- Automated version update script (scripts/update-version.sh)
- Internal UPDATE_ROUTINE.md for version management

## [2.0.1] - 2025-09-28

### Added
- Implemented `prism update` command for self-updating the framework
- Added version checking and comparison functionality
- Added automatic backup before updates
- Added rollback capability for failed updates
- Added `--check` flag for checking updates without installing
- Added `--force` flag for skipping confirmation prompts
- Created comprehensive CHANGELOG.md

### Fixed
- Fixed PRISM_ROOT path in binary to correctly use ~/.prism installation directory
- Fixed command parsing to properly handle options and flags
- Fixed PRISM_HOME path that was incorrectly set to ~/.claude
- Fixed `set -e` issue with non-zero return codes in version comparison
- Fixed Bash 3.2 compatibility issues for macOS users

### Changed
- Improved PATH setup documentation with clear warnings and instructions
- Enhanced troubleshooting documentation for "command not found" errors
- Updated installer to clone from main branch instead of looking for releases

## [2.0.0] - 2025-09-28

### Added
- Complete framework rewrite with enhanced security
- Modular library architecture
- Comprehensive logging system
- Security validation and checksum verification
- Doctor command for system diagnostics
- Init command for project initialization

### Changed
- Migrated from v1 to v2 architecture
- Improved error handling and recovery
- Enhanced documentation structure

### Security
- Added GPG signature verification
- Implemented secure update mechanism
- Added permission validation