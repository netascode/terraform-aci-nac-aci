resource "aci_rest_managed" "infraPortConfig" {
  dn         = "uni/infra/portconfnode-${var.node_id}-card-${var.module}-port-${var.port}-sub-${var.sub_port}"
  class_name = "infraPortConfig"
  content = {
    assocGrp     = var.policy_group_type == "access" && var.breakout == "none" && var.fex_id == "unspecified" && var.role == "leaf" ? "uni/infra/funcprof/accportgrp-${var.policy_group}" : (contains(["pc", "vpc"], var.policy_group_type) && var.breakout == "none" && var.fex_id == "unspecified" && var.role == "leaf" ? "uni/infra/funcprof/accbundle-${var.policy_group}" : (var.role == "spine" ? "uni/infra/funcprof/spaccportgrp-${var.policy_group}" : ""))
    brkoutMap    = var.breakout
    card         = var.module
    connectedFex = var.fex_id
    description  = var.description
    node         = var.node_id
    port         = var.port
    role         = var.role
    shutdown     = var.shutdown ? "yes" : "no"
    subPort      = var.sub_port
    pcMember     = (var.policy_group_type == "pc" || var.policy_group_type == "vpc") && var.role == "leaf" ? var.port_channel_member_policy : ""
  }
}
