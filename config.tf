terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.66.1"
    }
  }
}

provider "google" {
  project     = "third-booth-312713"
  zone        = "europe-west3-c"
  credentials = file("/home/user/google/third-booth-312713-8908e40c7142.json")
}

#---------------

resource "google_compute_instance" "default" {
  count = 1
  name         = "test"
  machine_type = "e2-micro"
# e2-medium (2 vCPUs, 4 GB memory)
# e2-small (2 vCPUs, 2 GB memory)

  boot_disk {
    initialize_params {
#    image = "ubuntu-os-cloud/ubuntu-2004-focal-v20210429"
#     image = "third-booth-312713/build-hw14:latest"

       sourceImage = projects/cos-cloud/global/images/cos-stable-89-16108-403-26
       diskType = projects/third-booth-312713/zones/europe-west3-c/diskTypes/pd-balanced
       diskSizeGb = 10

    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }
  metadata = {
   google-logging-enabled="true"  
    gce-container-declaration = "spec:\n  containers:\n    - name: instance-1\n      image: eu.gcr.io/third-booth-312713/build-hw14\n      volumeMounts:\n        - name: tmpfs-0\n          mountPath: /home/user/target\n      securityContext:\n        privileged: true\n      stdin: true\n      tty: false\n  restartPolicy: Never\n  volumes:\n    - name: tmpfs-0\n      emptyDir:\n        medium: Memory\n\n"

     startup-script = "/home/user/google/runsc"
     ssh-keys = "vfilinov1:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCzC3T0TKO95rmEmtGGcPFbvNY1SdKL65SpxCBKkrOIRxHxhGxURFWRW88k8qz12lswJ4WX5l4fl5dPtwP22DZ2iju64jADqkglJCXDlyzZ3G0wZzMiZaxso2SzK301SNr/h8VCjhfs8zQ7ADq1C7qrHcz+Z10t/eueZnujA91SYXav6G1XOQVBTkuyjN+YKZDoLOyOLW33zMbuSCpLn13h3cO4QpE1Cbbna4hBt+r8CcvhHLn1WSUaGl4kGBI8Dtlh4ajMCFqPpvi5E2RFBLDCYPYAqS8v1EpS97oRRYz7f62yaitGqPegCoUxXuc7Pm+iJ/HMiGPY1jhkRC6XmtfpKlmyKrByOjVBcdYO6KiKw6v9VdV4S64+pZZW9vvzY6MyJrxeDuTu4w0sZSeCUcnXNp6F0zhhvqVDTMCCvw+tbSijfo0USckLf3DfXpMH4YW4mQ3wHF8ebyxm8OkySmE0tABBVXWnQkRpHeh7uom8mBK9DOgI6/o/ki/26e9tJ/c= vfilinov1"
}


#service_account {
#    scopes = [ "https://www.googleapis.com/auth/devstorage.read_only",
#        "https://www.googleapis.com/auth/logging.write",
#        "https://www.googleapis.com/auth/monitoring.write",
#        "https://www.googleapis.com/auth/servicecontrol",
#        "https://www.googleapis.com/auth/service.management.readonly",
#        "https://www.googleapis.com/auth/trace.append"]
#  }
#  metadata_startup_script = "runsc"

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = "824851000940-compute@developer.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }

}


resource "google_compute_firewall" "default" {
  name    = "new-rule-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "443"]
  }
}

#------------------------

#resource "google_cloud_run_service" "mywebapp" {
#  name     = "mywebapp"
#  location = "europe-west3-c"
#  template {
#    spec {
#      containers {
#        image = "docker.io/vmdocker2022/ansiblaws_hw13"
#      }
#    }
#  }
#  traffic {
#    percent         = 100
#    latest_revision = true
#  }
#}

