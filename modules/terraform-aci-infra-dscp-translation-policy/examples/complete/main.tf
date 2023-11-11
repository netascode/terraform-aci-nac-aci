module "aci_infra_dscp_translation_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-infra-dscp-translation-policy"
  version = ">= 0.8.0"

  admin_state   = true
  control_plane = "CS1"
  level_1       = "CS2"
  level_2       = "CS3"
  level_3       = "CS4"
  level_4       = "CS5"
  level_5       = "CS6"
  level_6       = "CS7"
  policy_plane  = "AF11"
  span          = "AF12"
  traceroute    = "AF13"
}
