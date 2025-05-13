terraform {
  required_version = ">= 1.8.0"

  required_providers {
    aci = {
      source  = "CiscoDevNet/aci"
      version = ">= 2.15.0"
    }
  }
}
