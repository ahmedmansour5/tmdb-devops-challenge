terraform {
  backend "gcs" {
    bucket = "tmdb-demo"
    prefix = "terraform/state"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.28.0"
    }
  }
}

provider "google" {
  credentials = file("./secret.json")
  project     = var.project_id
  region      = var.region
  zone        = var.zone
}