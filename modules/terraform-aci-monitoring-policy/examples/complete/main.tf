module "aci_monitoring_policy" {
  source  = "netascode/nac-aci/aci/modules/terraform-aci-monitoring-policy"
  version = "> 1.2.0"

  snmp_trap_policies = [{
    name              = "SNMP1"
    destination_group = "DST1"
  }]
  syslog_policies = [{
    name              = "SYSLOG1"
    audit             = false
    events            = false
    faults            = false
    session           = true
    minimum_severity  = "alerts"
    destination_group = "DST1"
  }]
}
