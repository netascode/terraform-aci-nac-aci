<!-- BEGIN_TF_DOCS -->
# Forwarding Scale Policy Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_forwarding_scale_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-forwarding-scale-policy"
  version = ">= 0.8.0"

  name    = "HIGH-DUAL-STACK"
  profile = "high-dual-stack"
}
```
<!-- END_TF_DOCS -->