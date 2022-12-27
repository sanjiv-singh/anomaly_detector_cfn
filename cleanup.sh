#!/bin/bash

aws ec2 delete-key-pair --key-name gltest
rm -f gltest.pem

aws cloudformation delete-stack \
	--stack-name task1stack
