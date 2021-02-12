provider "aws" {
  profile = "default"
  region  = "sa-east-1"
}

module "aws_kinesis" {
  source = "./kinesis/"
}

module "lambda_producer" {
  source = "./lambda_producer/"
}