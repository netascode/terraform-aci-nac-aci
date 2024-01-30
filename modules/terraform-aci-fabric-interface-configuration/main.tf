resource "aci_rest_managed" "fabricPortConfig" {
  dn         = "uni/fabric/portconfnode-${var.node_id}-card-${var.module}-port-${var.port}-sub-${var.sub_port}"
  class_name = "fabricPortConfig"
  content = {
    assocGrp    = var.role == "leaf" ? "uni/fabric/funcprof/leportgrp-${var.policy_group}" : var.role == "spine" ? "uni/fabric/funcprof/spportgrp-${var.policy_group}" : ""
    card        = var.module
    description = var.description
    node        = var.node_id
    port        = var.port
    role        = var.role
    shutdown    = var.shutdown ? "yes" : "no"
    subPort     = var.sub_port
  }
}
