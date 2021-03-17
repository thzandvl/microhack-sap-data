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

variable "username" {
  description = "Administrator user name for virtual machine"
  type        = string
}

variable "password" {
  description = "Password must meet Azure complexity requirements"
  type        = string
}

variable "vmsize" {
  description = "Size of the VMs"
  default     = "Standard_B2s"
}