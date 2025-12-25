#!/bin/bash


set -e

STACK_NAME="aws-infra-cf-stack"
TEMPLATE_FILE="infrastructure.yaml"
PARAMETERS_FILE="parameters.json"
REGION="us-east-1"

echo "CloudFormation Stack Deployment"
echo 
echo "Stack Name: $STACK_NAME"
echo "Region: $REGION"
echo 

if aws cloudformation describe-stacks --stack-name $STACK_NAME --region $REGION >/dev/null 2>&1; then
    echo "Stack exists. Updating..."
    aws cloudformation update-stack \
        --stack-name $STACK_NAME \
        --template-body file://$TEMPLATE_FILE \
        --parameters file://$PARAMETERS_FILE \
        --region $REGION \
        --capabilities CAPABILITY_IAM

    echo "Waiting for stack update to complete..."
    aws cloudformation wait stack-update-complete \
        --stack-name $STACK_NAME \
        --region $REGION
else
    echo "Creating new stack..."
    aws cloudformation create-stack \
        --stack-name $STACK_NAME \
        --template-body file://$TEMPLATE_FILE \
        --parameters file://$PARAMETERS_FILE \
        --region $REGION \
        --capabilities CAPABILITY_IAM

    echo "Waiting for stack creation to complete..."
    aws cloudformation wait stack-create-complete \
        --stack-name $STACK_NAME \
        --region $REGION
fi

aws cloudformation describe-stacks \
    --stack-name $STACK_NAME \
    --region $REGION \
    --query 'Stacks[0].Outputs[*].[OutputKey,OutputValue]' \
    --output table

echo ""
echo "To get the SSH command:"
echo "aws cloudformation describe-stacks --stack-name $STACK_NAME --region $REGION --query 'Stacks[0].Outputs[?OutputKey==\`ConnectCommand\`].OutputValue' --output text"