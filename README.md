# anomaly_detector_cfn
# Cloud Infrastructure as Code using AWS CloudFormation for IoT Data Anomaly Detection

This project has been completed as part of course on Software Engineering for IoT, Blockchain and Cloud Computing conducted by Great Learning&reg; in collaboration with IIT, Madras

##  Project Destription

The project involves deployment of cloud infratrusture on AWS using IaC (Infrastrure as Code). AWS CloudFormation templates have been used to define infrastructure.

The project comprises three parts, viz. Task1, Task2 and Task3 (as per the problem statement). The templates are defined in JSON in the files `task1.json`, `task2.json` and `task3.json` in the `templates` folder. 

After provisioning of ec2 instance in task1, the application code is deployed on the ec2 instance using AWS CodeDeploy service. The application specification file for CodeDeploy is given in `appspec.yml` file. CodeDeploy is provisioned using `aws cli`. The commands are given in the task2 function in the `deploy.sh` script.

The `cleanup.sh` script is used to destroy the stacks and cleanup the infrastructure.

## Setting up the Cloud Infrastructure

The template expects two parameters, viz. `KeyName` (name of keypair), `AnomalyAlertsEmail` (the Email Address where alerts are to be sent) and `AppS3BucketName` (name of the S3 Bucket where the application and lambda handler code will be pushed for deployment in task2 and task3).

The `deploy.sh` script may be used for running all the three tasks. For this to work, the above parameters must be stored in the `templates/params.json` file. The provided script runs on Linux (Unix) and Mac systems only. It is assumed that aws cli is installed on the system and properly configured with access key and secret.

In the lambda_hander code in `anomaly_detection.py` change the `topic_arn` in line number 22 to as per the account being used to deploy the project.

```console
foo@bar:~$ cd <project dir>
foo@bar:~$ chmod 755 deploy.sh
foo@bar:~$ ./deploy.sh
```

For SNS Notification to succeed, the user is to check his/her mail box and subscribe to the SNS topic. 

## Cleaning up Resources on Cloud

```console
foo@bar:~$ chmod 755 cleanup.sh
foo@bar:~$ ./cleanup.sh
```


&copy; Great Learning&reg; and IIT, Madras

