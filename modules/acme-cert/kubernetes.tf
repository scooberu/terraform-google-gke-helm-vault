# Create Service Account for ACME provider to conduct DNS authentication
resource "google_service_account" "dns_validation_service_account" {
  account_id   = "vault-dns-validation-svc"
  display_name = "Service Account (Vault Cluster) to provide DNS authentication for ACME certs"
  project      = var.project_id
}

# Grant service account access to DNS
resource "google_project_iam_member" "service-account-iam-membership" {
  project = var.project_id
  role    = "roles/dns.admin"
  member  = "serviceAccount:${google_service_account.dns_validation_service_account.email}"
}

resource "google_service_account_key" "dns_validation_service_account_key" {
  service_account_id = google_service_account.dns_validation_service_account.name
}

resource "local_file" "dns_validation_svc_creds" {
  filename = "./credentials/vault_acme_svc_account_key.json"
  content  = base64decode(google_service_account_key.dns_validation_service_account_key.private_key)
  depends_on = [
    google_service_account.dns_validation_service_account,
    google_service_account_key.dns_validation_service_account_key,
  ]
}
