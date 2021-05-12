terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.66.1"
    }
  }
}

provider "google" {
  project     = var.project_id
  zone        = "europe-west3-c"
  credentials = file("/home/user/google/third-booth-312713-8908e40c7142.json")
}

# Create bucket for storing artifacts
resource "google_storage_bucket" "auto-expire" {
  name          = var.backet_name
  location      = "europe-west3"
  force_destroy = true
}

# Create Build instance
resource "google_compute_instance" "build-env" {
  name         = "build"
  machine_type = "e2-small"

  boot_disk  { 
    initialize_params  {
       image = "cos-cloud/cos-stable-89-16108-403-26"
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }
  metadata = {
    google-logging-enabled="false"  
    gce-container-declaration = "spec:\n  containers:\n    - name: instance-11\n      image: ${var.image_build}\n      securityContext:\n        privileged: true\n      stdin: true\n      tty: false\n  restartPolicy: Never\n\n"
    ssh-keys = "${var.glogin}:${file("~/.ssh/key_google.pub")}" 
  }

  service_account {
    email  = "824851000940-compute@developer.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }
}

# Create Prod instance
resource "google_compute_instance" "prod-env" {
  name         = "prod"
  machine_type = "e2-small"

  boot_disk  { 
    initialize_params  {
       image = "cos-cloud/cos-stable-89-16108-403-26"
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }
  metadata = {
    google-logging-enabled="false"  
    gce-container-declaration = "spec:\n  containers:\n    - name: instance-11\n      image: ${var.image_prod}\n      securityContext:\n        privileged: true\n      stdin: true\n      tty: false\n  restartPolicy: Never\n\n"
    ssh-keys = "${var.glogin}:${file("~/.ssh/key_google.pub")}"
  }
  service_account {
     email  = "824851000940-compute@developer.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }
}

# Show IP's instances
output "build-ip" {
  value = google_compute_instance.build-env.network_interface[0].access_config[0].nat_ip
}
output "prod-ip" {
  value = google_compute_instance.prod-env.network_interface[0].access_config[0].nat_ip
}

resource "google_compute_firewall" "default" {
  name    = "new-rule-firewall"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }
}
