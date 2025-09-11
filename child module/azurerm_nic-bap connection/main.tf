data "azurerm_network_interface" "nic" {
  name                = var.nic_name    
  resource_group_name = var.rg_name
}
data "azurerm_lb" "lb" {
  name                = var.lb_name
  resource_group_name = var.rg_name
}
data "azurerm_lb_backend_address_pool" "bap" {
  name            = var.bap_name 
  loadbalancer_id = data.azurerm_lb.lb.id
}
resource "azurerm_network_interface_backend_address_pool_association" "bap_association" {
  network_interface_id    = data.azurerm_network_interface.nic.id
  ip_configuration_name   = var.pip_name
  backend_address_pool_id = data.azurerm_lb_backend_address_pool.bap.id
}