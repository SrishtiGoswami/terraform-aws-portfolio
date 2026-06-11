#!/bin/bash

# Define Variables
BUCKET_NAME="terraform-portfolio-state-$RANDOM"
REGION="us-east-1"
TABLE_NAME="terraform-lock-table"

echo "Starting AWS Backend Bootstrap..."

# 1. Create the S3 Bucket
echo "Creating S3 bucket: $BUCKET_NAME"
aws s3api create-bucket \
    --bucket $BUCKET_NAME \
    --region $REGION

# 2. Enable Bucket Versioning
echo "Enabling versioning for state recovery..."
aws s3api put-bucket-versioning \
    --bucket $BUCKET_NAME \
    --versioning-configuration Status=Enabled

# 3. Enable Server-Side Encryption (AES256)
echo "Enabling default encryption..."
aws s3api put-bucket-encryption \
    --bucket $BUCKET_NAME \
    --server-side-encryption-configuration '{"Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]}'

# 4. Create the DynamoDB Lock Table
echo "Creating DynamoDB table: $TABLE_NAME"
aws dynamodb create-table \
    --table-name $TABLE_NAME \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST \
    --region $REGION \
    --no-cli-pager

echo "Bootstrap complete!"
echo "========================================"
echo "CRITICAL: Copy your bucket name below:"
echo "Bucket Name: $BUCKET_NAME"
echo "========================================"
