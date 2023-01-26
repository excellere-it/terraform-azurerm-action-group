# Key Vaults

Creates an Azure Key Vault using RBAC mode.
- [Key Vaults](#key-vaults)
  - [Example](#example)
  - [Required Inputs](#required-inputs)
    - [ log\_analytics\_workspace\_id](#-log_analytics_workspace_id)
    - [ name](#-name)
    - [ private\_endpoint](#-private_endpoint)
    - [ resource\_group](#-resource_group)
    - [ tenant\_id](#-tenant_id)
  - [Optional Inputs](#optional-inputs)
    - [ enabled\_for\_disk\_encryption](#-enabled_for_disk_encryption)
    - [ expiration\_days](#-expiration_days)
    - [ network\_acls](#-network_acls)
    - [ optional\_tags](#-optional_tags)
    - [ testing](#-testing)
  - [Outputs](#outputs)
    - [ id](#-id)
  - [Resources](#resources)
  - [Requirements](#requirements)
  - [Providers](#providers)
  - [Modules](#modules)
    - [ diagnostics](#-diagnostics)
    - [ name](#-name-1)
    - [ private\_endpoint](#-private_endpoint-1)
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

resource "azurerm_log_analytics_workspace" "example" {
  location            = azurerm_resource_group.example.location
  name                = "la-${local.test_namespace}"
  resource_group_name = azurerm_resource_group.example.name
  retention_in_days   = 30
  sku                 = "PerGB2018"
  tags                = local.tags
}

resource "azurerm_virtual_network" "example" {
  address_space       = ["192.168.0.0/24"]
  location            = azurerm_resource_group.example.location
  name                = "vnet-${local.test_namespace}"
  resource_group_name = azurerm_resource_group.example.name
  tags                = local.tags
}

resource "azurerm_subnet" "example" {
  address_prefixes     = [cidrsubnet(azurerm_virtual_network.example.address_space.0, 1, 0)]
  name                 = "vault"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
}

resource "azurerm_private_dns_zone" "example" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = azurerm_resource_group.example.name
  tags                = local.tags
}

module "example" {
  source = "../.."

  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id
  resource_group             = azurerm_resource_group.example
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  testing                    = true

  name = {
    contact     = "nobody@dell.org"
    environment = "sbx"
    instance    = 0
    program     = "dyl"
    repository  = "terraform-azurerm-key-vault"
    workload    = "apps"
  }

  private_endpoint = {
    subnet_id = azurerm_subnet.example.id
    subresource = {
      vault = [azurerm_private_dns_zone.example.id]
    }
  }
}
```

## Required Inputs

The following input variables are required:

### <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id)

Description: The workspace to write logs into.

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

### <a name="input_private_endpoint"></a> [private\_endpoint](#input\_private\_endpoint)

Description: The private endpoint configuration.

Type:

```hcl
object({
    subnet_id   = string
    subresource = map(list(string))
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

### <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id)

Description: The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault.

Type: `string`

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

### <a name="input_testing"></a> [testing](#input\_testing)

Description: Deploy Key Vault with options appropriate for testing.

Type: `bool`

Default: `false`

## Outputs

The following outputs are exported:

### <a name="output_id"></a> [id](#output\_id)

Description: The Key Vault ID.

## Resources

The following resources are used by this module:

- [azurerm_key_vault.vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) (resource)

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.3.3)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 3.31)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 3.31)

## Modules

The following Modules are called:

### <a name="module_diagnostics"></a> [diagnostics](#module\_diagnostics)

Source: app.terraform.io/dellfoundation/diagnostics/azurerm

Version: 0.0.4

### <a name="module_name"></a> [name](#module\_name)

Source: app.terraform.io/dellfoundation/namer/terraform

Version: 0.0.5

### <a name="module_private_endpoint"></a> [private\_endpoint](#module\_private\_endpoint)

Source: app.terraform.io/dellfoundation/private-link/azurerm

Version: 0.0.1
<!-- END_TF_DOCS -->

## <a name='update-docs'></a>Update Docs

Run this command:

```
terraform-docs markdown document --output-file README.md --output-mode inject .
```