module "aci_tenant_netflow_record" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-tenant-netflow-record"
  version = ">= 0.9.0"

  name             = "RECORD1"
  description      = "Netflow record 1"
  match_parameters = ["dst-ip", "src-ip"]
}