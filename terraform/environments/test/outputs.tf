output "resource_group_name" {
  description = "The name of the test resource group"
  value       = module.resource_group.resource_group_name
}

output "resource_group_id" {
  description = "The ID of the test resource group"
  value       = module.resource_group.resource_group_id
}

output "resource_group_location" {
  description = "The location of the test resource group"
  value       = module.resource_group.resource_group_location
}

