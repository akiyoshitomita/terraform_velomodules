# ---------------------------------------------------------------------------------------------------------------------
# ENVIRONMENT VARIABLES
# ---------------------------------------------------------------------------------------------------------------------

variable "location" {
  description = "azure location"
  type        = string
  default     = "japaneast"
}

variable "resource_group_name" {
  description = "name of resource group"
  type        = string
}

variable "virtual_machine_size" {
  description = "Virtual machine size"
  type        = string
  default     = "Standard_DS3_v2"
}


variable "edge_version" {
  description = "The version of the Edge to deploy from Marketplace"
  type        = string
  default     = "Virtual Edge 3.x"
  validation {
    condition     = contains(["Virtual Edge 3.x", "Virtual Edge 2.5"], var.edge_version)
    error_message = "Allow values for edge_version are \"Virtual Edge 3.x\" or \"Virtual Edge 2.5\"."
  }
}

variable "vco" {
  description = "FQDN or IP address of VCO"
  type        = string
  default     = "vco301-syd1.velocloud.net"
}

variable "ignore_cert_errors" {
  description = "Determines whether or not to ignore certificate errors"
  type        = bool
  default     = false
}

variable "activation_key" {
  description = "Activation Key"
  type        = string
}

variable "edge_name" {
  description = "Name of the Virtual Edge"
  type        = string
  default     = "VeloCloudVirtualEdge"
}

variable "ssh_public_key" {
  description = "The Public Key for Virtual Edge Instance paired with local private key"
  type        = string
}

variable "vnet_name" {
  description = "Virtual Network Name"
  type        = string
  default     = "AzureVNET"
}

variable "vnet_prefix" {
  description = "Virtual Network IP Address Space"
  type        = string
  default     = "172.16.0.0/16"
}

variable "public_subnet_name" {
  description = "Public Subnet Name for Edge WAN Interface within vNET"
  type        = string
  default     = "public_SN"
}

variable "public_subnet" {
  description = "Public Subnet IP Range for Edge WAN Interface"
  type        = string
  default     = "172.16.0.0/24"
}

variable "private_subnet_name" {
  description = "Private Subnet Name for Edge LAN Interface witin vNET"
  type        = string
  default     = "Private_SN"
}

variable "private_subnet" {
  description = "Private Subnet for Edge LAN Interface"
  type        = string
  default     = "172.16.1.0/24"
}

variable "edge_ge3_lanip" {
  description = "IP Address used for Edge LAN Interface GE3"
  type        = string
  default     = "172.16.1.4"
}

variable "tags" {
  description = "azure tags"
  type        = map(any)
  default     = {}
}
