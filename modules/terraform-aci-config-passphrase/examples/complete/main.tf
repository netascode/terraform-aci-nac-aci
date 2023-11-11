module "aci_config_passphrase" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-config-passphrase"
  version = ">= 0.8.0"

  config_passphrase = "Cisco123!Cisco123!"
}
