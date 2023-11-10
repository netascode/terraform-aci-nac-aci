module "aci_config_passphrase" {
  source  = "netascode/config-passphrase/aci"
  version = ">= 0.1.0"

  config_passphrase = "Cisco123!Cisco123!"
}
