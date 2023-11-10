<!-- BEGIN_TF_DOCS -->
# Set Rule Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_set_rule" {
  source  = "netascode/set-rule/aci"
  version = ">= 0.1.0"

  tenant                      = "ABC"
  name                        = "SR1"
  description                 = "My Description"
  community                   = "no-export"
  community_mode              = "replace"
  dampening                   = true
  dampening_half_life         = 15
  dampening_max_suppress_time = 60
  dampening_reuse_limit       = 750
  dampening_suppress_limit    = 2000
  weight                      = 100
  next_hop                    = "1.1.1.1"
  metric                      = 1
  preference                  = 1
  metric_type                 = "ospf-type1"
  additional_communities = [
    {
      community   = "regular:as2-nn2:4:15"
      description = "My Community"
    }
  ]
  set_as_path          = true
  set_as_path_criteria = "prepend"
  set_as_path_count    = 0
  set_as_path_asn      = 65001
  set_as_path_order    = 5

  next_hop_propagation = true
  multipath            = true
}
```
<!-- END_TF_DOCS -->