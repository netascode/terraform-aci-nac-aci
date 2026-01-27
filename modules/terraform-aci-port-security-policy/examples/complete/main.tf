module "aci_port_security_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-port-security-policy"
  version = ">= 0.8.0"

  name        = "PORT_SEC_10"
  description = "Port security with max 10 endpoints"
  maximum     = 10
  timeout     = 300
}
