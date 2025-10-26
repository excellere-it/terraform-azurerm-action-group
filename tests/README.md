# Terraform Tests

This directory contains native Terraform tests for the terraform-azurerm-action-group module using Terraform's built-in testing framework.

## Overview

The tests use Terraform's native `.tftest.hcl` format introduced in Terraform 1.6.0+. These tests complement the existing Go-based Terratest suite in the `test/` directory.

## Test Files

### basic.tftest.hcl

Tests core functionality of the module:
- Module can be instantiated
- Required outputs are generated
- Resources are created with correct names
- Tags are applied correctly
- Integration with namer module works

### validation.tftest.hcl

Tests input validation:
- Display name length validation (1-12 characters)
- Expiration days validation (must be > 0)
- Required variable enforcement
- Invalid input rejection

## Running Tests

### Run All Tests

```bash
terraform test
```

### Run Specific Test File

```bash
terraform test -filter=tests/basic.tftest.hcl
terraform test -filter=tests/validation.tftest.hcl
```

### Run Specific Test

```bash
terraform test -filter=tests/basic.tftest.hcl -verbose
```

### Verbose Output

```bash
terraform test -verbose
```

## Test Structure

Each test file follows this structure:

```hcl
# Define mock providers if needed
mock_provider "azurerm" {
  # Mock provider configuration
}

# Test runs
run "test_name" {
  command = plan  # or apply

  variables {
    # Override variables for this test
  }

  assert {
    condition     = # assertion expression
    error_message = "Error message if assertion fails"
  }
}
```

## Test Modes

Tests can run in two modes:

1. **Plan Mode** (`command = plan`)
   - Faster execution
   - No actual resources created
   - Good for validation and structure tests

2. **Apply Mode** (`command = apply`)
   - Actually creates resources
   - Tests real Azure integration
   - Requires Azure credentials
   - Slower but more thorough

## Mock Providers

For tests that don't need real Azure resources, we use mock providers to simulate Azure behavior without actual API calls.

## Assertions

Common assertion patterns:

```hcl
# Check output is not empty
assert {
  condition     = output.id != ""
  error_message = "Output should not be empty"
}

# Check output format
assert {
  condition     = can(regex("^ag-", output.id))
  error_message = "Action group name should start with 'ag-'"
}

# Check resource attributes
assert {
  condition     = azurerm_monitor_action_group.main.short_name == var.display_name
  error_message = "Short name should match display name"
}
```

## Prerequisites

- Terraform >= 1.6.0 (for native test support)
- For plan-only tests: No Azure credentials needed
- For apply tests: Valid Azure credentials configured

## Integration with CI/CD

These tests are automatically run by GitHub Actions on:
- Every push to main/develop
- Every pull request
- Manual workflow triggers

See `.github/workflows/test.yml` for the CI/CD configuration.

## Test Development Guidelines

### When to Add Tests

Add tests when:
- Adding new variables
- Adding new outputs
- Adding new resources
- Changing validation rules
- Fixing bugs (regression tests)

### Test Naming

Use descriptive test names:
- `test_valid_configuration` - Tests that should succeed
- `test_invalid_display_name` - Tests that should fail validation
- `test_output_format` - Tests output formatting

### Assertions

- Add at least one assertion per test
- Test both positive and negative cases
- Include helpful error messages
- Test edge cases

### Keep Tests Fast

- Prefer plan mode over apply mode when possible
- Use mock providers for unit tests
- Reserve apply mode for integration tests

## Test Coverage

Current test coverage:

- [x] Basic module instantiation
- [x] Output generation
- [x] Display name validation (length)
- [x] Expiration days validation
- [x] Required variables enforcement
- [x] Tag generation
- [x] Resource naming
- [ ] Email receiver configuration (future)
- [ ] SMS receiver configuration (future)
- [ ] Webhook receiver configuration (future)

## Comparison with Go Tests

| Aspect | Native Terraform Tests | Go/Terratest |
|--------|------------------------|--------------|
| **Speed** | Faster (plan mode) | Slower (always applies) |
| **Setup** | Minimal | Requires Go environment |
| **Language** | HCL | Go |
| **Mocking** | Built-in | Manual |
| **CI/CD** | Easy | More complex |
| **Real Resources** | Optional | Default |
| **Best For** | Unit tests, validation | Integration tests |

## Troubleshooting

### Test Fails in CI but Passes Locally

- Check Terraform version compatibility
- Verify provider versions match
- Check for environment-specific variables

### Mock Provider Issues

- Ensure provider is properly mocked
- Check that resource schemas match
- Verify mock data types

### Timeout Issues

- Increase timeout for apply tests
- Use plan mode when possible
- Check Azure API rate limits

## Future Enhancements

Planned improvements:
- [ ] Add tests for all receiver types
- [ ] Add integration tests with real Azure resources
- [ ] Add performance benchmarking
- [ ] Add tests for error conditions
- [ ] Add tests for resource updates
- [ ] Add tests for resource deletion

## Related Documentation

- [Terraform Testing Documentation](https://developer.hashicorp.com/terraform/language/tests)
- [CONTRIBUTING.md](../CONTRIBUTING.md) - Development guidelines
- [Go Tests README](../test/README.md) - Go/Terratest documentation

## Examples

See the test files in this directory for complete examples:
- `basic.tftest.hcl` - Basic functionality tests
- `validation.tftest.hcl` - Input validation tests
