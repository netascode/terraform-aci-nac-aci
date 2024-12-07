resource "aci_rest_managed" "macsecKeyChainPol" {
  dn         = "uni/infra/macsecpcont/keychainp-${var.name}"
  class_name = "macsecKeyChainPol"
  content = {
    name  = var.name
    descr = var.description
  }
}

resource "aci_rest_managed" "macsecKeyPol" {
  for_each   = { for kp in var.key_policies : kp.key_name => kp }
  dn         = "${aci_rest_managed.macsecKeyChainPol.dn}/keyp-${each.value.key_name}"
  class_name = "macsecKeyPol"
  content = {
    name         = each.value.name
    keyName      = each.value.key_name
    descr        = each.value.description
    preSharedKey = sensitive(each.value.pre_shared_key)
    startTime    = each.value.start_time
    endTime      = each.value.end_time
  }

  lifecycle {
    ignore_changes = [content["startTime"], content["preSharedKey"]]
  }
}
