<!-- BEGIN_TF_DOCS -->
# Interface Configuration Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_interface_configuration" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-interface-configuration"
  version = ">= 0.8.0"

  node_id                    = 101
  policy_group               = "ACC1"
  description                = "Port description"
  port                       = 10
  port_channel_member_policy = "FAST"
}
```
<!-- END_TF_DOCS -->