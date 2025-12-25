#!/bin/bash
# CloudFormation Stack Deletion Script

set -e

STACK_NAME="aws-infra-cf-stack"
REGION="us-east-1"

echo "======================================"
echo "CloudFormation Stack Deletion"
echo "======================================"
echo "Stack Name: $STACK_NAME"
echo "Region: $REGION"
echo "======================================"
echo ""

read -p "Are you sure you want to delete the stack? (yes/no): " CONFIRM

if [ "$CONFIRM" != "yes" ]; then
    echo "Deletion cancelled."
    exit 0
fi

echo "Deleting stack..."
aws cloudformation delete-stack \
    --stack-name $STACK_NAME \
    --region $REGION

echo "Waiting for stack deletion to complete..."
aws cloudformation wait stack-delete-complete \
    --stack-name $STACK_NAME \
    --region $REGION

echo ""
echo "======================================"
echo "Stack deleted successfully!"
echo "======================================"