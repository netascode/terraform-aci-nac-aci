# apic:
#   access_policies:
#     macsec_parameter_policies:
#       - name: ""
#         description: ""
#         cipher_suite: ""
#         confidentiality_offset: ""
#         key_server_priority: ""
#         window_size: ""
#         key_expiry_time: ""
#         security_policy: ""
#     macsec_keychains:
#       - name: ""
#         description: ""
#         key_policies:
#           - keyName:
#             name: 
#             preSharedKey: ""
#             startTime: ""
#             endTime: ""

resource "aci_rest_managed" "macsecKeyChainPol" {
  dn = "uni/infra/macsecpcont/keychainp-${var.name}"
  class_name = "macsecKeyChainPol"
  content = {
    name  = var.name
    descr = var.description
  }
}

locals {
  key_policies = flatten([
    for kcp in try(local.access_policies.macsec_keychains, []) : [
      for kp in try(kcp.key_policies, []) : {
        key          = "${kcp.name}/${kp.name}"
        tDn          = "uni/infra/macsecpcont/keychainp-${kcp.name}"
        name         = kp.name
        descr        = kp.description
        keyName      = kp.keyName
        preSharedKey = kp.preSharedKey
        startTime    = kp.startTime
        endTime      = kp.endTime
      }
    ]
  ])
}

resource "aci_rest_managed" "macsecKeyPol" {
  for_each = local.key_policies
  dn         = "${each.value.tDn}/keyp-${each.local.keyName}"
  class_name = "macsecKeyPol"
  content = {
    name    = each.local.name
    keyName = each.local.keyName
    descr   = each.local.description
    keyName = each.local.keyName
    preSharedKey = each.local.preSharedKey
    startTime = each.local.startTime
    endTime = each.local.endTime
  }
}
