variable "aws_region" {
    description = "The AWS region."
    default     = "us-east-2"
}

variable "deployment_name" {
    description = "The name of deployment. Will be the part of resources names."
    default     = "auto"
}

variable "vpc_cidr_block" {
    description = " The cidr block of the desired VPC."
    default     = "10.10.0.0/16"
}

variable "vpc_enable_dns" {
    description = "Whether or not the VPC has DNS support."
    default     = "true"
}

variable "vpc_enable_dns_hostnames" {
    description = "Whether or not the VPC has DNS hostname support."
    default     = "true"
}

variable "subnet_cidr_block" {
    description = "The cidr block of the desired subnet."
    default     = "10.10.0.0/20"
}

variable "subnet_map_public_ip" {
    description = "Specify true to indicate that instances launched into the subnet should be assigned a public IP address. Default is false."
    default     = "false"
}

variable "sgroup_inbound_cidr_blocks" {
    description = "List of CIDR blocks for ingress rule."
    default     = ["66.129.239.10/31", "66.129.239.12/30", "66.129.239.16/30", "66.129.242.10/31", "66.129.242.12/30", "66.129.242.16/30", "213.208.163.170/32"]
}