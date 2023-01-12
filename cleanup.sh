#!/bin/bash

BUCKET_NAME=sanjivsingh-gl-app-bucket

aws ec2 delete-key-pair --key-name gltest
rm -f gltest.pem
rm -f app.zip
rm -f anomaly_lambda.zip

aws s3 rm s3://$BUCKET_NAME/ --recursive
aws s3 rb s3://$BUCKET_NAME

clean_stacks() {
    aws cloudformation delete-stack \
	    --stack-name task3stack

    aws cloudformation delete-stack \
	    --stack-name task2stack

    aws cloudformation delete-stack \
	    --stack-name task1stack
}

clean_codedeploy() {
    aws deploy delete-deployment-group \
        --application-name my-app \
        --deployment-group-name my-app-group

    aws deploy delete-application \
        --application-name my-app

    codedeploy_policy_arn="arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"

    aws iam detach-role-policy \
            --role-name codedeploy-service-role \
            --policy-arn $codedeploy_policy_arn

    aws iam delete-role --role-name codedeploy-service-role
}

clean_codedeploy
clean_stacks
