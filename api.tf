# Description:
# This Terraform script sets up an AWS API Gateway with a REST API to expose endpoints for the first milestone project. 
# It creates a resource representing an entity, such as "/users", and defines a GET method on this resource with no authorization required. 
# Integration between the GET method and a Lambda function is established, with permissions granted to API Gateway to invoke the Lambda function. 
# The API is deployed to a specified stage, and method responses are configured for successful GET requests with a status code of 200 and an empty response model.

# Create the API Gateway
resource "aws_api_gateway_rest_api" "MilestoneAPI" {
  name        = var.REST_API_Name
  description = var.REST_API_Description
  tags        = local.common_tags
}

# Create a resource under the API, this could represent an entity - e.g. "/milestone-one"
resource "aws_api_gateway_resource" "resourse" {
  rest_api_id = aws_api_gateway_rest_api.MilestoneAPI.id
  parent_id   = aws_api_gateway_rest_api.MilestoneAPI.root_resource_id
  path_part   = var.resource_path
}

# Define a GET method on the "/users" resource. 
resource "aws_api_gateway_method" "method" {
  rest_api_id   = aws_api_gateway_rest_api.MilestoneAPI.id
  resource_id   = aws_api_gateway_resource.resourse.id
  http_method   = "GET"                   
  authorization = "NONE"
}

# Integration between the GET method and the Lambda function
resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = aws_api_gateway_rest_api.MilestoneAPI.id
  resource_id = aws_api_gateway_resource.resourse.id
  http_method = aws_api_gateway_method.method.http_method

  integration_http_method = "POST"          #This must be POST because we are integrate it with lambda.
  type                    = "AWS"
  uri                     = aws_lambda_function.Milistone-1-Lambda.invoke_arn
  content_handling        = "CONVERT_TO_TEXT"
}

# Granting API Gateway permissions to invoke the Lambda function
resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.Milistone-1-Lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.MilestoneAPI.execution_arn}/*/${aws_api_gateway_method.method.http_method}${aws_api_gateway_resource.resourse.path}"
}

# Deployment of the API
resource "aws_api_gateway_deployment" "deployment" {
  depends_on  = [aws_api_gateway_integration.lambda]
  rest_api_id = aws_api_gateway_rest_api.MilestoneAPI.id
  stage_name  = var.stage_name
}

# Create a method response for the GET method
resource "aws_api_gateway_method_response" "response" {
  rest_api_id = aws_api_gateway_rest_api.MilestoneAPI.id
  resource_id = aws_api_gateway_resource.resourse.id
  http_method = aws_api_gateway_method.method.http_method
  status_code = "200"  # Status code for the response

  response_models = {
    "application/json" = "Empty"  # Content type and model for the response
  }
}
# Associate the method response with the appropriate content type
resource "aws_api_gateway_integration_response" "example" {
  rest_api_id = aws_api_gateway_rest_api.MilestoneAPI.id
  resource_id = aws_api_gateway_resource.resourse.id
  http_method = aws_api_gateway_method.method.http_method
  status_code = aws_api_gateway_method_response.response.status_code
  depends_on  = [aws_api_gateway_integration.lambda]

  response_templates ={
    "application/json"  = <<EOF
    EOF
  }
}


