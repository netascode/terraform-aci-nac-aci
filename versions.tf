terraform {
  required_version = ">= 1.8.0"

  required_providers {
    aci = {
      source  = "CiscoDevNet/aci"
      version = "= 2.15.0"
    }
    utils = {
      source  = "netascode/utils"
      version = ">= 1.0.1"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.3.0"
    }
  }
}
