module "aci_fabric_pod_policy_group" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-fabric-pod-policy-group"
  version = ">= 0.8.0"

  name                     = "POD1"
  snmp_policy              = "SNMP1"
  date_time_policy         = "DATE1"
  management_access_policy = "MAP1"
}
