resource "aci_rest_managed" "fabricProtPol" {
  dn         = "uni/fabric/protpol"
  class_name = "fabricProtPol"
  content = {
    name  = "default"
    pairT = var.mode
  }
}

resource "aci_rest_managed" "fabricExplicitGEp" {
  for_each   = { for g in var.groups : g.name => g }
  dn         = "${aci_rest_managed.fabricProtPol.dn}/expgep-${each.key}"
  class_name = "fabricExplicitGEp"
  content = {
    name = each.value.name
    id   = each.value.id
  }

  child {
    rn         = "nodepep-${each.value.switch_1}"
    class_name = "fabricNodePEp"
    content = {
      id = each.value.switch_1
    }
  }

  child {
    rn         = "nodepep-${each.value.switch_2}"
    class_name = "fabricNodePEp"
    content = {
      id = each.value.switch_2
    }
  }
}

resource "aci_rest_managed" "fabricRsVpcInstPol" {
  for_each   = { for g in var.groups : g.name => g if g.policy != null }
  dn         = "${aci_rest_managed.fabricExplicitGEp[each.key].dn}/rsvpcInstPol"
  class_name = "fabricRsVpcInstPol"
  content = {
    tnVpcInstPolName = each.value.policy
  }
}
