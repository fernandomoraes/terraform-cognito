output "pool_id" {
  value       = aws_cognito_user_pool.cognito_user_pool.id
  description = "Cognito user pool id"
}

output "client_id" {
  value       = aws_cognito_user_pool_client.user_pool_client.id
  description = "Cognito client id"
}