<!-- BEGIN_TF_DOCS -->
# Node Registration Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_node_registration" {
  source  = "netascode/node-registration/aci"
  version = ">= 0.1.1"

  name           = "LEAF105"
  node_id        = 105
  pod_id         = 2
  serial_number  = "ABCDEFGHIJKLMN"
  type           = "remote-leaf-wan"
  remote_pool_id = 2
}
```
<!-- END_TF_DOCS -->