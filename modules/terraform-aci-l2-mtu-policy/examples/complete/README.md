<!-- BEGIN_TF_DOCS -->
# L2 MTU Policy Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_l2_mtu_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-l2-mtu-policy"
  version = ">= 0.8.0"

  name          = "L2_8950"
  port_mtu_size = 8950
}
```
<!-- END_TF_DOCS -->