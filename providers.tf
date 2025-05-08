terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region     = "us-west-2"
  access_key = "TU_ACCESS_KEY"
  secret_key = "TU_SECRET_KEY"
}
