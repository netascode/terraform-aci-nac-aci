module "aci_fabric_scheduler" {
  source  = "netascode/fabric-scheduler/aci"
  version = ">= 0.2.0"

  name        = "SCHED1"
  description = "My Description"
  recurring_windows = [{
    name   = "EVEN-DAY"
    day    = "even-day"
    hour   = 2
    minute = 10
  }]
}
