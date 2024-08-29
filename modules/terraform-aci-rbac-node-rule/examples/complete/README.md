<!-- BEGIN_TF_DOCS -->
# RBAC Node Rule Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

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
<!-- END_TF_DOCS -->