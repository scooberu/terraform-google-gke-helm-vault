# README

## Example Invocation of this Module

```terraform
module "test-vault" {
  source                    = "../terraform-google-gke-helm-vault"
  credentials_file          = "./vault-credentials.json"
  project_id                = "my-project-8675309"
  cluster_name              = "vault"
  region                    = "us-central-1"
  cluster_zone              = "us-central-1b"
  num_vault_pods            = 3
  cert_secret_name          = "acme-tls"
  vault_hostname            = "vault.domain.com"
  cert_organization_name    = "MyCorp, Inc."
  cert_common_name          = "MyCorp, Inc. Private Cert Authority"
  cert_country              = "United States"
  public_cert_email_address = "janedoe@domain.com"
  vault_version             = "1.5.5"
}
```