resource "aci_rest_managed" "macsecKeyChainPol" {
  # for_each = { for kp in var.key_policies: kp.name => kp }
  dn         = "uni/infra/macsecpcont/keychainp-${var.name}"
  class_name = "macsecKeyChainPol"
  content = {
    name  = var.name
    descr = var.description
  }
}

resource "aci_rest_managed" "macsecKeyPol" {
  for_each   = { for kp in var.key_policies : kp.keyName => kp }
  dn         = "uni/infra/macsecpcont/keychainp-${var.name}/keyp-${each.value.keyName}"
  class_name = "macsecKeyPol"
  content = {
    name         = each.value.name
    keyName      = each.value.keyName
    descr        = each.value.description
    keyName      = each.value.keyName
    preSharedKey = each.value.preSharedKey
    startTime    = each.value.startTime
    endTime      = each.value.endTime
  }

  lifecycle {
    ignore_changes = [content["startTime"], content["preSharedKey"]]
  }
}
