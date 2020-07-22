export TU_AMI_VPC_ID=vpc-0869a63d4d540f150
export TU_AMI_SUBNET_ID=subnet-0db6d7322e13b2ce4
export TU_AMI_PACKER_ROLE=arn:aws:iam::890769921003:role/rjelinski-terraform-provider-role

ENV ?= dev
INFRASTRUCTURE_DIR = infrastructure/envs/$(ENV)
TERRAFORM_OPTIONS_MAIN = -var-file=../public/main.tfvars -var-file=../private/main.tfvars
TERRAFORM_OPTIONS_APP = -var-file=../public/app.tfvars -var-file=../private/app.tfvars

AMI_DIR = infrastructure/ami/ami

run_server:
	gunicorn -c gunicorn.conf.py 'app.app:create_app()'

tf_init:
	cd $(INFRASTRUCTURE_DIR)/main && terraform init $(TERRAFORM_OPTIONS_MAIN) .
	cd $(INFRASTRUCTURE_DIR)/app && terraform init $(TERRAFORM_OPTIONS_APP) .

tf_apply: tf_init
	cd $(INFRASTRUCTURE_DIR)/main && terraform apply $(TERRAFORM_OPTIONS_MAIN) .
	cd $(INFRASTRUCTURE_DIR)/app && terraform apply $(TERRAFORM_OPTIONS_APP) .

tf_destroy: tf_init
	cd $(INFRASTRUCTURE_DIR)/app && terraform destroy $(TERRAFORM_OPTIONS_APP) .
	cd $(INFRASTRUCTURE_DIR)/main && terraform destroy $(TERRAFORM_OPTIONS_MAIN) .

tf_ami_init:
	cd $(AMI_DIR)/main && terraform init $(TERRAFORM_OPTIONS_MAIN) .

tf_ami_apply: tf_ami_init
	cd $(AMI_DIR)/main && terraform apply $(TERRAFORM_OPTIONS_MAIN) .

tf_ami_destroy: tf_ami_init
	cd $(AMI_DIR)/main && terraform destroy $(TERRAFORM_OPTIONS_MAIN) .

create_app_bundle:
	mkdir build
	cp -r app build/app
	cp gunicorn.conf.py init_db.py Makefile requirements.txt build/
	find build -name "*.pyc" -type f -delete
	cd build; zip -r ../build.zip *
	rm -rf build

packer_create_ami: create_app_bundle
	chmod +x infrastructure/ami/create_ami.sh
	./infrastructure/ami/create_ami.sh