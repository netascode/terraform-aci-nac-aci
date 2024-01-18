<!-- BEGIN_TF_DOCS -->
# Fabric Interface Configuration Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_fabric_interface_configuration" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-fabric-interface-configuration"
  version = ">= 0.8.0"

  node_id      = 101
  policy_group = "FAB1"
  description  = "Port description"
  port         = 49
}
```
<!-- END_TF_DOCS -->