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

module "main_master" {
  source = "../.."

  tenant              = aci_rest_managed.fvTenant.content.name
  application_profile = aci_rest_managed.fvAp.content.name
  name                = "ESG_MASTER"
  vrf                 = "VRF1"
}

module "main" {
  source = "../.."

  name                        = "ESG1"
  description                 = "My Description"
  tenant                      = aci_rest_managed.fvTenant.content.name
  application_profile         = aci_rest_managed.fvAp.content.name
  vrf                         = "VRF1"
  shutdown                    = false
  intra_esg_isolation         = true
  preferred_group             = true
  contract_consumers          = ["CON1"]
  contract_providers          = ["CON1"]
  contract_imported_consumers = ["IMPORTED-CON1"]
  contract_intra_esgs         = ["CON1"]
  esg_contract_masters = [
    {
      tenant                  = "TF"
      application_profile     = "AP1"
      endpoint_security_group = "ESG_MASTER"
    }
  ]
  tag_selectors = [
    {
      key      = "key1"
      operator = "contains"
      value    = "value1"
    },
    {
      key      = "key2"
      operator = "equals"
      value    = "value2"
    },
    {
      key      = "key3"
      operator = "regex"
      value    = "value3"
    },
    {
      key   = "key4"
      value = "value4"
    },
    {
      key   = "__vmm::vmname"
      value = "value4"
    }
  ]
  epg_selectors = [
    {
      tenant              = "TF"
      application_profile = "AP1"
      endpoint_group      = "EPG1"
    }
  ]
  ip_subnet_selectors = [
    {
      value = "1.1.1.0/24"
    },
    {
      value = "1.1.2.0/24"
    },
    {
      value = "1.1.3.0/24"
    },
    {
      value       = "1.1.4.0/24"
      description = "foo"
    }
  ]
  depends_on = [module.main_master]
}

data "aci_rest_managed" "fvESg" {
  dn = "${aci_rest_managed.fvAp.id}/esg-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "fvESg" {
  component = "fvESg"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.fvESg.content.name
    want        = module.main.name
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.fvESg.content.descr
    want        = "My Description"
  }

  equal "pcEnfPref" {
    description = "pcEnfPref"
    got         = data.aci_rest_managed.fvESg.content.pcEnfPref
    want        = "enforced"
  }

  equal "prefGrMemb" {
    description = "prefGrMemb"
    got         = data.aci_rest_managed.fvESg.content.prefGrMemb
    want        = "include"
  }
}

data "aci_rest_managed" "fvRsScope" {
  dn = "${data.aci_rest_managed.fvESg.id}/rsscope"

  depends_on = [module.main]
}

resource "test_assertions" "fvRsScope" {
  component = "fvRsScope"

  equal "tnFvCtxName" {
    description = "tnFvCtxName"
    got         = data.aci_rest_managed.fvRsScope.content.tnFvCtxName
    want        = "VRF1"
  }
}

data "aci_rest_managed" "fvRsCons" {
  dn = "${data.aci_rest_managed.fvESg.id}/rscons-CON1"

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
  dn = "${data.aci_rest_managed.fvESg.id}/rsprov-CON1"

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
  dn = "${data.aci_rest_managed.fvESg.id}/rsconsIf-IMPORTED-CON1"

  depends_on = [module.main]
}

resource "test_assertions" "fvRsConsIf" {
  component = "fvRsConsIf"

  equal "tnVzCPIfName" {
    description = "tnVzCPIfName"
    got         = data.aci_rest_managed.fvRsConsIf.content.tnVzCPIfName
    want        = "IMPORTED-CON1"
  }
}

data "aci_rest_managed" "fvRsIntraEpg" {
  dn = "${data.aci_rest_managed.fvESg.id}/rsintraEpg-CON1"

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
  dn = "${data.aci_rest_managed.fvESg.id}/rssecInherited-[uni/tn-${aci_rest_managed.fvTenant.content.name}/ap-${aci_rest_managed.fvAp.content.name}/esg-ESG_MASTER]"

  depends_on = [module.main]
}

resource "test_assertions" "fvRsSecInherited" {
  component = "fvRsSecInherited"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.fvRsSecInherited.content.tDn
    want        = "uni/tn-${aci_rest_managed.fvTenant.content.name}/ap-${aci_rest_managed.fvAp.content.name}/esg-ESG_MASTER"
  }
}


data "aci_rest_managed" "fvTagSelector_1" {
  dn = "${data.aci_rest_managed.fvESg.id}/tagselectorkey-[key1]-value-[value1]"

  depends_on = [module.main]
}

resource "test_assertions" "fvTagSelector_1" {
  component = "fvTagSelector_1"

  equal "matchKey" {
    description = "matchKey"
    got         = data.aci_rest_managed.fvTagSelector_1.content.matchKey
    want        = "key1"
  }

  equal "matchValue" {
    description = "matchValue"
    got         = data.aci_rest_managed.fvTagSelector_1.content.matchValue
    want        = "value1"
  }

  equal "valueOperator" {
    description = "valueOperator"
    got         = data.aci_rest_managed.fvTagSelector_1.content.valueOperator
    want        = "contains"
  }
}

data "aci_rest_managed" "fvTagSelector_4" {
  dn = "${data.aci_rest_managed.fvESg.id}/tagselectorkey-[key4]-value-[value4]"

  depends_on = [module.main]
}

resource "test_assertions" "fvTagSelector_4" {
  component = "fvTagSelector_4"

  equal "matchKey" {
    description = "matchKey"
    got         = data.aci_rest_managed.fvTagSelector_4.content.matchKey
    want        = "key4"
  }

  equal "matchValue" {
    description = "matchValue"
    got         = data.aci_rest_managed.fvTagSelector_4.content.matchValue
    want        = "value4"
  }

  equal "valueOperator" {
    description = "valueOperator"
    got         = data.aci_rest_managed.fvTagSelector_4.content.valueOperator
    want        = "equals"
  }
}

data "aci_rest_managed" "fvEPgSelector" {
  dn = "${data.aci_rest_managed.fvESg.id}/epgselector-[uni/tn-${aci_rest_managed.fvTenant.content.name}/ap-${aci_rest_managed.fvAp.content.name}/epg-EPG1]"

  depends_on = [module.main]
}

resource "test_assertions" "fvEPgSelector" {
  component = "fvEPgSelector"

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.fvEPgSelector.content.descr
    want        = ""
  }

  equal "matchEpgDn" {
    description = "matchEpgDn"
    got         = data.aci_rest_managed.fvEPgSelector.content.matchEpgDn
    want        = "uni/tn-${aci_rest_managed.fvTenant.content.name}/ap-${aci_rest_managed.fvAp.content.name}/epg-EPG1"
  }
}

data "aci_rest_managed" "fvEPSelector_1" {
  dn = "${data.aci_rest_managed.fvESg.id}/epselector-[ip=='1.1.1.0/24']"

  depends_on = [module.main]
}

resource "test_assertions" "fvEPSelector_1" {
  component = "fvEPSelector_1"

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.fvEPSelector_1.content.descr
    want        = ""
  }

  equal "matchExpression" {
    description = "matchExpression"
    got         = data.aci_rest_managed.fvEPSelector_1.content.matchExpression
    want        = "ip=='1.1.1.0/24'"
  }
}

data "aci_rest_managed" "fvEPSelector_4" {
  dn = "${data.aci_rest_managed.fvESg.id}/epselector-[ip=='1.1.4.0/24']"

  depends_on = [module.main]
}

resource "test_assertions" "fvEPSelector_4" {
  component = "fvEPSelector_4"

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.fvEPSelector_4.content.descr
    want        = "foo"
  }

  equal "matchExpression" {
    description = "matchExpression"
    got         = data.aci_rest_managed.fvEPSelector_4.content.matchExpression
    want        = "ip=='1.1.4.0/24'"
  }
}
