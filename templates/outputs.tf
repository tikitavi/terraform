output "infra_private_ip" {
    value = "${join("\n", aws_instance.infra_instance.*.private_ip)}"
}

output "infra_public_ip" {
    value = "${join("\n", aws_instance.infra_instance.*.public_ip)}"
}

output "infra_name" {
    value = "${join("\n", aws_instance.infra_instance.*.tags.Name)}"
}

output "master_private_ip" {
    value = "${join("\n", aws_instance.master_instance.*.private_ip)}"
}

output "master_public_ip" {
    value = "${join("\n", aws_instance.master_instance.*.public_ip)}"
}

output "master_name" {
    value = "${join("\n", aws_instance.master_instance.*.tags.Name)}"
}

output "workers_private_ip" {
    value = "${join("\n", aws_instance.worker_instance.*.private_ip)}"
}

output "workers_public_ip" {
    value = "${join("\n", aws_instance.worker_instance.*.public_ip)}"
}

output "workers_name" {
    value = "${join("\n", aws_instance.worker_instance.*.tags.Name)}"
}
