# This creates a compute instance with ssh keys in the app subnet. 

resource "google_compute_instance" "tmdb-instance" {
  boot_disk {
    auto_delete = true

    initialize_params {
      image = "projects/rocky-linux-cloud/global/images/rocky-linux-8-optimized-gcp-v20240415"
      size  = 20
      type  = "pd-balanced"
    }
  }

  can_ip_forward      = false
  deletion_protection = false
  enable_display      = false

  name         = "tmdb-instance"
  machine_type = "e2-medium"

  network_interface {
    access_config {
      network_tier = "PREMIUM"
    }

    queue_count = 0
    stack_type  = "IPV4_ONLY"
    subnetwork  = google_compute_subnetwork.tmdb_app_subnet.id
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
    provisioning_model  = "STANDARD"
  }

  service_account {
    email  = "190160106685-compute@developer.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/devstorage.read_only", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring.write", "https://www.googleapis.com/auth/service.management.readonly", "https://www.googleapis.com/auth/servicecontrol", "https://www.googleapis.com/auth/trace.append"]
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = true
    enable_vtpm                 = true
  }

  metadata = {

    sshKeys = "${var.tmdb_ssh_user}:${file(var.tmdb_ssh_pub_key_file)}"
  }

  tags = ["http-server", "lb-health-check", "tmdb"]
  zone = var.zone
}

resource "null_resource" "tmdb_provisioner" {

  depends_on = [google_compute_instance.tmdb-instance]

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = google_compute_instance.tmdb-instance.network_interface[0].access_config[0].nat_ip
      agent       = false
      timeout     = "5m"
      user        = "tmdb"
      private_key = file(var.tmdb_ssh_private_key_file)

    }

    inline = [
      "sudo yum install -y yum-utils",
      "sudo yum-config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo",
      "sudo yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin",
      "sudo systemctl daemon-reload",
      "sudo systemctl enable docker.service",
      "sudo systemctl start --no-block docker.service",
      "sudo usermod -aG docker $USER",
      "mkdir /home/tmdb/tmdb-app/"
    ]

  }
}

resource "null_resource" "send-app-files" {
  connection {
    type        = "ssh"
    host        = google_compute_instance.tmdb-instance.network_interface[0].access_config[0].nat_ip
    agent       = false
    timeout     = "5m"
    user        = "tmdb"
    private_key = file(var.tmdb_ssh_private_key_file)

  }
  provisioner "file" {
    source      = "../../../tmdb-app/"
    destination = "/home/tmdb/tmdb-app/"
  }
}


resource "null_resource" "start-app-services" {

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = google_compute_instance.tmdb-instance.network_interface[0].access_config[0].nat_ip
      agent       = false
      timeout     = "5m"
      user        = "tmdb"
      private_key = file(var.tmdb_ssh_private_key_file)

    }

    inline = [
      "docker compose -f /home/tmdb/tmdb-app/docker-compose.yml up --build -d"
    ]

  }
}