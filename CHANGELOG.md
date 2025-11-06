# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- **COMPLIANCE**: Diagnostic settings integration via terraform-azurerm-diagnostics module (v0.0.11)
  - Enables Action Group audit logging for alert notification activity tracking
  - Configurable via `diagnostics` object variable (default: disabled)
  - Supports Dedicated or AzureDiagnostics table types
  - Provides alert activity logs for monitoring notification delivery and action execution (SOC 2 compliance)
- Comprehensive module header documentation in main.tf (80+ lines)
- CONTRIBUTING.md with development workflow and guidelines
- CHANGELOG.md for tracking version history
- Enhanced .gitignore with comprehensive patterns
- Enhanced Makefile with additional development targets
- GitHub Actions test workflow for CI/CD
- Native Terraform tests alongside existing Go tests
- tests/basic.tftest.hcl for core functionality testing
- tests/validation.tftest.hcl for input validation testing
- tests/README.md documenting test approach
- .github/workflows/README.md documenting workflows

### Changed
- Updated module source to use local relative path (../terraform-terraform-namer)
- Removed version constraint for local namer module
- Improved documentation structure
- Enhanced code organization with section headers

### Fixed
- Module now uses local terraform-terraform-namer for development

## [0.0.1] - Initial Release

### Added
- Initial module implementation for Azure Monitor Action Groups
- Standardized resource naming using terraform-terraform-namer
- Automatic tagging with company, environment, location metadata
- Display name validation (1-12 characters)
- Expiration days validation
- Resource group integration
- Basic README with usage examples
- Go-based tests using Terratest
- Example configuration (default)
- Variables for name, display_name, resource_group, optional_tags, expiration_days
- Output for action group ID

### Supported
- Terraform >= 1.13.4
- AzureRM provider >= 3.0.0
- Azure Monitor Action Groups
- Integration with terraform-terraform-namer module

---

## Version History Notes

### Versioning Scheme

This project follows [Semantic Versioning](https://semver.org/):
- **MAJOR** version for incompatible API changes
- **MINOR** version for new functionality in a backward compatible manner
- **PATCH** version for backward compatible bug fixes

### Release Process

Releases are automated via GitHub Actions:
1. Create a tag matching the pattern `v*.*.*` (e.g., `v0.1.0`)
2. Push the tag to GitHub
3. GitHub Actions automatically creates a release with notes

### Upgrade Guidance

When upgrading between versions, check the relevant sections above for:
- **Breaking Changes**: May require updates to your configuration
- **Deprecated Features**: Plan to migrate away from these
- **New Features**: Optional enhancements you may want to adopt

---

## Template for Future Releases

```markdown
## [X.Y.Z] - YYYY-MM-DD

### Added
- New features and capabilities

### Changed
- Changes to existing functionality

### Deprecated
- Features that will be removed in future versions

### Removed
- Features removed in this version

### Fixed
- Bug fixes

### Security
- Security-related changes
```

---

[Unreleased]: https://github.com/kelomai/terraform-azurerm-action-group/compare/0.0.1...HEAD
[0.0.1]: https://github.com/kelomai/terraform-azurerm-action-group/releases/tag/0.0.1
