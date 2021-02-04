terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
    helm = {
      source = "hashicorp/helm"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    acme = {
      source = "vancluever/acme"
    }
  }
  required_version = ">= 0.14"
}
