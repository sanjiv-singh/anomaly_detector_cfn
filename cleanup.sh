#!/bin/bash

BUCKET_NAME=sanjivsingh-gl-app-bucket

aws ec2 delete-key-pair --key-name gltest
rm -f gltest.pem
rm -f app.zip
rm -f anomaly_lambda.zip

aws s3 rm s3://$BUCKET_NAME/ --recursive
aws s3 rb s3://$BUCKET_NAME

aws cloudformation delete-stack \
	--stack-name task3stack

aws cloudformation delete-stack \
	--stack-name task2stack

aws cloudformation delete-stack \
	--stack-name task1stack

