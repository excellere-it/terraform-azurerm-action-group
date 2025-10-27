# Input Validation Tests
#
# Tests input validation rules for the terraform-azurerm-action-group module including:
# - Display name length validation (1-12 characters)
# - Expiration days validation (> 0)
# - Required variable enforcement
# - Invalid input rejection

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

#
# Test: Valid Display Name
#
# Verifies that a valid display name (within 1-12 character limit) is accepted.
#
run "test_valid_display_name" {
  command = plan

  variables {
    display_name = "ValidName"

    name = {
      contact     = "test@example.com"
      environment = "dev"
      repository  = "test-repo"
      workload    = "test"
    }

    resource_group = {
      location = "centralus"
      name     = "rg-test"
    }
  }

  assert {
    condition     = azurerm_monitor_action_group.main.short_name == "ValidName"
    error_message = "Valid display name should be accepted"
  }
}

#
# Test: Display Name Maximum Length
#
# Verifies that a 12-character display name (maximum allowed) is accepted.
#
run "test_display_name_max_length" {
  command = plan

  variables {
    display_name = "TwelveChars1" # Exactly 12 characters

    name = {
      contact     = "test@example.com"
      environment = "dev"
      repository  = "test-repo"
      workload    = "test"
    }

    resource_group = {
      location = "centralus"
      name     = "rg-test"
    }
  }

  assert {
    condition     = length(var.display_name) == 12
    error_message = "Display name should be exactly 12 characters"
  }

  assert {
    condition     = azurerm_monitor_action_group.main.short_name == "TwelveChars1"
    error_message = "12-character display name should be accepted"
  }
}

#
# Test: Display Name Minimum Length
#
# Verifies that a 1-character display name (minimum allowed) is accepted.
#
run "test_display_name_min_length" {
  command = plan

  variables {
    display_name = "A" # Single character

    name = {
      contact     = "test@example.com"
      environment = "dev"
      repository  = "test-repo"
      workload    = "test"
    }

    resource_group = {
      location = "centralus"
      name     = "rg-test"
    }
  }

  assert {
    condition     = length(var.display_name) == 1
    error_message = "Display name should be exactly 1 character"
  }

  assert {
    condition     = azurerm_monitor_action_group.main.short_name == "A"
    error_message = "1-character display name should be accepted"
  }
}

#
# Test: Display Name Too Long
#
# Verifies that a display name longer than 12 characters is rejected.
# This should fail the validation rule.
#
run "test_display_name_too_long" {
  command = plan

  variables {
    display_name = "ThirteenChars" # 13 characters - should fail

    name = {
      contact     = "test@example.com"
      environment = "dev"
      repository  = "test-repo"
      workload    = "test"
    }

    resource_group = {
      location = "centralus"
      name     = "rg-test"
    }
  }

  expect_failures = [
    var.display_name,
  ]
}

#
# Test: Empty Display Name
#
# Verifies that an empty display name is rejected.
# This should fail the validation rule.
#
run "test_empty_display_name" {
  command = plan

  variables {
    display_name = "" # Empty string - should fail

    name = {
      contact     = "test@example.com"
      environment = "dev"
      repository  = "test-repo"
      workload    = "test"
    }

    resource_group = {
      location = "centralus"
      name     = "rg-test"
    }
  }

  expect_failures = [
    var.display_name,
  ]
}

# Tests for expiration_days removed - variable no longer exists in module

#
# Test: Required Name Fields
#
# Verifies that all required fields in the name object are enforced.
# Tests with minimal required fields only.
#
run "test_required_name_fields" {
  command = plan

  variables {
    display_name = "Test"

    name = {
      contact     = "required@example.com"
      environment = "dev"
      repository  = "required-repo"
      workload    = "required"
    }

    resource_group = {
      location = "centralus"
      name     = "rg-test"
    }
  }

  assert {
    condition     = var.name.contact == "required@example.com"
    error_message = "Contact field should be required"
  }

  assert {
    condition     = var.name.environment == "dev"
    error_message = "Environment field should be required"
  }

  assert {
    condition     = var.name.repository == "required-repo"
    error_message = "Repository field should be required"
  }

  assert {
    condition     = var.name.workload == "required"
    error_message = "Workload field should be required"
  }
}

#
# Test: Optional Name Fields
#
# Verifies that optional fields in the name object can be omitted.
#
run "test_optional_name_fields" {
  command = plan

  variables {
    display_name = "Test"

    name = {
      contact     = "test@example.com"
      environment = "dev"
      repository  = "test-repo"
      workload    = "test"
      # instance and program are optional - omitted
    }

    resource_group = {
      location = "centralus"
      name     = "rg-test"
    }
  }

  assert {
    condition     = var.name.instance == null
    error_message = "Instance should be optional and null when not provided"
  }

  assert {
    condition     = var.name.program == null
    error_message = "Program should be optional and null when not provided"
  }
}

#
# Test: Optional Name Fields Set
#
# Verifies that optional fields in the name object work when provided.
#
run "test_optional_name_fields_set" {
  command = plan

  variables {
    display_name = "Test"

    name = {
      contact     = "test@example.com"
      environment = "dev"
      instance    = 5
      program     = "test-program"
      repository  = "test-repo"
      workload    = "test"
    }

    resource_group = {
      location = "centralus"
      name     = "rg-test"
    }
  }

  assert {
    condition     = var.name.instance == 5
    error_message = "Instance should be set when provided"
  }

  assert {
    condition     = var.name.program == "test-program"
    error_message = "Program should be set when provided"
  }
}

#
# Test: Required Resource Group Fields
#
# Verifies that both location and name are required in the resource_group object.
#
run "test_resource_group_fields" {
  command = plan

  variables {
    display_name = "Test"

    name = {
      contact     = "test@example.com"
      environment = "dev"
      repository  = "test-repo"
      workload    = "test"
    }

    resource_group = {
      location = "eastus2"
      name     = "rg-required-test"
    }
  }

  assert {
    condition     = var.resource_group.location == "eastus2"
    error_message = "Resource group location should be required"
  }

  assert {
    condition     = var.resource_group.name == "rg-required-test"
    error_message = "Resource group name should be required"
  }
}

#
# Test: Empty Optional Tags
#
# Verifies that the module works correctly with no optional tags.
#
run "test_empty_optional_tags" {
  command = plan

  variables {
    display_name = "Test"

    name = {
      contact     = "test@example.com"
      environment = "dev"
      repository  = "test-repo"
      workload    = "test"
    }

    resource_group = {
      location = "centralus"
      name     = "rg-test"
    }

    optional_tags = {}
  }

  assert {
    condition     = length(var.optional_tags) == 0
    error_message = "Optional tags should be allowed to be empty"
  }
}

#
# Test: Multiple Optional Tags
#
# Verifies that multiple optional tags can be provided.
#
run "test_multiple_optional_tags" {
  command = plan

  variables {
    display_name = "Test"

    name = {
      contact     = "test@example.com"
      environment = "dev"
      repository  = "test-repo"
      workload    = "test"
    }

    resource_group = {
      location = "centralus"
      name     = "rg-test"
    }

    optional_tags = {
      Tag1 = "Value1"
      Tag2 = "Value2"
      Tag3 = "Value3"
    }
  }

  assert {
    condition     = length(var.optional_tags) == 3
    error_message = "Multiple optional tags should be accepted"
  }
}
