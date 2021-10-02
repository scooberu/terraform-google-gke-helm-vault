# README

A detailed accounting of the module structure can be found [in this blog post](https://www.reu.dev/blog/2021/2/4/new-terraform-module-vault-on-gke). An operational summary follows below.

THIS IS A NEW LINE!

## Purpose

Vault's implementation on Kubernetes is really pretty good, but there's no offical (or even particularly high-quality) batteries-included Terraform module out there to produce a Vault Kubernetes cluster on GKE with minimal pain. So I decided to write one.

## A Note on Credentials

As with all Terraform on GCP, you'll need to create a service account (or use one of your existing ones) and provide this module with access to it. That service account will need quite a few permissions, as it will be creating a static external IP, making new service accounts for Vault, generating Kubernetes secrets, setting up a cluster, generating keys and keyrings in Cloud KMS, and more. The JSON key for these credentials should be stored somewhere that Terraform can access it, but *do not commit these credentials to a repo in plaintext*. My preferred tool for encrypting some parts of a Git repo is [git-crypt](https://github.com/AGWA/git-crypt).

### Caveat: DNS Stuff

The outward-facing ACME TLS cert uses DNS validation (because this is all happening programmatically, it's easier than trying to do HTTP validation). You'll need to own whatever domain you provide in the module invocation's `vault_hostname` variable.

The way I do this is with a domain I own in [Google Domains](https://domains.google.com) (a separate service from GCP). I'd recommend running an initial `terraform apply` and seeing it error out due to the ACME cert resource not being able to find a record for the host specified at `vault_hostname`. Then pop into GCP -> Network Services -> Cloud DNS, grab the IP address from your newly created Zone (making sure to note the Nameservers that it's using!), and add those Nameservers as NS records for `vault.yourdomain.com` (or whatever parameter you stuck in the `vault_hostname` variable) with your DNS provider. Then simply wait a few minutes for the change to propagate and `terraform apply` again.

There are probably other ways to do this involving GCP more directly for domain name management, but this is how I handle it with a pre-existing domain that I already own in another platform.

### Caveat: ACME/LetsEncrypt Cert Stuff

The externally-facing TLS listener for this cluster is provisioned with a cert from ACME (LetsEncrypt). As a result, you will need to run a `terraform apply` at least once every 30 days in order to renew the cert.

## Example Invocation of this Module

```terraform
module "test-vault" {
  module "gke-helm-vault" {
  source                    = "gatsbysghost/gke-helm-vault/google"
  version                   = "0.2.0"
  credentials_file          = "./terraform-gcp-credentials.json"
  project_id                = "my-project-8675309"
  cluster_name              = "vault"
  region                    = "us-central1"
  cluster_zone              = "us-central1-b"
  num_vault_pods            = 3
  cert_secret_name          = "acme-tls"
  vault_hostname            = "vault.domain.com"
  cert_organization_name    = "MyCorp, Inc."
  cert_common_name          = "MyCorp, Inc. Private Cert Authority"
  cert_country              = "United States"
  public_cert_email_address = "janedoe@domain.com"
  vault_version             = "1.8.2"
}
```

## Cluster's up! How do I get started with Vault?

Great! You are now officially at the point where [the Hashicorp documentation](https://www.vaultproject.io/docs/platform/k8s/helm/examples/ha-with-raft) starts to be useful!

My advice at this point would be to log into your cluster with kubectl (by following the instructions in the "Connect" dialog box in GKE). You may notice that all of your Vault pods are in an unready state, and in the logs, it will indicate that the pods cannot communicate with each other because the Vault cluster is sealed.

This can be quickly remedied by simply connecting to any of your Vault pods (`kubectl exec -n vault -it vault-0 -- /bin.sh`) and executing the `vault operator init` command. This will generate your unseal tokens and root token, and all of the pods should immediately become ready at this point.
