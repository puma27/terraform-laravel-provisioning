variable "linode_token" {
  description = "Linode API Token"
  type        = string
  sensitive   = true
}

variable "root_password" {
  description = "Root password for Linode instance"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "Linode region"
  type        = string
  default     = "ap-south"
}

variable "username" {
  description = "Your name for VM naming convention"
  type        = string
}
