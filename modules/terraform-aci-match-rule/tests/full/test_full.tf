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
  name        = "MR1"
  description = "My Description"
  regex_community_terms = [{
    name        = "REGEX1"
    regex       = "1234"
    type        = "extended"
    description = "REGEX1 description"
  }]
  community_terms = [{
    name        = "COM1"
    description = "COM1 description"
    factors = [{
      community   = "regular:as2-nn2:1:2345"
      description = "2345 description"
      scope       = "non-transitive"
    }]
  }]
  prefixes = [{
    ip          = "10.1.1.0/24"
    description = "Prefix Description"
    aggregate   = true
    from_length = 25
    to_length   = 32
  }]
}

data "aci_rest_managed" "rtctrlSubjP" {
  dn = "${aci_rest_managed.fvTenant.id}/subj-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "rtctrlSubjP" {
  component = "rtctrlSubjP"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.rtctrlSubjP.content.name
    want        = module.main.name
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.rtctrlSubjP.content.descr
    want        = "My Description"
  }
}

data "aci_rest_managed" "rtctrlMatchCommRegexTerm" {
  dn = "${data.aci_rest_managed.rtctrlSubjP.id}/commrxtrm-extended"

  depends_on = [module.main]
}

resource "test_assertions" "rtctrlMatchCommRegexTerm" {
  component = "rtctrlMatchCommRegexTerm"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.rtctrlMatchCommRegexTerm.content.name
    want        = "REGEX1"
  }

  equal "regex" {
    description = "regex"
    got         = data.aci_rest_managed.rtctrlMatchCommRegexTerm.content.regex
    want        = "1234"
  }

  equal "commType" {
    description = "commType"
    got         = data.aci_rest_managed.rtctrlMatchCommRegexTerm.content.commType
    want        = "extended"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.rtctrlMatchCommRegexTerm.content.descr
    want        = "REGEX1 description"
  }
}

data "aci_rest_managed" "rtctrlMatchCommTerm" {
  dn = "${data.aci_rest_managed.rtctrlSubjP.id}/commtrm-COM1"

  depends_on = [module.main]
}

resource "test_assertions" "rtctrlMatchCommTerm" {
  component = "rtctrlMatchCommTerm"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.rtctrlMatchCommTerm.content.name
    want        = "COM1"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.rtctrlMatchCommTerm.content.descr
    want        = "COM1 description"
  }
}

data "aci_rest_managed" "rtctrlMatchCommFactor" {
  dn = "${data.aci_rest_managed.rtctrlMatchCommTerm.id}/commfct-regular:as2-nn2:1:2345"

  depends_on = [module.main]
}

resource "test_assertions" "rtctrlMatchCommFactor" {
  component = "rtctrlMatchCommFactor"

  equal "community" {
    description = "community"
    got         = data.aci_rest_managed.rtctrlMatchCommFactor.content.community
    want        = "regular:as2-nn2:1:2345"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.rtctrlMatchCommFactor.content.descr
    want        = "2345 description"
  }

  equal "scope" {
    description = "scope"
    got         = data.aci_rest_managed.rtctrlMatchCommFactor.content.scope
    want        = "non-transitive"
  }
}

data "aci_rest_managed" "rtctrlMatchRtDest" {
  dn = "${data.aci_rest_managed.rtctrlSubjP.id}/dest-[10.1.1.0/24]"

  depends_on = [module.main]
}

resource "test_assertions" "rtctrlMatchRtDest" {
  component = "rtctrlMatchRtDest"

  equal "ip" {
    description = "ip"
    got         = data.aci_rest_managed.rtctrlMatchRtDest.content.ip
    want        = "10.1.1.0/24"
  }

  equal "aggregate" {
    description = "aggregate"
    got         = data.aci_rest_managed.rtctrlMatchRtDest.content.aggregate
    want        = "yes"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.rtctrlMatchRtDest.content.descr
    want        = "Prefix Description"
  }

  equal "fromPfxLen" {
    description = "fromPfxLen"
    got         = data.aci_rest_managed.rtctrlMatchRtDest.content.fromPfxLen
    want        = "25"
  }

  equal "toPfxLen" {
    description = "toPfxLen"
    got         = data.aci_rest_managed.rtctrlMatchRtDest.content.toPfxLen
    want        = "32"
  }
}
