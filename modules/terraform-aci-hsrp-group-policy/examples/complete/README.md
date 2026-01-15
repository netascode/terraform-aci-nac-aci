<!-- BEGIN_TF_DOCS -->
# HSRP Group Policy Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_hsrp_group_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-hsrp-group-policy"
  version = ">= 0.8.0"

  tenant               = "ABC"
  name                 = "HSRP_GRP1"
  description          = "My Description"
  preempt              = true
  hello_interval       = 3000
  hold_interval        = 10000
  priority             = 110
  hsrp_type            = "md5"
  key                  = "SecureKey123"
  preempt_delay_min    = 60
  preempt_delay_reload = 300
  preempt_delay_sync   = 60
  timeout              = 90
}
```
<!-- END_TF_DOCS -->