module "aci_spanning_tree_policy" {
  source  = "netascode/spanning-tree-policy/aci"
  version = ">= 0.1.0"

  name        = "STP1"
  bpdu_filter = true
  bpdu_guard  = true
}
