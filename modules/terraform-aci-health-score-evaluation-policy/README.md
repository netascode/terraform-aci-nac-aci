<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-health-score-evaluation-policy/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-health-score-evaluation-policy/actions/workflows/test.yml)

# Terraform ACI Health Score Evaluation Policy Module

Manages ACI Health Score Evaluation Policy

Location in GUI:
`Fabric` » `Fabric Policies` » `Policies` » `Monitoring` » `Common Policy` » `Health Score Evaluation Policies` » `Health Score Evaluation Policy`

## Examples

```hcl
module "aci_health_score_evaluation_policy" {
  source  = "netascode/health-score-evaluation-policy/aci"
  version = ">= 0.1.0"

  ignore_acked_faults = true
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 2.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aci"></a> [aci](#provider\_aci) | >= 2.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ignore_acked_faults"></a> [ignore\_acked\_faults](#input\_ignore\_acked\_faults) | Ignore acknowledged faults. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `healthEvalP` object. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.healthEvalP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->