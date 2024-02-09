provider "aws" {
  region = "eu-north-1"

  default_tags {
    tags = {
      Environment = "stage"
      Name        = "YogithaKakakrla"
    }
  }
}

terraform {
  backend "s3" {
    bucket = "terraform-assignment"
    key    = "ec2"
    region = "eu-north-1"
  }
}

/*
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "terraform-assignment"
    key    = "vpc/terraform.tfstate"
    region = "eu-north-1"
  }
}
*/
