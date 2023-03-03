# What's this project for #
This project deploys a new 'state' bucket, dynamodb tables and a 'logging' bucket that gets the server access logs from the 'state' bucket. The resources are for use as a Terraform state backend for other  Terraform projects in the target account. The state file of this project is to remain in the source code repository so it is not included in the .gitignore file.

### Design ###   
This is the design for the use of this backend state:   
- a central bucket in each account, created by this project, for Terraform state files of each Terraform project in each account   
- a bucket prefix in this central bucket for each Terraform project's state file   
- a new dynamodb table for each Terraform project's state file   
- this project will be updated and run to add a new prefix in the central bucket and a new dynamodb table as needed   
- the new Terraform projects will use the central bucket with the specific prefix and new dynamodb table for its backend by importing the outputs of this project   

--centralbucket   
----proj1prefix/statefile   
----proj2prefix/statefile   

proj1_dynamodb/LockID   
proj2_dynamodb/LockID   

### Development/Deployment ###
You can use the _development\_shell_ Docker image as a container to test your work on this project without having to configure Terraform on your local machine. The Dockerfiles included provide for amd and arm (for use with Macs running the m1 chip) versions of Terraform and the aws cliv2. The version of Terraform can be updated as needed in the Dockerfiles and the image rebuilt to update the development environment. The run_shell script provided will mount your local version of this project into the container but the path in the script must be updated to match your local path to this project.   

To initialize Terraform run: `terraform init -backend-config="path=backend/{env_name}/terraform.tfstate"`. This will allow you to have different env_name state files.   

Then run: `terraform plan -var-file={env_name}.tfvars`. This allows you to set different values for the variables based on the environment you want to work in.   

If the plan step shows you what you expect then run: `terraform apply -var-file={env_name}.tfvars`
