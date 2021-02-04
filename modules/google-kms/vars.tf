variable "region" {
  type = string
}

variable "credentials_file" {
  type = string
}

variable "project_id" {
  type = string
}

variable "keyring_name" {
  type = string
}

variable "keyring_location" {
  type    = string
  default = "global"
}

variable "key_name" {
  type = string
}

variable "service_account_iam_roles" {
  type = list(string)
  default = [
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
    "roles/iam.serviceAccountKeyAdmin",
    "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  ]
  description = "List of IAM roles to assign to the service account."
}
