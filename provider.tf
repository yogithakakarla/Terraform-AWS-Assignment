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
    key    = "main-statefile"
    region = "eu-north-1"
  }
}

