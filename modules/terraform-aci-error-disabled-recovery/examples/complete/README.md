<!-- BEGIN_TF_DOCS -->
# Error Disabled Recovery Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_error_disabled_recovery" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-error-disabled-recovery"
  version = ">= 0.8.0"

  interval   = 600
  mcp_loop   = true
  ep_move    = true
  bpdu_guard = true
}
```
<!-- END_TF_DOCS -->