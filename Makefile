export TU_AMI_VPC_ID=vpc-0b1201af9315cbe9b
export TU_AMI_SUBNET_ID=subnet-057d1a050aa3dda0e
export TU_AMI_PACKER_ROLE=arn:aws:iam::890769921003:role/rjelinski-terraform-provider-role

ENV ?= dev
LAYER ?= main
INFRASTRUCTURE_DIR = infrastructure/envs/$(ENV)
TERRAFORM_OPTIONS = -var-file=../public/$(LAYER).tfvars -var-file=../private/$(LAYER).tfvars

run_server:
	gunicorn -c gunicorn.conf.py 'app.app:create_app()'

tf_init:
	cd $(INFRASTRUCTURE_DIR)/$(LAYER) && terraform init $(TERRAFORM_OPTIONS) .

tf_apply: tf_init
	cd $(INFRASTRUCTURE_DIR)/$(LAYER) && terraform apply $(TERRAFORM_OPTIONS) .

tf_destroy: tf_init
	cd $(INFRASTRUCTURE_DIR)/$(LAYER) && terraform destroy $(TERRAFORM_OPTIONS) .

create_app_bundle:
	mkdir build
	cp -r app build/app
	cp gunicorn.conf.py init_db.py Makefile requirements.txt build/
	find build -name "*.pyc" -type f -delete
	cd build; zip -r ../build.zip *
	rm -rf build

packer_create_ami: create_app_bundle
	packer build ./infrastructure/ami/ec2_ami.template.json