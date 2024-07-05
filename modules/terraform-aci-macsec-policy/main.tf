# apic:
#   access_policies:
#     interface_policies:
#       macsec_policies:
#         - name: ""
#           security_policy: ""
#            admin_state: 
#           keychain:
#             - name:
#               description: ""
#               keys:
#                 - name: ""
#                   preshared_key: ""
#                   key_start: ""
#                   key_end: ""

resource "aci_rest_managed" "macsecIfPol" {
  dn         = "uni/infra/macsecifp-${var.name}"
  class_name = "macsecIfPol"
  content = {
    name  = var.name
    adminSt = var.admin_state #@therealdoug - todo, use defaults file
    descr = try(var.description,"")
  }
}

# macsecIfPol relation to KeyCainPol and ParamPol
# KeyCainPol- KeyChainPol relation to KeyPol

# create keychain policy
resource "aci_rest_managed" "macsecKeyChainPol" {
  dn =      "uni/infra/macsecpcont/keychainp-${var.keyChain}"
  class_name = "macsecKeyChainPol"

  content = {
    name = var.keyChain
  }
}

# Create relation keychain policy to macsec policy
resource "aci_rest_managed" "RsToKeyChainPol" {
  dn = "${aci_rest_managed.macsecIfPol.dn}/rsToKeyChainPol"
  class_name = "macsecrsToKeyChainPol"
  content = {
    tDn = ""
  }
}

# create key
resource "aci_rest_managed" "macsecParmPol" {
  dn = "uni/infra/macsecpcont/paramp-${var.keyName}"
  class_name = "dd"
  
  content = {
    name = var.keyName
  }
}

# create key relation from IfPolicy