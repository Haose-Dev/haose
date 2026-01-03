variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
  default     = "rg-haose-dev"
}

variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
  default     = "East US"
}

variable "tags" {
  description = "A map of tags to assign to resources"
  type        = map(string)
  default = {
    Environment = "dev"
    Project     = "haose"
    ManagedBy   = "terraform"
  }
}

