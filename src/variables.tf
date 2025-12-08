###cloud vars
# variable "token" {
#   type        = string
#   description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
# }

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
  validation {
    condition = length(var.cloud_id) >= 20
    error_message = "Invalid cloud id value"
  }
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
  validation {
    condition = length(var.folder_id) >= 20
    error_message = "Invalid folder id value"
  }
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
  validation {
    condition = contains(["ru-central1-a", "ru-central1-b", "ru-central1-d"], var.default_zone)
    error_message = "Invalid zone value"
  }
}

variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
  validation {
    #condition = alltrue([can(cidrhost(var.default_cidr[0])), can(cidrnetmask(var.default_cidr)) ])
    condition = can(cidrnetmask(var.default_cidr[0]))
    #condition = can(regex("\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}/\\d{1,2}", var.default_cidr[0]))
    error_message = "Invalid cidr value"
  }  
}

variable "source_addresses_good" {
  type = set(string)
  default     = ["192.168.0.1", "1.1.1.1", "127.0.0.1"]
  validation {
    condition = alltrue([
      for a in var.source_addresses_bad : can(cidrnetmask("${a}/32"))
    ])
    error_message = "All elements must be valid IPv4 CIDR block addresses."
  }
}

variable "source_addresses_bad" {
  type = set(string)
  default     = ["192.168.0.1", "1.1.1.1", "1270.0.0.1"]
  validation {
    condition = alltrue([
      for a in var.source_addresses_bad : can(cidrnetmask("${a}/32"))
    ])
    error_message = "All elements must be valid IPv4 CIDR block addresses"
  }
}

variable "vpc_name" {
  type        = string
  default     = "net"
  description = "VPC network&subnet name"
  validation {
    condition = length(var.vpc_name) >= 3
    error_message = "Invalid vpc name length, must be at least 3 characters"
  } 
}

variable "sub_vpc_name" {
  type        = string
  default     = "subnet"
  description = "VPC network&subnet name"
  validation {
    condition = length(var.sub_vpc_name) >= 3
    error_message = "Invalid sub_vpc name length, must be at least 3 characters"
  } 
}

###common vars

# variable "vms_ssh_root_key" {
#   type        = string
#   default     = "~/.ssh/id_ed25519.pub"
#   description = "ssh-keygen -t ed25519"
# }

# ###example vm_web var
# variable "vm_web_name" {
#   type        = string
#   default     = "netology-develop-platform-web"
#   description = "example vm_web_ prefix"
# }

# ###example vm_db var
# variable "vm_db_name" {
#   type        = string
#   default     = "netology-develop-platform-db"
#   description = "example vm_db_ prefix"
# }
