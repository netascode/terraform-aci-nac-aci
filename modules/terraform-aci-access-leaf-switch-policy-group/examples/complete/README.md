<!-- BEGIN_TF_DOCS -->
# Access Leaf Switch Policy Group Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_access_leaf_switch_policy_group" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-access-leaf-switch-policy-group"
  version = ">= 0.8.0"

  name                    = "SW-PG1"
  forwarding_scale_policy = "HIGH-DUAL-STACK"
  bfd_ipv4_policy         = "BFD-IPV4-POLICY"
  bfd_ipv6_policy         = "BFD-IPV6-POLICY"
}
```
<!-- END_TF_DOCS -->