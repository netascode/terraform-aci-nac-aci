<!-- BEGIN_TF_DOCS -->
# Node Control Policy Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_node_control_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-node-control-policy"
  version = ">= 0.8.0"

  name      = "NC1"
  dom       = true
  telemetry = "netflow"
}
```
<!-- END_TF_DOCS -->