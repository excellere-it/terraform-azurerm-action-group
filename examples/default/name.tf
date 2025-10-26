module "name" {
  source  = "app.terraform.io/infoex/diagnostics/azurerm"
  version = "0.0.1"

  contact     = "nobody@dell.org"
  environment = "sbx"
  location    = local.location
  repository  = "terraform-azurerm-action-group"
  workload    = "apps"
}