### virtualenv
```
virtualenv venv -p python3.8
source venv/bin/activate
pip install -r requirements.txt
```
### prerequisites
```
installed:
    - terraform
    - packer
    - jq
    - aws cli

S3 for terraform states:
    - 'rjelinski-terraform-state'

Roles:
    - 'rjelinski-terraform-role': s3 with state, permissions
    - 'rjelinski-terraform-provider-role': ec2 + vpc + rds, permissions 

used user should be able to assume aforementioned roles: 
    - user in 'trusted entities' of roles
    - permission to 'sts:AssumeRole'

aws config
    - in ~/.aws/config file
    - sandbox with credentials fromsanbox 
    - sandbox_packer entry with specified role refering to sanbox
```

### terraform
```
make ENV=dev LAYER=main tf_apply
make ENV=dev LAYER=main tf_destroy
```
Available envs: dev, test
Available layers: main, app
### ami
update TU_AMI* variables in Makefile
```
make packer_create_ami
```