module "aci_access_monitoring_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-access-monitoring-policy"
  version = "> 1.0.1"

  name = "test_mon_pol"
  snmp_trap_policies = [{
    name              = "test_trap"
    destination_group = "DAR"
  }]
  syslog_policies = [{
    name              = "test_syslog"
    audit             = false
    events            = false
    faults            = true
    session           = false
    minimum_severity  = "alerts"
    destination_group = "syslog_grp"
  }]
  fault_severity_policies = [{
    class = "l1PhysIf"
    faults = [{
      fault_id         = "F1696"
      initial_severity = "warning"
      target_severity  = "inherit"
      description      = "test"
    }]
  }]
}
