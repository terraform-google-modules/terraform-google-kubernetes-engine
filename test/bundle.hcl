terraform {
  version = "0.13.6"
}

providers {
  google = {
    version = "~> 3.42.0"
    source  = "hashicorp/google"
  }
  google-beta = {
    version = "~> 3.49.0"
    source  = "hashicorp/google-beta"
  }
  external = {
    version = "~> 1.0"
    source  = "hashicorp/external"
  }
  kubernetes = {
    version = "~> 1.12.0"
    source  = "hashicorp/kubernetes"
  }
  null = {
    version = "~> 2.0"
    source  = "hashicorp/null"
  }
  random = {
    version = "~> 2.0"
    source  = "hashicorp/random"
  }
}
