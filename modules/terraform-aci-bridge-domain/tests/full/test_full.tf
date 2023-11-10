terraform {
  required_version = ">= 1.3.0"

  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    aci = {
      source  = "CiscoDevNet/aci"
      version = ">=2.0.0"
    }
  }
}

resource "aci_rest_managed" "fvTenant" {
  dn         = "uni/tn-TF"
  class_name = "fvTenant"
}

module "main" {
  source = "../.."

  tenant                     = aci_rest_managed.fvTenant.content.name
  name                       = "BD1"
  alias                      = "BD1-ALIAS"
  description                = "My Description"
  arp_flooding               = true
  advertise_host_routes      = true
  ip_dataplane_learning      = false
  limit_ip_learn_to_subnets  = false
  mac                        = "11:11:11:11:11:11"
  ep_move_detection          = true
  virtual_mac                = "22:22:22:22:22:22"
  l3_multicast               = true
  multi_destination_flooding = "drop"
  unicast_routing            = false
  unknown_unicast            = "flood"
  unknown_ipv4_multicast     = "opt-flood"
  unknown_ipv6_multicast     = "opt-flood"
  vrf                        = "VRF1"
  igmp_interface_policy      = "IIP1"
  igmp_snooping_policy       = "ISP1"
  subnets = [{
    description        = "Subnet Description"
    ip                 = "1.1.1.1/24"
    primary_ip         = true
    public             = true
    shared             = true
    igmp_querier       = true
    nd_ra_prefix       = false
    no_default_gateway = false
    virtual            = true
    tags = [
      {
        key   = "tag_key"
        value = "tag_value"
      }
    ]
  }]
  l3outs = ["L3OUT1"]
  dhcp_labels = [{
    dhcp_relay_policy  = "DHCP_RELAY_1"
    dhcp_option_policy = "DHCP_OPTION_1"
  }]
}

data "aci_rest_managed" "fvBD" {
  dn = "uni/tn-${aci_rest_managed.fvTenant.content.name}/BD-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "fvBD" {
  component = "fvBD"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.fvBD.content.name
    want        = module.main.name
  }

  equal "nameAlias" {
    description = "nameAlias"
    got         = data.aci_rest_managed.fvBD.content.nameAlias
    want        = "BD1-ALIAS"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.fvBD.content.descr
    want        = "My Description"
  }

  equal "arpFlood" {
    description = "arpFlood"
    got         = data.aci_rest_managed.fvBD.content.arpFlood
    want        = "yes"
  }

  equal "hostBasedRouting" {
    description = "hostBasedRouting"
    got         = data.aci_rest_managed.fvBD.content.hostBasedRouting
    want        = "yes"
  }

  equal "ipLearning" {
    description = "ipLearning"
    got         = data.aci_rest_managed.fvBD.content.ipLearning
    want        = "no"
  }

  equal "limitIpLearnToSubnets" {
    description = "limitIpLearnToSubnets"
    got         = data.aci_rest_managed.fvBD.content.limitIpLearnToSubnets
    want        = "no"
  }

  equal "mac" {
    description = "mac"
    got         = data.aci_rest_managed.fvBD.content.mac
    want        = "11:11:11:11:11:11"
  }

  equal "epMoveDetectMode" {
    description = "epMoveDetectMode"
    got         = data.aci_rest_managed.fvBD.content.epMoveDetectMode
    want        = "garp"
  }

  equal "vmac" {
    description = "vmac"
    got         = data.aci_rest_managed.fvBD.content.vmac
    want        = "22:22:22:22:22:22"
  }

  equal "mcastAllow" {
    description = "mcastAllow"
    got         = data.aci_rest_managed.fvBD.content.mcastAllow
    want        = "yes"
  }

  equal "multiDstPktAct" {
    description = "multiDstPktAct"
    got         = data.aci_rest_managed.fvBD.content.multiDstPktAct
    want        = "drop"
  }

  equal "unicastRoute" {
    description = "unicastRoute"
    got         = data.aci_rest_managed.fvBD.content.unicastRoute
    want        = "no"
  }

  equal "unkMacUcastAct" {
    description = "unkMacUcastAct"
    got         = data.aci_rest_managed.fvBD.content.unkMacUcastAct
    want        = "flood"
  }

  equal "unkMcastAct" {
    description = "unkMcastAct"
    got         = data.aci_rest_managed.fvBD.content.unkMcastAct
    want        = "opt-flood"
  }

  equal "v6unkMcastAct" {
    description = "v6unkMcastAct"
    got         = data.aci_rest_managed.fvBD.content.v6unkMcastAct
    want        = "opt-flood"
  }
}

data "aci_rest_managed" "fvSubnet" {
  dn = "${data.aci_rest_managed.fvBD.id}/subnet-[1.1.1.1/24]"

  depends_on = [module.main]
}

resource "test_assertions" "fvSubnet" {
  component = "fvSubnet"

  equal "ip" {
    description = "ip"
    got         = data.aci_rest_managed.fvSubnet.content.ip
    want        = "1.1.1.1/24"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.fvSubnet.content.descr
    want        = "Subnet Description"
  }

  equal "preferred" {
    description = "preferred"
    got         = data.aci_rest_managed.fvSubnet.content.preferred
    want        = "yes"
  }

  equal "ctrl" {
    description = "ctrl"
    got         = data.aci_rest_managed.fvSubnet.content.ctrl
    want        = "querier"
  }

  equal "scope" {
    description = "scope"
    got         = data.aci_rest_managed.fvSubnet.content.scope
    want        = "public,shared"
  }

  equal "virtual" {
    description = "virtual"
    got         = data.aci_rest_managed.fvSubnet.content.virtual
    want        = "yes"
  }
}

data "aci_rest_managed" "fvRsBDToOut" {
  dn = "${data.aci_rest_managed.fvBD.id}/rsBDToOut-L3OUT1"

  depends_on = [module.main]
}

resource "test_assertions" "fvRsBDToOut" {
  component = "fvRsBDToOut"

  equal "tnL3extOutName" {
    description = "tnL3extOutName"
    got         = data.aci_rest_managed.fvRsBDToOut.content.tnL3extOutName
    want        = "L3OUT1"
  }
}

data "aci_rest_managed" "dhcpLbl" {
  dn = "${data.aci_rest_managed.fvBD.id}/dhcplbl-DHCP_RELAY_1"

  depends_on = [module.main]
}

resource "test_assertions" "dhcpLbl" {
  component = "dhcpLbl"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.dhcpLbl.content.name
    want        = "DHCP_RELAY_1"
  }
}

data "aci_rest_managed" "dhcpRsDhcpOptionPol" {
  dn = "${data.aci_rest_managed.dhcpLbl.id}/rsdhcpOptionPol"

  depends_on = [module.main]
}

resource "test_assertions" "dhcpRsDhcpOptionPol" {
  component = "dhcpRsDhcpOptionPol"

  equal "tnDhcpOptionPolName" {
    description = "tnDhcpOptionPolName"
    got         = data.aci_rest_managed.dhcpRsDhcpOptionPol.content.tnDhcpOptionPolName
    want        = "DHCP_OPTION_1"
  }
}

data "aci_rest_managed" "fvRsCtx" {
  dn = "${data.aci_rest_managed.fvBD.id}/rsctx"

  depends_on = [module.main]
}

resource "test_assertions" "fvRsCtx" {
  component = "fvRsCtx"

  equal "tnFvCtxName" {
    description = "tnFvCtxName"
    got         = data.aci_rest_managed.fvRsCtx.content.tnFvCtxName
    want        = "VRF1"
  }
}

data "aci_rest_managed" "igmpRsIfPol" {
  dn = "${data.aci_rest_managed.fvBD.id}/igmpIfP/rsIfPol"

  depends_on = [module.main]
}

resource "test_assertions" "igmpRsIfPol" {
  component = "igmpRsIfPol"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.igmpRsIfPol.content.tDn
    want        = "uni/tn-TF/igmpIfPol-IIP1"
  }
}

data "aci_rest_managed" "fvRsIgmpsn" {
  dn = "${data.aci_rest_managed.fvBD.id}/rsigmpsn"

  depends_on = [module.main]
}

resource "test_assertions" "fvRsIgmpsn" {
  component = "fvRsIgmpsn"

  equal "tnIgmpSnoopPolName" {
    description = "tnIgmpSnoopPolName"
    got         = data.aci_rest_managed.fvRsIgmpsn.content.tnIgmpSnoopPolName
    want        = "ISP1"
  }
}

data "aci_rest_managed" "tagTag" {
  dn = "${data.aci_rest_managed.fvSubnet.id}/tagKey-tag_key"

  depends_on = [module.main]
}

resource "test_assertions" "tagTag" {
  component = "tagTag"

  equal "key" {
    description = "key"
    got         = data.aci_rest_managed.tagTag.content.key
    want        = "tag_key"
  }

  equal "value" {
    description = "value"
    got         = data.aci_rest_managed.tagTag.content.value
    want        = "tag_value"
  }
}
