terraform {
 required_version = "> 0.12.0"
}


provider "aws" {
  version = "~> 2.38.0"
  region  = "eu-west-1"
}

provider "github" {
    token        = "${var.github_token}"
    organization = "${var.github_org}"
    version = "~> 2.2.1"
}

