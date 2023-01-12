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

task3() {

    zip anomaly_lambda.zip anomaly_detection.py
    aws s3 cp anomaly_lambda.zip s3://$BUCKET_NAME/anomaly_lambda.zip

    stream_arn=$(aws kinesis describe-stream --stream-name "$STREAM_NAME" --query "StreamDescription.StreamARN" --output text)

    aws cloudformation deploy \
	--stack-name task3stack \
        --parameter-overrides "KinesisStreamArn=$stream_arn" \
	--template-file task3.json \
	--capabilities CAPABILITY_IAM

}

task1
task2
task3

