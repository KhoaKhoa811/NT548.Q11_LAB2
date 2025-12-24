variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "public_subnet_id" {
  description = "Public subnet ID to place the NAT Gateway"
  type        = string
}

