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
  source  = "netascode/fabric-pod-policy-group/aci"
  version = ">= 0.1.1"

  name                     = "POD1"
  snmp_policy              = "SNMP1"
  date_time_policy         = "DATE1"
  management_access_policy = "MAP1"
}
```
<!-- END_TF_DOCS -->