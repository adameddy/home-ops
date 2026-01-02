variable "cluster_name" {
  description = "A name to provide for the Talos cluster"
  type        = string
  default     = "homelab"
}

variable "cluster_vip" {
  description = "The VIP for the management of the Talos cluster"
  type        = string
  default     = "10.0.0.160"
}

variable "cluster_endpoint" {
  description = "The k8s api-server (VIP) endpoint"
  type        = string
  default     = "https://10.0.0.160:6443"
}

variable "cluster_node_network" {
  description = "The IP network prefix of the cluster nodes"
  type        = string
  default     = "10.0.0.0/24"
}


variable "pod_subnets" {
  description = "Pod network CIDR ranges"
  type        = list(string)
  default     = ["10.244.0.0/16"]
}

variable "service_subnets" {
  description = "Service network CIDR ranges"
  type        = list(string)
  default     = ["10.96.0.0/12"]
}

variable "talos_version" {
  type    = string
  default = "1.12.0"
  validation {
    condition     = can(regex("^\\d+(\\.\\d+)+", var.talos_version))
    error_message = "Must be a version number."
  }
}
