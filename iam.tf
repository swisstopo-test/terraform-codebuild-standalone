


// --------- POlcies ---------------------



// TODO add to role...
resource "aws_iam_policy" "ecr_policy" {
  name = "${var.project}_ecr_policy"
  //role = "${aws_iam_role.codebuild_role.id}"
  path        = "/"
  description = "My test policy"



  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "ecr:GetAuthorizationToken",
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "ecr:*",
            "Resource": "arn:aws:ecr:eu-west-1:050475232797:repository/*"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "codebuild_policy" {
  name        = "${var.project}-codebuild-policy"
  path        = "/service-role/"


  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "codebuild:*",
      "Resource": "${aws_codebuild_project.standalone.id}"
    },
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "autoscaling:*",
        "codebuild:*",
        "ec2:*",
        "elasticloadbalancing:*",
        "iam:*",
        "logs:*",
        "rds:DescribeDBInstances",
        "route53:*",
        "s3:*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameters",
        "ssm:PutParameter"
      ],
      "Resource": "arn:aws:ssm:eu-west-1:${var.account_id}:parameter/*"
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "ssm_policy" {
  name        = "${var.project}-ssm-policy"
  path        = "/service-role/"


  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ssm:DescribeParameters"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ssm:GetParameters"
            ],
            "Resource": "arn:aws:ssm:eu-west-1:050475232797:parameter/terraform-codepipeline-*"
        }
    ]
}
POLICY
}

// ----------- Roles ----------------


resource "aws_iam_role" "codebuild_role" {
  name = "${var.project}-codebuild-role"
  description = "Role for test project <${var.project}>"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "codebuild.amazonaws.com",
          "codepipeline.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}



resource "aws_iam_policy_attachment" "codebuild_policy_attachment" {
  name       = "${var.project}-codebuild-policy-attachment"
  policy_arn = "${aws_iam_policy.codebuild_policy.arn}"
  roles      = ["${aws_iam_role.codebuild_role.id}"]
}

resource "aws_iam_policy_attachment" "codebuild_policy_attachment2" {
  name       = "${var.project}-codebuild-policy-attachment2"
  policy_arn = "${aws_iam_policy.ecr_policy.arn}"
  roles      = ["${aws_iam_role.codebuild_role.id}"]
}

resource "aws_iam_policy_attachment" "codebuild_policy_attachment3" {
  name       = "${var.project}-codebuild-policy-attachment3"
  policy_arn = "${aws_iam_policy.ssm_policy.arn}"
  roles      = ["${aws_iam_role.codebuild_role.id}"]
}

