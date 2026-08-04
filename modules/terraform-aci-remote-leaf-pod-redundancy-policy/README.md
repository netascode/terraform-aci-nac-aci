<!-- BEGIN_TF_DOCS -->
# Terraform ACI Remote Leaf Pod Redundancy Policy Module

Manages ACI Remote Leaf Pod Redundancy Policy

Location in GUI:
`System` » `System Settings` » `Remote Leaf POD Redundancy`

## Examples

```hcl
module "aci_remote_leaf_pod_redundancy_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-remote-leaf-pod-redundancy-policy"
  version = "> 2.0.0"

  enable_policy = true
  preemption    = true
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
| <a name="input_enable_policy"></a> [enable\_policy](#input\_enable\_policy) | Enable Remote Leaf Pod Redundancy Policy. | `bool` | `false` | no |
| <a name="input_preemption"></a> [preemption](#input\_preemption) | Enable Pod Redundancy Preemption. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `infraRlPodRedPol` object. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.infraRlPodRedPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->