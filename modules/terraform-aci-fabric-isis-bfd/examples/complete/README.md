<!-- BEGIN_TF_DOCS -->
# Fabric ISIS BFD Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_fabric_isis_bfd" {
  source  = "netascode/fabric-isis-bfd/aci"
  version = ">= 0.1.0"

  admin_state = true
}
```
<!-- END_TF_DOCS -->