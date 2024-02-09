# IAM Role for Lambda Functions
resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

# IAM Policy for Lambda Functions
resource "aws_iam_role_policy" "lambda_policy" {
  name        = "lambda_execution_policy"
  role        = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "logs:*",
        "dynamodb:*",
      ],
      Resource = "*",
    }]
  })
}

# Lambda Function - getData
resource "aws_lambda_function" "get_data_function" {
  filename         = var.lambda1_code_path
  source_code_hash = filebase64(var.lambda1_code_path)
  function_name    = "getDataFunction"
  role             = aws_iam_role.lambda_role.arn
  handler          = "getEmployee.lambda_handler"
  runtime          = "python3.9"

  
}

# Lambda Function - putData
resource "aws_lambda_function" "put_data_function" {
  filename         = var.lambda2_code_path
  source_code_hash = filebase64(var.lambda2_code_path)
  function_name    = "putDataFunction"
  role             = aws_iam_role.lambda_role.arn
  handler          = "insertEmployeeData.lambda_handler"
  runtime          = "python3.9"

}


#trriger to allow API gateway to access to lambda
resource "aws_lambda_permission" "apigw_get" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.get_data_function.function_name}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_rest_api.my_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "apigw_post" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.put_data_function.function_name}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_rest_api.my_api.execution_arn}/*/*"
}

