module "aci_hsrp_group_policy" {
  source = "../.."

  tenant               = "OSPF_TEST"
  name                 = "hsrp_group_policy_prod"
  alias                = "hsrp_grp_pol"
  description          = "Production HSRP Group Policy with preemption"
  annotation           = "orchestrator:terraform"
  preempt              = true
  hello_interval       = 3000
  hold_interval        = 10000
  priority             = 110
  hsrp_type            = "md5"
  key                  = "SecureHSRPKey2024"
  preempt_delay_min    = 5
  preempt_delay_reload = 60
  preempt_delay_sync   = 10
  timeout              = 300
  owner_key            = "network_team"
  owner_tag            = "production"
}