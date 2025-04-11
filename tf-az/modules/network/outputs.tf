output "vnet_id" {
  value = azurerm_virtual_network.this.id
}

output "subnet_ids" {
  value = {
    for k, subnet in azurerm_subnet.subnets :
    k => subnet.id
  }
}

