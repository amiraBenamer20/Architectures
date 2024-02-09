variable "company" {
  type = string
  description = "name of the company"
  default = "Mqueen"
}

variable "project" {
  type = string
  description = "name of the project"
}

variable "billing_code" {
  type = string
  description = "billing code for resource tagging"
}

variable "region" {
  type = string
  description = "deployement region"
  default = "eu-west-3"
}

variable "enable_dns_hostnames" {
  type = bool
  description = "enbale dns hostnames in vpc"
  default = true
}

variable "vpc_cidr_block" {
  type = string
  description = "Base CIDR for vpc"
  default = "10.0.0.0/16"
}

variable "subnet1_cidr_block" {
  type = string
  description = "Base CIDR for subnet1"
  default = "10.0.0.0/24"
}

variable "map_public_ip_on_launch" {
  type = bool
  description = "map public IP @ for subnet instances"
  default = true
}

variable "instance_type" {
  type = string
  description = "instance type"
  default = "t2.micro"
}