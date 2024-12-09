<!-- BEGIN_TF_DOCS -->
# Access Leaf CoPP Policy Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_access_leaf_copp_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-access-leaf-copp-policy"
  version = ">= 0.8.0"

  name        = "POL1"
  description = "POL1"
  type        = "custom"
  custom_values = {
    arp_rate      = 1234
    arp_burst     = 300
    acl_log_rate  = 150
    acl_log_burst = 300
  }
}
```
<!-- END_TF_DOCS -->