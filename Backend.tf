terraform {
  required_version = "= 1.9.6"
  required_providers {
    aws = "~> 3.51"

  }


  backend "s3" {
    bucket  = "terraform-afif-states"
    key     = "states/terraform-test.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

provider "aws" {
  profile                 = "default"
  region                  = "eu-central-1"
  shared_credentials_file = "C:/Users/Soussi/.aws/credentials"
}


