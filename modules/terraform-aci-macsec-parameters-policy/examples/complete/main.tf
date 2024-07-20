module "aci_macsec_parameters_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-macsec-parameters-policy"
  version = ">= 0.8.0"

  name                   = "macsecparam1"
  description            = "macsecparam1 description"
  admin_state            = true
  confidentiality_offset = "offset-30"
  key_server_priority    = 128
  cipher_suite           = "gcm-aes-128"
  window_size            = 1024
  key_expiry_time        = 120
  security_policy        = "must-secure"
}