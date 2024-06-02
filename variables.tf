variable "project_id" {
  type        = string
  description = "GCP Project Id."
}

variable "region" {
  type        = string
  description = "GCP Region."
  default     = "us-east1"
}

variable "name" {
  type        = string
  description = "Value to prefix resources with."
  default     = "vault"
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
  description = "Specifies the log level to use."
  default     = "info"
}

variable "ui" {
  type        = bool
  description = "Enables the built-in web UI."
  default     = true
}

variable "cpu" {
  type        = string
  description = "Specifies the CPU."
  default     = "1000m"
}

variable "memory" {
  type        = string
  description = "Specifies the memory."
  default     = "256Mi"
}
