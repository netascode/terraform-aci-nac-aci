module "aci_set_rule" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-set-rule"
  version = ">= 0.8.0"

  tenant                      = "ABC"
  name                        = "SR1"
  description                 = "My Description"
  community                   = "no-export"
  community_mode              = "replace"
  dampening                   = true
  dampening_half_life         = 15
  dampening_max_suppress_time = 60
  dampening_reuse_limit       = 750
  dampening_suppress_limit    = 2000
  weight                      = 100
  next_hop                    = "1.1.1.1"
  metric                      = 1
  preference                  = 1
  metric_type                 = "ospf-type1"
  additional_communities = [
    {
      community   = "regular:as2-nn2:4:15"
      description = "My Community"
    }
  ]
  set_as_paths = [
    {
      criteria = "prepend"
      asns = [
        {
          number = 65001
          order  = 5
        }
      ]
    }
  ]
  next_hop_propagation = true
  multipath            = true
}
