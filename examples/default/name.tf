module "name" {
  source = "git::https://github.com/excellere-it/terraform-namer.git"

  contact     = "nobody@infoex.dev"
  environment = "sbx"
  location    = local.location
  repository  = "terraform-azurerm-action-group"
  workload    = "apps"
}