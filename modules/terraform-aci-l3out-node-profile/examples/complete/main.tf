module "aci_l3out_node_profile" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-l3out-node-profile"
  version = ">= 0.9.1"

  tenant             = "ABC"
  l3out              = "L3OUT1"
  name               = "NP1"
  bgp_timer_policy   = "BGP_TIMER-1"
  bgp_as_path_policy = "BGP_AS_PATH-1"
  multipod           = true
  remote_leaf        = false
  nodes = [{
    node_id               = 201
    pod_id                = 2
    router_id             = "2.2.2.2"
    router_id_as_loopback = false
    loopbacks             = ["12.12.12.12", "2001:db8:42f8:2c07:85a3:0000:0000:abcd"]
    static_routes = [{
      prefix      = "0.0.0.0/0"
      description = "Default Route"
      preference  = 10
      bfd         = true
      next_hops = [{
        ip          = "3.3.3.3"
        description = "Next Hop Description"
        preference  = 10
        type        = "prefix"
        track_list  = "TRACK_POL"
        },
        {
          ip            = "5.5.5.5"
          description   = "Next Hop Description"
          preference    = 10
          type          = "prefix"
          ip_sla_policy = "IP_SLA_POLICY1"
          track_list    = "TRACK_POL"
        }
      ]
      },
      {
        prefix = "192.168.1.1/32"
        next_hops = [{
          ip         = "0.0.0.0/0"
          preference = 0
          type       = "none"
        }]
    }]
  }]
}