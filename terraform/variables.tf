variable "location" {
  description = "Location to deploy resources"
  type        = string
  default     = "westus2"
}

variable "tags" {
  type = map

  default = {
    environment = "landingzone"
    deployment  = "terraform"
    microhack   = "sap-data"
  }
}

variable "prefix" {
  type        = string
  default     = "sap-data"
}

variable "address_space" {
  description = "The address space that is used by the virtual network."
  type        = list(string)
  default     = ["10.20.0.0/16"]
}

variable "subnet_prefixes" {
  description = "The address prefix to use for the subnet."
  type        = list(string)
  default     = ["10.20.1.0/24"]
}

variable "username" {
  description = "Administrator user name for virtual machine"
  type        = string
  default     = "azureadmin"
}

variable "password" {
  description = "Password must meet Azure complexity requirements"
  type        = string
  default     = "Sapdata!pass123"
}

variable "object_id" {
  description = "Principal ID for logged in user, only required when using Cloud Shell"
  type        = string
  default     = "00000000-0000-0000-0000-000000000000"
}

variable "vmsize" {
  description = "Size of the VMs"
  default     = "Standard_B2s"
}
