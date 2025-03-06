resource "aci_rest_managed" "aaaRbacNodeRule" {
  dn         = "uni/rbacdb/rbacnoderule-${var.node_id}"
  class_name = "aaaRbacNodeRule"
  content = {
    nodeId = var.node_id
  }
}

resource "aci_rest_managed" "aaaRbacPortRule" {
  for_each   = { for rule in var.port_rules : rule.name => rule }
  dn         = "${aci_rest_managed.aaaRbacNodeRule.dn}/rbacportrule-${each.key}"
  class_name = "aaaRbacPortRule"
  content = {
    name   = each.key
    domain = each.value.domain
  }
}
