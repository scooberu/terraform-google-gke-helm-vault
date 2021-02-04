resource "tls_private_key" "vault_private_key" {
  algorithm = "RSA"
}


resource "acme_registration" "reg" {
  account_key_pem = tls_private_key.vault_private_key.private_key_pem
  email_address   = var.email_address
}

resource "acme_certificate" "vault_certificate" {
  account_key_pem = acme_registration.reg.account_key_pem
  common_name     = var.vault_hostname

  dns_challenge {
    provider = "gcloud"
    config = {
      GCE_PROJECT              = var.project_id
      GCE_SERVICE_ACCOUNT_FILE = file(var.credentials_file)
    }
  }
  depends_on = [
    local_file.dns_validation_svc_creds
  ]
}

resource "kubernetes_secret" "vault_acme_cert" {
  metadata {
    name      = var.cert_secret_name
    namespace = var.vault_namespace
  }

  data = {
    "tls.ca"  = acme_certificate.vault_certificate.issuer_pem
    "tls.crt" = acme_certificate.vault_certificate.certificate_pem
    "tls.key" = acme_certificate.vault_certificate.private_key_pem
  }

  type = "Opaque"
}

