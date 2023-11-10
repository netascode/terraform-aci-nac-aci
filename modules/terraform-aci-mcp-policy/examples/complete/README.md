<!-- BEGIN_TF_DOCS -->
# MCP Policy Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_mcp_policy" {
  source  = "netascode/mcp-policy/aci"
  version = ">= 0.1.0"

  name        = "MCP-OFF"
  admin_state = false
}
```
<!-- END_TF_DOCS -->