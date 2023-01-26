module "name" {
  source  = "app.terraform.io/dellfoundation/namer/terraform"
  version = "0.0.5"

  contact       = var.name.contact
  environment   = var.name.environment
  instance      = var.name.instance
  location      = var.resource_group.location
  optional_tags = var.optional_tags
  program       = var.name.program
  repository    = var.name.repository
  workload      = var.name.workload
}

resource "azurerm_key_vault" "vault" {
  enable_rbac_authorization     = true
  enabled_for_disk_encryption   = false
  location                      = var.resource_group.location
  name                          = "kv${module.name.resource_suffix_compact}"
  public_network_access_enabled = var.testing
  purge_protection_enabled      = !var.testing
  resource_group_name           = var.resource_group.name
  sku_name                      = "standard"
  soft_delete_retention_days    = 90
  tags                          = module.name.tags
  tenant_id                     = var.tenant_id

  network_acls {
    bypass         = "AzureServices"
    default_action = var.testing ? "Allow" : "Deny"
  }
}

module "diagnostics" {
  source  = "app.terraform.io/dellfoundation/diagnostics/azurerm"
  version = "0.0.4"

  log_analytics_workspace_id = var.log_analytics_workspace_id

  monitored_services = {
    kv = {
      id = azurerm_key_vault.vault.id
    }
  }
}

module "private_endpoint" {
  source  = "app.terraform.io/dellfoundation/private-link/azurerm"
  version = "0.0.1"

  resource_group  = var.resource_group
  resource_id     = azurerm_key_vault.vault.id
  resource_prefix = azurerm_key_vault.vault.name
  subnet_id       = var.private_endpoint.subnet_id
  subresource     = var.private_endpoint.subresource
  tags            = module.name.tags
}
