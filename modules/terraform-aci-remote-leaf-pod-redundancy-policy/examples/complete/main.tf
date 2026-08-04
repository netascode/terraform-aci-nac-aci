module "aci_remote_leaf_pod_redundancy_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-remote-leaf-pod-redundancy-policy"
  version = "> 2.0.0"

  enable_policy = true
  preemption    = true
}
