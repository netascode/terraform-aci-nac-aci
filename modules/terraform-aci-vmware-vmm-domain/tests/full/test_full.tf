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

module "main" {
  source = "../.."

  name                        = "VMW1"
  access_mode                 = "read-only"
  delimiter                   = "="
  tag_collection              = true
  vlan_pool                   = "VP1"
  vswitch_cdp_policy          = "CDP1"
  vswitch_lldp_policy         = "LLDP1"
  vswitch_port_channel_policy = "PC1"
  vswitch_mtu_policy          = "L2_8950"
  security_domains            = ["SEC1"]
  vswitch_enhanced_lags = [{
    name      = "ELAG1"
    mode      = "passive"
    lb_mode   = "dst-ip-l4port"
    num_links = 2
  }]
  vcenters = [{
    name              = "VC1"
    hostname_ip       = "1.1.1.1"
    datacenter        = "DC"
    credential_policy = "CP1"
    dvs_version       = "6.5"
    statistics        = true
    mgmt_epg_type     = "oob"
  }]
  credential_policies = [{
    name     = "CP1"
    username = "domain\\USER1"
    password = "PASSWORD1"
  }]
  uplinks = [{
    id   = 10
    name = "UL10"
  }]
}

data "aci_rest_managed" "vmmDomP" {
  dn = "uni/vmmp-VMware/dom-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "vmmDomP" {
  component = "vmmDomP"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.vmmDomP.content.name
    want        = module.main.name
  }

  equal "accessMode" {
    description = "accessMode"
    got         = data.aci_rest_managed.vmmDomP.content.accessMode
    want        = "read-only"
  }

  equal "delimiter" {
    description = "delimiter"
    got         = data.aci_rest_managed.vmmDomP.content.delimiter
    want        = "="
  }

  equal "enableTag" {
    description = "enableTag"
    got         = data.aci_rest_managed.vmmDomP.content.enableTag
    want        = "yes"
  }

  equal "mode" {
    description = "mode"
    got         = data.aci_rest_managed.vmmDomP.content.mode
    want        = "default"
  }
}

data "aci_rest_managed" "infraRsVlanNs" {
  dn = "${data.aci_rest_managed.vmmDomP.id}/rsvlanNs"

  depends_on = [module.main]
}

resource "test_assertions" "infraRsVlanNs" {
  component = "infraRsVlanNs"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.infraRsVlanNs.content.tDn
    want        = "uni/infra/vlanns-[VP1]-dynamic"
  }
}

data "aci_rest_managed" "vmmRsVswitchOverrideLldpIfPol" {
  dn = "${data.aci_rest_managed.vmmDomP.id}/vswitchpolcont/rsvswitchOverrideLldpIfPol"

  depends_on = [module.main]
}

resource "test_assertions" "vmmRsVswitchOverrideLldpIfPol" {
  component = "vmmRsVswitchOverrideLldpIfPol"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.vmmRsVswitchOverrideLldpIfPol.content.tDn
    want        = "uni/infra/lldpIfP-LLDP1"
  }
}

data "aci_rest_managed" "vmmRsVswitchOverrideCdpIfPol" {
  dn = "${data.aci_rest_managed.vmmDomP.id}/vswitchpolcont/rsvswitchOverrideCdpIfPol"

  depends_on = [module.main]
}

resource "test_assertions" "vmmRsVswitchOverrideCdpIfPol" {
  component = "vmmRsVswitchOverrideCdpIfPol"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.vmmRsVswitchOverrideCdpIfPol.content.tDn
    want        = "uni/infra/cdpIfP-CDP1"
  }
}

data "aci_rest_managed" "vmmRsVswitchOverrideLacpPol" {
  dn = "${data.aci_rest_managed.vmmDomP.id}/vswitchpolcont/rsvswitchOverrideLacpPol"

  depends_on = [module.main]
}

resource "test_assertions" "vmmRsVswitchOverrideLacpPol" {
  component = "vmmRsVswitchOverrideLacpPol"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.vmmRsVswitchOverrideLacpPol.content.tDn
    want        = "uni/infra/lacplagp-PC1"
  }
}

data "aci_rest_managed" "vmmRsVswitchOverrideMtuPol" {
  dn = "${data.aci_rest_managed.vmmDomP.id}/vswitchpolcont/rsvswitchOverrideMtuPol"

  depends_on = [module.main]
}

resource "test_assertions" "vmmRsVswitchOverrideMtuPol" {
  component = "vmmRsVswitchOverrideMtuPol"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.vmmRsVswitchOverrideMtuPol.content.tDn
    want        = "uni/fabric/l2pol-L2_8950"
  }
}

data "aci_rest_managed" "lacpEnhancedLagPol" {
  dn = "${data.aci_rest_managed.vmmDomP.id}/vswitchpolcont/enlacplagp-ELAG1"

  depends_on = [module.main]
}

resource "test_assertions" "lacpEnhancedLagPol" {
  component = "lacpEnhancedLagPol"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.lacpEnhancedLagPol.content.name
    want        = "ELAG1"
  }

  equal "lbmode" {
    description = "lbmode"
    got         = data.aci_rest_managed.lacpEnhancedLagPol.content.lbmode
    want        = "dst-ip-l4port"
  }

  equal "mode" {
    description = "mode"
    got         = data.aci_rest_managed.lacpEnhancedLagPol.content.mode
    want        = "passive"
  }

  equal "numLinks" {
    description = "numLinks"
    got         = data.aci_rest_managed.lacpEnhancedLagPol.content.numLinks
    want        = "2"
  }
}

data "aci_rest_managed" "vmmCtrlrP" {
  dn = "${data.aci_rest_managed.vmmDomP.id}/ctrlr-VC1"

  depends_on = [module.main]
}

resource "test_assertions" "vmmCtrlrP" {
  component = "vmmCtrlrP"

  equal "dvsVersion" {
    description = "dvsVersion"
    got         = data.aci_rest_managed.vmmCtrlrP.content.dvsVersion
    want        = "6.5"
  }

  equal "hostOrIp" {
    description = "hostOrIp"
    got         = data.aci_rest_managed.vmmCtrlrP.content.hostOrIp
    want        = "1.1.1.1"
  }

  equal "inventoryTrigSt" {
    description = "inventoryTrigSt"
    got         = data.aci_rest_managed.vmmCtrlrP.content.inventoryTrigSt
    want        = "untriggered"
  }

  equal "mode" {
    description = "mode"
    got         = data.aci_rest_managed.vmmCtrlrP.content.mode
    want        = "default"
  }

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.vmmCtrlrP.content.name
    want        = "VC1"
  }

  equal "port" {
    description = "port"
    got         = data.aci_rest_managed.vmmCtrlrP.content.port
    want        = "0"
  }

  equal "rootContName" {
    description = "rootContName"
    got         = data.aci_rest_managed.vmmCtrlrP.content.rootContName
    want        = "DC"
  }

  equal "scope" {
    description = "scope"
    got         = data.aci_rest_managed.vmmCtrlrP.content.scope
    want        = "vm"
  }

  equal "statsMode" {
    description = "statsMode"
    got         = data.aci_rest_managed.vmmCtrlrP.content.statsMode
    want        = "enabled"
  }
}

data "aci_rest_managed" "vmmUsrAccP" {
  dn = "${data.aci_rest_managed.vmmDomP.id}/usracc-CP1"

  depends_on = [module.main]
}

resource "test_assertions" "vmmUsrAccP" {
  component = "vmmUsrAccP"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.vmmUsrAccP.content.name
    want        = "CP1"
  }

  equal "usr" {
    description = "usr"
    got         = data.aci_rest_managed.vmmUsrAccP.content.usr
    want        = "domain\\USER1"
  }
}

data "aci_rest_managed" "vmmRsAcc" {
  dn = "${data.aci_rest_managed.vmmCtrlrP.id}/rsacc"

  depends_on = [module.main]
}

resource "test_assertions" "vmmRsAcc" {
  component = "vmmRsAcc"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.vmmRsAcc.content.tDn
    want        = "uni/vmmp-VMware/dom-VMW1/usracc-CP1"
  }
}


data "aci_rest_managed" "vmmUplinkPCont" {
  dn = "${data.aci_rest_managed.vmmDomP.id}/uplinkpcont"

  depends_on = [module.main]
}

resource "test_assertions" "vmmUplinkPCont" {
  component = "vmmUplinkPCont"

  equal "numOfUplinks" {
    description = "numOfUplinks"
    got         = data.aci_rest_managed.vmmUplinkPCont.content.numOfUplinks
    want        = "1"
  }
}

data "aci_rest_managed" "vmmUplinkP" {
  dn = "${data.aci_rest_managed.vmmUplinkPCont.id}/uplinkp-10"

  depends_on = [module.main]
}

resource "test_assertions" "vmmUplinkP" {
  component = "vmmUplinkP"

  equal "uplinkId" {
    description = "uplinkId"
    got         = data.aci_rest_managed.vmmUplinkP.content.uplinkId
    want        = "10"
  }

  equal "uplinkName" {
    description = "uplinkName"
    got         = data.aci_rest_managed.vmmUplinkP.content.uplinkName
    want        = "UL10"
  }
}

data "aci_rest_managed" "aaaDomainRef" {
  dn = "${data.aci_rest_managed.vmmDomP.dn}/domain-SEC1"

  depends_on = [module.main]
}

resource "test_assertions" "aaaDomainRef" {
  component = "aaaDomainRef"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.aaaDomainRef.content.name
    want        = "SEC1"
  }
}
