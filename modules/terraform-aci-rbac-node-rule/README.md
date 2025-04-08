<!-- BEGIN_TF_DOCS -->
# Terraform ACI RBAC Node Rule Module

Manages ACI RBAC Node Rule

Location in GUI:
`Admin` » `AAA` » `Security` » `RBAC Rules` » `Node Rules`

## Examples

```hcl
module "aci_rbac_node_rule" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-rbac-node-rule"
  version = ">= 0.9.1"

  node_id = 101
  port_rules = [{
    name   = "SEC1"
    domain = "SEC1"
  }]
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 2.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aci"></a> [aci](#provider\_aci) | >= 2.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_node_id"></a> [node\_id](#input\_node\_id) | Node ID. Minimum value: 101. Maximum value: 4000. | `number` | n/a | yes |
| <a name="input_port_rules"></a> [port\_rules](#input\_port\_rules) | List of RBAC Port Rules for Node. | <pre>list(object({<br/>    name   = string<br/>    domain = string<br/>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `aaaRbacNodeRule` object. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.aaaRbacNodeRule](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.aaaRbacPortRule](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->