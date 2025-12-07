terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = ">= 0.13" # из-за нервного tflint добавил
    }
  }
  
  required_version = "~> 1.13" # версия tf с которой совместим провайдер yandex

  backend "s3" {
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }

    bucket = "s3-core"
    key    = "prod/terraform.tfstate"
    region = "ru-central1"

    use_lockfile = true

    skip_region_validation = true
    skip_credentials_validation = true
    skip_requesting_account_id = true
    skip_s3_checksum = true

    use_path_style  = true

    #access_key  = ""
    #secret_key  = ""

  }  
}

provider "yandex" {
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.default_zone
  service_account_key_file = "../cloud-key/key.json"
}

