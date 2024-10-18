module "aci_netflow_vmm_exporter" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-netflow-vmm-exporter"
  version = ">= 0.9.0"

  name             = "EXPORTER1"
  description      = "Netflow exporter 1"
  source_ip        = "172.16.0.0/20"
  destination_port = "1234"
  destination_ip   = "10.1.1.1"
}