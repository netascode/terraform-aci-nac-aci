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
  source  = "netascode/error-disabled-recovery/aci"
  version = ">= 0.1.0"

  interval   = 600
  mcp_loop   = true
  ep_move    = true
  bpdu_guard = true
}
```
<!-- END_TF_DOCS -->