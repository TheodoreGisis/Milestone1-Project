# Description:
# This Terraform script configures AWS CloudWatch Log Metric Filters and Alarms to monitor errors in Lambda function logs. 
# It creates a metric filter to count errors based on a specified pattern within a CloudWatch Log Group. 
# Additionally, it sets up an SNS topic for notifications and an email subscription for alerting on errors exceeding a threshold.

#Create custom filter for our lambda log group.The filter is that every time that we count the word "ERROR" if it is existing in logs.
resource "aws_cloudwatch_log_metric_filter" "lambdaLogErrorsCountMetric" {
  name           = var.Error-Count-Metric
  pattern        = var.pattern
  log_group_name = aws_cloudwatch_log_group.function_log_group.name
  metric_transformation {
    name      = var.metric_name
    namespace = var.metric_namespace
    value     = "1"
  }
}

#Create SNS Topic to be notified via email
resource "aws_sns_topic" "errorsOverTheLimit" {
  name = var.sns_topic_name
  tags = local.common_tags
}

#Create an email subscription. This email will notify every time that the SNS topic send an alert
resource "aws_sns_topic_subscription" "EmailSubscription" {
  topic_arn = aws_sns_topic.errorsOverTheLimit.arn
  protocol  = "email"
  endpoint  = var.email_subscription #You can change the email from the variables.tf file
}

#Establish a CloudWatch Alarm: We've configured an alarm to activate when the Lambda function detects one or more occurrences of the term "ERROR."
resource "aws_cloudwatch_metric_alarm" "lambdaErrorsCountAlarm" {
  alarm_name                = var.alarm_name
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 1
  metric_name               = var.metric_name
  namespace                 = var.metric_namespace
  period                    = 300                         #Period 5 minutes
  statistic                 = "SampleCount"
  threshold                 = 1                           #You can change the theshold from here
  alarm_description         = var.aws_sns_topic_description
  insufficient_data_actions = []
  treat_missing_data        = "notBreaching"
  alarm_actions             = [aws_sns_topic.errorsOverTheLimit.arn]
  tags                      = local.common_tags
}

