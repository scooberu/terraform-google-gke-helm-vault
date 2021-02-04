resource "google_dns_managed_zone" "vault_dns_zone" {
  name        = "vault"
  dns_name    = "${var.vault_hostname}."
  description = "Vault DNS zone managed by Terraform (do not modify manually)"
  project     = var.project_id

  visibility = "public"
  dnssec_config {
    state = "off"
  }
}

resource "google_dns_record_set" "vault_dns_record_set" {
  name         = google_dns_managed_zone.vault_dns_zone.dns_name
  project      = var.project_id
  type         = "A"
  ttl          = 3600
  managed_zone = google_dns_managed_zone.vault_dns_zone.name
  rrdatas      = [var.cluster_listener_ip]
}
