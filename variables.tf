variable "project_id" {
  type        = string
  description = "GCP Project Id."
}

variable "region" {
  type        = string
  description = "GCP Region."
  default     = "us-east1"
}

variable "apis_services" {
  type        = list(string)
  description = "APIs & Services to enable."
  default = [
    "cloudkms.googleapis.com",
    "run.googleapis.com",
    "secretmanager.googleapis.com",
    "storage.googleapis.com"
  ]
}

variable "name" {
  type        = string
  description = "Value to prefix resources with."
  default     = "vault"
}

variable "vault_image" {
  type        = string
  description = "Specifies the Vault image to use."
  default     = "hashicorp/vault"
}

variable "vault_log_level" {
  type        = string
  description = "Specifies the log level to use."
  default     = "info"
}

variable "vault_ui" {
  type        = bool
  description = "Enables the built-in web UI."
  default     = true
}

variable "vault_cpu" {
  type        = string
  description = "Specifies the CPU."
  default     = "1000m"
}

variable "vault_memory" {
  type        = string
  description = "Specifies the memory."
  default     = "256Mi"
}

locals {
  service_env_vars = [
    {
      name  = "SKIP_SETCAP"
      value = 1
    }
  ]
}
