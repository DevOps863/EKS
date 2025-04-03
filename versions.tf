terraform {
  required_version = ">=0.12"
  required_providers {
    random = {
      source = "hashicorp/random"
      version = "~> 3.1.0"
    }
    
    kubernetes = {
        source = "hashicorp/kubernetes"
        version = ">=2.7.1"
    }
  }
}