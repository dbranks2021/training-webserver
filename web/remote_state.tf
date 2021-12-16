terraform {
  backend "s3" {
    encrypt = "true"
    bucket  = "dawn-test"
    key     = "tfstate/web.tfstate"
    region  = "eu-west-1"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "dawn-test"
    key    = "tfstate/vpc.tfstate"
    region = "eu-west-1"
  }
}