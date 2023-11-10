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
  dn         = "uni/tn-${aci_rest_managed.fvTenant.content.name}/out-L3OUT1"
  class_name = "l3extOut"
}

module "main" {
  source = "../.."

  tenant          = aci_rest_managed.fvTenant.content.name
  l3out           = aci_rest_managed.l3extOut.content.name
  name            = "EXTEPG1"
  alias           = "EXTEPG1-ALIAS"
  description     = "My Description"
  preferred_group = false
  qos_class       = "level2"
  target_dscp     = "CS2"
  subnets = [{
    name                           = "SUBNET1"
    prefix                         = "0.0.0.0/0"
    import_route_control           = true
    export_route_control           = true
    shared_route_control           = true
    import_security                = true
    shared_security                = true
    aggregate_import_route_control = true
    aggregate_export_route_control = true
    aggregate_shared_route_control = true
    bgp_route_summarization        = false
  }]
  contract_consumers          = ["CON1"]
  contract_providers          = ["CON1"]
  contract_imported_consumers = ["ICON1"]
}

data "aci_rest_managed" "l3extInstP" {
  dn = module.main.dn

  depends_on = [module.main]
}

resource "test_assertions" "l3extInstP" {
  component = "l3extInstP"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.l3extInstP.content.name
    want        = module.main.name
  }

  equal "nameAlias" {
    description = "nameAlias"
    got         = data.aci_rest_managed.l3extInstP.content.nameAlias
    want        = "EXTEPG1-ALIAS"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.l3extInstP.content.descr
    want        = "My Description"
  }

  equal "prefGrMemb" {
    description = "prefGrMemb"
    got         = data.aci_rest_managed.l3extInstP.content.prefGrMemb
    want        = "exclude"
  }

  equal "prio" {
    description = "prio"
    got         = data.aci_rest_managed.l3extInstP.content.prio
    want        = "level2"
  }

  equal "targetDscp" {
    description = "targetDscp"
    got         = data.aci_rest_managed.l3extInstP.content.targetDscp
    want        = "CS2"
  }
}

data "aci_rest_managed" "fvRsCons" {
  dn = "${data.aci_rest_managed.l3extInstP.id}/rscons-CON1"

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
  dn = "${data.aci_rest_managed.l3extInstP.id}/rsprov-CON1"

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
  dn = "${data.aci_rest_managed.l3extInstP.id}/rsconsIf-ICON1"

  depends_on = [module.main]
}

resource "test_assertions" "fvRsConsIf" {
  component = "fvRsConsIf"

  equal "tnVzCPIfName" {
    description = "tnVzCPIfName"
    got         = data.aci_rest_managed.fvRsConsIf.content.tnVzCPIfName
    want        = "ICON1"
  }
}

data "aci_rest_managed" "l3extSubnet" {
  dn = "${data.aci_rest_managed.l3extInstP.id}/extsubnet-[0.0.0.0/0]"

  depends_on = [module.main]
}

resource "test_assertions" "l3extSubnet" {
  component = "l3extSubnet"

  equal "ip" {
    description = "ip"
    got         = data.aci_rest_managed.l3extSubnet.content.ip
    want        = "0.0.0.0/0"
  }

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.l3extSubnet.content.name
    want        = "SUBNET1"
  }

  equal "scope" {
    description = "scope"
    got         = data.aci_rest_managed.l3extSubnet.content.scope
    want        = "export-rtctrl,import-rtctrl,import-security,shared-rtctrl,shared-security"
  }

  equal "aggregate" {
    description = "aggregate"
    got         = data.aci_rest_managed.l3extSubnet.content.aggregate
    want        = "export-rtctrl,import-rtctrl,shared-rtctrl"
  }
}
