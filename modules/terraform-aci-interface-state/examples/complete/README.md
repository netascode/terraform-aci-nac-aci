<!-- BEGIN_TF_DOCS -->
# Interface Type Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_interface_type" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-interface-state"
  version = ">= 0.8.0"

  pod_id   = 1
  node_id  = 101
  module   = 1
  port     = 1
  shutdown = false
 }
```
<!-- END_TF_DOCS -->