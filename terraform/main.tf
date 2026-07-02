resource "azurerm_resource_group" "rg" {
 name = "jenkins-terraform-rg"
 location = var.location
}
resource "azurerm_virtual_network" "vnet" {
 name = "jenkins-vnet"
 address_space = ["10.0.0.0/16"]
 location = azurerm_resource_group.rg.location
 resource_group_name = azurerm_resource_group.rg.name
}
resource "azurerm_subnet" "subnet" {
 name = "internal-subnet"
 resource_group_name = azurerm_resource_group.rg.name
 virtual_network_name = azurerm_virtual_network.vnet.name
 address_prefixes = ["10.0.2.0/24"]
}
resource "azurerm_public_ip" "pip" {
 name = "jenkins-vm-pip"
 resource_group_name = azurerm_resource_group.rg.name
 location = azurerm_resource_group.rg.location
 allocation_method = "static"
 sku                 = "Standard"
}
resource "azurerm_network_security_group" "nsg" {
 name = "jenkins-vm-nsg"
 location = azurerm_resource_group.rg.location
 resource_group_name = azurerm_resource_group.rg.name
 security_rule {
 name = "SSH"
 priority = 1001
 direction = "Inbound"
 access = "Allow"
 protocol = "Tcp"
 source_port_range = "*"
 destination_port_range = "22"
 source_address_prefix = "*"
 destination_address_prefix = "*"
 }
}
resource "azurerm_network_interface" "nic" {
 name = "jenkins-vm-nic"
 location = azurerm_resource_group.rg.location
 resource_group_name = azurerm_resource_group.rg.name
 ip_configuration {
 name = "internal"
 subnet_id = azurerm_subnet.subnet.id
 private_ip_address_allocation = "Dynamic"
 public_ip_address_id = azurerm_public_ip.pip.id
 }
}
resource "azurerm_network_interface_security_group_association" "assoc" {
 network_interface_id = azurerm_network_interface.nic.id
 network_security_group_id = azurerm_network_security_group.nsg.id
}
