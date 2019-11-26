

data "aws_ssm_parameter" "webhook_secret" {
   name = "/${var.ssm_name}/webhook_secret"
}


## Wire the CodePipeline webhook into a GitHub repository.
resource "github_repository_webhook" "bar" {
  repository = "${var.github_repo}"   
  
   configuration {
     url          =  "${aws_codebuild_webhook.standalone.payload_url}" 
     content_type = "application/json"
     insecure_ssl = false
     secret       = "${data.aws_ssm_parameter.webhook_secret.value}"
   }
  
    events = ["push", "pull_request"]
}


output "github_webhook_url" {
  description = "Github webhook"
  value       = "${github_repository_webhook.bar.url}"
}
 
 

