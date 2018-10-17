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

resource "aws_security_group" "default" {
  vpc_id      = "${aws_vpc.vpc.id}"
  name        = "default-${var.deployment_name}"
  vpc_id      = "${aws_vpc.vpc.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.sgroup_inbound_cidr_blocks}"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "tls_keypair" {
  key_name   = "${var.tls_key_name}"
  public_key = "${var.PUBLIC_KEY_OPENSSH}"
}

resource "aws_instance" "infra_instance" {
    ami = "${lookup(var.images, var.aws_region)}"
    instance_type = "${var.infra_instance_type}"

    subnet_id = "${aws_subnet.subnet.id}"
    associate_public_ip_address = true

    root_block_device {
        delete_on_termination = true
    }

    availability_zone = "${data.aws_availability_zones.available.names[0]}"
    vpc_security_group_ids = ["${aws_security_group.default.id}"]
    key_name = "${var.tls_key_name}"

    tags {
        Name = "${var.deployment_name}-infra-1"
    }
}

resource "aws_instance" "master_instance" {
    ami = "${lookup(var.images, var.aws_region)}"
    instance_type = "${var.master_instance_type}"

    subnet_id = "${aws_subnet.subnet.id}"
    associate_public_ip_address = true

    root_block_device {
        delete_on_termination = true
    }

    availability_zone = "${data.aws_availability_zones.available.names[0]}"
    vpc_security_group_ids = ["${aws_security_group.default.id}"]
    key_name = "${var.tls_key_name}"

    tags {
        Name = "${var.deployment_name}-master-1"
    }
}

resource "aws_instance" "worker_instance" {
    count = 3
    ami = "${lookup(var.images, var.aws_region)}"
    instance_type = "${var.worker_instance_type}"

    subnet_id = "${aws_subnet.subnet.id}"
    associate_public_ip_address = true

    root_block_device {
        delete_on_termination = true
    }

    availability_zone = "${data.aws_availability_zones.available.names[0]}"
    vpc_security_group_ids = ["${aws_security_group.default.id}"]
    key_name = "${var.tls_key_name}"

    tags {
        Name = "${var.deployment_name}-worker-${count.index+1}"
    }
}

/*
* Create Kubespray Inventory File
*
*/
data "template_file" "inventory" {
    template = "${file("${path.module}/templates/inventory.tpl")}"

    vars {
        public_ip_address_infra = "${join("\n",formatlist("infra ansible_host=%s" , aws_instance.infra_instance.*.public_ip))}"
        public_ip_address_master = "${join("\n",formatlist("master ansible_host=%s" , aws_instance.master_instance.*.public_ip))}"
        public_ip_address_workers = "${join("\n",formatlist("workers ansible_hosts=%s" , aws_instance.worker_instance.*.public_ip))}"
        connection_strings_master = "${join("\n",formatlist("%s ansible_host=%s",aws_instance.master_instance.*.tags.Name, aws_instance.master_instance.*.private_ip))}"
        connection_strings_nodes = "${join("\n", formatlist("%s ansible_host=%s", aws_instance.worker_instance.*.tags.Name, aws_instance.worker_instance.*.private_ip))}"
        connection_strings_etcd = "${join("\n",formatlist("%s ansible_host=%s", aws_instance.infra_instance.*.tags.Name, aws_instance.infra_instance.*.private_ip))}"
        list_master = "${join("\n",aws_instance.master_instance.*.tags.Name)}"
        list_workers = "${join("\n",aws_instance.worker_instance.*.tags.Name)}"
        list_infra = "${join("\n",aws_instance.infra_instance.*.tags.Name)}"
    }

}

resource "null_resource" "inventories" {
  provisioner "local-exec" {
      command = "echo '${data.template_file.inventory.rendered}' > ${var.inventory_file}"
  }

  triggers {
      template = "${data.template_file.inventory.rendered}"
  }

}
# module "test_instance" {
#     source = "./modules"
#     SubnetId = "${aws_subnet.subnet.id}"
#     deployment_name = "${var.deployment_name}"
# }