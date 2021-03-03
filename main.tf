resource "aws_cognito_user_pool" "cognito_user_pool" {
  name = var.pool_name

  schema {
    attribute_data_type      = "String"
    mutable                  = true
    name                     = "email"
    required                 = true
    developer_only_attribute = false
    string_attribute_constraints {
      max_length = "2048"
      min_length = "0"
    }
  }

  schema {
    attribute_data_type      = "String"
    mutable                  = true
    name                     = "name"
    required                 = true
    developer_only_attribute = false
    string_attribute_constraints {
      max_length = "2048"
      min_length = "0"
    }
  }

  password_policy {
    minimum_length                   = "8"
    require_lowercase                = false
    require_numbers                  = false
    require_symbols                  = false
    require_uppercase                = false
    temporary_password_validity_days = 7
  }

  mfa_configuration        = "OFF"
  auto_verified_attributes = ["email"]

  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }

  tags = var.tags
}

resource "aws_cognito_user_pool_domain" "user_pool_domain" {
  user_pool_id = aws_cognito_user_pool.cognito_user_pool.id
  domain       = var.domain
}

resource "aws_cognito_identity_provider" "facebook" {
  user_pool_id  = aws_cognito_user_pool.cognito_user_pool.id
  provider_name = "Facebook"
  provider_type = "Facebook"

  provider_details = {
    client_id                       = var.facebook_client_id
    client_secret                   = var.facebook_secret_id
    authorize_scopes                = var.facebook_scopes
    "api_version"                   = "v6.0"
    "attributes_url"                = "https://graph.facebook.com/v6.0/me?fields="
    "attributes_url_add_attributes" = "true"
    "authorize_url"                 = "https://www.facebook.com/v6.0/dialog/oauth"
    "token_request_method"          = "GET"
    "token_url"                     = "https://graph.facebook.com/v6.0/oauth/access_token"
  }

  attribute_mapping = {
    "username"   = "id"
    "email"      = "email"
    "name"       = "name"
    "gender"     = "gender"
    "picture"    = "picture"
    "given_name" = "first_name"
  }
}

resource "aws_cognito_identity_provider" "google" {
  user_pool_id  = aws_cognito_user_pool.cognito_user_pool.id
  provider_name = "Google"
  provider_type = "Google"

  provider_details = {
    client_id                       = var.google_client_id
    client_secret                   = var.google_secret_id
    authorize_scopes                = var.google_scopes
    "attributes_url"                = "https://people.googleapis.com/v1/people/me?personFields="
    "attributes_url_add_attributes" = "true"
    "authorize_url"                 = "https://accounts.google.com/o/oauth2/v2/auth"
    "oidc_issuer"                   = "https://accounts.google.com"
    "token_request_method"          = "POST"
    "token_url"                     = "https://www.googleapis.com/oauth2/v4/token"
  }

  attribute_mapping = {
    "username"   = "sub"
    "email"      = "email"
    "name"       = "name"
    "gender"     = "genders"
    "picture"    = "picture"
    "given_name" = "given_name"
  }
}

resource "aws_cognito_user_pool_client" "user_pool_client" {
  user_pool_id = aws_cognito_user_pool.cognito_user_pool.id

  name                   = var.client_name
  refresh_token_validity = 30
  read_attributes        = ["email", "name", "given_name"]
  write_attributes       = ["email", "name", "picture", "gender", "given_name"]

  supported_identity_providers = ["Facebook", "Google"]
  callback_urls                = var.callback_urls
  logout_urls                  = var.logout_urls

  depends_on = [aws_cognito_identity_provider.facebook, aws_cognito_identity_provider.google]

  allowed_oauth_flows                  = ["code"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_scopes = [
    "aws.cognito.signin.user.admin",
    "email",
    "openid",
    "phone",
    "profile"
  ]
  explicit_auth_flows = [
    "ALLOW_CUSTOM_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_SRP_AUTH"
  ]
}