<!-- BEGIN_TF_DOCS -->
# QoS Custom Policy Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_qos_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-qos-policy"
  version = ">= 0.8.0"

  name        = "ABC"
  tenant      = "TEN1"
  description = "My Custom Policy"
  alias       = "MyAlias"
  dscp_priority_maps = [
    {
      dscp_from   = "AF12"
      dscp_to     = "AF13"
      priority    = "level5"
      dscp_target = "CS0"
      cos_target  = 5
    }
  ]
  dot1p_classifiers = [
    {
      dot1p_from  = 3
      dot1p_to    = 4
      priority    = "level5"
      dscp_target = "CS0"
      cos_target  = 5
    }
  ]
}
```
<!-- END_TF_DOCS -->