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

  tenant      = aci_rest_managed.fvTenant.content.name
  name        = "FILTER1"
  alias       = "FILTER1-ALIAS"
  description = "My Description"
  entries = [{
    name                  = "ENTRY1"
    alias                 = "ENTRY1-ALIAS"
    description           = "Entry Description"
    ethertype             = "ip"
    protocol              = "tcp"
    source_from_port      = "22"
    source_to_port        = "124"
    destination_from_port = "234"
    destination_to_port   = "554"
    stateful              = true
  }]
}

data "aci_rest_managed" "vzFilter" {
  dn = module.main.dn

  depends_on = [module.main]
}

resource "test_assertions" "vzFilter" {
  component = "vzFilter"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.vzFilter.content.name
    want        = module.main.name
  }

  equal "nameAlias" {
    description = "nameAlias"
    got         = data.aci_rest_managed.vzFilter.content.nameAlias
    want        = "FILTER1-ALIAS"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.vzFilter.content.descr
    want        = "My Description"
  }
}

data "aci_rest_managed" "vzEntry" {
  dn = "${data.aci_rest_managed.vzFilter.id}/e-ENTRY1"

  depends_on = [module.main]
}

resource "test_assertions" "vzEntry" {
  component = "vzEntry"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.vzEntry.content.name
    want        = "ENTRY1"
  }

  equal "nameAlias" {
    description = "nameAlias"
    got         = data.aci_rest_managed.vzEntry.content.nameAlias
    want        = "ENTRY1-ALIAS"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.vzEntry.content.descr
    want        = "Entry Description"
  }

  equal "etherT" {
    description = "etherT"
    got         = data.aci_rest_managed.vzEntry.content.etherT
    want        = "ip"
  }

  equal "prot" {
    description = "prot"
    got         = data.aci_rest_managed.vzEntry.content.prot
    want        = "tcp"
  }

  equal "sFromPort" {
    description = "sFromPort"
    got         = data.aci_rest_managed.vzEntry.content.sFromPort
    want        = "ssh"
  }

  equal "sToPort" {
    description = "sToPort"
    got         = data.aci_rest_managed.vzEntry.content.sToPort
    want        = "124"
  }

  equal "dFromPort" {
    description = "dFromPort"
    got         = data.aci_rest_managed.vzEntry.content.dFromPort
    want        = "234"
  }

  equal "dToPort" {
    description = "dToPort"
    got         = data.aci_rest_managed.vzEntry.content.dToPort
    want        = "rtsp"
  }

  equal "stateful" {
    description = "stateful"
    got         = data.aci_rest_managed.vzEntry.content.stateful
    want        = "yes"
  }
}
