variable "cluster_timeouts" {
  description = "Optional timeouts for the GKE cluster."
  type = object({
    create = optional(string, "30m")
    update = optional(string, "40m")
    delete = optional(string, "20m")
  })
  default = {}  # will fall back to the optional defaults above
}
variable "cluster_name" {
  type        = string
  description = "Name of the GKE cluster"
}
variable "location" {
  type        = string
  description = "GCP location for the GKE cluster"
}
variable "initial_node_count" {
    type        = number
    description = "Initial number of nodes in the GKE cluster"
    default     = 1
}
variable "deletion_protection" {
    type        = bool
    description = "Whether to enable deletion protection for the GKE cluster"
    default     = false
}
variable "machine_type" {
  description = "The machine type for the GKE nodes."
  type        = string
  default     = "e2-medium"
}

variable "use_spot_nodes" {
  description = "Use spot VMs for the GKE nodes."
  type        = bool
  # default     = false
}
variable "min_node_count" {
  description = "Minimum number of nodes in the GKE node pool."
  type        = number
  default     = 0
}
variable "max_node_count" {
  description = "Maximum number of nodes in the GKE node pool."
  type        = number
  default     = 3
}