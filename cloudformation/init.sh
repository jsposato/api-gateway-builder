#!/usr/bin/env bash

PROFILE=$1
ENVIRONMENT=$2
ACTION=$3
SWAGGERPATH=$4
TEMPLATEPATH=${PWD}
CFBUCKET=mob-serverlesstodo-${ENVIRONMENT}
STACKNAME=ServerlessTODO-${ENVIRONMENT}


if [ ${ACTION} = "create" ]; then
    # create S3 bucket
    aws s3 mb s3://${CFBUCKET} --profile ${PROFILE}

    # upload swagger doc and templates
    aws s3 sync ${TEMPLATEPATH} s3://${CFBUCKET} --include "*.json" --profile ${PROFILE}
    aws s3 sync ${SWAGGERPATH} s3://${CFBUCKET} --include "*.json" --profile ${PROFILE}

set -x
    aws cloudformation create-stack \
        --stack-name ${STACKNAME} \
        --capabilities CAPABILITY_IAM \
        --parameters ParameterKey=Environment,ParameterValue=${ENVIRONMENT} ParameterKey=CFBucket,ParameterValue=${CFBUCKET} \
        --template-body file://${TEMPLATEPATH}/template.json \
        --profile ${PROFILE}

    # create lambda functions
    # create dynamo table
    # create roles
    # assign permissions
elif [ ${ACTION} = "update" ]; then

    # sync templates to S3 bucket
    aws s3 sync ./ s3://${CFBUCKET} --include "*.json" --profile ${PROFILE}
    aws s3 sync ../ s3://${CFBUCKET} --include "*.json" --profile ${PROFILE}

set -x
    # run CF update stack

elif [ ${ACTION} = "delete" ]; then

    # removed files from all S3 buckets
    aws s3 rm --recursive s3://${CFBUCKET} --profile ${PROFILE}
    # run CF delete
    aws cloudformation delete-stack \
        --stack-name ${STACKNAME}  \
        --profile ${PROFILE}
set -x
    # delete S3 buckets
    aws s3 rb s3://${CFBUCKET} --profile ${PROFILE}
else

    echo "don't know what you want to do"

fi
