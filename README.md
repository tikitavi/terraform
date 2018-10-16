# Terraform

For the first start run `terraform init` for initializes various local settings and data.

Don't forget to store your AWS credentials in `.aws/credentials` or configure them by `aws configure`.

To create an execution plan run `terraform apply`. You can use `-out <filename>` option to to save the generated plan to a file for later execution.

All variables for terraform templates have their defaults. You can see them [here](./templates/vars.tf). You can change it by adding `-var variable_name=variable_value` option while planning and applying module.

Then apply with `terraform apply` (Use `terraform apply -var variable_name=variable_value` if neccessary.)

You can inspect the current state with `terraform show` command.

To destroy - run `terraform destroy`.