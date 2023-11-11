module "aci_redirect_backup_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-redirect-backup-policy"
  version = ">= 0.8.0"

  tenant      = "ABC"
  name        = "REDIRECT1"
  description = "My Description"
  l3_destinations = [{
    name                  = "DEST1"
    description           = "L3 description"
    ip                    = "1.1.1.1"
    ip_2                  = "1.1.1.2"
    mac                   = "00:01:02:03:04:05"
    redirect_health_group = "HEALTH_GRP1"
  }]
}
