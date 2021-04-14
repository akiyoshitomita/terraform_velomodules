locals {
  virtual_machine_name         = var.edge_name
  nic1                         = join("-", [var.edge_name, "nic-ge1"])
  nic2                         = join("-", [var.edge_name, "nic-ge2"])
  nic3                         = join("-", [var.edge_name, "nic-ge3"])
  ipge1                        = join("-", [var.edge_name, "ipconfig-ge1"])
  ipge2                        = join("-", [var.edge_name, "ipconfig-ge2"])
  ipge3                        = join("-", [var.edge_name, "ipconfig-ge3"])
  publicip                     = join("-", [var.edge_name, "publicIP"])
  subnet1_id                   = var.public_subnet_id
  subnet2_id                   = var.private_subnet_id
  private_subnet_start_address = var.edge_ge3_lanip
  network_security_group_name  = join("-", [var.edge_name, "vVCE_SG"])
  ssh_key_path                 = "/home/vcadmin/.ssh/authorized_keys"
  ssh_pub_key                  = var.ssh_public_key
  cloudinit                    = "#cloud-config\nvelocloud:\n vce:\n  vco: ${var.vco}\n  activation_code: ${var.activation_key}\n  vco_ignore_cert_errors: ${var.ignore_cert_errors}\n"
  images = {
    "Virtual Edge 2.5" = {
      "publisher" = "velocloud"
      "offer"     = "velocloud-virtual-edge"
      "sku"       = "velocloud-virtual-edge"
      "version"   = "2.5.0"
    }
    "Virtual Edge 3.x" = {
      "publisher" = "velocloud"
      "offer"     = "velocloud-virtual-edge-3x"
      "sku"       = "velocloud-virtual-edge-3x"
      "version"   = "3.0.0"
    }
  }
  image_sku       = local.images[var.edge_version]["sku"]
  image_publisher = local.images[var.edge_version]["publisher"]
  image_offer     = local.images[var.edge_version]["offer"]
  image_version   = local.images[var.edge_version]["version"]
}

