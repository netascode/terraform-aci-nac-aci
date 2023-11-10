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

  tenant          = aci_rest_managed.fvTenant.content.name
  name            = "DEV1"
  alias           = "DEV1-ALIAS"
  context_aware   = "multi-Context"
  type            = "PHYSICAL"
  function        = "GoTo"
  copy_device     = false
  managed         = false
  service_type    = "FW"
  trunking        = false
  physical_domain = "PD1"
  concrete_devices = [{
    name  = "CDEV1"
    alias = "CDEV1-ALIAS"
    interfaces = [{
      name     = "CINT1"
      alias    = "CINT1-ALIAS"
      pod_id   = 2
      node_id  = 101
      node2_id = 102
      channel  = "VPC1"
    }]
  }]
  logical_interfaces = [{
    name  = "INT1"
    alias = "INT1-ALIAS"
    vlan  = 10
    concrete_interfaces = [{
      device    = "CDEV1"
      interface = "CINT1"
    }]
  }]
}

data "aci_rest_managed" "vnsLDevVip" {
  dn = "uni/tn-${aci_rest_managed.fvTenant.content.name}/lDevVip-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "vnsLDevVip" {
  component = "vnsLDevVip"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.vnsLDevVip.content.name
    want        = module.main.name
  }

  equal "contextAware" {
    description = "contextAware"
    got         = data.aci_rest_managed.vnsLDevVip.content.contextAware
    want        = "multi-Context"
  }

  equal "devtype" {
    description = "devtype"
    got         = data.aci_rest_managed.vnsLDevVip.content.devtype
    want        = "PHYSICAL"
  }

  equal "funcType" {
    description = "funcType"
    got         = data.aci_rest_managed.vnsLDevVip.content.funcType
    want        = "GoTo"
  }

  equal "isCopy" {
    description = "isCopy"
    got         = data.aci_rest_managed.vnsLDevVip.content.isCopy
    want        = "no"
  }

  equal "managed" {
    description = "managed"
    got         = data.aci_rest_managed.vnsLDevVip.content.managed
    want        = "no"
  }

  equal "mode" {
    description = "mode"
    got         = data.aci_rest_managed.vnsLDevVip.content.mode
    want        = "legacy-Mode"
  }

  equal "nameAlias" {
    description = "nameAlias"
    got         = data.aci_rest_managed.vnsLDevVip.content.nameAlias
    want        = "DEV1-ALIAS"
  }

  equal "packageModel" {
    description = "packageModel"
    got         = data.aci_rest_managed.vnsLDevVip.content.packageModel
    want        = ""
  }

  equal "promMode" {
    description = "promMode"
    got         = data.aci_rest_managed.vnsLDevVip.content.promMode
    want        = "no"
  }

  equal "svcType" {
    description = "svcType"
    got         = data.aci_rest_managed.vnsLDevVip.content.svcType
    want        = "FW"
  }

  equal "trunking" {
    description = "trunking"
    got         = data.aci_rest_managed.vnsLDevVip.content.trunking
    want        = "no"
  }
}

data "aci_rest_managed" "vnsRsALDevToPhysDomP" {
  dn = "${data.aci_rest_managed.vnsLDevVip.id}/rsALDevToPhysDomP"

  depends_on = [module.main]
}

resource "test_assertions" "vnsRsALDevToPhysDomP" {
  component = "vnsRsALDevToPhysDomP"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.vnsRsALDevToPhysDomP.content.tDn
    want        = "uni/phys-PD1"
  }
}

data "aci_rest_managed" "vnsCDev" {
  dn = "${data.aci_rest_managed.vnsLDevVip.id}/cDev-CDEV1"

  depends_on = [module.main]
}

resource "test_assertions" "vnsCDev" {
  component = "vnsCDev"

  equal "cloneCount" {
    description = "cloneCount"
    got         = data.aci_rest_managed.vnsCDev.content.cloneCount
    want        = "0"
  }

  equal "devCtxLbl" {
    description = "devCtxLbl"
    got         = data.aci_rest_managed.vnsCDev.content.devCtxLbl
    want        = ""
  }

  equal "host" {
    description = "host"
    got         = data.aci_rest_managed.vnsCDev.content.host
    want        = ""
  }

  equal "isCloneOperation" {
    description = "isCloneOperation"
    got         = data.aci_rest_managed.vnsCDev.content.isCloneOperation
    want        = "no"
  }

  equal "isTemplate" {
    description = "isTemplate"
    got         = data.aci_rest_managed.vnsCDev.content.isTemplate
    want        = "no"
  }

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.vnsCDev.content.name
    want        = "CDEV1"
  }

  equal "nameAlias" {
    description = "nameAlias"
    got         = data.aci_rest_managed.vnsCDev.content.nameAlias
    want        = "CDEV1-ALIAS"
  }

  equal "vcenterName" {
    description = "vcenterName"
    got         = data.aci_rest_managed.vnsCDev.content.vcenterName
    want        = ""
  }

  equal "vmName" {
    description = "vmName"
    got         = data.aci_rest_managed.vnsCDev.content.vmName
    want        = ""
  }
}

data "aci_rest_managed" "vnsCIf" {
  dn = "${data.aci_rest_managed.vnsCDev.id}/cIf-[CINT1]"

  depends_on = [module.main]
}

resource "test_assertions" "vnsCIf" {
  component = "vnsCIf"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.vnsCIf.content.name
    want        = "CINT1"
  }

  equal "nameAlias" {
    description = "nameAlias"
    got         = data.aci_rest_managed.vnsCIf.content.nameAlias
    want        = "CINT1-ALIAS"
  }

  equal "vnicName" {
    description = "vnicName"
    got         = data.aci_rest_managed.vnsCIf.content.vnicName
    want        = ""
  }
}

data "aci_rest_managed" "vnsRsCIfPathAtt_channel" {
  dn = "${data.aci_rest_managed.vnsCIf.id}/rsCIfPathAtt"

  depends_on = [module.main]
}

resource "test_assertions" "vnsRsCIfPathAtt_channel" {
  component = "vnsRsCIfPathAtt_channel"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.vnsRsCIfPathAtt_channel.content.tDn
    want        = "topology/pod-2/protpaths-101-102/pathep-[VPC1]"
  }
}

data "aci_rest_managed" "vnsLIf" {
  dn = "${data.aci_rest_managed.vnsLDevVip.id}/lIf-INT1"

  depends_on = [module.main]
}

resource "test_assertions" "vnsLIf" {
  component = "vnsLIf"

  equal "encap" {
    description = "encap"
    got         = data.aci_rest_managed.vnsLIf.content.encap
    want        = "vlan-10"
  }

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.vnsLIf.content.name
    want        = "INT1"
  }

  equal "nameAlias" {
    description = "nameAlias"
    got         = data.aci_rest_managed.vnsLIf.content.nameAlias
    want        = "INT1-ALIAS"
  }
}

data "aci_rest_managed" "vnsRsCIfAttN" {
  dn = "${data.aci_rest_managed.vnsLIf.id}/rscIfAttN-[${data.aci_rest_managed.vnsCIf.id}]"

  depends_on = [module.main]
}

resource "test_assertions" "vnsRsCIfAttN" {
  component = "vnsRsCIfAttN"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.vnsRsCIfAttN.content.tDn
    want        = data.aci_rest_managed.vnsCIf.id
  }
}
