module "aci_remote_leaf_pod_redundancy_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-remote-leaf-pod-redundancy-policy"
  version = ">= 0.8.0"

  enable_remote_leaf_policy = true
  enable_preemption         = true
}
