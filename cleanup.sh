#!/bin/bash

BUCKET_NAME=sanjivsingh-gl-app-bucket

aws ec2 delete-key-pair --key-name gltest
rm -f gltest.pem

aws cloudformation delete-stack \
	--stack-name task1stack

rm -f app.zip
aws s3 rm s3://$BUCKET_NAME/app.zip
aws s3 rb s3://$BUCKET_NAME

aws cloudformation delete-stack \
	--stack-name task2stack

