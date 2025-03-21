module "aci_macsec_keychain_policies" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-macsec-keychain-policies"
  version = ">= 0.9.2"

  name        = "macsec-keychain-pol"
  description = "Keychain Description"
  key_policies = [{
    name           = "keypolicy1"
    description    = "Key Policy Description"
    key_name       = "deadbeef9898765431"
    pre_shared_key = "abcd1234abcd1234abcd1234abcd1234abcd1234abcd1234abcd1234abcd1234"
    start_time     = "now"
    end_time       = "infinite"
  }]
}