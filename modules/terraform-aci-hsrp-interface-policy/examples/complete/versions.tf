
terraform {
  required_version = ">= 1.3"

  required_providers {
    aci = {
      source  = "CiscoDevNet/aci"
      version = ">= 2.17"
    }
  }
}
