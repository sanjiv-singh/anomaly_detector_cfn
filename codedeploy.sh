#!/bin/bash

aws iam create-role \
    --role-name codedeploy-service-role \
    --assume-role-policy-document file://code_policy.json

aws iam attach-role-policy \
    --role-name codedeploy-service-role \
    --policy-arn arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole

role_arn=$(aws iam get-role --role-name codedeploy-service-role --query "Role.Arn" --output text)

aws deploy create-application --application-name my-app

aws deploy push \
  --application-name my-app \
  --s3-location s3://sanjivsingh-gl-app-bucket/app.zip \
  --ignore-hidden-files

aws deploy create-deployment-group \
  --application-name my-app \
  --deployment-group-name my-app-group \
  --deployment-config-name CodeDeployDefault.OneAtATime \
  --ec2-tag-filters Key=ec2-app-name,Value=my-app,Type=KEY_AND_VALUE \
  --service-role-arn $role_arn

aws deploy create-deployment \
  --application-name my-app \
  --deployment-config-name CodeDeployDefault.OneAtATime \
  --deployment-group-name my-app-group \
  --s3-location bucket=sanjivsingh-gl-app-bucket,bundleType=zip,key=app.zip

