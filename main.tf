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

resource "azurerm_monitor_action_group" "main" {
  name                = "ag-${module.name.resource_suffix}}"
  resource_group_name = var.resource_group.name
  short_name          = var.display_name
  tags                = module.name.tags
}

