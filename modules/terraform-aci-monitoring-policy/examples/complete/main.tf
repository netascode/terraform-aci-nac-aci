module "aci_monitoring_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-monitoring-policy"
  version = ">= 0.8.0"

  snmp_trap_policies = [{
    name              = "SYSLOG1"
    destination_group = "SNMP_DEST_GROUP1"
  }]
  syslog_policies = [{
    name              = "SYSLOG1"
    audit             = false
    events            = false
    faults            = false
    session           = true
    minimum_severity  = "alerts"
    destination_group = "SYSLOG_DEST_GROUP1"
  }]
}
