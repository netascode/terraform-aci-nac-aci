# apic:
#   access_policies:
#     macsec_parameter_policies:
#       - name: ""
#         description: ""
#         cipher_Suite: ""
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
  for_each = { for kp in var.key_policies: kp.name => kp }
  dn         = "uni/infra/macsecpcont/keychainp-${var.name}"
  class_name = "macsecKeyChainPol"
  content = {
    name  = var.name
    descr = var.description
  }
  child {
    rn = "keyp-${each.value.keyName}"
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
  }
}

# resource "aci_rest_managed" "macsecKeyPol" {
#   for_each   = local.key_policies
#   dn         = "${each.value.tDn}/keyp-${each.local.keyName}"
#   class_name = "macsecKeyPol"
#   content = {
#     name         = each.local.name
#     keyName      = each.local.keyName
#     descr        = each.local.description
#     keyName      = each.local.keyName
#     preSharedKey = each.local.preSharedKey
#     startTime    = each.local.startTime
#     endTime      = each.local.endTime
#   }
# }
