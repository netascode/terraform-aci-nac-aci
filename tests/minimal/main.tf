# tflint-ignore-file: terraform_unused_declarations

data "aci_rest_managed" "fvnsVlanInstP" {
  dn = "uni/infra/vlanns-[VLAN_POOL_1]-static"
}

data "aci_rest_managed" "aaaPreLoginBanner" {
  dn = "uni/userext/preloginbanner"
}

data "aci_rest_managed" "fabricSetupP" {
  dn = "uni/controller/setuppol/setupp-13"
}

data "aci_rest_managed" "fabricExplicitGEp" {
  dn = "uni/fabric/protpol/expgep-GROUP_1451"
}

data "aci_rest_managed" "infraFexP" {
  dn = "uni/infra/fexprof-LEAF1451-FEX101"
}

data "aci_rest_managed" "fvTenant" {
  dn = "uni/tn-TENANT1"
}