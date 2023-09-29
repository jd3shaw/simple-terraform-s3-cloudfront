# Terraform targets
.PHONY: init validate plan apply destroy deploy list

init:
	terraform -chdir=terraform init -upgrade

validate:
	terraform -chdir=terraform validate

plan:
	terraform -chdir=terraform plan -var-file=env.tfvars

apply:
	terraform -chdir=terraform apply -var-file=env.tfvars

destroy:
	terraform -chdir=terraform destroy -var-file=env.tfvars

deploy:
	terraform -chdir=terraform validate
	terraform -chdir=terraform plan -out=tfplan -var-file=env.tfvars
	terraform -chdir=terraform apply tfplan -var-file=env.tfvars

list:
	terraform -chdir=terraform state list

.PHONY: configure

configure:
	@read -p "Enter the new domain name: " new_domain && \
	echo 'variable "domain_name" {\n  type    = string\n  default = "'$$new_domain'"\n \n  lifecycle {\n    prevent_destroy = true\n  }  \n  }' > "terraform/variables.tf"

.PHONY: setup

setup:
	@echo "Installing Terraform..."
	@if ! command -v terraform &> /dev/null; then \
		echo "Terraform not found, installing..."; \
		curl -fsSL https://releases.hashicorp.com/terraform/0.15.5/terraform_0.15.5_linux_amd64.zip -o terraform.zip; \
		unzip terraform.zip; \
		rm terraform.zip; \
		chmod +x terraform; \
		mv terraform /usr/local/bin/; \
	fi
	@echo "Terraform installation complete."

	@echo "Installing AWS CLI..."
	@if ! command -v aws &> /dev/null; then \
		echo "AWS CLI not found, installing..."; \
		curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"; \
		unzip awscliv2.zip; \
		sudo ./aws/install; \
		rm -r aws awscliv2.zip; \
	fi
	@echo "AWS CLI installation complete."

	@echo "Configuring AWS CLI..."
	@aws configure
	@echo "AWS CLI configuration complete."

# Alias for validate target
v: validate
p: plan
a: apply