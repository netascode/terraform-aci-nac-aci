<!-- BEGIN_TF_DOCS -->
# vPC Group Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_vpc_group" {
  source  = "netascode/vpc-group/aci"
  version = ">= 0.2.0"

  mode = "explicit"
  groups = [{
    name     = "VPC101"
    id       = 101
    policy   = "VPC1"
    switch_1 = 101
    switch_2 = 102
  }]
}
```
<!-- END_TF_DOCS -->