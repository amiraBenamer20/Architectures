

resource "aws_cognito_user_pool" "user_pool" {
  name = "MyUserPool"

  username_attributes = ["email"]

  auto_verified_attributes = ["email"]

  schema {
    attribute_data_type = "String"
    name               = "email"
    required           = true
  }

  admin_create_user_config {
    allow_admin_create_user_only = false
  }

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }
}

resource "aws_cognito_identity_pool" "identity_pool" {
  identity_pool_name =  "RestaurentPoolClients"

  allow_unauthenticated_identities = false

  cognito_identity_providers {
    client_id   = aws_cognito_user_pool.user_pool_client.id
    provider_name = aws_cognito_user_pool.user_pool_provider.provider_name
    server_side_token_check = true
  }
}

resource "aws_cognito_user_pool_client" "user_pool_client" {
  name                   = "MyUserPoolClient"
  user_pool_id           = aws_cognito_user_pool.user_pool.id
  generate_secret        = false
  allowed_oauth_flows    = ["code"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_scopes   = ["openid"]
}

resource "aws_cognito_user_pool_domain" "user_pool_domain" {
  domain = "my-cognito-domain"
  user_pool_id = aws_cognito_user_pool.user_pool.id
}
