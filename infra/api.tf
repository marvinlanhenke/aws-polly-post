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
