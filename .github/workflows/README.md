# GitHub Actions Workflows

This directory contains automated workflows for the terraform-azurerm-action-group module.

## Available Workflows

### test.yml - Terraform Tests

Automated testing workflow that runs on every push and pull request to main and develop branches.

#### Triggers

- Push to `main` or `develop` branches (when .tf, test, or workflow files change)
- Pull requests to `main` or `develop` branches (when .tf, test, or workflow files change)
- Manual trigger via `workflow_dispatch`

#### Jobs

1. **terraform-format**
   - Checks code formatting using `terraform fmt -check -recursive`
   - Ensures consistent code style
   - Fails if formatting issues are found

2. **terraform-validate**
   - Validates Terraform configuration syntax
   - Runs `terraform init` and `terraform validate`
   - Ensures configuration is syntactically valid

3. **security-scan**
   - Runs Checkov security scanning
   - Identifies potential security issues
   - Generates SARIF report
   - Soft fail (does not block PR)

4. **lint**
   - Runs TFLint for Terraform best practices
   - Checks for deprecated syntax, unused variables, etc.
   - Uses latest TFLint version

5. **test-examples**
   - Tests all example configurations
   - Matrix strategy for parallel testing
   - Currently tests: `default`
   - Runs init, validate, and plan for each example
   - Uploads plan artifacts

6. **test-summary**
   - Aggregates results from all test jobs
   - Creates summary in GitHub Actions UI
   - Fails if required tests fail

7. **comment-pr**
   - Posts test results as PR comment
   - Only runs on pull requests
   - Provides quick visibility of test status

#### Required Checks

The following jobs must pass for PR approval:
- Terraform Format Check
- Terraform Validate
- Test Examples

#### Optional Checks

The following jobs run but don't block PRs:
- Security Scan (soft fail)
- TFLint

#### Artifacts

- **Security Scan Results**: SARIF file with security findings (30-day retention)
- **Terraform Plans**: Plan output for each example (90-day default retention)

## Local Testing

Before pushing, run these commands locally to catch issues early:

```bash
# Format check
terraform fmt -check -recursive

# Validate
terraform init -backend=false
terraform validate

# Test examples
cd examples/default
terraform init
terraform validate
terraform plan
```

Or use the Makefile:

```bash
make fmt
make validate
make test
```

## Workflow Permissions

The workflows use minimal required permissions:
- `contents: read` - Read repository contents
- `pull-requests: write` - Post comments on PRs

## Adding New Examples

When adding a new example:

1. Create the example directory under `examples/`
2. Add the example name to the matrix in `test.yml`:
   ```yaml
   matrix:
     example:
       - default
       - your-new-example  # Add here
   ```

## Commenting Out Jobs

Some jobs are commented out by default:

- **terraform-docs**: Uncomment when ready to enforce documentation standards
- **Upload SARIF to GitHub Security**: Requires GitHub Advanced Security

To enable, remove the `#` comments from the relevant sections in `test.yml`.

## Troubleshooting

### Format Check Fails

Run locally:
```bash
terraform fmt -recursive
```

### Validate Fails

Check syntax errors:
```bash
terraform validate
```

### Example Tests Fail

Test the specific example:
```bash
cd examples/default
terraform init
terraform plan
```

### Security Scan Issues

Review Checkov output in the workflow logs. These are informational and don't block PRs.

## Continuous Improvement

Planned enhancements:
- [ ] Add native Terraform tests execution
- [ ] Enable terraform-docs enforcement
- [ ] Add automated dependency updates
- [ ] Integration testing with actual Azure resources (in separate workflow)
- [ ] Performance benchmarking

## Related Documentation

- [CONTRIBUTING.md](../../CONTRIBUTING.md) - Development guidelines
- [README.md](../../README.md) - Module documentation
- [CHANGELOG.md](../../CHANGELOG.md) - Version history
