###Creating IAM role for lambda
resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

##Creating IAM policy for the role
resource "aws_iam_policy" "iam_policy_for_lambda" {
 
 name         = "aws_iam_policy_for_terraform_aws_lambda_role"
 path         = "/"
 description  = "AWS IAM Policy for managing aws lambda role"
 policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:List*",
                    "s3:Get*"                   
    ],
      "Resource": ["arn:aws:s3:::my-first-backupp-bucket"]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": ["arn:aws:s3:::my-first-backupp-bucket/*"]
    }
  ]
}
EOF
}

##Attaching the policy to the IAM role
resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
 role        = aws_iam_role.iam_for_lambda.name
 policy_arn  = aws_iam_policy.iam_policy_for_lambda.arn
}


##Creating a ZIP of Python Application
data "archive_file" "zip_the_python_code" {
type        = "zip"
source_dir  = "${path.module}/lambda/"
output_path = "${path.module}/lambda/readstatefile.zip"
}



resource "aws_lambda_function" "this" {
  filename      = "${path.module}/lambda/readstatefile.zip"
  function_name = "read_state_file"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "index.lambda_handler"
  runtime = "python3.9"

  environment {
    variables = {
      BUCKET_NAME = "my-first-backupp-bucket"
    }
  }
  depends_on      = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
}