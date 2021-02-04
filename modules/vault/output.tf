output "vault_namespace" {
  value = kubernetes_namespace.vault.metadata.0.name
}
