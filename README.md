# DevOps Project: Stock Exchange Data Processing with ECS, S3, and Terraform
This project demonstrates the automation of a Dockerized application using AWS services (ECS, S3) and Terraform for infrastructure provisioning. The system ingests, processes, and displays stock exchange data. The deployment pipeline is managed using GitLab CI and supports Blue-Green Deployment for seamless updates.
# Overview
## Key Components:
  * ECS (Elastic Container Service): Orchestrates Docker containers, running tasks to fetch stock exchange data.
  * S3 (Simple Storage Service): Used for data storage and static website hosting.
  * Terraform: Manages the infrastructure deployment for ECS, S3, and other AWS resources.
  * Application Load Balancer (ALB): Routes traffic between the Blue and Green environments, allowing controlled deployment and rollback.
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
with load balancer
http://cb-load-balancer-1550563592.eu-central-1.elb.amazonaws.com
Blue URL
http://my-exchange-rate-blue-bucket.s3-website.eu-central-1.amazonaws.com
green URL
http://my-exchange-rate-blue-bucket.s3-website.eu-central-1.amazonaws.com

## Execution Flow
  * ECS runs the Docker container to fetch and process stock exchange data.
  * The processed data is saved in S3.
  * The S3-hosted static website displays the processed data in an HTML table.
  * Terraform manages the AWS infrastructure provisioning.
  * GitLab CI handles the continuous integration and deployment of the Docker image and Terraform infrastructure.

## Blue-Green Deployment Strategy
The project follows a Blue-Green Deployment strategy to ensure zero-downtime updates and safe rollbacks in case of errors. This strategy utilizes two distinct environments:

  * Blue (Production): The current live environment serving user traffic.
  * Green (Testing): The environment where new versions of the application are deployed and tested.
### Deployment Flow:
  * The first Terraform deployment applies changes only to the green environment (green S3 bucket and green ECS task).
  * After deployment, the pipeline waits for 2 minutes, then checks the health status of the green bucket using Route 53 health checks.
  * If the green bucket passes the health check, the pipeline proceeds to deploy the code to the blue environment (blue S3 bucket and blue ECS task).
  * The pipeline waits again for 2 minutes, then checks the health status of the blue bucket.
  * If the blue environment fails its health check, the pipeline rolls back the deployment by reapplying the green deployment.
### Key Components of the Blue-Green Deployment:
  * ECS Task Definitions: Separate task definitions for Blue and Green environments manage the different application versions.
  * S3 Buckets: Two S3 buckets—my-exchange-rate-blue-html-bucket and my-exchange-rate-green-html-bucket—are used to store processed data and host the static website for each environment.
## CI/CD Pipeline Stages
The pipeline, managed with GitLab CI, is structured to ensure proper testing and validation at each stage before the final switch to production.

  * Python Lint and Tests: Lints the code using tools like flake8 and black and runs unit tests to ensure code quality.
  * Build and Push Docker Image: Builds the Docker image for the application and pushes it to the GitHub Container Registry (GHCR) with a version tag.
  * Terraform Infrastructure Deployment: Deploys the infrastructure, including ECS services for both Blue and Green environments, and configures the S3 buckets.
  * Test Green Environment: Once the Green environment is deployed, automated health checks verify that the service is functioning correctly.
  * Promote Green to Production: After successful tests, traffic is switched to the Green environment using the ALB, promoting it to production.
  * Rollback to Blue (if necessary):If tests fail, the ALB is used to immediately route traffic back to the Blue environment, ensuring zero downtime.

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
  * A GitLab CI pipeline handles the entire deployment process, from building the Docker image to deploying the infrastructure with Terraform.
  * Multiple stages in the pipeline ensure that both the code and infrastructure are tested before any traffic is switched to the Green environment.
## 6- Future Improvements
  * TLS for Security: The application is running on port 80 over HTTP, with no TLS security. In the future, a TLS certificate can be added for secure communication.