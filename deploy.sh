#!/bin/bash

aws cloudformation deploy \
	--stack-name task1stack \
	--parameter-overrides EmailAddress=sk.sanjiv@gmail.com \
	--template-file task1.json
