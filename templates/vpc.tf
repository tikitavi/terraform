provider "aws" {
    region = "${var.aws_region}"
}

resource "aws_vpc" "vpc" {
    cidr_block           = "${var.vpc_cidr_block}"
    enable_dns_support   = "${var.vpc_enable_dns}"
    enable_dns_hostnames = "${var.vpc_enable_dns_hostnames}"
    tags {
        Name = "${var.deployment_name}_vpc"
    }
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "subnet" {
    cidr_block              = "${var.subnet_cidr_block}"
    vpc_id                  = "${aws_vpc.vpc.id}"
    map_public_ip_on_launch = "${var.subnet_map_public_ip}"
    availability_zone       = "${data.aws_availability_zones.available.names[0]}"
    tags {
        Name = "${var.deployment_name}_subnet"
    }
}

resource "aws_internet_gateway" "internet_gateway" {
    vpc_id = "${aws_vpc.vpc.id}"
    tags {
        Name = "${var.deployment_name}_internet_gateway"
    }
}

resource "aws_route_table" "route_table" {
    vpc_id = "${aws_vpc.vpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.internet_gateway.id}"
    }
    tags {
        Name = "${var.deployment_name}_route_table"
    }
}

resource "aws_route_table_association" "route_table_association" {
    subnet_id      = "${aws_subnet.subnet.id}"
    route_table_id = "${aws_route_table.route_table.id}"
}
