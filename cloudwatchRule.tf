# Description:
# This Terraform script sets up an AWS CloudWatch Event Rule to trigger a Lambda function on a scheduled basis. 
# The schedule expression is defined by the provided cron expression. 
# Additionally, it configures permissions to allow CloudWatch Events to invoke the Lambda function.

# Resource block for creating a CloudWatch Event Rule
resource "aws_cloudwatch_event_rule" "schedule" {
  name                =  var.cloudwatch_event_rule_name
  description         =  var.cloudwatch_event_rule_description
  is_enabled          =  true       #Make it false if you wand to disable the alarm
  schedule_expression =  var.cron   #cron expression to trigger lambda every 5 minutes.If you want to change the cron job go to the variables.tf file
  tags                =  local.common_tags
}

# Resource block for creating a target for the CloudWatch Event Rule (in this case, a Lambda function)
resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.schedule.name
  target_id = "lambda_target"
  arn       = aws_lambda_function.Milistone-1-Lambda.arn #Here we specify the lammbda function that we have created in lambda.tf file
}

# Resource block for granting permission to CloudWatch Events to invoke the Lambda function
resource "aws_lambda_permission" "allow_cloudwatch_to_call_check_foo" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.Milistone-1-Lambda.function_name
    principal = "events.amazonaws.com"
    source_arn = aws_cloudwatch_event_rule.schedule.arn
}
