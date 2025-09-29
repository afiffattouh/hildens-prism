# Changelog

All notable changes to the PRISM Framework will be documented in this file.

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