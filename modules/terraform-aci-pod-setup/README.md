<!-- BEGIN_TF_DOCS -->
# Terraform ACI Pod Setup Module

Manages ACI Pod Setup

Location in GUI:
`Fabric` » `Inventory` » `Pod Fabric Setup Policy`

## Examples

```hcl
module "aci_pod_setup" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-pod-setup"
  version = ">= 0.8.0"

  pod_id   = 2
  tep_pool = "10.2.0.0/16"
  external_tep_pools = [
    {
      prefix                 = "172.16.18.0/24"
      reserved_address_count = 4
    },
    {
      prefix                 = "172.16.17.0/24"
      reserved_address_count = 2
    }
  ]
  remote_pools = [
    {
      id          = 1
      remote_pool = "10.191.200.0/24"
    },
    {
      id          = 2
      remote_pool = "10.191.202.0/24"
    }
  ]
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
| <a name="input_pod_id"></a> [pod\_id](#input\_pod\_id) | Pod ID. Minimum value: 1. Maximum value: 255. | `number` | n/a | yes |
| <a name="input_tep_pool"></a> [tep\_pool](#input\_tep\_pool) | TEP pool. | `string` | n/a | yes |
| <a name="input_external_tep_pools"></a> [external\_tep\_pools](#input\_external\_tep\_pools) | List of external TEP Pools | <pre>list(object({<br/>    prefix                 = string<br/>    reserved_address_count = number<br/>  }))</pre> | `[]` | no |
| <a name="input_remote_pools"></a> [remote\_pools](#input\_remote\_pools) | List of Remote Pools | <pre>list(object({<br/>    id          = number<br/>    remote_pool = string<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `fabricSetupP` object. |
| <a name="output_id"></a> [id](#output\_id) | Pod ID. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.fabricExtRoutablePodSubnet](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fabricExtSetupP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fabricSetupP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->