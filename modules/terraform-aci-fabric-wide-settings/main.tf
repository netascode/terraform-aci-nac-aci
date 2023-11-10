resource "aci_rest_managed" "infraSetPol" {
  dn         = "uni/infra/settings"
  class_name = "infraSetPol"
  content = {
    domainValidation           = var.domain_validation == true ? "yes" : "no"
    enforceSubnetCheck         = var.enforce_subnet_check == true ? "yes" : "no"
    opflexpAuthenticateClients = var.opflex_authentication == true ? "yes" : "no"
    unicastXrEpLearnDisable    = var.disable_remote_endpoint_learn == true ? "yes" : "no"
    validateOverlappingVlans   = var.overlapping_vlan_validation == true ? "yes" : "no"
    enableRemoteLeafDirect     = var.remote_leaf_direct == true ? "yes" : "no"
    reallocateGipo             = var.reallocate_gipo == true ? "yes" : "no"
  }
}
