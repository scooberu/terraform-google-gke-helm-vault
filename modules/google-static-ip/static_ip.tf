resource "google_compute_address" "vault_ext_ip_address" {
    name = "vault-external-ip"
    project = var.project_id
    region = var.region
}