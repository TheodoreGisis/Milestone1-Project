output "cloudwatch_log_metric_filter_id" {
  value = aws_cloudwatch_log_metric_filter.lambdaLogErrorsCountMetric.id
}

output "sns_topic_id" {
  value = aws_sns_topic.errorsOverTheLimit.id
}

output "sns_topic_subscription_id" {
  value = aws_sns_topic_subscription.EmailSubscription.id
}

output "cloudwatch_metric_alarm_id" {
  value = aws_cloudwatch_metric_alarm.lambdaErrorsCountAlarm.id
}

output "lambda_function_arn" {
  value = aws_lambda_function.Milistone-1-Lambda.arn
}

output "lambda_function_name" {
  value = aws_lambda_function.Milistone-1-Lambda.function_name
}

output "lambda_function_invoke_arn" {
  value = aws_lambda_function.Milistone-1-Lambda.invoke_arn
}

output "lambda_function_role_arn" {
  value = aws_iam_role.lambda_role.arn
}

output "lambda_function_log_group_name" {
  value = aws_cloudwatch_log_group.function_log_group.name
}

output "rest_api_id" {
  value = aws_api_gateway_rest_api.MilestoneAPI.id
}

output "resource_id" {
  value = aws_api_gateway_resource.resourse.id
}

output "method_id" {
  value = aws_api_gateway_method.method.id
}

output "integration_id" {
  value = aws_api_gateway_integration.lambda.id
}

output "lambda_permission_id" {
  value = aws_lambda_permission.apigw.id
}

output "deployment_id" {
  value = aws_api_gateway_deployment.deployment.id
}

output "method_response_id" {
  value = aws_api_gateway_method_response.response.id
}

output "integration_response_id" {
  value = aws_api_gateway_integration_response.example.id
}


