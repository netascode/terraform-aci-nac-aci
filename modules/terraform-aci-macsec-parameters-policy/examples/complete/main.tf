module "aci_macsec_parameters_policy" {
  source = "netascode/nac-aci/aci//modules/terraform-aci-macsec-parameters-policy"
  version = ">= 0.8.0"

  name          = "macsecparam1"
  descr         = "macsecparam1 description"
  admin_state   = true
  confOffset    = "offset-30"
  keySvrPrio    = 128
  cipherSuite   = "gcm-aes-128"
  replayWindow  = 1024
  sakExpiryTime = 120
  secPolicy     = "must-secure"
}