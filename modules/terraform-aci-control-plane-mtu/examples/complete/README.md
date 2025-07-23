<!-- BEGIN_TF_DOCS -->
# Control Plane MTU Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_control_plane_mtu" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-control-plane-mtu"
  version = ">= 0.8.0"

  CPMtu        = 9000
  APICMtuApply = true
}
```
<!-- END_TF_DOCS -->