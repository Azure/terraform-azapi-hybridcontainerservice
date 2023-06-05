# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------
variable "resource_group_name" {
  description = "(Required) The name of the resource group that the resources for consul will run in"
  type        = string
}

variable "cluster_name" {
  description = "(Required) The name of cluster"
  type        = string
}

variable "customLocation_id" {
  description = "(Required) The name of the customer location that the resources for consul will run in"
  type        = string
}

variable "vnet_name" {
  description = "(Required) The name of the vnet that the resources for consul will run in"
  type        = string
}

variable "site_name" {
  description = "(Required) The name of the site"
  type        = string
}

variable "environment" {
  description = "(Required) The environment of the site, possiblily value like: test/prod"
  type        = string
}

variable "public_key" {
  description = "(Required) Base64 encoded public certificate used by the agent to do the initial handshake to the backend services in Azure."
  type        = string
}


# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

# can't change in portal
variable "kubernetes_version" {
  default     = "v1.22.11"
  description = "(Optional) kubernates version of this hybrid aks"
}

variable "default_agent_count" {
  default     = 1
  description = "(Optional) VM count of the default node pool"
}

variable "default_agent_VM_size" {
  default     = "Standard_A4_v2"
  description = "(Optional) VM sku of the default node pool"
  validation {
    condition     = can(regex("^Standard_A4_v2$|^Standard_K8S3_v1$", var.default_agent_VM_size))
    error_message = "Err: default_agent_VM_size is not valid."
  }

}

# can't change in portal
variable "controlplane_count" {
  default     = 1
  description = "(Optional) VM count of the control plane"
}

variable "controlplane_VM_size" {
  default     = "Standard_A4_v2"
  description = "(Optional) VM sku of the control plane"
  validation {
    condition     = can(regex("^Standard_A4_v2$|^Standard_K8S3_v1$", var.controlplane_VM_size))
    error_message = "Err: controlplane_VM_size is not valid."
  }
}

# didn't show in portal
variable "loadbalancer_count" {
  default     = 1
  description = "(Optional) VM count of the load balancer"
}

variable "loadbalancer_VM_size" {
  default     = "Standard_K8S3_v1"
  description = "(Optional) VM sku of the load balancer"
  validation {
    condition     = can(regex("^Standard_A4_v2$|^Standard_K8S3_v1$", var.loadbalancer_VM_size))
    error_message = "Err: loadbalancer_VM_size is not valid."
  }
}

variable "loadbalancer_sku" {
  default     = "unstacked-haproxy"
  description = "(Optional) value"
  validation {
    condition     = can(regex("^unstacked-haproxy$", var.loadbalancer_sku))
    error_message = "Err: loadbalancer_sku is not valid."
  }
}

# can't change in portal
variable "network_policy" {
  default     = "calico"
  description = "(Optional) network cni of this hybrid aks"
  validation {
    condition     = can(regex("^calico$", var.network_policy))
    error_message = "Err: network_policy is not valid."
  }
}

# didn't show in portal
variable "pod_cidr" {
  default     = "10.245.0.0/16"
  description = "(Optional) CIDR of pods in this hybrid aks"
}

variable "admin_group_object_IDs" {
  default     = []
  type        = list(string)
  description = "(Optional) If you want to Use Azure AD for authentication and Kubernetes native RBAC for authorization, specify AAD group here. Assign Azure Active Directory groups that will have admin access within the cluster. Make sure you are part of the assigned groups to ensure cluster access after deployment regardless of if you are an Owner or a Contributor. "
}
