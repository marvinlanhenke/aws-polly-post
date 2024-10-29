resource "aws_api_gateway_rest_api" "posts_api" {
  name        = "posts-api"
  description = "API for creating Posts and retrieving the converted audio file"
}

resource "aws_api_gateway_resource" "v1" {
  rest_api_id = aws_api_gateway_rest_api.posts_api.id
  parent_id   = aws_api_gateway_rest_api.posts_api.root_resource_id
  path_part   = "v1"
}

resource "aws_api_gateway_resource" "posts" {
  rest_api_id = aws_api_gateway_rest_api.posts_api.id
  parent_id   = aws_api_gateway_resource.v1.id
  path_part   = "posts"
}

resource "aws_api_gateway_method" "post_method" {
  rest_api_id   = aws_api_gateway_rest_api.posts_api.id
  resource_id   = aws_api_gateway_resource.posts.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "post_integration" {
  rest_api_id = aws_api_gateway_rest_api.posts_api.id
  resource_id = aws_api_gateway_resource.posts.id
  http_method = aws_api_gateway_method.post_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.new_posts.invoke_arn
}

resource "aws_api_gateway_method" "get_method" {
  rest_api_id   = aws_api_gateway_rest_api.posts_api.id
  resource_id   = aws_api_gateway_resource.posts.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_integration" {
  rest_api_id = aws_api_gateway_rest_api.posts_api.id
  resource_id = aws_api_gateway_resource.posts.id
  http_method = aws_api_gateway_method.get_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.get_posts.invoke_arn
}

resource "aws_api_gateway_method" "options_method" {
  rest_api_id   = aws_api_gateway_rest_api.posts_api.id
  resource_id   = aws_api_gateway_resource.posts.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "options_integration" {
  rest_api_id = aws_api_gateway_rest_api.posts_api.id
  resource_id = aws_api_gateway_resource.posts.id
  http_method = aws_api_gateway_method.options_method.http_method

  type = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "options_method_response" {
  rest_api_id = aws_api_gateway_rest_api.posts_api.id
  resource_id = aws_api_gateway_resource.posts.id
  http_method = aws_api_gateway_method.options_method.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Headers" = true
  }

  response_models = {
    "application/json" = "Empty"
  }

  depends_on = [aws_api_gateway_method.options_method]
}

resource "aws_api_gateway_integration_response" "options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.posts_api.id
  resource_id = aws_api_gateway_resource.posts.id
  http_method = aws_api_gateway_method.options_method.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
    "method.response.header.Access-Control-Allow-Methods" = "'*'"
    "method.response.header.Access-Control-Allow-Headers" = "'*'"
  }

  depends_on = [aws_api_gateway_integration.options_integration, aws_api_gateway_method_response.options_method_response]
}

resource "aws_api_gateway_deployment" "prod_deployment" {
  depends_on = [
    aws_api_gateway_integration.post_integration,
    aws_api_gateway_integration.get_integration,
    aws_api_gateway_integration.options_integration,
  ]

  rest_api_id = aws_api_gateway_rest_api.posts_api.id
  stage_name  = "prod"

  lifecycle {
    create_before_destroy = true
  }
}

output "api_url" {
  description = "The URL of the API Gateway"
  value       = aws_api_gateway_deployment.prod_deployment.invoke_url
}
