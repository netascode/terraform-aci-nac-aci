module "aci_endpoint_security_group" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-endpoint-security-group"
  version = ">= 0.8.0"

  name                        = "ESG1"
  description                 = "My Description"
  tenant                      = "ABC"
  application_profile         = "AP1"
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
  ip_external_subnet_selectors = [
    {
      ip = "1.1.1.0/24"
    },
    {
      ip = "1.1.2.0/24"
    },
    {
      ip = "1.1.3.0/24"
    },
    {
      ip       = "1.1.4.0/24"
      description = "foo"
      shared      = true
    }
  ]
}
