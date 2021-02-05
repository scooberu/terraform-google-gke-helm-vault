# README

A detailed accounting of the module structure can be found [in this blog post](https://www.reu.dev/blog/2021/2/4/new-terraform-module-vault-on-gke). An operational summary follows below.

## Purpose

Vault's implementation on Kubernetes is really pretty good, but there's no offical (or even particularly high-quality) batteries-included Terraform module out there to produce a Vault Kubernetes cluster on GKE with minimal pain. So I decided to write one.

## A Note on Credentials

As with all Terraform on GCP, you'll need to create a service account (or use one of your existing ones) and provide this module with access to it. That service account will need quite a few permissions, as it will be creating a static external IP, making new service accounts for Vault, generating Kubernetes secrets, setting up a cluster, generating keys and keyrings in Cloud KMS, and more.

### Caveat: DNS Stuff

The outward-facing ACME TLS cert uses DNS validation (because this is all happening programmatically, it's easier than trying to do HTTP validation). You'll need to own whatever domain you provide in the module invocation's `vault_hostname` variable.

### Caveat: ACME/LetsEncrypt Cert Stuff

The externally-facing TLS listener for this cluster is provisioned with a cert from ACME (LetsEncrypt). As a result, you will need to run a `terraform apply` at least once every 30 days in order to renew the cert.

## Example Invocation of this Module

```terraform
module "test-vault" {
  source                    = "../terraform-google-gke-helm-vault"
  credentials_file          = "./terraform-gcp-credentials.json"
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
