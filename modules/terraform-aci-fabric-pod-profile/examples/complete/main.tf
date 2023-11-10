module "aci_fabric_pod_profile" {
  source  = "netascode/fabric-pod-profile/aci"
  version = ">= 0.2.0"

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
