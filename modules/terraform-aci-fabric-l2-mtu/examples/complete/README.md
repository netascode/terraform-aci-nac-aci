<!-- BEGIN_TF_DOCS -->
# Fabric L2 MTU Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_fabric_l2_mtu" {
  source  = "netascode/fabric-l2-mtu/aci"
  version = ">= 0.1.0"

  l2_port_mtu = 9216
}
```
<!-- END_TF_DOCS -->