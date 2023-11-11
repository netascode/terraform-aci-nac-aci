module "aci_fabric_scheduler" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-fabric-scheduler"
  version = ">= 0.8.0"

  name        = "SCHED1"
  description = "My Description"
  recurring_windows = [{
    name   = "EVEN-DAY"
    day    = "even-day"
    hour   = 2
    minute = 10
  }]
}
