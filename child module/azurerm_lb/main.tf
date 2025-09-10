data "azurerm_public_ip" "pip" {
  name                = var.pip_name
  resource_group_name = var.rg_name
}


resource "azurerm_lb" "lb" {
  name                = var.lb_name
  location            = var.rg_location
  resource_group_name = var.rg_name

  frontend_ip_configuration {
    name                 = var.pip_name
    public_ip_address_id = data.azurerm_public_ip.pip.id
  }
}
resource "azurerm_lb_backend_address_pool" "bap" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = var.bap_name    
}
resource "azurerm_lb_probe" "probe" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = var.probe_name
  port            = 80
}
resource "azurerm_lb_rule" "lb_rule" {
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = var.lb_rule_name
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = var.pip_name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.bap.id]
  probe_id                       = azurerm_lb_probe.probe.id
}

