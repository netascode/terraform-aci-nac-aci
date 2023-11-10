module "aci_qos_policy" {
  source  = "netascode/qos-policy/aci"
  version = ">= 0.1.0"

  name        = "ABC"
  tenant      = "TEN1"
  description = "My Custom Policy"
  alias       = "MyAlias"
  dscp_priority_maps = [
    {
      dscp_from   = "AF12"
      dscp_to     = "AF13"
      priority    = "level5"
      dscp_target = "CS0"
      cos_target  = 5
    }
  ]
  dot1p_classifiers = [
    {
      dot1p_from  = 3
      dot1p_to    = 4
      priority    = "level5"
      dscp_target = "CS0"
      cos_target  = 5
    }
  ]
}
