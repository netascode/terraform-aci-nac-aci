terraform {
  required_version = ">= 1.3.0"

  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    aci = {
      source  = "CiscoDevNet/aci"
      version = "=2.10.0"
    }
  }
}

resource "aci_rest_managed" "fvTenant" {
  dn         = "uni/tn-TF"
  class_name = "fvTenant"
  content = {
    name = "TF"
  }
}

resource "aci_rest_managed" "l3extOut" {
  dn         = "${aci_rest_managed.fvTenant.dn}/out-L3OUT1"
  class_name = "l3extOut"
  content = {
    name = "L3OUT1"
  }
}

resource "aci_rest_managed" "l3extLNodeP" {
  dn         = "${aci_rest_managed.l3extOut.dn}/lnodep-NP1"
  class_name = "l3extLNodeP"
  content = {
    name = "NP1"
  }
}

module "main" {
  source = "../.."

  tenant                       = aci_rest_managed.fvTenant.content.name
  l3out                        = aci_rest_managed.l3extOut.content.name
  node_profile                 = aci_rest_managed.l3extLNodeP.content.name
  name                         = "IP1"
  multipod                     = false
  remote_leaf                  = false
  bfd_policy                   = "BFD1"
  ospf_interface_profile_name  = "OSPFP1"
  ospf_authentication_key      = "12345678"
  ospf_authentication_key_id   = 2
  ospf_authentication_type     = "md5"
  ospf_interface_policy        = "OSPF1"
  eigrp_interface_profile_name = "EIGRP1"
  eigrp_keychain_policy        = "EIGRP_KEYCHAIN"
  eigrp_interface_policy       = "EIGRP1"
  igmp_interface_policy        = "IIP"
  qos_class                    = "level2"
  custom_qos_policy            = "CQP"
  interfaces = [{
    description = "Interface 1"
    type        = "vpc"
    svi         = true
    vlan        = 5
    mac         = "12:34:56:78:90:AB"
    mtu         = "1500"
    mode        = "native"
    node_id     = 201
    node2_id    = 202
    pod_id      = 2
    channel     = "VPC1"
    ip_a        = "1.1.1.2/24"
    ip_b        = "1.1.1.3/24"
    ip_shared   = "1.1.1.1/24"
    bgp_peers = [{
      ip                               = "4.4.4.4"
      remote_as                        = 12345
      description                      = "BGP Peer Description"
      allow_self_as                    = true
      as_override                      = true
      disable_peer_as_check            = true
      next_hop_self                    = false
      send_community                   = true
      send_ext_community               = true
      password                         = "BgpPassword"
      allowed_self_as_count            = 5
      bfd                              = true
      disable_connected_check          = true
      ttl                              = 2
      weight                           = 200
      remove_all_private_as            = true
      remove_private_as                = true
      replace_private_as_with_local_as = true
      unicast_address_family           = false
      multicast_address_family         = false
      admin_state                      = false
      local_as                         = 12346
      as_propagate                     = "no-prepend"
      peer_prefix_policy               = "PPP"
      export_route_control             = "ERC"
      import_route_control             = "IRC"
    }]
  }]
}

data "aci_rest_managed" "l3extLIfP" {
  dn = module.main.dn

  depends_on = [module.main]
}

resource "test_assertions" "l3extLIfP" {
  component = "l3extLIfP"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.l3extLIfP.content.name
    want        = module.main.name
  }
}

data "aci_rest_managed" "ospfIfP" {
  dn = "${data.aci_rest_managed.l3extLIfP.id}/ospfIfP"

  depends_on = [module.main]
}

resource "test_assertions" "ospfIfP" {
  component = "ospfIfP"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.ospfIfP.content.name
    want        = "OSPFP1"
  }

  equal "authKeyId" {
    description = "authKeyId"
    got         = data.aci_rest_managed.ospfIfP.content.authKeyId
    want        = "2"
  }

  equal "authType" {
    description = "authType"
    got         = data.aci_rest_managed.ospfIfP.content.authType
    want        = "md5"
  }
}

data "aci_rest_managed" "ospfRsIfPol" {
  dn = "${data.aci_rest_managed.ospfIfP.id}/rsIfPol"

  depends_on = [module.main]
}

resource "test_assertions" "ospfRsIfPol" {
  component = "ospfRsIfPol"

  equal "tnOspfIfPolName" {
    description = "tnOspfIfPolName"
    got         = data.aci_rest_managed.ospfRsIfPol.content.tnOspfIfPolName
    want        = "OSPF1"
  }
}

data "aci_rest_managed" "eigrpIfP" {
  dn = "${data.aci_rest_managed.l3extLIfP.id}/eigrpIfP"

  depends_on = [module.main]
}

resource "test_assertions" "eigrpIfP" {
  component = "eigrpIfP"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.eigrpIfP.content.name
    want        = "EIGRP1"
  }

}

data "aci_rest_managed" "eigrpRsIfPol" {
  dn = "${data.aci_rest_managed.eigrpIfP.id}/rsIfPol"

  depends_on = [module.main]
}

resource "test_assertions" "eigrpRsIfPol" {
  component = "eigrpRsIfPol"

  equal "tnEigrpIfPolName" {
    description = "tnEigrpIfPolName"
    got         = data.aci_rest_managed.eigrpRsIfPol.content.tnEigrpIfPolName
    want        = "EIGRP1"
  }
}

data "aci_rest_managed" "bfdIfP" {
  dn = "${data.aci_rest_managed.l3extLIfP.id}/bfdIfP"

  depends_on = [module.main]
}

resource "test_assertions" "bfdIfP" {
  component = "bfdIfP"

  equal "type" {
    description = "type"
    got         = data.aci_rest_managed.bfdIfP.content.type
    want        = "none"
  }
}

data "aci_rest_managed" "bfdRsIfPol" {
  dn = "${data.aci_rest_managed.bfdIfP.id}/rsIfPol"

  depends_on = [module.main]
}

resource "test_assertions" "bfdRsIfPol" {
  component = "bfdRsIfPol"

  equal "tnBfdIfPolName" {
    description = "tnBfdIfPolName"
    got         = data.aci_rest_managed.bfdRsIfPol.content.tnBfdIfPolName
    want        = "BFD1"
  }
}

data "aci_rest_managed" "igmpRsIfPol" {
  dn = "${data.aci_rest_managed.l3extLIfP.id}/igmpIfP/rsIfPol"

  depends_on = [module.main]
}

resource "test_assertions" "igmpRsIfPol" {
  component = "igmpRsIfPol"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.igmpRsIfPol.content.tDn
    want        = "uni/tn-TF/igmpIfPol-IIP"
  }
}

data "aci_rest_managed" "l3extRsLIfPCustQosPol" {
  dn = "${data.aci_rest_managed.l3extLIfP.id}/rslIfPCustQosPol"

  depends_on = [module.main]
}

resource "test_assertions" "l3extRsLIfPCustQosPol" {
  component = "l3extRsLIfPCustQosPol"

  equal "tnQosCustomPolName" {
    description = "tnQosCustomPolName"
    got         = data.aci_rest_managed.l3extRsLIfPCustQosPol.content.tnQosCustomPolName
    want        = "CQP"
  }
}

data "aci_rest_managed" "l3extRsPathL3OutAtt" {
  dn = "${data.aci_rest_managed.l3extLIfP.id}/rspathL3OutAtt-[topology/pod-2/protpaths-201-202/pathep-[VPC1]]"

  depends_on = [module.main]
}

resource "test_assertions" "l3extRsPathL3OutAtt" {
  component = "l3extRsPathL3OutAtt"

  equal "addr" {
    description = "addr"
    got         = data.aci_rest_managed.l3extRsPathL3OutAtt.content.addr
    want        = "0.0.0.0"
  }

  equal "autostate" {
    description = "autostate"
    got         = data.aci_rest_managed.l3extRsPathL3OutAtt.content.autostate
    want        = "disabled"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.l3extRsPathL3OutAtt.content.descr
    want        = "Interface 1"
  }

  equal "encapScope" {
    description = "encapScope"
    got         = data.aci_rest_managed.l3extRsPathL3OutAtt.content.encapScope
    want        = "local"
  }

  equal "ifInstT" {
    description = "ifInstT"
    got         = data.aci_rest_managed.l3extRsPathL3OutAtt.content.ifInstT
    want        = "ext-svi"
  }

  equal "encap" {
    description = "encap"
    got         = data.aci_rest_managed.l3extRsPathL3OutAtt.content.encap
    want        = "vlan-5"
  }

  equal "ipv6Dad" {
    description = "ipv6Dad"
    got         = data.aci_rest_managed.l3extRsPathL3OutAtt.content.ipv6Dad
    want        = "enabled"
  }

  equal "llAddr" {
    description = "llAddr"
    got         = data.aci_rest_managed.l3extRsPathL3OutAtt.content.llAddr
    want        = "::"
  }

  equal "mac" {
    description = "mac"
    got         = data.aci_rest_managed.l3extRsPathL3OutAtt.content.mac
    want        = "12:34:56:78:90:AB"
  }

  equal "mode" {
    description = "mode"
    got         = data.aci_rest_managed.l3extRsPathL3OutAtt.content.mode
    want        = "native"
  }

  equal "mtu" {
    description = "mtu"
    got         = data.aci_rest_managed.l3extRsPathL3OutAtt.content.mtu
    want        = "1500"
  }

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.l3extRsPathL3OutAtt.content.tDn
    want        = "topology/pod-2/protpaths-201-202/pathep-[VPC1]"
  }
}

data "aci_rest_managed" "l3extMember_A" {
  dn = "${data.aci_rest_managed.l3extRsPathL3OutAtt.id}/mem-A"

  depends_on = [module.main]
}

resource "test_assertions" "l3extMember_A" {
  component = "l3extMember_A"

  equal "addr" {
    description = "addr"
    got         = data.aci_rest_managed.l3extMember_A.content.addr
    want        = "1.1.1.2/24"
  }

  equal "side" {
    description = "side"
    got         = data.aci_rest_managed.l3extMember_A.content.side
    want        = "A"
  }
}

data "aci_rest_managed" "l3extIp_A" {
  dn = "${data.aci_rest_managed.l3extMember_A.id}/addr-[1.1.1.1/24]"

  depends_on = [module.main]
}

resource "test_assertions" "l3extIp_A" {
  component = "l3extIp_A"

  equal "addr" {
    description = "addr"
    got         = data.aci_rest_managed.l3extIp_A.content.addr
    want        = "1.1.1.1/24"
  }
}

data "aci_rest_managed" "l3extMember_B" {
  dn = "${data.aci_rest_managed.l3extRsPathL3OutAtt.id}/mem-B"

  depends_on = [module.main]
}

resource "test_assertions" "l3extMember_B" {
  component = "l3extMember_B"

  equal "addr" {
    description = "addr"
    got         = data.aci_rest_managed.l3extMember_B.content.addr
    want        = "1.1.1.3/24"
  }

  equal "side" {
    description = "side"
    got         = data.aci_rest_managed.l3extMember_B.content.side
    want        = "B"
  }
}

data "aci_rest_managed" "l3extIp_B" {
  dn = "${data.aci_rest_managed.l3extMember_B.id}/addr-[1.1.1.1/24]"

  depends_on = [module.main]
}

resource "test_assertions" "l3extIp_B" {
  component = "l3extIp_B"

  equal "addr" {
    description = "addr"
    got         = data.aci_rest_managed.l3extIp_B.content.addr
    want        = "1.1.1.1/24"
  }
}

data "aci_rest_managed" "bgpPeerP" {
  dn = "${data.aci_rest_managed.l3extRsPathL3OutAtt.id}/peerP-[4.4.4.4]"

  depends_on = [module.main]
}

resource "test_assertions" "bgpPeerP" {
  component = "bgpPeerP"

  equal "addr" {
    description = "addr"
    got         = data.aci_rest_managed.bgpPeerP.content.addr
    want        = "4.4.4.4"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.bgpPeerP.content.descr
    want        = "BGP Peer Description"
  }

  equal "ctrl" {
    description = "ctrl"
    got         = data.aci_rest_managed.bgpPeerP.content.ctrl
    want        = "allow-self-as,as-override,dis-peer-as-check,send-com,send-ext-com"
  }

  equal "allowedSelfAsCnt" {
    description = "allowedSelfAsCnt"
    got         = data.aci_rest_managed.bgpPeerP.content.allowedSelfAsCnt
    want        = "5"
  }

  equal "peerCtrl" {
    description = "peerCtrl"
    got         = data.aci_rest_managed.bgpPeerP.content.peerCtrl
    want        = "bfd,dis-conn-check"
  }

  equal "ttl" {
    description = "ttl"
    got         = data.aci_rest_managed.bgpPeerP.content.ttl
    want        = "2"
  }

  equal "weight" {
    description = "weight"
    got         = data.aci_rest_managed.bgpPeerP.content.weight
    want        = "200"
  }

  equal "privateASctrl" {
    description = "privateASctrl"
    got         = data.aci_rest_managed.bgpPeerP.content.privateASctrl
    want        = "remove-all,remove-exclusive,replace-as"
  }

  equal "addrTCtrl" {
    description = "addrTCtrl"
    got         = data.aci_rest_managed.bgpPeerP.content.addrTCtrl
    want        = ""
  }

  equal "adminSt" {
    description = "adminSt"
    got         = data.aci_rest_managed.bgpPeerP.content.adminSt
    want        = "disabled"
  }
}

data "aci_rest_managed" "bgpAsP" {
  dn = "${data.aci_rest_managed.bgpPeerP.id}/as"

  depends_on = [module.main]
}

resource "test_assertions" "bgpAsP" {
  component = "bgpAsP"

  equal "asn" {
    description = "asn"
    got         = data.aci_rest_managed.bgpAsP.content.asn
    want        = "12345"
  }
}

data "aci_rest_managed" "bgpLocalAsnP" {
  dn = "${data.aci_rest_managed.bgpPeerP.id}/localasn"

  depends_on = [module.main]
}

resource "test_assertions" "bgpLocalAsnP" {
  component = "bgpLocalAsnP"

  equal "localAsn" {
    description = "localAsn"
    got         = data.aci_rest_managed.bgpLocalAsnP.content.localAsn
    want        = "12346"
  }

  equal "asnPropagate" {
    description = "asnPropagate"
    got         = data.aci_rest_managed.bgpLocalAsnP.content.asnPropagate
    want        = "no-prepend"
  }
}

data "aci_rest_managed" "bgpRsPeerPfxPol" {
  dn = "${data.aci_rest_managed.bgpPeerP.id}/rspeerPfxPol"

  depends_on = [module.main]
}

resource "test_assertions" "bgpRsPeerPfxPol" {
  component = "bgpRsPeerPfxPol"

  equal "tnBgpPeerPfxPolName" {
    description = "tnBgpPeerPfxPolName"
    got         = data.aci_rest_managed.bgpRsPeerPfxPol.content.tnBgpPeerPfxPolName
    want        = "PPP"
  }
}

data "aci_rest_managed" "bgpRsPeerToProfile_export" {
  dn = "${data.aci_rest_managed.bgpPeerP.id}/rspeerToProfile-[uni/tn-TF/prof-ERC]-export"

  depends_on = [module.main]
}

resource "test_assertions" "bgpRsPeerToProfile_export" {
  component = "bgpRsPeerToProfile_export"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.bgpRsPeerToProfile_export.content.tDn
    want        = "uni/tn-TF/prof-ERC"
  }

  equal "direction" {
    description = "direction"
    got         = data.aci_rest_managed.bgpRsPeerToProfile_export.content.direction
    want        = "export"
  }
}

data "aci_rest_managed" "bgpRsPeerToProfile_import" {
  dn = "${data.aci_rest_managed.bgpPeerP.id}/rspeerToProfile-[uni/tn-TF/prof-IRC]-import"

  depends_on = [module.main]
}

resource "test_assertions" "bgpRsPeerToProfile_import" {
  component = "bgpRsPeerToProfile_import"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.bgpRsPeerToProfile_import.content.tDn
    want        = "uni/tn-TF/prof-IRC"
  }

  equal "direction" {
    description = "direction"
    got         = data.aci_rest_managed.bgpRsPeerToProfile_import.content.direction
    want        = "import"
  }
}
