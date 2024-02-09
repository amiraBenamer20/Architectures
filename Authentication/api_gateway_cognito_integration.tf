
resource "aws_api_gateway_authorizer" "cognito_authorizer" {
  name                   = "CognitoAuthorizer"
  rest_api_id           = aws_api_gateway_rest_api.rest_api.id
  type                   = "COGNITO_USER_POOLS"
  identity_source       = "method.request.header.Authorization"
  provider_arns         = [aws_cognito_user_pool.user_pool.arn]
}

resource "aws_api_gateway_integration" "cognito_integration" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.get_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.get_items_lambda.invoke_arn

  request_parameters = {
    "integration.request.header.Authorization" = "method.request.header.Authorization"
  }
}

resource "aws_api_gateway_method" "cognito_method" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.resource.id
  http_method   = aws_api_gateway_method.get_method.http_method
  authorization = aws_api_gateway_authorizer.cognito_authorizer.id
}
