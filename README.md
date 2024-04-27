
# aws-lambda-python-dynamodb

## Description
This project allows performing CRUD operations on a DynamoDB table, which is created and managed using Terraform. It utilizes AWS Lambda for the operations, making the solution serverless and scalable.

*Lea este archivo en otros idiomas: [Español](README_ES.md)*

## Prerequisites
Before getting started, you'll need to set up your environment with some tools and configurations:

1. **AWS Account**: You'll need an AWS account.
2. **AWS CLI**: Installed and configured on your local machine. [AWS CLI Installation and Configuration Guide](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).
3. **Terraform**: You'll need Terraform installed to run local tests and deploy the necessary infrastructure. [Download Terraform](https://www.terraform.io/downloads.html).

## Initial Configuration

### Configure Terraform State

1. **Create an S3 Bucket**:
   - You'll need an S3 bucket to handle Terraform state.
   - Make sure to create the bucket in the region where you want to deploy your resources.

### Configure AWS CLI

- Ensure your AWS CLI is configured correctly by running:
  ```bash
  aws configure
  ```

## Deploying Infrastructure with Terraform

To deploy the necessary infrastructure for this project, follow these steps:

1. **Initialize Terraform**:
   - Navigate to the directory where your `config.tf` file is located.
   - Initialize Terraform:
     ```bash
     cd infra
     terraform init
     ```

2. **Plan Changes**:
   - Review the changes Terraform will apply:
     ```bash
     terraform plan
     ```

3. **Apply Changes**:
   - Apply the changes to configure the infrastructure:
     ```bash
     terraform apply --auto-approve
     ```

## Usage

Once the infrastructure is deployed, you can use AWS Lambda functions to perform CRUD operations on the configured DynamoDB table.

### Test Events for AWS Lambda

To test AWS Lambda functions from the AWS console, you can use the following test events:

1. **Get Car Information (GET)**:
   ```json
   {
     "httpMethod": "GET",
     "path": "/cars",
     "queryStringParameters": {
       "carId": "1"
     }
   }
   ```

2. **Create a New Car (POST)**:
   ```json
   {
     "httpMethod": "POST",
     "path": "/cars",
     "headers": {},
     "body": "{"carId": "1", "model": "tesla"}"
   }
   ```

## Contributing

If you'd like to contribute to this project, please consider submitting a pull request with your changes or improvements.

## License

This project is under a free license. You can use and modify it at your own responsibility and needs.
