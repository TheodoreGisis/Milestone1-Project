# This Terraform configuration defines an AWS IAM role for the Lambda function. 
#The IAM role allows the Lambda function to assume necessary permissions to execute its tasks. 
#It includes a policy that grants permissions for logging activities to CloudWatch Logs.


# Define IAM role for the Lambda function
resource "aws_iam_role" "lambda_role" {
  name  = var.lambda_function_role_name
  tags  = local.common_tags
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "lambda.amazonaws.com"
        },
        "Effect": "Allow"
      }
    ]
  })
}

# Define IAM policy for the Lambda function role.This policy allows the lambda function to write logs on the Cloudwatch.
resource "aws_iam_policy" "iam_policy_for_lambda" {
  name        = var.lambda_function_policy_name
  path        = "/"
  description = "AWS IAM Policy for managing AWS Lambda role"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource": "arn:aws:logs:*:*:*",
        "Effect": "Allow"
      }
    ]
  })
}

# Attach IAM policy to IAM role
resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.iam_policy_for_lambda.arn
}

# Create Lambda function
resource "aws_lambda_function" "Milistone-1-Lambda" {
  filename    = "${path.module}/nodejs/milestone1.zip" #Code for our lambda is uploaded with zip.
  function_name = var.lambda_function_name
  role        = aws_iam_role.lambda_role.arn #Here we are attach the role that we created previous for our lambda function.
  handler     = "index.handler"
  runtime     = "nodejs20.x"
  timeout     = 900  #We are setting the timeout at 15min.This is the maximum time that one lambda function can run.
  tags        = local.common_tags
  depends_on  = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
  source_code_hash = data.archive_file.zip_the_nodejs_code.output_base64sha256 #Reads every changes that happen in local code and push it to aws
}

#Create Log group for our lambda function logs.At this log group we can find all the logs from the execution of our lambda.
resource "aws_cloudwatch_log_group" "function_log_group" {
    name    =   "/aws/lambda/${aws_lambda_function.Milistone-1-Lambda.function_name}"
    retention_in_days = var.retention_in_days
    tags    = local.common_tags
    lifecycle {
    prevent_destroy = false
  }
}

# Archive nodejs code for Lambda function.To upload our code to the lambda function, we create a dictionary called nodejs in the root folder.
#Then we convert our folder in zip mode and we upload the code to the lambda function.
data "archive_file" "zip_the_nodejs_code" {
  type        = "zip"
  source_dir  = "${path.module}/nodejs/"
  output_path = "${path.module}/nodejs/milestone1.zip"
}

