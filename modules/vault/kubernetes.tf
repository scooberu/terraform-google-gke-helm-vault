resource "kubernetes_namespace" "vault" {
  metadata {
    name = "vault"
  }
  depends_on = [var.cluster_endpoint]
}

resource "kubernetes_secret" "vault_local_tls" {
  metadata {
    name      = "vault-internal-tls"
    namespace = kubernetes_namespace.vault.metadata.0.name
  }

  data = {
    "vault-local.ca"   = var.vault_internal_tls_ca
    "vault-local.cert" = var.vault_internal_tls_cert
    "vault-local.key"  = var.vault_internal_tls_key
  }

  type = "Opaque"
}
