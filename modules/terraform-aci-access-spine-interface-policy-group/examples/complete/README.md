<!-- BEGIN_TF_DOCS -->
# Access Spine Interface Policy Group Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_access_spine_interface_policy_group" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-access-spine-interface-policy-group"
  version = ">= 0.8.0"

  name              = "IPN"
  link_level_policy = "100G"
  cdp_policy        = "CDP-ON"
  aaep              = "AAEP1"
}
```
<!-- END_TF_DOCS -->