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

resource "aci_rest_managed" "l3extOut" {
  dn         = "${aci_rest_managed.fvTenant.dn}/out-L3OUT1"
  class_name = "l3extOut"
}

module "main" {
  source = "../.."

  tenant      = "TF"
  l3out       = "L3OUT1"
  name        = "NP1"
  multipod    = false
  remote_leaf = false
  nodes = [{
    node_id               = 201
    pod_id                = 2
    router_id             = "2.2.2.2"
    router_id_as_loopback = false
    loopback              = "12.12.12.12"
    static_routes = [{
      prefix      = "0.0.0.0/0"
      description = "Default Route"
      preference  = 10
      bfd         = true
      next_hops = [{
        ip         = "3.3.3.3"
        preference = 10
        type       = "prefix"
      }]
    }]
  }]
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

  depends_on = [aci_rest_managed.l3extOut]
}

data "aci_rest_managed" "l3extLNodeP" {
  dn = module.main.dn

  depends_on = [module.main]
}

resource "test_assertions" "l3extLNodeP" {
  component = "l3extLNodeP"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.l3extLNodeP.content.name
    want        = module.main.name
  }
}

data "aci_rest_managed" "l3extRsNodeL3OutAtt" {
  dn = "${data.aci_rest_managed.l3extLNodeP.id}/rsnodeL3OutAtt-[topology/pod-2/node-201]"

  depends_on = [module.main]
}

resource "test_assertions" "l3extRsNodeL3OutAtt" {
  component = "l3extRsNodeL3OutAtt"

  equal "rtrId" {
    description = "rtrId"
    got         = data.aci_rest_managed.l3extRsNodeL3OutAtt.content.rtrId
    want        = "2.2.2.2"
  }

  equal "rtrIdLoopBack" {
    description = "rtrIdLoopBack"
    got         = data.aci_rest_managed.l3extRsNodeL3OutAtt.content.rtrIdLoopBack
    want        = "no"
  }
}

data "aci_rest_managed" "l3extLoopBackIfP" {
  dn = "${data.aci_rest_managed.l3extRsNodeL3OutAtt.id}/lbp-[12.12.12.12]"

  depends_on = [module.main]
}

resource "test_assertions" "l3extLoopBackIfP" {
  component = "l3extLoopBackIfP"

  equal "addr" {
    description = "addr"
    got         = data.aci_rest_managed.l3extLoopBackIfP.content.addr
    want        = "12.12.12.12"
  }
}

data "aci_rest_managed" "ipRouteP" {
  dn = "${data.aci_rest_managed.l3extRsNodeL3OutAtt.id}/rt-[0.0.0.0/0]"

  depends_on = [module.main]
}

resource "test_assertions" "ipRouteP" {
  component = "ipRouteP"

  equal "ip" {
    description = "ip"
    got         = data.aci_rest_managed.ipRouteP.content.ip
    want        = "0.0.0.0/0"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.ipRouteP.content.descr
    want        = "Default Route"
  }

  equal "pref" {
    description = "pref"
    got         = data.aci_rest_managed.ipRouteP.content.pref
    want        = "10"
  }

  equal "rtCtrl" {
    description = "rtCtrl"
    got         = data.aci_rest_managed.ipRouteP.content.rtCtrl
    want        = "bfd"
  }
}

data "aci_rest_managed" "ipNexthopP" {
  dn = "${data.aci_rest_managed.ipRouteP.id}/nh-[3.3.3.3]"

  depends_on = [module.main]
}

resource "test_assertions" "ipNexthopP" {
  component = "ipNexthopP"

  equal "nhAddr" {
    description = "nhAddr"
    got         = data.aci_rest_managed.ipNexthopP.content.nhAddr
    want        = "3.3.3.3"
  }

  equal "pref" {
    description = "pref"
    got         = data.aci_rest_managed.ipNexthopP.content.pref
    want        = "10"
  }

  equal "type" {
    description = "type"
    got         = data.aci_rest_managed.ipNexthopP.content.type
    want        = "prefix"
  }
}

data "aci_rest_managed" "bgpPeerP" {
  dn = "${data.aci_rest_managed.l3extLNodeP.id}/peerP-[4.4.4.4]"

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
