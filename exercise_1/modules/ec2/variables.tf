variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "bastion_instance_type" {
  type = string
}

variable "app_instance_type" {
  type = string
}

variable "ssh_public_key" {
  type = string
}

variable "public_subnet_id" {
  type = string
}

variable "private_subnet_id" {
  type = string
}

variable "bastion_sg_id" {
  type = string
}

variable "app_sg_id" {
  type = string
}

