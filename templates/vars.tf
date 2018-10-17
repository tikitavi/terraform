variable "aws_region" {
    description = "The AWS region."
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

variable "tls_key_name" {
    default = "jenkins-terraform"
}

variable "PUBLIC_KEY_OPENSSH" {
    description = "Public key for ssh access to the instances"
}

variable "images" {
  description="AMI images for CentOS Linux 7 x86_64"
  type = "map"

  default = {
    "us-east-1"      = "ami-9887c6e7"
    "us-east-2"      = "ami-9c0638f9"
    "us-west-1"      = "ami-4826c22b"
    "us-west-2"      = "ami-3ecc8f46"
    "ap-south-1"     = "ami-1780a878"
    "ap-northeast-2" = "ami-bf9c36d1"
    "ap-southeast-1" = "ami-8e0205f2"
    "ap-southeast-2" = "ami-d8c21dba"
    "ap-northeast-1" = "ami-8e8847f1"
    "ca-central-1"   = "ami-e802818c"
    "eu-central-1"   = "ami-dd3c0f36"
    "eu-west-1"      = "ami-3548444c"
    "eu-west-2"      = "ami-00846a67"
    "eu-west-3"      = "ami-262e9f5b"
    "sa-east-1"      = "ami-cb5803a7"
  }
}

variable "infra_instance_type" {
    description = "Intance type for Infra node"
#    default = "m5.2xlarge"
    default = "t2.micro"
}

variable "master_instance_type" {
    description = "Intance type for Master node"
#    default = "m5.2xlarge"
    default = "t2.micro"
}

variable "worker_instance_type" {
    description = "Intance type for Worker nodes"
#    default = "m5.4xlarge"
    default = "t2.micro"
}

variable "inventory_file" {
    description = "The file for inventory information"
    default = "./ansible_hosts"
}