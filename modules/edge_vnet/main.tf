

module "edge" {
  source               = "../edge"
  location             = var.location
  resource_group_name  = var.resource_group_name
  virtual_machine_size = var.virtual_machine_size
  edge_version         = var.edge_version
  vco                  = var.vco
  ignore_cert_errors   = var.ignore_cert_errors
  activation_key       = var.activation_key
  edge_name            = var.edge_name
  ssh_public_key       = var.ssh_public_key
  public_subnet_id     = azurerm_subnet.public.id
  private_subnet_id    = azurerm_subnet.private.id
  edge_ge3_lanip       = "172.16.1.14"
  tags                 = var.tags
}

resource "azurerm_virtual_network" "vnet1" {
  name                = local.vnet_name
  resource_group_name = var.resource_group_name
  location            = var.location

  address_space = [local.vnet_prefix_space]

  tags = var.tags
}

resource "azurerm_subnet" "public" {
  name                 = local.subnet1_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = [local.public_subnet_space]
}

resource "azurerm_subnet" "private" {
  name                 = local.subnet2_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = [local.private_subnet_space]
}

resource "azurerm_subnet_route_table_association" "public" {
  subnet_id      = azurerm_subnet.public.id
  route_table_id = azurerm_route_table.public.id
}

resource "azurerm_subnet_route_table_association" "private" {
  subnet_id      = azurerm_subnet.private.id
  route_table_id = azurerm_route_table.private.id
}
resource "azurerm_route_table" "public" {
  name                = local.route_table_public
  resource_group_name = var.resource_group_name
  location            = var.location

  route {
    name           = "DefaultRouteToInternet"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "Internet"
  }

  tags = var.tags
}

resource "azurerm_route_table" "private" {
  name                = local.route_table_private
  resource_group_name = var.resource_group_name
  location            = var.location

  route {
    name                   = "DefaultRouteToGE3"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = local.private_subnet_start_address
  }

  tags = var.tags
}
