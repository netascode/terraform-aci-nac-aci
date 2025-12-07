module "aci_monitoring_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-monitoring-policy"
  version = ">= 1.3.0"

  snmp_trap_policies = [{
    name       = "SNMP1"
    dest_group = "SNMP1"
  }]
  syslog_policies = [{
    name             = "SYSLOG1"
    dest_group       = "SYSLOG1"
    audit            = false
    events           = false
    faults           = false
    session          = true
    minimum_severity = "alerts"
  }]
}
