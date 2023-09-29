Simple Terraform for hosting an S3 Static Website via Cloudfront (Route53 included)
This project provides a simple Terraform configuration for hosting an S3 static website via Cloudfront. It also includes a Makefile with targets for initializing, validating, planning, applying, and destroying the Terraform configuration.

To use this project, you will need to have Terraform and the AWS CLI installed. You can install Terraform using the following command:

curl -fsSL https://releases.hashicorp.com/terraform/0.15.5/terraform_0.15.5_linux_amd64.zip -o terraform.zip
unzip terraform.zip
rm terraform.zip
chmod +x terraform
sudo mv terraform /usr/local/bin/

You can install the AWS CLI using the following command:

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -r aws awscliv2.zip
Once you have Terraform and the AWS CLI installed, you can clone this repository and configure the Terraform configuration for your project. To do this, run the following commands:

git clone https://github.com/example/simple-terraform-s3-cloudfront.git
cd simple-terraform-s3-cloudfront
The Terraform configuration for this project is defined in the terraform directory. To configure the Terraform configuration, you will need to create an env.tfvars file and define the following variables:

domain_name: The domain name for your website.
certificate_arn: The ARN of the ACM certificate for your domain name.
You can create the env.tfvars file using the following command:

touch terraform/env.tfvars
Once you have created the env.tfvars file, you can open it in a text editor and define the required variables.

Once you have configured the Terraform configuration, you can initialize, validate, plan, and apply the Terraform configuration using the following Makefile targets:

init: Initializes the Terraform configuration.
validate: Validates the Terraform configuration.
plan: Outputs a plan of the changes that Terraform will make to your infrastructure.
apply: Applies the Terraform configuration to your infrastructure.
To initialize the Terraform configuration, run the following command:

make init
To validate the Terraform configuration, run the following command:

make validate
To plan the changes that Terraform will make to your infrastructure, run the following command:

make plan
To apply the Terraform configuration to your infrastructure, run the following command:

make apply
Once you have applied the Terraform configuration, your S3 static website will be hosted via Cloudfront. You can access your website by visiting the domain name that you specified in the env.tfvars file.

Makefile targets
The following is a list of the Makefile targets for this project:

init: Initializes the Terraform configuration.
validate: Validates the Terraform configuration.
plan: Outputs a plan of the changes that Terraform will make to your infrastructure.
apply: Applies the Terraform configuration to your infrastructure.
destroy: Destroys the Terraform configuration.
deploy: Validates the Terraform configuration, outputs a plan of the changes, and applies the changes to the infrastructure.
list: Lists the resources that are managed by the Terraform configuration.
configure: Allows you to configure the domain name for your website.
setup: Installs Terraform and the AWS CLI, and configures the AWS CLI.
Aliases
The following are aliases for the Makefile targets:

v: validate
p: plan
a: apply
Conclusion
This project provides a simple Terraform configuration for hosting an S3 static website via Cloudfront. It also includes a Makefile with targets for initializing, validating, planning, applying, and destroying the Terraform configuration.