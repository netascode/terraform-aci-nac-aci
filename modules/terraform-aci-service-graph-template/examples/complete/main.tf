module "aci_service_graph_template" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-service-graph-template"
  version = ">= 0.8.0"

  tenant                  = "ABC"
  name                    = "SGT1"
  alias                   = "SGT1-ALIAS"
  description             = "My Description"
  template_type           = "FW_ROUTED"
  redirect                = true
  share_encapsulation     = true
  device_name             = "DEV1"
  device_tenant           = "DEF"
  device_function         = "GoThrough"
  device_copy             = false
  device_managed          = false
  consumer_direct_connect = false
  provider_direct_connect = true
}
