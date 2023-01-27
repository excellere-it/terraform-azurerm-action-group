# Azure Monitor Action Group

Create an action group in Azure Monitor that can be used to configure how alerts are handled.

- [Azure Monitor Action Group](#azure-monitor-action-group)
  - [Example](#example)
  - [Required Inputs](#required-inputs)
    - [ display\_name](#-display_name)
    - [ name](#-name)
    - [ resource\_group](#-resource_group)
  - [Optional Inputs](#optional-inputs)
    - [ expiration\_days](#-expiration_days)
    - [ optional\_tags](#-optional_tags)
  - [Outputs](#outputs)
  - [Resources](#resources)
  - [Requirements](#requirements)
  - [Providers](#providers)
  - [Modules](#modules)
    - [ name](#-name-1)
  - [Update Docs](#update-docs)

<!-- BEGIN_TF_DOCS -->


## Example

```hcl
locals {
  location       = "centralus"
  tags           = module.name.tags
  test_namespace = random_pet.instance_id.id
}

data "azurerm_client_config" "current" {}

resource "random_pet" "instance_id" {}

resource "azurerm_resource_group" "example" {
  location = local.location
  name     = "rg-${local.test_namespace}"
  tags     = local.tags
}

module "example" {
  source = "../.."

  display_name   = "DoNothing"
  resource_group = azurerm_resource_group.example

  name = {
    contact     = "nobody@dell.org"
    environment = "sbx"
    instance    = 0
    program     = "dyl"
    repository  = "terraform-azurerm-action-group"
    workload    = "apps"
  }
}
```

## Required Inputs

The following input variables are required:

### <a name="input_display_name"></a> [display\_name](#input\_display\_name)

Description: The display name of the action group.

Type: `string`

### <a name="input_name"></a> [name](#input\_name)

Description: The name tokens used to construct the resource name and tags.

Type:

```hcl
object({
    contact     = string
    environment = string
    instance    = optional(number)
    program     = optional(string)
    repository  = string
    workload    = string
  })
```

### <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group)

Description: The resource group to deploy resources into

Type:

```hcl
object({
    location = string
    name     = string
  })
```

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_expiration_days"></a> [expiration\_days](#input\_expiration\_days)

Description: Used to calculate the value of the EndDate tag by adding the specified number of days to the CreateDate tag.

Type: `number`

Default: `365`

### <a name="input_optional_tags"></a> [optional\_tags](#input\_optional\_tags)

Description: A map of additional tags for the resource.

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_id"></a> [id](#output\_id)

Description: The ID of the Action Group.

## Resources

The following resources are used by this module:

- [azurerm_monitor_action_group.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_action_group) (resource)

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.3.3)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 3.31)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 3.31)

## Modules

The following Modules are called:

### <a name="module_name"></a> [name](#module\_name)

Source: app.terraform.io/dellfoundation/namer/terraform

Version: 0.0.5
<!-- END_TF_DOCS -->

## <a name='update-docs'></a>Update Docs

Run this command:

```
terraform-docs markdown document --output-file README.md --output-mode inject .
```