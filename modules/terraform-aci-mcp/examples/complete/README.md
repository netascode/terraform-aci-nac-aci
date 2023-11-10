<!-- BEGIN_TF_DOCS -->
# MCP Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_mcp" {
  source  = "netascode/mcp/aci"
  version = ">= 0.1.0"

  admin_state         = true
  per_vlan            = true
  initial_delay       = 200
  key                 = "$ECRETKEY1"
  loop_detection      = 5
  disable_port_action = true
  frequency_sec       = 0
  frequency_msec      = 100
}
```
<!-- END_TF_DOCS -->