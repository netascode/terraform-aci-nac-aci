<!-- BEGIN_TF_DOCS -->
# vPC Policy Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_vpc_policy" {
  source  = "netascode/vpc-policy/aci"
  version = ">= 0.1.0"

  name               = "VPC1"
  peer_dead_interval = 300
}
```
<!-- END_TF_DOCS -->