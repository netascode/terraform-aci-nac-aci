resource "aci_rest_managed" "qosDscpTransPol" {
  dn         = "uni/tn-infra/dscptranspol-default"
  class_name = "qosDscpTransPol"
  content = {
    adminSt    = var.admin_state == true ? "enabled" : "disabled"
    control    = var.control_plane
    level1     = var.level_1
    level2     = var.level_2
    level3     = var.level_3
    level4     = var.level_4
    level5     = var.level_5
    level6     = var.level_6
    policy     = var.policy_plane
    span       = var.span
    traceroute = var.traceroute
  }
}
