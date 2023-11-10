module "aci_fabric_pod_policy_group" {
  source  = "netascode/fabric-pod-policy-group/aci"
  version = ">= 0.1.1"

  name                     = "POD1"
  snmp_policy              = "SNMP1"
  date_time_policy         = "DATE1"
  management_access_policy = "MAP1"
}
