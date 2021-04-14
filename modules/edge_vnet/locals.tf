locals {
  vnet_name                    = var.vnet_name
  subnet1_name                 = var.public_subnet_name
  subnet2_name                 = var.private_subnet_name
  vnet_prefix_space            = var.vnet_prefix
  public_subnet_space          = var.public_subnet
  private_subnet_space         = var.private_subnet
  route_table_public           = join("-", [var.vnet_name, "-PUB-RT"])
  route_table_private          = join("-", [var.vnet_name, "-PRI-RT"])
  private_subnet_start_address = var.edge_ge3_lanip
}

