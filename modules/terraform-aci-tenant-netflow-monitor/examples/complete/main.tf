module "aci_tenant_netflow_monitor" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-tenant-netflow-monitor"
  version = ">= 0.9.0"

  name           = "MONITOR1"
  description    = "Netflow monitor 1"
  flow_record    = "RECORD1"
  flow_exporters = ["EXPORTER1", "EXPORTER2"]
}