module "aci_contract" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-contract"
  version = ">= 0.8.0"

  tenant      = "ABC"
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
    },
    {
      name                               = "SUB2"
      alias                              = "SUB2-ALIAS"
      description                        = "Subject Description"
      service_graph                      = "SG1"
      qos_class                          = "level5"
      target_dscp                        = "CS1"
      reverse_filter_ports               = false
      consumer_to_provider_service_graph = "SG1"
      consumer_to_provider_qos           = "level5"
      consumer_to_provider_dscp          = "CS1"
      consumer_to_provider_filters = [{
        filter   = "FILTER1"
        action   = "deny"
        priority = "level1"
        log      = true
        no_stats = true
      }]
      provider_to_consumer_service_graph = "SG1"
      provider_to_consumer_qos           = "level5"
      provider_to_consumer_dscp          = "CS1"
      provider_to_consumer_filters = [{
        filter   = "FILTER1"
        action   = "deny"
        priority = "level1"
        log      = true
        no_stats = true
      }]
  }]
}
