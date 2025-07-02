module "aci_tenant_monitoring_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-tenant-monitoring-policy"
  version = ">= 0.8.0"

  name               = "MON1"
  snmp_trap_policies = ["SNMP1"]
  syslog_policies = [{
    name             = "SYSLOG1"
    audit            = false
    events           = false
    faults           = false
    session          = true
    minimum_severity = "alerts"
  }]
}
