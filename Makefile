export TU_AMI_VPC_ID=vpc-0869a63d4d540f150
export TU_AMI_SUBNET_ID=subnet-0db6d7322e13b2ce4
export TU_AMI_PACKER_ROLE=arn:aws:iam::890769921003:role/rjelinski-terraform-provider-role

INFRASTRUCTURE_DIR = infrastructure/envs
ENV ?= dev

run_server:
	gunicorn -c gunicorn.conf.py 'app.app:create_app()'

tf_init:
	terraform init $(INFRASTRUCTURE_DIR)/$(ENV)

tf_plan:
	terraform plan $(INFRASTRUCTURE_DIR)/$(ENV)

tf_apply:
	terraform apply $(INFRASTRUCTURE_DIR)/$(ENV)

tf_destroy:
	terraform destroy $(INFRASTRUCTURE_DIR)/$(ENV)

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