module "aci_node_registration" {
  source  = "netascode/node-registration/aci"
  version = ">= 0.1.1"

  name           = "LEAF105"
  node_id        = 105
  pod_id         = 2
  serial_number  = "ABCDEFGHIJKLMN"
  type           = "remote-leaf-wan"
  remote_pool_id = 2
}
