### virtualenv
```
virtualenv venv -p python3.8
source venv/bin/activate
pip install -r requirements.txt
```
### prerequisites
```
S3 for terraform states:
    - 'rjelinski-terraform-state'
Roles:
    - 'rjelinski-terraform-role': s3 with state, permissions
    - 'rjelinski-terraform-provider-role': ec2 + vpc + rds, permissions 
used user should be able to assume aforementioned roles: 
    - user in 'trusted entities' of roles
    - permission to 'sts:AssumeRole'
```

### terraform
```
make ENV=dev tf_init
make ENV=dev tf_plan
make ENV=dev tf_apply
make ENV=dev tf_destroy
```
Available envs: dev, test

### ami
```
make ENV=ami tf_init
make ENV=ami tf_apply
```
update TU_AMI* variables in Makefile
```
make packer_create_ami
```