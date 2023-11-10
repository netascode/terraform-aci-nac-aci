module "aci_oob_contract" {
  source  = "netascode/oob-contract/aci"
  version = ">= 0.2.0"

  name        = "OOB1"
  alias       = "OOB1-ALIAS"
  description = "My Description"
  scope       = "global"
  subjects = [{
    name        = "SUB1"
    alias       = "SUB1-ALIAS"
    description = "Subject Description"
    filters = [{
      filter = "FILTER1"
    }]
  }]
}
