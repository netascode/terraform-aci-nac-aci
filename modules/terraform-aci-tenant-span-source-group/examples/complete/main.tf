module "aci_tenant_span_source_group" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-tenant-span-source-group"
  version = ">= 0.8.0"

  name        = "SPAN1"
  tenant      = "ABC"
  description = "My Test Tenant Span Source Group"
  admin_state = false
  sources = [
    {
      name                = "SRC1"
      description         = "Source1"
      direction           = "both"
      endpoint_group      = "EPG1"
      application_profile = "AP1"
    }
  ]
  destination = "DESTINATION1"
}
