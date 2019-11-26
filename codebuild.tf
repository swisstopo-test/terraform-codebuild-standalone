# Independant coebuild

resource "aws_codebuild_source_credential" "example" {
  auth_type = "PERSONAL_ACCESS_TOKEN"
  server_type = "GITHUB"
  token = "${var.github_token}"
}


resource "aws_codebuild_project" "standalone" {
  name          = "${var.project}"
  description   = "Standalone CodeBuild Project"
  build_timeout = "10"
  service_role  = "${aws_iam_role.codebuild_role.arn}"
  badge_enabled = true

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "${var.docker_build_image}"
    type         = "LINUX_CONTAINER"
    privileged_mode = true

    environment_variable {
      name  = "RELEASE_BUCKET_NAME"
      value = "aws-admin-test-1-releases"
    }
    environment_variable {
      name  = "ARTIFACT_NAME"
      value = "hello"
    }
    environment_variable {
      name  = "ARTIFACT_FILENAME"
      value = "hello"
    }
    environment_variable {
      name  = "GITHUB_TOKEN"
      value = "${var.github_token}"
    }

  }
  source {
    type            = "GITHUB"
    location        = "https://github.com/${var.github_org}/${var.github_repo}.git"
    git_clone_depth = 25
    report_build_status = true
  }

  artifacts {
    type = "NO_ARTIFACTS"
  }
}



resource "aws_codebuild_webhook" "standalone" {
  project_name = "${aws_codebuild_project.standalone.name}"

  filter_group {
  		filter {
  			type = "EVENT"
  			pattern = "PUSH"
  		}
  		filter {
  			type = "HEAD_REF"
  			pattern = "refs/heads/master"  
  		}
  	}
  	filter_group {
  		filter {
  			type = "EVENT"
  			pattern = "PULL_REQUEST_CREATED"
  		}
  		
  	}
  	filter_group {
  		filter {
  			type = "EVENT"
  			pattern = "PULL_REQUEST_UPDATED"
  		}
  		
  	}
  	
}





output "badge_url" {
  description = "The URL of the build badge when badge_enabled is enabled"
  value       = "${aws_codebuild_project.standalone.badge_url}"
}

output "webhook_url" {
  description = "The URL to the webhook."
  value       = "${aws_codebuild_webhook.standalone.url}"
}

output "webhook_payload_url" {
  description = "The CodeBuild endpoint where webhook events are sent."
  value       = "${aws_codebuild_webhook.standalone.payload_url}"
}
