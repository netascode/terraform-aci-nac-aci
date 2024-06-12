module "aci_useg_endpoint_group" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-endpoint-group"
  version = ">= 0.8.0"

  tenant                      = "ABC"
  application_profile         = "AP1"
  name                        = "uSeg_EPG1"
  alias                       = "uSeg-EPG1-ALIAS"
  description                 = "My uSeg EPG Description"
  flood_in_encap              = false
  intra_epg_isolation         = true
  preferred_group             = true
  qos_class                   = "level1"
  custom_qos_policy           = "CQP1"
  bridge_domain               = "BD1"
  trust_control_policy        = "TRUST_POL"
  contract_consumers          = ["CON1"]
  contract_providers          = ["CON1"]
  contract_imported_consumers = ["I_CON1"]
  contract_intra_epgs         = ["CON1"]
  contract_masters = [{
    endpoint_group      = "EPG2"
    application_profile = "AP1"
  }]
  physical_domains = ["PHY1"]
  tags = [
    "tag1",
    "tag2"
  ]

  match_type = "any"
  ip_statements = [{
    name           = "ip_1"
    use_epg_subnet = false
    ip             = "1.2.2.11"
    }, {
    name           = "ip_2"
    use_epg_subnet = true
  }]
  mac_statements = [{
    name = "mac_1"
    mac  = "02:aa:68:22:58:d1"
    }, {
    name = "mac_2"
    mac  = "02:aa:68:22:58:d2"
  }]
  subnets = [{
    description        = "Subnet Description"
    ip                 = "1.2.2.1/24"
    public             = true
    shared             = true
    igmp_querier       = true
    nd_ra_prefix       = true
    no_default_gateway = false
  }]
  vmware_vmm_domains = [{
    name                 = "VMW1"
    netflow              = false
    deployment_immediacy = "immediate"
  }]
  static_leafs = [{
    node_id = 102
  }]
  l4l7_address_pools = [{
    name            = "POOL1"
    gateway_address = "1.2.2.1/24"
    from            = "1.2.2.10"
    to              = "1.2.2.100"
  }]
}
