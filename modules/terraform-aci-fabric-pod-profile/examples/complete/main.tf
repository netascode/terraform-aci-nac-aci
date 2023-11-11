module "aci_fabric_pod_profile" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-fabric-pod-profile"
  version = ">= 0.8.0"

  name = "POD1-2"
  selectors = [{
    name         = "SEL1"
    policy_group = "POD1-2"
    pod_blocks = [{
      name = "PB1"
      from = 1
      to   = 2
    }]
  }]
}
