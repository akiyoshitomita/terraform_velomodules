resource "azurerm_virtual_machine" "edge" {
  name                = local.virtual_machine_name
  location            = var.location
  resource_group_name = var.resource_group_name

  vm_size = var.virtual_machine_size

  os_profile {
    computer_name  = local.virtual_machine_name
    admin_username = "vcadmin"
    custom_data    = base64encode(local.cloudinit)
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = local.ssh_pub_key
      path     = local.ssh_key_path
    }
  }

  storage_image_reference {
    publisher = local.image_publisher
    offer     = local.image_offer
    sku       = local.image_sku
    version   = local.image_version
  }

  plan {
    name      = local.image_sku
    publisher = local.image_publisher
    product   = local.image_offer
  }

  storage_os_disk {
    name          = local.virtual_machine_name
    create_option = "FromImage"
  }

  network_interface_ids        = [azurerm_network_interface.ge1.id, azurerm_network_interface.ge2.id, azurerm_network_interface.ge3.id]
  primary_network_interface_id = azurerm_network_interface.ge1.id

  tags = var.tags
}


resource "azurerm_network_interface" "ge1" {
  name                = local.nic1
  location            = var.location
  resource_group_name = var.resource_group_name

  enable_ip_forwarding = true
  ip_configuration {
    name                          = local.ipge1
    subnet_id                     = local.subnet1_id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tags
}

resource "azurerm_network_interface" "ge2" {
  name                = local.nic2
  location            = var.location
  resource_group_name = var.resource_group_name

  enable_ip_forwarding = true
  ip_configuration {
    name                          = local.ipge2
    subnet_id                     = local.subnet1_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ge2_pub.id
  }

  tags = var.tags
}

resource "azurerm_network_interface" "ge3" {
  name                = local.nic3
  location            = var.location
  resource_group_name = var.resource_group_name

  enable_ip_forwarding = true
  ip_configuration {
    name                          = local.ipge3
    subnet_id                     = local.subnet2_id
    private_ip_address_allocation = "Static"
    private_ip_address            = local.private_subnet_start_address
  }

  tags = var.tags
}

resource "azurerm_network_interface_security_group_association" "ge1" {
  network_interface_id      = azurerm_network_interface.ge1.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_network_interface_security_group_association" "ge2" {
  network_interface_id      = azurerm_network_interface.ge2.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_network_interface_security_group_association" "ge3" {
  network_interface_id      = azurerm_network_interface.ge3.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_public_ip" "ge2_pub" {
  name                = local.publicip
  location            = var.location
  resource_group_name = var.resource_group_name

  allocation_method = "Dynamic"

  tags = var.tags
}

resource "azurerm_network_security_group" "nsg" {
  name                = local.network_security_group_name
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "VCMP"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_range     = "2426"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "SNMP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_range     = "161"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = var.tags
}
