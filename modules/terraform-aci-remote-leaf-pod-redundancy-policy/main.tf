resource "aci_rest_managed" "infraRlPodRedPol" {
  dn         = "uni/infra/rlpodred"
  class_name = "infraRlPodRedPol"
  content = {
    name                   = "default"
    enableRlPodRedPol      = var.enable_remote_leaf_policy == true ? "yes" : "no"
    enablePodRedPreemption = var.enable_preemption == true ? "yes" : "no"
  }
}
