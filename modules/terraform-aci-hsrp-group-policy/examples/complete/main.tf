module "aci_hsrp_group_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-hsrp-group-policy"
  version = ">= 0.8.0"

  tenant               = "ABC"
  name                 = "HSRP_GRP1"
  description          = "My Description"
  preempt              = true
  hello_interval       = 3000
  hold_interval        = 10000
  priority             = 110
  auth_type            = "md5"
  auth_key             = "SecureKey123"
  preempt_delay_min    = 60
  preempt_delay_reload = 300
  preempt_delay_max    = 60
  timeout              = 90
}
