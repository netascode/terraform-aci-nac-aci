<!-- BEGIN_TF_DOCS -->
# Port Channel Member Policy Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_port_channel_member_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-port-channel-member-policy"
  version = ">= 0.8.0"

  name     = "FAST"
  priority = 10
  rate     = "fast"
}
```
<!-- END_TF_DOCS -->