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

resource "aci_rest_managed" "fvAp" {
  dn         = "${aci_rest_managed.fvTenant.id}/ap-AP1"
  class_name = "fvAp"
}

module "main" {
  source = "../.."

  tenant                      = aci_rest_managed.fvTenant.content.name
  application_profile         = aci_rest_managed.fvAp.content.name
  name                        = "EPG1"
  alias                       = "EPG1-ALIAS"
  description                 = "My Description"
  flood_in_encap              = false
  intra_epg_isolation         = true
  proxy_arp                   = true
  preferred_group             = true
  qos_class                   = "level1"
  custom_qos_policy           = "CQP1"
  bridge_domain               = "BD1"
  trust_control_policy        = "TRUST_POL"
  contract_consumers          = ["CON1"]
  contract_providers          = ["CON1"]
  contract_imported_consumers = ["I_CON1"]
  contract_intra_epgs         = ["CON1"]
  physical_domains            = ["PHY1"]
  tags = [
    "tag1",
    "tag2"
  ]
  subnets = [
    {
      description        = "Subnet Description"
      ip                 = "1.1.1.1/24"
      public             = true
      shared             = true
      igmp_querier       = true
      nd_ra_prefix       = true
      no_default_gateway = false
      ip_pools = [
        {
          name              = "POOL1"
          start_ip          = "172.16.0.1"
          end_ip            = "172.16.0.10"
          dns_server        = "dns.cisco.com"
          dns_search_suffix = "cisco"
          dns_suffix        = "cisco"
          wins_server       = "win"
        }
      ]
    },
    {
      ip                 = "2.2.2.2/32"
      no_default_gateway = true
      next_hop_ip        = "192.168.1.1"
    },
    {
      ip                 = "3.3.3.3/32"
      no_default_gateway = true
      anycast_mac        = "00:00:00:01:02:03"
    },
    {
      ip                 = "4.4.4.4/32"
      no_default_gateway = true
      nlb_group          = "230.1.1.1"
      nlb_mode           = "mode-mcast-igmp"
    }
  ]
  vmware_vmm_domains = [
    {
      name                 = "VMW1"
      u_segmentation       = true
      delimiter            = "|"
      primary_vlan         = 123
      secondary_vlan       = 124
      netflow              = false
      deployment_immediacy = "lazy"
      resolution_immediacy = "lazy"
      allow_promiscuous    = true
      forged_transmits     = true
      mac_changes          = true
      custom_epg_name      = "custom-epg-name"
      elag                 = "ELAG1"
      active_uplinks_order = "1"
      standby_uplinks      = "2"
    }
  ]
  static_ports = [
    {
      node_id              = 101
      vlan                 = 123
      pod_id               = 1
      port                 = 10
      sub_port             = 1
      module               = 1
      deployment_immediacy = "lazy"
      mode                 = "untagged"
    },
    {
      node_id  = 101
      node2_id = 102
      fex_id   = 151
      fex2_id  = 152
      vlan     = 2
      channel  = "ipg_vpc_test"
    },
    {
      node_id = 101
      fex_id  = 151
      vlan    = 2
      channel = "ipg_regular-po_test"
    },
    {
      node_id = 101
      fex_id  = 151
      port    = 1
      vlan    = 2
    }
  ]
  static_leafs = [
    {
      node_id              = 102
      vlan                 = 124
      deployment_immediacy = "lazy"
      mode                 = "untagged"
    }
  ]
  static_endpoints = [
    {
      name           = "EP1"
      alias          = "EP1-ALIAS"
      mac            = "11:11:11:11:11:11"
      ip             = "1.1.1.10"
      type           = "silent-host"
      node_id        = 101
      node2_id       = 102
      vlan           = 123
      pod_id         = 1
      channel        = "VPC1"
      additional_ips = ["1.1.1.11"]
    }
  ]
  l4l7_virtual_ips = [
    {
      ip          = "1.2.3.4"
      description = "My Virtual IP"
    }
  ]
  l4l7_address_pools = [
    {
      name            = "POOL1"
      gateway_address = "1.1.1.1/24"
      from            = "1.1.1.10"
      to              = "1.1.1.100"
    }
  ]
}

data "aci_rest_managed" "fvAEPg" {
  dn = "${aci_rest_managed.fvAp.id}/epg-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "fvAEPg" {
  component = "fvAEPg"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.fvAEPg.content.name
    want        = module.main.name
  }

  equal "nameAlias" {
    description = "nameAlias"
    got         = data.aci_rest_managed.fvAEPg.content.nameAlias
    want        = "EPG1-ALIAS"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.fvAEPg.content.descr
    want        = "My Description"
  }

  equal "floodOnEncap" {
    description = "floodOnEncap"
    got         = data.aci_rest_managed.fvAEPg.content.floodOnEncap
    want        = "disabled"
  }

  equal "pcEnfPref" {
    description = "pcEnfPref"
    got         = data.aci_rest_managed.fvAEPg.content.pcEnfPref
    want        = "enforced"
  }

  equal "fwdCtrl" {
    description = "fwdCtrl"
    got         = data.aci_rest_managed.fvAEPg.content.fwdCtrl
    want        = "proxy-arp"
  }

  equal "prefGrMemb" {
    description = "prefGrMemb"
    got         = data.aci_rest_managed.fvAEPg.content.prefGrMemb
    want        = "include"
  }

  equal "prio" {
    description = "prio"
    got         = data.aci_rest_managed.fvAEPg.content.prio
    want        = "level1"
  }
}

data "aci_rest_managed" "fvRsCustQosPol" {
  dn = "${data.aci_rest_managed.fvAEPg.id}/rscustQosPol"

  depends_on = [module.main]
}

resource "test_assertions" "fvRsCustQosPol" {
  component = "fvRsCustQosPol"

  equal "tnQosCustomPolName" {
    description = "tnQosCustomPolName"
    got         = data.aci_rest_managed.fvRsCustQosPol.content.tnQosCustomPolName
    want        = "CQP1"
  }
}

data "aci_rest_managed" "fvRsBd" {
  dn = "${data.aci_rest_managed.fvAEPg.id}/rsbd"

  depends_on = [module.main]
}

resource "test_assertions" "fvRsBd" {
  component = "fvRsBd"

  equal "tnFvBDName" {
    description = "tnFvBDName"
    got         = data.aci_rest_managed.fvRsBd.content.tnFvBDName
    want        = "BD1"
  }
}

data "aci_rest_managed" "fvRsTrustCtrl" {
  dn = "${data.aci_rest_managed.fvAEPg.id}/rstrustCtrl"

  depends_on = [module.main]
}

resource "test_assertions" "fvRsTrustCtrl" {
  component = "fvRsTrustCtrl"

  equal "tnFhsTrustCtrlPolName" {
    description = "tnFhsTrustCtrlPolName"
    got         = data.aci_rest_managed.fvRsTrustCtrl.content.tnFhsTrustCtrlPolName
    want        = "TRUST_POL"
  }
}

data "aci_rest_managed" "tagInst" {
  dn = "${data.aci_rest_managed.fvAEPg.id}/tag-tag1"

  depends_on = [module.main]
}

resource "test_assertions" "tagInst" {
  component = "tagInst"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.tagInst.content.name
    want        = "tag1"
  }
}

data "aci_rest_managed" "fvSubnet" {
  dn = "${data.aci_rest_managed.fvAEPg.id}/subnet-[1.1.1.1/24]"

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

  equal "ctrl" {
    description = "ctrl"
    got         = data.aci_rest_managed.fvSubnet.content.ctrl
    want        = "nd,querier"
  }

  equal "scope" {
    description = "scope"
    got         = data.aci_rest_managed.fvSubnet.content.scope
    want        = "public,shared"
  }
}

data "aci_rest_managed" "fvCepNetCfgPol" {
  dn = "${data.aci_rest_managed.fvSubnet.id}/cepNetCfgPol-POOL1"

  depends_on = [module.main]
}

resource "test_assertions" "fvCepNetCfgPol" {
  component = "fvCepNetCfgPol"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.fvCepNetCfgPol.content.name
    want        = "POOL1"
  }

  equal "startIp" {
    description = "startIp"
    got         = data.aci_rest_managed.fvCepNetCfgPol.content.startIp
    want        = "172.16.0.1"
  }

  equal "endIp" {
    description = "endIp"
    got         = data.aci_rest_managed.fvCepNetCfgPol.content.endIp
    want        = "172.16.0.10"
  }

  equal "dnsSearchSuffix" {
    description = "dnsSearchSuffix"
    got         = data.aci_rest_managed.fvCepNetCfgPol.content.dnsSearchSuffix
    want        = "cisco"
  }

  equal "dnsServers" {
    description = "dnsServers"
    got         = data.aci_rest_managed.fvCepNetCfgPol.content.dnsServers
    want        = "dns.cisco.com"
  }

  equal "dnsSuffix" {
    description = "dnsSuffix"
    got         = data.aci_rest_managed.fvCepNetCfgPol.content.dnsSuffix
    want        = "cisco"
  }

  equal "winsServers" {
    description = "winsServers"
    got         = data.aci_rest_managed.fvCepNetCfgPol.content.winsServers
    want        = "win"
  }
}

data "aci_rest_managed" "ipNexthopEpP" {
  dn = "${data.aci_rest_managed.fvAEPg.id}/subnet-[2.2.2.2/32]/epReach/nh-[192.168.1.1]"

  depends_on = [module.main]
}

resource "test_assertions" "ipNexthopEpP" {
  component = "ipNexthopEpP"

  equal "nhAddr" {
    description = "nhAddr"
    got         = data.aci_rest_managed.ipNexthopEpP.content.nhAddr
    want        = "192.168.1.1"
  }
}

data "aci_rest_managed" "fvEpAnycast" {
  dn = "${data.aci_rest_managed.fvAEPg.id}/subnet-[3.3.3.3/32]/epAnycast-[00:00:00:01:02:03]"

  depends_on = [module.main]
}

resource "test_assertions" "fvEpAnycast" {
  component = "fvEpAnycast"

  equal "mac" {
    description = "mac"
    got         = data.aci_rest_managed.fvEpAnycast.content.mac
    want        = "00:00:00:01:02:03"
  }
}

data "aci_rest_managed" "fvEpNlb" {
  dn = "${data.aci_rest_managed.fvAEPg.id}/subnet-[4.4.4.4/32]/epnlb"

  depends_on = [module.main]
}

resource "test_assertions" "fvEpNlb" {
  component = "fvEpNlb"

  equal "group" {
    description = "group"
    got         = data.aci_rest_managed.fvEpNlb.content.group
    want        = "230.1.1.1"
  }

  equal "mac" {
    description = "mac"
    got         = data.aci_rest_managed.fvEpNlb.content.mac
    want        = "00:00:00:00:00:00"
  }

  equal "mode" {
    description = "mode"
    got         = data.aci_rest_managed.fvEpNlb.content.mode
    want        = "mode-mcast-igmp"
  }
}

data "aci_rest_managed" "fvRsCons" {
  dn = "${data.aci_rest_managed.fvAEPg.id}/rscons-CON1"

  depends_on = [module.main]
}

resource "test_assertions" "fvRsCons" {
  component = "fvRsCons"

  equal "tnVzBrCPName" {
    description = "tnVzBrCPName"
    got         = data.aci_rest_managed.fvRsCons.content.tnVzBrCPName
    want        = "CON1"
  }
}

data "aci_rest_managed" "fvRsProv" {
  dn = "${data.aci_rest_managed.fvAEPg.id}/rsprov-CON1"

  depends_on = [module.main]
}

resource "test_assertions" "fvRsProv" {
  component = "fvRsProv"

  equal "tnVzBrCPName" {
    description = "tnVzBrCPName"
    got         = data.aci_rest_managed.fvRsProv.content.tnVzBrCPName
    want        = "CON1"
  }
}

data "aci_rest_managed" "fvRsConsIf" {
  dn = "${data.aci_rest_managed.fvAEPg.id}/rsconsIf-I_CON1"

  depends_on = [module.main]
}

resource "test_assertions" "fvRsConsIf" {
  component = "fvRsConsIf"

  equal "tnVzCPIfName" {
    description = "tnVzCPIfName"
    got         = data.aci_rest_managed.fvRsConsIf.content.tnVzCPIfName
    want        = "I_CON1"
  }
}

data "aci_rest_managed" "fvRsIntraEpg" {
  dn = "${data.aci_rest_managed.fvAEPg.id}/rsintraEpg-CON1"

  depends_on = [module.main]
}

resource "test_assertions" "fvRsIntraEpg" {
  component = "fvRsIntraEpg"

  equal "tnVzBrCPName" {
    description = "tnVzBrCPName"
    got         = data.aci_rest_managed.fvRsIntraEpg.content.tnVzBrCPName
    want        = "CON1"
  }
}

data "aci_rest_managed" "fvRsSecInherited" {
  dn = "${data.aci_rest_managed.fvAEPg.id}/rssecInherited-[uni/tn-TF/ap-AP1/epg-EPG1]"

  depends_on = [module.main]
}

resource "test_assertions" "fvRsSecInherited" {
  component = "fvRsSecInherited"

  equal "endpoint_group" {
    description = "endpoint_group"
    got         = data.aci_rest_managed.fvRsSecInherited.content.endpoint_group
    want        = "EPG2"
  }
  equal "application_profile" {
    description = "application_profile"
    got         = data.aci_rest_managed.fvRsSecInherited.content.application_profile
    want        = "AP1"
  }
}

data "aci_rest_managed" "fvRsDomAtt" {
  dn = "${data.aci_rest_managed.fvAEPg.id}/rsdomAtt-[uni/phys-PHY1]"

  depends_on = [module.main]
}

resource "test_assertions" "fvRsDomAtt" {
  component = "fvRsDomAtt"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.fvRsDomAtt.content.tDn
    want        = "uni/phys-PHY1"
  }
}

data "aci_rest_managed" "fvRsPathAtt" {
  dn = "${data.aci_rest_managed.fvAEPg.id}/rspathAtt-[topology/pod-1/paths-101/pathep-[eth1/10/1]]"

  depends_on = [module.main]
}

resource "test_assertions" "fvRsPathAtt" {
  component = "fvRsPathAtt"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.fvRsPathAtt.content.tDn
    want        = "topology/pod-1/paths-101/pathep-[eth1/10/1]"
  }

  equal "encap" {
    description = "encap"
    got         = data.aci_rest_managed.fvRsPathAtt.content.encap
    want        = "vlan-123"
  }

  equal "mode" {
    description = "mode"
    got         = data.aci_rest_managed.fvRsPathAtt.content.mode
    want        = "untagged"
  }

  equal "instrImedcy" {
    description = "instrImedcy"
    got         = data.aci_rest_managed.fvRsPathAtt.content.instrImedcy
    want        = "lazy"
  }
}

data "aci_rest_managed" "fvRsNodeAtt" {
  dn = "${data.aci_rest_managed.fvAEPg.id}/rsnodeAtt-[topology/pod-1/node-102]"

  depends_on = [module.main]
}

resource "test_assertions" "fvRsNodeAtt" {
  component = "fvRsNodeAtt"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.fvRsNodeAtt.content.tDn
    want        = "topology/pod-1/node-102"
  }

  equal "encap" {
    description = "encap"
    got         = data.aci_rest_managed.fvRsNodeAtt.content.encap
    want        = "vlan-124"
  }

  equal "mode" {
    description = "mode"
    got         = data.aci_rest_managed.fvRsNodeAtt.content.mode
    want        = "untagged"
  }

  equal "instrImedcy" {
    description = "instrImedcy"
    got         = data.aci_rest_managed.fvRsNodeAtt.content.instrImedcy
    want        = "lazy"
  }
}

data "aci_rest_managed" "fvStCEp" {
  dn = "${data.aci_rest_managed.fvAEPg.id}/stcep-11:11:11:11:11:11-type-silent-host"

  depends_on = [module.main]
}

resource "test_assertions" "fvStCEp" {
  component = "fvStCEp"

  equal "encap" {
    description = "encap"
    got         = data.aci_rest_managed.fvStCEp.content.encap
    want        = "vlan-123"
  }

  equal "id" {
    description = "id"
    got         = data.aci_rest_managed.fvStCEp.content.id
    want        = "0"
  }

  equal "ip" {
    description = "ip"
    got         = data.aci_rest_managed.fvStCEp.content.ip
    want        = "1.1.1.10"
  }

  equal "mac" {
    description = "mac"
    got         = data.aci_rest_managed.fvStCEp.content.mac
    want        = "11:11:11:11:11:11"
  }

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.fvStCEp.content.name
    want        = "EP1"
  }

  equal "nameAlias" {
    description = "nameAlias"
    got         = data.aci_rest_managed.fvStCEp.content.nameAlias
    want        = "EP1-ALIAS"
  }

  equal "type" {
    description = "type"
    got         = data.aci_rest_managed.fvStCEp.content.type
    want        = "silent-host"
  }
}

data "aci_rest_managed" "fvStIp" {
  dn = "${data.aci_rest_managed.fvStCEp.id}/ip-[1.1.1.11]"

  depends_on = [module.main]
}

resource "test_assertions" "fvStIp" {
  component = "fvStIp"

  equal "addr" {
    description = "addr"
    got         = data.aci_rest_managed.fvStIp.content.addr
    want        = "1.1.1.11"
  }
}

data "aci_rest_managed" "fvRsStCEpToPathEp" {
  dn = "${data.aci_rest_managed.fvStCEp.id}/rsstCEpToPathEp-[topology/pod-1/protpaths-101-102/pathep-[VPC1]]"

  depends_on = [module.main]
}

resource "test_assertions" "fvRsStCEpToPathEp" {
  component = "fvRsStCEpToPathEp"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.fvRsStCEpToPathEp.content.tDn
    want        = "topology/pod-1/protpaths-101-102/pathep-[VPC1]"
  }
}

data "aci_rest_managed" "fvRsDomAtt_vmm" {
  dn = "${data.aci_rest_managed.fvAEPg.id}/rsdomAtt-[uni/vmmp-VMware/dom-VMW1]"

  depends_on = [module.main]
}

resource "test_assertions" "fvRsDomAtt_vmm" {
  component = "fvRsDomAtt_vmm"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.fvRsDomAtt_vmm.content.tDn
    want        = "uni/vmmp-VMware/dom-VMW1"
  }

  equal "classPref" {
    description = "classPref"
    got         = data.aci_rest_managed.fvRsDomAtt_vmm.content.classPref
    want        = "useg"
  }

  equal "delimiter" {
    description = "delimiter"
    got         = data.aci_rest_managed.fvRsDomAtt_vmm.content.delimiter
    want        = "|"
  }

  equal "encap" {
    description = "encap"
    got         = data.aci_rest_managed.fvRsDomAtt_vmm.content.encap
    want        = "vlan-124"
  }

  equal "encapMode" {
    description = "encapMode"
    got         = data.aci_rest_managed.fvRsDomAtt_vmm.content.encapMode
    want        = "auto"
  }

  equal "primaryEncap" {
    description = "primaryEncap"
    got         = data.aci_rest_managed.fvRsDomAtt_vmm.content.primaryEncap
    want        = "vlan-123"
  }

  equal "netflowPref" {
    description = "netflowPref"
    got         = data.aci_rest_managed.fvRsDomAtt_vmm.content.netflowPref
    want        = "disabled"
  }

  equal "instrImedcy" {
    description = "instrImedcy"
    got         = data.aci_rest_managed.fvRsDomAtt_vmm.content.instrImedcy
    want        = "lazy"
  }

  equal "resImedcy" {
    description = "resImedcy"
    got         = data.aci_rest_managed.fvRsDomAtt_vmm.content.resImedcy
    want        = "lazy"
  }

  equal "switchingMode" {
    description = "switchingMode"
    got         = data.aci_rest_managed.fvRsDomAtt_vmm.content.switchingMode
    want        = "native"
  }

  equal "customEpgName" {
    description = "customEpgName"
    got         = data.aci_rest_managed.fvRsDomAtt_vmm.content.customEpgName
    want        = "custom-epg-name"
  }
}

data "aci_rest_managed" "vmmSecP" {
  dn = "${data.aci_rest_managed.fvRsDomAtt_vmm.id}/sec"

  depends_on = [module.main]
}

resource "test_assertions" "vmmSecP" {
  component = "vmmSecP"

  equal "allowPromiscuous" {
    description = "allowPromiscuous"
    got         = data.aci_rest_managed.vmmSecP.content.allowPromiscuous
    want        = "accept"
  }

  equal "forgedTransmits" {
    description = "forgedTransmits"
    got         = data.aci_rest_managed.vmmSecP.content.forgedTransmits
    want        = "accept"
  }

  equal "macChanges" {
    description = "macChanges"
    got         = data.aci_rest_managed.vmmSecP.content.macChanges
    want        = "accept"
  }
}

data "aci_rest_managed" "fvVip" {
  dn = "${data.aci_rest_managed.fvAEPg.id}/vip-1.2.3.4"

  depends_on = [module.main]
}

resource "test_assertions" "fvVip" {
  component = "fvVip"

  equal "addr" {
    description = "addr"
    got         = data.aci_rest_managed.fvVip.content.addr
    want        = "1.2.3.4"
  }
  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.fvVip.content.descr
    want        = "My Virtual IP"
  }
}


data "aci_rest_managed" "vnsAddrInst" {
  dn = "${data.aci_rest_managed.fvAEPg.id}/CtrlrAddrInst-POOL1"

  depends_on = [module.main]
}

resource "test_assertions" "vnsAddrInst" {
  component = "vnsAddrInst"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.vnsAddrInst.content.name
    want        = "POOL1"
  }
  equal "addr" {
    description = "addr"
    got         = data.aci_rest_managed.vnsAddrInst.content.addr
    want        = "1.1.1.1/24"
  }
}

data "aci_rest_managed" "fvnsUcastAddrBlk" {
  dn = "${data.aci_rest_managed.vnsAddrInst.id}/fromaddr-[1.1.1.10]-toaddr-[1.1.1.100]"

  depends_on = [module.main]
}

resource "test_assertions" "fvnsUcastAddrBlk" {
  component = "fvnsUcastAddrBlk"

  equal "from" {
    description = "from"
    got         = data.aci_rest_managed.fvnsUcastAddrBlk.content.from
    want        = "1.1.1.10"
  }
  equal "to" {
    description = "to"
    got         = data.aci_rest_managed.fvnsUcastAddrBlk.content.to
    want        = "1.1.1.100"
  }
}

data "aci_rest_managed" "fvRsVmmVSwitchEnhancedLagPol" {
  dn = "${data.aci_rest_managed.fvRsDomAtt_vmm.id}/epglagpolatt/rsvmmVSwitchEnhancedLagPol"

  depends_on = [module.main]
}

resource "test_assertions" "fvRsVmmVSwitchEnhancedLagPol" {
  component = "fvRsVmmVSwitchEnhancedLagPol"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.fvRsVmmVSwitchEnhancedLagPol.content.tDn
    want        = "uni/vmmp-VMware/dom-VMW1/vswitchpolcont/enlacplagp-ELAG1"
  }
}

data "aci_rest_managed" "fvUplinkOrderCont" {
  dn = "${data.aci_rest_managed.fvRsDomAtt_vmm.id}/uplinkorder"

  depends_on = [module.main]
}

resource "test_assertions" "fvUplinkOrderCont" {
  component = "fvUplinkOrderCont"

  equal "active" {
    description = "active"
    got         = data.aci_rest_managed.fvUplinkOrderCont.content.active
    want        = "1"
  }

  equal "standby" {
    description = "standby"
    got         = data.aci_rest_managed.fvUplinkOrderCont.content.standby
    want        = "2"
  }

}
