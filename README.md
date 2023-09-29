# Terraform Configuration for Hosting an S3 Static Website via Cloudfront

This project provides a simple Terraform configuration for hosting a static website on Amazon S3, distributing it through Amazon CloudFront, and configuring a Route 53 DNS entry for the website. With minimal setup, you can deploy your static website to a highly available and scalable infrastructure on AWS.

## Prerequisites

Before you begin, ensure you have the following prerequisites in place:

1. [Terraform](https://www.terraform.io/) installed on your local machine.
2. AWS CLI configured with your AWS credentials.

## Getting Started

Follow these steps to set up and deploy your static website:

### 1. Clone the Repository

Clone this repository to your local machine:

```bash
git clone <repository_url>
cd <repository_directory>
```

### 2. Initialize Your Project

Run the following command to initialize your Terraform project:

```bash
make setup
```

This will try to install terraform and awscli as well as get you to configure it. You can skip this if you already have these installed and setup or you want to do it manually.

### 3. Initialize Terraform

Run the following command to initialize Terraform and download the required providers:

```bash
make init
```

### 4. Validate Your Configuration

Validate your Terraform configuration to ensure there are no errors:

```bash
make validate
```

### 5. Plan Your Deployment

Generate an execution plan to review the changes that will be applied:

```bash
make plan
```

Review the plan to ensure it aligns with your expectations.

### 6. Apply Your Configuration

Apply the Terraform configuration to create your AWS resources:

```bash
make apply
```

Terraform will prompt you to confirm the changes. Type `yes` to proceed with the deployment.

## Clean Up

To destroy the infrastructure and remove all resources, run:

```bash
make destroy
```

## Contributing

If you find issues or have suggestions for improvements, please feel free to open an issue or submit a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.