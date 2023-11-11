<!-- BEGIN_TF_DOCS -->
# LLDP Policy Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_lldp_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-lldp-policy"
  version = ">= 0.8.0"

  name           = "LLDP-ON"
  admin_rx_state = true
  admin_tx_state = true
}
```
<!-- END_TF_DOCS -->