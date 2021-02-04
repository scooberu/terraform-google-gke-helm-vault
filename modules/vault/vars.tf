variable "num_vault_pods" {
  type = number
}

variable "vault_version" {
  type = string
  description = "Version of Hashicorp Vault to use for this deployment"
}

variable "project_id" {
  type = string
}

variable "unseal_keyring_name" {
  type        = string
  description = "Keyring name containing the GKMS key that will unseal Vault"
}

variable "unseal_key_name" {
  type        = string
  description = "Name of key inside the unseal keyring that unseals the vault"
}

variable "unseal_account_name" {
  type        = string
  description = "Name of Service Account used to unseal vault with GKMS key"
}

variable "region" {
  type = string
}

variable "loadbalancer_ip" {
  type        = string
  description = "IP Address of ingress to cluster"
}

variable "cluster_endpoint" {
}

variable "cluster_cert" {
}

variable "vault_internal_tls_ca" {
  description = "CA to use for internal raft validation"
}

variable "vault_internal_tls_cert" {
  description = "Cert to use for internal raft validation"
}

variable "vault_internal_tls_key" {
  description = "Key to use for internal raft validation"
}

variable "vault_hostname" {
  type        = string
  description = "Hostname associated with TLS Cert"
}

variable "vault_tls_k8s_secret" {
  type        = string
  description = "Kubernetes secret containing TLS cert files"
}

variable "vault_tls_secret_resource" {
  description = "Link to k8s secret resource for the sake of creating a cross-module dependency"
}