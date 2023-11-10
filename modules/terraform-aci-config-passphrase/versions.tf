
terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aci = {
      source  = "CiscoDevNet/aci"
      version = ">= 2.6.0"
    }
  }
}
