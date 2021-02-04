resource "helm_release" "vault" {
  name       = "vault"
  chart      = "vault"
  repository = "https://helm.releases.hashicorp.com/"
  namespace  = kubernetes_namespace.vault.metadata.0.name

  values = [<<EOF
global:
  tlsDisable: false
server:
  image:
    repository: "vault"
    tag: "${var.vault_version}"
  agentImage:
    repository: "vault"
    tag: "${var.vault_version}"
  extraEnvironmentVars:
    VAULT_ADDR: https://127.0.0.1:8200
    VAULT_SKIP_VERIFY: true
    VAULT_CACERT: /vault/userconfig/vault-internal-tls/vault-local.ca
    VAULT_API_ADDR: https://127.0.0.1
  extraVolumes:
    - type: secret
      name: vault-acme-tls
    - type: secret
      name: vault-internal-tls

  ingress:
    enabled: true
    annotations:
      kubernetes.io/ingress.class: nginx
      kubernetes.io/ssl-redirect: "true"
    hosts:
      - host: ${var.vault_hostname}
    tls:
      - secretName: ${var.vault_tls_k8s_secret}
        hosts:
          - ${var.vault_hostname}
  ha:
    enabled: true
    replicas: ${var.num_vault_pods}    

    raft:      
      # Enables Raft integrated storage
      enabled: true
      config: |
        ui = true

        listener "tcp" {
          tls_disable = 0
          address = "[::]:8200"
          cluster_address = "[::]:8201"
          tls_cert_file = "/vault/userconfig/vault-acme-tls/tls.crt"
          tls_key_file  = "/vault/userconfig/vault-acme-tls/tls.key"
          tls_client_ca_file = "/vault/userconfig/vault-acme-tls/tls.ca"
        }

        listener "tcp" {
          tls_disable = 0
          address = "[::]:8500"
          cluster_address = "[::]:8501"
          tls_cert_file = "/vault/userconfig/vault-internal-tls/vault-local.cert"
          tls_key_file = "/vault/userconfig/vault-internal-tls/vault-local.key"
          tls_client_ca_file = "/vault/userconfig/vault-internal-tls/vault-local.ca"
        }

        seal "gcpckms" {
          project     = "${var.project_id}"
          region      = "global"
          key_ring    = "${var.unseal_keyring_name}"
          crypto_key  = "${var.unseal_key_name}"
        }

        storage "raft" {
          path = "/vault/data"
          %{for index in range(var.num_vault_pods)}
          retry_join {
             leader_api_addr    = "https://vault-${index}.vault-internal:8500"
             leader_client_cert_file = "/vault/userconfig/vault-internal-tls/vault-local.cert"
             leader_client_key_file  = "/vault/userconfig/vault-internal-tls/vault-local.key"
             leader_ca_cert_file     = "/vault/userconfig/vault-internal-tls/vault-local.ca"
          }
          %{endfor}
        }
ui:
  enabled: true
  serviceType: "LoadBalancer"
  serviceNodePort: null
  externalPort: 8200
  loadBalancerIP: ${var.loadbalancer_ip}
EOF
  ]

  depends_on = [
    var.vault_tls_secret_resource,
  ]
}
