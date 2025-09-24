module "aci_redirect_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-redirect-policy"
  version = ">= 0.8.0"

  tenant                 = "ABC"
  name                   = "REDIRECT1"
  alias                  = "REDIRECT1-ALIAS"
  description            = "My Description"
  anycast                = false
  type                   = "L3"
  hashing                = "sip"
  threshold              = true
  max_threshold          = 90
  min_threshold          = 10
  pod_aware              = true
  resilient_hashing      = true
  threshold_down_action  = "deny"
  ip_sla_policy          = "SLA1"
  redirect_backup_policy = "REDIRECT_BCK1"
  rewrite_source_mac     = true
  l3_destinations = [{
    description           = "L3 description"
    name                  = "L3_DEST1"
    ip                    = "1.1.1.1"
    ip_2                  = "1.1.1.2"
    mac                   = "00:01:02:03:04:05"
    pod_id                = 2
    redirect_health_group = "HEALTH_GRP1"
  }]
}
