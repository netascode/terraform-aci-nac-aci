resource "aci_rest_managed" "infraNodeConfig" {
  count      = var.access_policy_group != "" ? 1 : 0
  dn         = "uni/infra/nodeconfnode-${var.node_id}"
  class_name = "infraNodeConfig"
  content = {
    assocGrp = var.role == "leaf" ? "uni/infra/funcprof/accnodepgrp-${var.access_policy_group}" : var.role == "spine" ? "uni/infra/funcprof/spaccnodepgrp-${var.access_policy_group}" : ""
    node     = var.node_id
  }
}

resource "aci_rest_managed" "fabricNodeConfig" {
  count      = var.fabric_policy_group != "" ? 1 : 0
  dn         = "uni/fabric/nodeconfnode-${var.node_id}"
  class_name = "fabricNodeConfig"
  content = {
    assocGrp = var.role == "leaf" ? "uni/fabric/funcprof/lenodepgrp-${var.fabric_policy_group}" : var.role == "spine" ? "uni/fabric/funcprof/spnodepgrp-${var.fabric_policy_group}" : ""
    node     = var.node_id
  }
}
