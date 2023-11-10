<!-- BEGIN_TF_DOCS -->
# ACI Health Score Evaluation Policy Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_health_score_evaluation_policy" {
  source  = "netascode/health-score-evaluation-policy/aci"
  version = ">= 0.1.0"

  ignore_acked_faults = true
}
```
<!-- END_TF_DOCS -->