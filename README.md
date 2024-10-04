# DevOps Project: Stock Exchange Data Processing with ECS, S3, and Terraform
This project demonstrates the automation of a Dockerized application using AWS services (ECS, S3) and Terraform for infrastructure provisioning. The system ingests, processes, and displays stock exchange data. The deployment pipeline is managed using GitLab CI.
# Overview
## Key Components:
  * ECS (Elastic Container Service): Orchestrates Docker containers, running tasks to fetch stock exchange data.
  * S3 (Simple Storage Service): Used for data storage and static website hosting.
  * Terraform: Manages the infrastructure deployment for ECS, S3, and other AWS resources.
  * Python: Handles the data ingestion and processing logic.
  * Docker: Containers the Python application and its dependencies.

## How to Run the Application
### Build the Docker Image:
```bash
docker build -t stock-exchange-app .
docker run stock-exchange-app
```
### Deploy with Terraform:
```bash
terraform init
terraform apply
```
### Access the website 
http://my-exchange-rate-html-bucket.s3-website.eu-central-1.amazonaws.com

## Execution Flow
  * ECS runs the Docker container to fetch and process stock exchange data.
  * The processed data is saved in S3.
  * The S3-hosted static website displays the processed data in an HTML table.
  * Terraform manages the AWS infrastructure provisioning.
  * GitLab CI handles the continuous integration and deployment of the Docker image and Terraform infrastructure.



# AWS Architecture
### Data Ingestion Layer:
  * ECS: Runs a Docker container that fetches stock exchange data and processes it.
  * Future Expansion: CloudWatch Events can be used in the future to schedule the ECS task to run periodically (e.g., daily).
### Data Storage Layer:
  * S3: Stores the downloaded and processed datasets.
  * S3 (Static Website Hosting): Hosts a simple HTML page displaying the extracted data.
### Orchestration & Infrastructure Layer:
  * Terraform: Used to define and automate the provisioning of ECS, S3, and other necessary AWS resources.
  * ECS: Manages the orchestration of the Docker container that processes the data.
### CI/CD Pipeline:
  * GitLab CI: Automates the deployment process, building the Docker image, pushing it to GitHub Container Registry (GHCR), and deploying the infrastructure using Terraform
  .
### Security and authentication:
  * IAM Role: The ECS task assumes an IAM role with permissions to access S3, ensuring no hardcoded credentials are used in the application.
  * Boto3 SDK: The application uses the boto3 SDK to interact with AWS services, leveraging the IAM role for secure and seamless access to S3.
  * No Static Credentials: Credentials are securely managed via AWS IAM roles, following best practices for accessing S3 from ECS tasks.


# Implementation Steps
### 1- S3 Bucket Setup
  * Created an S3 bucket for hosting the state file, initially public for testing. The bucket will be made private later.
  * Static Website Hosting: Configured an S3 bucket to host a helloworld.html page to verify connectivity and basic setup.
### 2- Infrastructure Deployment with Terraform
  * Defined infrastructure in Terraform to deploy resources across multiple Availability Zones for redundancy.
  * The Terraform configuration includes setting up ECS for orchestrating the container and S3 for both data storage and static website hosting.
### 3- Python Application and Docker Setup
  * Created a Python script to fetch stock exchange data and save it locally.
  * Packaged the Python application and its dependencies into a Docker container.
  * Used GitHub Container Registry (GHCR) to store the Docker image to avoid extra authentication with AWS/ECS.
### 4- ECS Task for Data Processing
  * An ECS task was created to pull the Docker image from GHCR and run it on a Fargate instance. This task fetches and processes stock exchange data.
  * Currently, the task is triggered manually, but it can be scheduled using CloudWatch Events for automation in the future.
### 5- CI/CD Pipeline
Implemented a GitLab CI pipeline with two jobs:
  * Build and Push Docker Image: Builds the Docker container and pushes it to GHCR.
  * Terraform Infrastructure Deployment: Deploys the infrastructure, ensuring the ECS task is orchestrated and the S3 bucket is correctly configured.
The Terraform job depends on the successful completion of the Docker build job.
## Future Improvements
  * EventBridge Scheduling: While currently not implemented, AWS EventBridge can be used in the future to run the ECS task on a schedule (e.g., daily).
  * TLS for Security: The application is running on port 80 over HTTP, with no TLS security. In the future, a TLS certificate can be added for secure communication.
