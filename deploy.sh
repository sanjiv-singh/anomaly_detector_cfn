#!/bin/bash

aws ec2 delete-key-pair --key-name gltest
rm -f gltest.pem
aws ec2 create-key-pair \
	--key-name gltest \
	--query 'KeyMaterial' | sed -e 's/"//g' -e 's/\\n/\n/g' > gltest.pem
chmod 400 gltest.pem


aws cloudformation deploy \
	--stack-name task1stack \
	--parameter-overrides file://params.json \
	--template-file task1.json
