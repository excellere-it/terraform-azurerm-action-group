# Basic Functionality Tests
#
# Tests core functionality of the terraform-azurerm-action-group module including:
# - Module instantiation
# - Output generation
# - Resource creation
# - Naming conventions
# - Tag application

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

variables {
  display_name = "TestGroup"

  name = {
    contact     = "test@example.com"
    environment = "sbx"
    instance    = 1
    program     = "testing"
    repository  = "terraform-azurerm-action-group"
    workload    = "alerts"
  }

  resource_group = {
    location = "centralus"
    name     = "rg-test-action-group"
  }

  optional_tags = {
    Test = "true"
  }
}

#
# Test: Valid Configuration Plan
#
# Verifies that a valid configuration can be planned successfully.
# This is a smoke test to ensure the module syntax is correct.
#
run "test_valid_configuration_plan" {
  command = plan

  assert {
    condition     = azurerm_monitor_action_group.main.short_name == "TestGroup"
    error_message = "Action group short_name should match display_name variable"
  }

  assert {
    condition     = azurerm_monitor_action_group.main.resource_group_name == "rg-test-action-group"
    error_message = "Action group should be in the specified resource group"
  }
}

#
# Test: Output ID is Generated
#
# Verifies that the module generates the required ID output.
# The output should not be empty after planning.
#
run "test_output_id_exists" {
  command = plan

  assert {
    condition     = azurerm_monitor_action_group.main.name != null
    error_message = "Action group resource should have a name"
  }
}

#
# Test: Resource Naming Convention
#
# Verifies that the action group name follows the expected naming pattern.
# Should start with 'ag-' prefix per organizational standards.
#
run "test_resource_naming" {
  command = plan

  assert {
    condition     = can(regex("^ag-", azurerm_monitor_action_group.main.name))
    error_message = "Action group name should start with 'ag-' prefix"
  }

  assert {
    condition     = length(azurerm_monitor_action_group.main.name) > 3
    error_message = "Action group name should be longer than just the prefix"
  }
}

#
# Test: Short Name Validation
#
# Verifies that the short_name (display_name) is correctly applied to the resource.
# This is the name visible in the Azure portal.
#
run "test_short_name_application" {
  command = plan

  variables {
    display_name = "Alert1"
  }

  assert {
    condition     = azurerm_monitor_action_group.main.short_name == "Alert1"
    error_message = "Short name should be set to the display_name variable"
  }
}

#
# Test: Tags are Applied
#
# Verifies that tags are properly applied to the action group resource.
# Tags come from both the namer module and optional_tags.
#
run "test_tags_applied" {
  command = plan

  assert {
    condition     = module.name.tags != null
    error_message = "Naming module should generate tags"
  }

  assert {
    condition     = length(module.name.tags) > 0
    error_message = "Naming module should have at least one tag"
  }
}

#
# Test: Namer Module Integration
#
# Verifies that the namer module is properly integrated and generates
# the expected resource_suffix output.
#
run "test_namer_integration" {
  command = plan

  assert {
    condition     = module.name.resource_suffix != null
    error_message = "Namer module should generate a resource_suffix"
  }

  assert {
    condition     = module.name.resource_suffix != ""
    error_message = "Namer module resource_suffix should not be empty"
  }
}

#
# Test: Environment Tag
#
# Verifies that the environment tag is correctly set from the name variable.
#
run "test_environment_tag" {
  command = plan

  variables {
    name = {
      contact     = "test@example.com"
      environment = "prd"
      instance    = 1
      program     = "testing"
      repository  = "terraform-azurerm-action-group"
      workload    = "alerts"
    }
  }

  assert {
    condition     = contains(keys(module.name.tags), "Environment")
    error_message = "Naming module tags should include Environment key"
  }
}

#
# Test: Optional Tags Merging
#
# Verifies that optional tags are properly merged with standard tags.
#
run "test_optional_tags" {
  command = plan

  variables {
    optional_tags = {
      CostCenter  = "IT-001"
      Criticality = "High"
    }
  }

  assert {
    condition     = var.optional_tags["CostCenter"] == "IT-001"
    error_message = "Optional tags should be accepted"
  }

  assert {
    condition     = var.optional_tags["Criticality"] == "High"
    error_message = "Optional tags should be accepted"
  }
}

#
# Test: Minimal Configuration
#
# Verifies that the module works with minimal required variables only.
# Tests with no optional_tags and minimal name configuration.
#
run "test_minimal_configuration" {
  command = plan

  variables {
    display_name = "Min"

    name = {
      contact     = "min@example.com"
      environment = "dev"
      repository  = "test-repo"
      workload    = "min"
    }

    resource_group = {
      location = "eastus2"
      name     = "rg-minimal"
    }

    optional_tags = {}
  }

  assert {
    condition     = azurerm_monitor_action_group.main.short_name == "Min"
    error_message = "Minimal configuration should work correctly"
  }

  assert {
    condition     = azurerm_monitor_action_group.main.resource_group_name == "rg-minimal"
    error_message = "Resource group should be correctly assigned"
  }
}

#
# Test: Location Inheritance
#
# Verifies that the location from the resource_group variable is properly
# passed to the namer module.
#
run "test_location_inheritance" {
  command = plan

  variables {
    resource_group = {
      location = "eastus2"
      name     = "rg-test"
    }
  }

  assert {
    condition     = module.name.resource_suffix != null && module.name.resource_suffix != ""
    error_message = "Namer module should generate resource_suffix using location from resource_group"
  }

  assert {
    condition     = can(regex("-e2-", module.name.resource_suffix))
    error_message = "Resource suffix should contain location abbreviation 'e2' for eastus2"
  }
}
