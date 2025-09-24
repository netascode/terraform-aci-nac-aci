module "aci_tenant_monitoring_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-tenant-monitoring-policy"
  version = "> 1.0.1"

  name = "MON1"
  snmp_trap_policies = [{
    name              = "SNMP1"
    destination_group = "DEST1"
  }]
  syslog_policies = [{
    name             = "SYSLOG1"
    audit            = false
    events           = false
    faults           = false
    session          = true
    minimum_severity = "alerts"
  }]
  fault_severity_policies = [{
    class = "vzRsSubjFiltAtt"
    faults = [{
      fault_id         = "F1127"
      initial_severity = "warning"
      target_severity  = "inherit"
      description      = "test"
    }]
  }]
}
