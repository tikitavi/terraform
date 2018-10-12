resource "aws_vpc" "terraform_vpc" {
    cidr_block           = "10.10.0.0/16"
    enable_dns_support   = "true"
    enable_dns_hostnames = "true"
    tags {
        Name = "terraform_vpc"
    }
}

resource "aws_subnet" "terraform_subnet" {
    cidr_block              = "10.10.0.0/20"
    vpc_id                  = "${aws_vpc.terraform_vpc.id}"
    map_public_ip_on_launch = "true"
    availability_zone       = "${var.AWS_AZ}"
    tags {
        Name = "terraform_subnet"
    }
}

resource "aws_internet_gateway" "terraform_internet_gateway" {
    vpc_id = "${aws_vpc.terraform_vpc.id}"
    tags {
        Name = "terraform_internet_gateway"
    }
}

resource "aws_route_table" "terraform_route_table" {
    vpc_id = "${aws_vpc.terraform_vpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.terraform_internet_gateway.id}"
    }
    tags {
        Name = "terraform_route_table"
    }
}

resource "aws_route_table_association" "terraform_route_table_association" {
    subnet_id      = "${aws_subnet.terraform_subnet.id}"
    route_table_id = "${aws_route_table.terraform_route_table.id}"
}