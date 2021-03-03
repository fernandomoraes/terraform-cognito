provider "aws" {
  region = "us-east-1"
}

module "cognito" {
  source = "../.."
  tags = {
    application = "test"
  }
  pool_name          = "test"
  client_name        = "test"
  domain             = "test-123-4"
  callback_urls      = ["http://localhost:3000"]
  logout_urls        = ["http://localhost:3000"]
  facebook_client_id = "test"
  facebook_secret_id = "test"
  facebook_scopes    = "test"
  google_client_id   = "test"
  google_secret_id   = "test"
  google_scopes      = "test"
}