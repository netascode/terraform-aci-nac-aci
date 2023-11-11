module "aci_pod_setup" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-pod-setup"
  version = ">= 0.8.0"

  pod_id   = 2
  tep_pool = "10.2.0.0/16"
  external_tep_pools = [
    {
      prefix                 = "172.16.18.0/24"
      reserved_address_count = 4
    },
    {
      prefix                 = "172.16.17.0/24"
      reserved_address_count = 2
    }
  ]
  remote_pools = [
    {
      id          = 1
      remote_pool = "10.191.200.0/24"
    },
    {
      id          = 2
      remote_pool = "10.191.202.0/24"
    }
  ]
}
