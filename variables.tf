variable "project_id" {
  type        = string
  description = "GCP project where Vault server should be deployed."
}

variable "region" {
  type        = string
  description = "GCP region where Vault server should be deployed."
  default     = "us-east1"
}

variable "name" {
  type        = string
  description = "Value to prefix resources with."
  default     = "vault-"
}

variable "public" {
  type        = bool
  description = "Whether or not Vault server should be public."
  default     = false
}

variable "image" {
  type        = string
  description = "Specifies the Vault image to use."
  default     = "hashicorp/vault"
}

variable "log_level" {
  type        = string
  description = "Log verbosity level."
  default     = "info"
}

variable "ui" {
  type        = bool
  description = "Enables the built-in web UI."
  default     = true
}

variable "cpu" {
  type        = string
  description = "Specifies the CPU for Vault server."
  default     = "1000m"
}

variable "memory" {
  type        = string
  description = "Specifies the memory for Vault server."
  default     = "256Mi"
}
