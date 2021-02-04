variable "project_id" {
  type = string
  description = "Project ID of the GCP project in which resources will be created"
}

variable "region" {
  type = string
  description = "GCP region in which to create resources"
}

variable "cluster_zone" {
  type = string
  description = "GCP zone in which to instantiate the Kubernetes cluster"
}

variable "cluster_name" {
  type = string
  description = "Name to use for the Vault GKE cluster"
}

variable "credentials_file" {
  type = string
  description = "Path to GCP Credentials JSON file"
}

variable "num_vault_pods" {
  type    = number
  default = 3
  description = "Number of Vault pods to create in GKE"
}

variable "cert_secret_name" {
  type        = string
  description = "Name to use for the k8s secret containing the ACME TLS cert/ca/key"
}

variable "vault_hostname" {
  type        = string
  description = "Domain name to use for the DNS zone, A record, and TLS Cert"
}

variable "cert_organization_name" {
  type        = string
  description = "Organization name for Private Cert, e.g. 'MyCorp Inc.'"
}

variable "cert_common_name" {
  type        = string
  description = "CN for Private Cert, e.g. 'MyCorp Inc. Private Certificate Authority'"
}

variable "cert_country" {
  type        = string
  description = "Country in which the private cert will be issued"
}

variable "public_cert_email_address" {
  type        = string
  description = "Email address to use for the public-facing TLS cert"
}

variable "vault_version" {
  type = string
  description = "Version of Hashicorp Vault to use (e.g. '1.5.5')"
}