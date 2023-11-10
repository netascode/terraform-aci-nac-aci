<!-- BEGIN_TF_DOCS -->
# MST Policy Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_mst_policy" {
  source  = "netascode/mst-policy/aci"
  version = ">= 0.2.0"

  name     = "MST1"
  region   = "REG1"
  revision = 1
  instances = [{
    name = "INST1"
    id   = 1
    vlan_ranges = [{
      from = 10
      to   = 20
    }]
  }]
}
```
<!-- END_TF_DOCS -->