module "aci_copp_interface_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-copp-interface-policy"
  version = ">= 0.8.0"

  name        = "COPP1"
  description = "COPP1 Description"
  protocol_policies = [{
    name            = "COPP-PROTO1"
    rate            = "123"
    burst           = "1234"
    match_protocols = ["bgp", "ospf"]
  }]
}
