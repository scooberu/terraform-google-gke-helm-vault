module "gke-cluster" {
  source                 = "./modules/google-gke-cluster/"
  credentials_file       = var.credentials_file
  region                 = var.region
  project_id             = var.project_id
  cluster_name           = var.cluster_name
  cluster_location       = var.cluster_zone
  network                = "projects/${var.project_id}/global/networks/default"
  subnetwork             = "projects/${var.project_id}/regions/${var.region}/subnetworks/default"
  initial_node_count     = var.num_vault_pods
  unseal_service_account = module.unseal_kms.service_account
}

module "tls" {
  source            = "./modules/tls-private"
  hostname          = "*.vault-internal"
  organization_name = var.cert_organization_name
  common_name       = var.cert_common_name
  country           = var.cert_country
}

module "acme_cert" {
  source           = "./modules/acme-cert"
  project_id       = var.project_id
  credentials_file = var.credentials_file
  cluster_endpoint = module.gke-cluster.endpoint
  cluster_cert     = module.gke-cluster.ca_certificate
  vault_namespace  = module.vault.vault_namespace
  cert_secret_name = var.cert_secret_name
  vault_hostname   = var.vault_hostname
  email_address    = var.public_cert_email_address
}

module "external_ip_address" {
  source     = "./modules/google-static-ip"
  project_id = var.project_id
  region     = var.region
}

module "cloud_dns" {
  source              = "./modules/google-cloud-dns"
  project_id          = var.project_id
  cluster_listener_ip = module.external_ip_address.ip_address
  vault_hostname      = var.vault_hostname
}

module "vault" {
  source                    = "./modules/vault"
  project_id                = var.project_id
  region                    = var.region
  vault_version             = var.vault_version
  unseal_keyring_name       = module.unseal_kms.unseal_keyring_name
  unseal_key_name           = module.unseal_kms.unseal_key_name
  unseal_account_name       = module.unseal_kms.service_account
  num_vault_pods            = var.num_vault_pods
  cluster_endpoint          = module.gke-cluster.endpoint
  cluster_cert              = module.gke-cluster.ca_certificate
  vault_internal_tls_ca     = module.tls.ca_cert
  vault_internal_tls_cert   = module.tls.cert
  vault_internal_tls_key    = module.tls.key
  loadbalancer_ip           = module.external_ip_address.ip_address
  vault_tls_k8s_secret      = var.cert_secret_name
  vault_tls_secret_resource = module.acme_cert.secret_resource
  vault_hostname            = var.vault_hostname
}

module "unseal_kms" {
  source           = "./modules/google-kms"
  credentials_file = var.credentials_file
  project_id       = var.project_id
  region           = "global"
  keyring_name     = "vault_unseal_keyring_v2"
  key_name         = "vault_unseal_key"
}
