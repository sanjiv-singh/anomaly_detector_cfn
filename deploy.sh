#!/bin/bash

BUCKET_NAME=sanjivsingh-gl-app-bucket

task1() {
    aws ec2 create-key-pair \
	--key-name gltest \
	--query 'KeyMaterial' | sed -e 's/"//g' -e 's/\\n/\n/g' > gltest.pem
    chmod 400 gltest.pem


    aws cloudformation deploy \
	--stack-name task1stack \
	--parameter-overrides file://params.json \
	--template-file task1.json \
	--capabilities CAPABILITY_IAM

}

task2() {
    aws cloudformation deploy \
	--stack-name task2stack \
	--template-file task2.json

    zip app.zip raw_data.py appspec.yml
    aws s3 cp app.zip s3://$BUCKET_NAME/app.zip
}

task1
task2
