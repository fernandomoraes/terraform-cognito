variable "tags" {
  type        = map(any)
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "pool_name" {
  type        = string
  description = "Pool name"
}

variable "client_name" {
  type        = string
  description = "Client name"
}

variable "domain" {
  type        = string
  description = "Domain name"
}

variable "callback_urls" {
  type        = list(string)
  description = "Callback urls used by clients"
}

variable "logout_urls" {
  type        = list(string)
  description = "Logout urls used by clients"
}

variable "facebook_client_id" {
  type        = string
  description = "Facebook client id"
}

variable "facebook_secret_id" {
  type        = string
  description = "Facebook secret id"
}

variable "facebook_scopes" {
  type        = string
  description = "Facebook required scopes"
}

variable "google_client_id" {
  type        = string
  description = "Google client id"
}

variable "google_secret_id" {
  type        = string
  description = "Google secret id"
}

variable "google_scopes" {
  type        = string
  description = "Google required scopes"
}
