# What's this project for #
This project is based on the [terraform-aws-bootstrap](https://github.com/trussworks/terraform-aws-bootstrap) from trussworks and deploys a new 'state' bucket, dynamodb table and a 'logging' bucket that gets the server access logs from the 'state' bucket. The resources are for use as a Terraform state backend. The state file of this project is to remain in the source code repository so it is not included in the .gitignore file.

### Design ###   
There is a module for bootstrapping the backend. The resources are defined there. The main.tf file in the terraform directory configures Terraform and the provider and calls into the module. Default values have been set on the variables but this could be expanded to use a .tfvars file to specify custom values. To deploy use the basic steps of init, plan. apply.

### Development ###
You can use the _development\_shell_ Docker image as a container to test your work on this project without having to configure Terraform on your local machine. The Dockerfiles included provide for amd and arm (for use with Macs running the m1 chip) versions of Terraform and the aws cliv2. The version of Terraform can be updated as needed in the Dockerfiles and the image rebuilt to update the development environment. The run_shell script provided will mount your local version of this project into the container but the path in the script must be updated to match your local path to this project.   
