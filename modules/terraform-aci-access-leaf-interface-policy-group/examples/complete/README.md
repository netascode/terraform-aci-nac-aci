<!-- BEGIN_TF_DOCS -->
# Access Leaf Interface Policy Group Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_access_leaf_interface_policy_group" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-access-leaf-interface-policy-group"
  version = ">= 0.8.0"

  name                       = "VPC1"
  description                = "VPC Interface Policy Group 1"
  type                       = "vpc"
  link_level_policy          = "10G"
  cdp_policy                 = "CDP-ON"
  lldp_policy                = "LLDP-OFF"
  macsec_interface_policy    = "MACSEC-ON"
  spanning_tree_policy       = "BPDU-GUARD"
  mcp_policy                 = "MCP-ON"
  l2_policy                  = "PORT-LOCAL"
  storm_control_policy       = "10P"
  port_channel_policy        = "LACP"
  port_channel_member_policy = "FAST"
  aaep                       = "AAEP1"
}
```
<!-- END_TF_DOCS -->