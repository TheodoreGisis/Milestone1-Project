###############################################
#Variables for lambda.tf file
variable lambda_function_name {
  type        = string
  default     = "Milestone-1"
  description = "Name for our Lambda function"
}

variable lambda_function_role_name{
  type        = string
  default     = "Milestone-1-Lambda-Function-Role-Name"
  description = "Name for our Role Name"
}


variable lambda_function_policy_name{
  type        = string
  default     = "Milestone-1-Lambda-Function-Policy-Name"
  description = "Name for our Policy Name"
}

variable retention_in_days{
    type    =   number
    default =   7
    description = "Retantion days for lambda logs"
}

###############################################
#Variables for cloudwatch.tf file

variable Error-Count-Metric{
  type        = string
  default     = "Milestone-1-Error-Count-Metric"
  description = "Log Metric Name"
}

variable pattern {
    type    = string
    default = "%ERROR%"
    description = "Pattern that we are using for our costum metric"
}

variable metric_name {
    type    = string
    default = "Milestone-1-Lambda-Errors"
    description = "Costum metric name for our "
}

variable metric_namespace{
    type    = string
    default = "Milestone-1-Lambda-Errors"
    description = "Costum metric namespace name"  
}

variable sns_topic_name{
    type    = string
    default = "Milestone-1-ErrorsOverTheLimit"
    description = "SNS Topic name"     
}

variable alarm_name{
    type    = string
    default = "Milestone-1-Lambda-Function-Error"
    description = "Name for our lambda alarm"      
}

variable aws_sns_topic_description{
    type   = string
    default = "This is an SNS that send an email when an error is detecting to the lambda function"
    description ="Description for our SNS topic"
}

variable email_subscription{
    type   = string
    default = "theodorosgkisis@gmail.com"
    description ="Give an email for SNS subscription"
}

###############################################
#Variables for api.tf file

variable REST_API_Name{
    type   = string
    default = "Milestone-1-API"
    description ="Name for our API"

}

variable REST_API_Description{
    type   = string
    default = "This is a REST Api for the first milestone project"
    description ="Desctiption for our REST API"

}

variable resource_path{
    type   = string
    default = "milestone-one"
    description ="resourse path for the REST API"
}

variable stage_name{
    type   = string
    default = "first-stage"
    description ="Name for stage"
}
###############################################
#Variables for cloudwatchRule.tf file

variable cloudwatch_event_rule_name{
    type   = string
    default = "Milestone-1-lambda_trigger_rule"
    description ="Name for cloudwatch event rule"
}

variable cloudwatch_event_rule_description{
    type   = string
    default = "Trigger Lambda function every 5 minutes"
    description ="Description for the evet rule"
}

variable cron{
    type   = string
    default = "rate(5 minutes)"
    description ="Cron job for our rule.We set our rule to trigger lambda every 5 minutes"
}
