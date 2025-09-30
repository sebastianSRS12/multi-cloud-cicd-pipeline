terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

variable "project" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "GCP zone"
  type        = string
  default     = "us-central1-a"
}

variable "machine_type" {
  description = "VM machine type"
  type        = string
  default     = "f1-micro"
}

variable "bucket_name" {
  description = "GCS bucket name"
  type        = string
}

variable "cluster_name" {
  description = "GKE cluster name"
  type        = string
  default     = "multi-cloud-cluster"
}

provider "google" {
  project = var.project
  region  = var.region
}

resource "google_compute_network" "main" {
  name                    = "multi-cloud-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "main" {
  name          = "multi-cloud-subnet"
  network       = google_compute_network.main.self_link
  ip_cidr_range = "10.1.1.0/24"
  region        = var.region
}

resource "google_compute_firewall" "ssh" {
  name    = "multi-cloud-ssh"
  network = google_compute_network.main.self_link

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "http" {
  name    = "multi-cloud-http"
  network = google_compute_network.main.self_link

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_instance" "main" {
  name         = "multi-cloud-vm"
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network    = google_compute_network.main.self_link
    subnetwork = google_compute_subnetwork.main.self_link

    access_config {
      // Ephemeral IP
    }
  }

  metadata_startup_script = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y python3 python3-pip git
              pip3 install flask
              EOF
}

resource "google_storage_bucket" "main" {
  name     = var.bucket_name
  location = var.region

  uniform_bucket_level_access = true
}

# GKE Cluster
resource "google_container_cluster" "main" {
  name     = var.cluster_name
  location = var.zone

  network    = google_compute_network.main.self_link
  subnetwork = google_compute_subnetwork.main.self_link

  initial_node_count = 2

  node_config {
    machine_type = "e2-medium"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

output "vm_public_ip" {
  value = google_compute_instance.main.network_interface[0].access_config[0].nat_ip
}

output "bucket_name" {
  value = google_storage_bucket.main.name
}

output "gke_cluster_name" {
  value = google_container_cluster.main.name
}

output "gke_cluster_endpoint" {
  value = google_container_cluster.main.endpoint
}