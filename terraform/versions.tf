terraform {
  required_version = ">= 1.3"

  required_providers {
    aws = {
      source  = "hashicorp/google"
      version = ">= 4.41"
    }

    random = {
      source  = "hashicorp/random"
      version = ">= 3.4"
    }
  }
}