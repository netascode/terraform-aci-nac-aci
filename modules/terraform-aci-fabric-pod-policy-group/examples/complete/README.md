<!-- BEGIN_TF_DOCS -->
# Fabric Pod Policy Group Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_fabric_pod_policy_group" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-fabric-pod-policy-group"
  version = ">= 0.8.0"

  name                     = "POD1"
  description              = "DESCRIPTION"
  snmp_policy              = "SNMP1"
  date_time_policy         = "DATE1"
  management_access_policy = "MAP1"
  route_reflector_policy   = "RR1"
  coop_group_policy        = "COOP1"
  isis_policy              = "ISIS1"
  macsec_policy            = "MACSEC1"

}
```
<!-- END_TF_DOCS -->