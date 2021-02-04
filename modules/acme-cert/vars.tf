variable "project_id" {
  type = string
}

variable "cluster_endpoint" {
}

variable "cluster_cert" {
}

variable "credentials_file" {
}

variable "vault_namespace" {
  type = string
}

variable "cert_secret_name" {
  type        = string
  description = "The name to use in k8s metadata for the k8s secret containing output cert data"
}

variable "vault_hostname" {
  type        = string
  description = "Hostname to use to register the ACME Cert"
}

variable "email_address" {
  type        = string
  description = "The email address to use to register the public-facing ACME cert"
}