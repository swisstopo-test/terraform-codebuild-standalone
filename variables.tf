variable "account_name" {
  default = "aws-admin-test-1"
}

variable "github_org" {
  #default = "swisstopo-test"
}

variable "account_id" {
    default = "not-set"
}

variable "github_token" {
    description = "GitHub personnal access token"
}

variable "github_repo" {
    description = "GitHub repository to use as source (name only, should match 'github_org')"

}


variable "github_repos" {
    description = "List of GitHub repositor to build"
    default     = []
}


variable "project" {
# 	default = "terraform-codebuild-standalone"
}

variable "bucket" {
	# default = "terraform-codebuild-standalone"
}

variable "docker_build_image" {
   # default = "ubuntu"
   default = "aws/codebuild/standard:2.0-1.13.0"
}

variable "ssm_name" {
    default ="terraform-codepipeline-example"
}


