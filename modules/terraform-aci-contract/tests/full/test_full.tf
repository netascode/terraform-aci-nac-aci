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
  name        = "CON1"
  alias       = "CON1-ALIAS"
  description = "My Description"
  scope       = "global"
  qos_class   = "level4"
  target_dscp = "CS0"
  subjects = [{
    name          = "SUB1"
    alias         = "SUB1-ALIAS"
    description   = "Subject Description"
    service_graph = "SG1"
    qos_class     = "level5"
    target_dscp   = "CS1"
    filters = [{
      filter   = "FILTER1"
      action   = "deny"
      priority = "level1"
      log      = true
      no_stats = true
    }]
  }]
}

data "aci_rest_managed" "vzBrCP" {
  dn = module.main.dn

  depends_on = [module.main]
}

resource "test_assertions" "vzBrCP" {
  component = "vzBrCP"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.vzBrCP.content.name
    want        = module.main.name
  }

  equal "nameAlias" {
    description = "nameAlias"
    got         = data.aci_rest_managed.vzBrCP.content.nameAlias
    want        = "CON1-ALIAS"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.vzBrCP.content.descr
    want        = "My Description"
  }

  equal "scope" {
    description = "scope"
    got         = data.aci_rest_managed.vzBrCP.content.scope
    want        = "global"
  }

  equal "prio" {
    description = "prio"
    got         = data.aci_rest_managed.vzBrCP.content.prio
    want        = "level4"
  }

  equal "targetDscp" {
    description = "targetDscp"
    got         = data.aci_rest_managed.vzBrCP.content.targetDscp
    want        = "CS0"
  }
}

data "aci_rest_managed" "vzSubj" {
  dn = "${data.aci_rest_managed.vzBrCP.id}/subj-SUB1"

  depends_on = [module.main]
}

resource "test_assertions" "vzSubj" {
  component = "vzSubj"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.vzSubj.content.name
    want        = "SUB1"
  }

  equal "nameAlias" {
    description = "nameAlias"
    got         = data.aci_rest_managed.vzSubj.content.nameAlias
    want        = "SUB1-ALIAS"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.vzSubj.content.descr
    want        = "Subject Description"
  }

  equal "revFltPorts" {
    description = "revFltPorts"
    got         = data.aci_rest_managed.vzSubj.content.revFltPorts
    want        = "yes"
  }

  equal "prio" {
    description = "prio"
    got         = data.aci_rest_managed.vzSubj.content.prio
    want        = "level5"
  }

  equal "targetDscp" {
    description = "targetDscp"
    got         = data.aci_rest_managed.vzSubj.content.targetDscp
    want        = "CS1"
  }
}

data "aci_rest_managed" "vzRsSubjFiltAtt" {
  dn = "${data.aci_rest_managed.vzSubj.id}/rssubjFiltAtt-FILTER1"

  depends_on = [module.main]
}

resource "test_assertions" "vzRsSubjFiltAtt" {
  component = "vzRsSubjFiltAtt"

  equal "action" {
    description = "action"
    got         = data.aci_rest_managed.vzRsSubjFiltAtt.content.action
    want        = "deny"
  }

  equal "tnVzFilterName" {
    description = "tnVzFilterName"
    got         = data.aci_rest_managed.vzRsSubjFiltAtt.content.tnVzFilterName
    want        = "FILTER1"
  }

  equal "directives" {
    description = "directives"
    got         = data.aci_rest_managed.vzRsSubjFiltAtt.content.directives
    want        = "log,no_stats"
  }

  equal "priorityOverride" {
    description = "priorityOverride"
    got         = data.aci_rest_managed.vzRsSubjFiltAtt.content.priorityOverride
    want        = "level1"
  }
}

data "aci_rest_managed" "vzRsSubjGraphAtt" {
  dn = "${data.aci_rest_managed.vzSubj.id}/rsSubjGraphAtt"

  depends_on = [module.main]
}

resource "test_assertions" "vzRsSubjGraphAtt" {
  component = "vzRsSubjGraphAtt"

  equal "tnVnsAbsGraphName" {
    description = "tnVnsAbsGraphName"
    got         = data.aci_rest_managed.vzRsSubjGraphAtt.content.tnVnsAbsGraphName
    want        = "SG1"
  }
}
