#!/bin/bash

BUCKET_NAME=sanjivsingh-gl-app-bucket
STREAM_NAME=m03p02_raw_data_stream

task1() {
    aws ec2 create-key-pair \
	--key-name gltest \
	--query 'KeyMaterial' | sed -e 's/"//g' -e 's/\\n/\n/g' > gltest.pem
    chmod 400 gltest.pem


    aws cloudformation deploy \
	--stack-name task1stack \
	--parameter-overrides file://templates/params.json \
	--template-file templates/task1.json \
	--capabilities CAPABILITY_IAM

}

codedeploy_setup() {
    aws iam create-role \
        --role-name codedeploy-service-role \
        --assume-role-policy-document file://templates/code_policy.json

    aws iam attach-role-policy \
        --role-name codedeploy-service-role \
        --policy-arn arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole
    
    role_arn=$(aws iam get-role --role-name codedeploy-service-role --query "Role.Arn" --output text)
    
    aws deploy create-application --application-name my-app --no-cli-pager
    
    aws deploy push \
      --application-name my-app \
      --s3-location s3://sanjivsingh-gl-app-bucket/app.zip \
      --ignore-hidden-files --no-cli-pager
    
    aws deploy create-deployment-group \
      --application-name my-app \
      --deployment-group-name my-app-group \
      --deployment-config-name CodeDeployDefault.OneAtATime \
      --ec2-tag-filters Key=ec2-app-name,Value=my-app,Type=KEY_AND_VALUE \
      --service-role-arn $role_arn --no-cli-pager
    
    aws deploy create-deployment \
      --application-name my-app \
      --deployment-config-name CodeDeployDefault.OneAtATime \
      --deployment-group-name my-app-group \
      --no-cli-pager \
      --s3-location bucket=sanjivsingh-gl-app-bucket,bundleType=zip,key=app.zip
}

task2() {
    aws cloudformation deploy \
	--stack-name task2stack \
	--template-file templates/task2.json

    codedeploy_setup
}

task3() {

    zip anomaly_lambda.zip anomaly_detection.py
    aws s3 cp anomaly_lambda.zip s3://$BUCKET_NAME/anomaly_lambda.zip

    stream_arn=$(aws kinesis describe-stream --stream-name "$STREAM_NAME" --query "StreamDescription.StreamARN" --output text)

    aws cloudformation deploy \
	--stack-name task3stack \
        --parameter-overrides "KinesisStreamArn=$stream_arn" \
	--template-file templates/task3.json \
	--capabilities CAPABILITY_IAM

}

task1
task2
task3


