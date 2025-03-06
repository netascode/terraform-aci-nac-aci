module "aci_netflow_exporter" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-netflow-exporter"
  version = ">= 0.9.0"

  name                = "EXPORTER1"
  description         = "Netflow exporter 1"
  source_type         = "custom-src-ip"
  source_ip           = "172.16.0.0/20"
  destination_port    = "1234"
  destination_ip      = "10.1.1.1"
  dscp                = "AF12"
  epg_type            = "epg"
  tenant              = "ABC"
  application_profile = "AP1"
  endpoint_group      = "EPG1"
  vrf                 = "VRF1"
}