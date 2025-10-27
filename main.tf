resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.location

  remove_default_node_pool = true
  initial_node_count       = var.initial_node_count

  networking_mode = "VPC_NATIVE" # Enables alias IPs
  timeouts {
    create = lookup(var.cluster_timeouts, "create", "30m")
    update = lookup(var.cluster_timeouts, "update", "40m")
    delete = lookup(var.cluster_timeouts, "delete", "20m")
  }
  deletion_protection = var.deletion_protection
}

resource "google_container_node_pool" "primary_nodes" {
  timeouts {
    create = lookup(var.cluster_timeouts, "create", "30m")
    update = lookup(var.cluster_timeouts, "update", "40m")
    delete = lookup(var.cluster_timeouts, "delete", "20m")
  }
  name     = "primary-node-pool"
  location = var.location
  cluster  = google_container_cluster.primary.name

  node_config {
    machine_type = var.machine_type
    spot         = var.use_spot_nodes
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  initial_node_count = 1

  autoscaling {
    min_node_count = var.min_node_count
    max_node_count = var.max_node_count
  }

}

resource "null_resource" "enable_gateway_api" {
  depends_on = [google_container_cluster.primary]

  provisioner "local-exec" {
    command = <<EOT
      # Wait until the cluster is ready
      while gcloud container clusters describe ${var.cluster_name} --format="value(status)" | grep -v "RUNNING"; do
        echo "Cluster is busy, waiting 10s..."
        sleep 10
      done

      gcloud container clusters update ${var.cluster_name} --gateway-api=standard
    EOT
  }
}

