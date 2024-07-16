module "aci_macsec_keychain_policies" {
  source = "netascode/nac-aci/aci//modules/terraform-aci-macsec-keychain-policies"
  version = ">= 0.8.0"

  name                     = "macsec-keychain-pol"
  description              = "Keychain Description"
  key_policies = [{
    name = "keypolicy1"
    description = "Key Policy Description"
    keyName = "deadbeef9898765431"
    preSharedKey = "abcd1234abcd1234abcd1234abcd1234abcd1234abcd1234abcd1234abcd1234"
    startTime = "now"
    endTime = "infinite"
  }]
}