module "aci_external_endpoint_group" {
  source  = "netascode/external-endpoint-group/aci"
  version = ">= 0.2.1"

  tenant          = "ABC"
  l3out           = "L3OUT1"
  name            = "EXTEPG1"
  alias           = "EXTEPG1-ALIAS"
  description     = "My Description"
  preferred_group = true
  qos_class       = "level2"
  target_dscp     = "CS2"
  subnets = [{
    name                           = "SUBNET1"
    prefix                         = "10.0.0.0/8"
    import_route_control           = true
    export_route_control           = true
    shared_route_control           = true
    import_security                = true
    shared_security                = true
    aggregate_import_route_control = true
    aggregate_export_route_control = true
    aggregate_shared_route_control = true
    bgp_route_summarization        = true
  }]
  contract_consumers          = ["CON1"]
  contract_providers          = ["CON1"]
  contract_imported_consumers = ["ICON1"]
}
