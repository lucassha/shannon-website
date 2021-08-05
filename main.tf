provider "aws" {
  region  = "us-east-1"
  profile = "shannon"
}

terraform {
  backend "s3" {
    bucket  = "shannon-website"
    key     = "public-webpage/terraform.tfstate"
    region  = "us-west-2"
    profile = "shannon"
  }
}
