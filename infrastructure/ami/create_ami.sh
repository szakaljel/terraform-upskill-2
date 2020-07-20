#!/bin/bash
aws sts assume-role --role-arn ${TU_AMI_PACKER_ROLE} --role-session-name packer --profile sandbox > ./credentials.json

TU_AMI_ACCESS_KEY=`jq '.["Credentials"]["AccessKeyId"]' ./credentials.json`
TU_AMI_SECRET_KEY=`jq '.["Credentials"]["SecretAccessKey"]' ./credentials.json`
TU_AMI_TOKEN=`jq '.["Credentials"]["SessionToken"]' ./credentials.json`

export  TU_AMI_ACCESS_KEY=${TU_AMI_ACCESS_KEY//\"/}
export  TU_AMI_SECRET_KEY=${TU_AMI_SECRET_KEY//\"/}
export  TU_AMI_TOKEN=${TU_AMI_TOKEN//\"/}

packer build ./infrastructure/ami/ec2_ami.template.json
rm ./credentials.json