module "aci_macsec_interfaces_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-macsec-interfaces-policy"
  version = ">= 0.9.2"

  name                     = "macsec-int-pol"
  admin_state              = true
  macsec_parameters_policy = "macsec-parameter-policy"
  macsec_keychain_policy   = "macsec-keychain-policy"
}
