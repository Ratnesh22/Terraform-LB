module "azurerm_rg" {
  source      = "../child module/azurerm_rg"
  rg_name     = "insider-rg"
  rg_location = "West Europe"

}
module "azurerm_vnet" {
  depends_on  = [module.azurerm_rg]
  source      = "../child module/azurerm_vnet"
  vnet_name   = "insider-vnet"
  rg_name     = "insider-rg"
  rg_location = "West Europe"
}
module "azurerm_subnet" {
  source      = "../child module/azurerm_subnet"
  depends_on  = [module.azurerm_vnet]
  subnet_name = "insider-subnet"
  rg_name     = "insider-rg"
  vnet_name = "insider-vnet"
  address_prefixes = ["10.0.1.0/24"]

}
module "azurerm_subnet1" {
  source      = "../child module/azurerm_subnet"
  depends_on  = [module.azurerm_vnet]
  subnet_name = "AzureBastionSubnet"
  rg_name     = "insider-rg"
  vnet_name = "insider-vnet"
  address_prefixes = ["10.0.3.0/26"]

}
module "azurerm_kv" {
  source         = "../child module/azurerm_kv"
  depends_on = [ module.azurerm_rg ]
  key_vault_name = "insider-kvvvv"
  rg_name        = "insider-rg"
  rg_location    = "West Europe"

}

module "azurerm_pip" {
  source      = "../child module/azurerm_pip"
  depends_on  = [module.azurerm_rg]
  pip_name    = "insider-pip"
  rg_name     = "insider-rg"
  rg_location = "West Europe"

}

module "azurerm_pip1" {
  source      = "../child module/azurerm_pip"
  depends_on  = [module.azurerm_rg]
  pip_name    = "insider-Bastion-pip"
  rg_name     = "insider-rg"
  rg_location = "West Europe"

}

module "azurerm_bastion" {
  source       = "../child module/azurerm_bastion"
  depends_on   = [module.azurerm_pip1, module.azurerm_subnet1]
  bastion_name = "insider-bastion"
  rg_name      = "insider-rg"
  rg_location  = "West Europe"
  vnet_name    = "insider-vnet"
  subnet_name  = "AzureBastionSubnet"
  pip_name     = "insider-Bastion-pip"
}
module "azurerm_vm1" {
  source         = "../child module/azurerm_vm"
  depends_on     = [module.azurerm_subnet]
  vm_name        = "insider-vm1"
  nic_name       = "insider-nic1"
  vnet_name      = "insider-vnet"
  subnet_name    = "insider-subnet"
  rg_name        = "insider-rg"
  rg_location    = "West Europe"
  key_vault_name = "insider-kv"
  admin_username = "insidervm1"
  admin_password = "qwerty!123456"
  pip_name = "insider-pip"

}
module "azurerm_vm2" {
  source         = "../child module/azurerm_vm"
  depends_on     = [module.azurerm_subnet]
  vm_name        = "insider-vm2"
  nic_name       = "insider-nic2"
  vnet_name      = "insider-vnet"
  subnet_name    = "insider-subnet"
  rg_name        = "insider-rg"
  rg_location    = "West Europe"
  key_vault_name = "insider-kv"
  admin_username = "insidervm2"
  admin_password = "qwerty!123456"
  pip_name = "insider-pip"

}
module "azurerm_lb" {
  source       = "../child module/azurerm_lb"
  depends_on   = [module.azurerm_vm1, module.azurerm_vm2, module.azurerm_pip, module.azurerm_subnet]
  pip_name     = "insider-pip"
  rg_name      = "insider-rg"
  rg_location  = "West Europe"
  lb_name      = "insider-lb"
  bap_name     = "insider-bap"
  probe_name   = "insider-probe"
  lb_rule_name = "insider-lb-rule"

}
module "azurerm_nic-bap_connection1" {
  source     = "../child module/azurerm_nic-bap connection"
  depends_on = [module.azurerm_lb, module.azurerm_vm1, ]
  nic_name   = "insider-nic1"
  rg_name    = "insider-rg"
  pip_name   = "internal"
  bap_name = "insider-bap"
  lb_name = "insider-lb"

}
module "azurerm_nic-bap_connection2" {
  source     = "../child module/azurerm_nic-bap connection"
  depends_on = [module.azurerm_lb, module.azurerm_vm2]
   nic_name   = "insider-nic2"
  rg_name    = "insider-rg"
  pip_name   = "internal"
  bap_name = "insider-bap"
  lb_name = "insider-lb"

}