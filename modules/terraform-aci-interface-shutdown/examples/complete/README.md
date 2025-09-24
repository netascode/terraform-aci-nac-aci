<!-- BEGIN_TF_DOCS -->
# Interface Shutdown Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_interface_shutdown" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-interface-shutdown"
  version = ">= 0.9.2"

  pod_id  = 1
  node_id = 101
  module  = 1
  port    = 1
}
```
<!-- END_TF_DOCS -->