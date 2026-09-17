<!-- BEGIN_TF_DOCS -->
# IP Address Pool Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_ip_address_pool" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-ip-address-pool"
  version = "> 2.0.0"

  name                    = "POOL_1"
  tenant                  = "mgmt"
  description             = "My Description"
  gateway_address         = "10.0.1.1/24"
  skip_gateway_validation = true
  address_ranges = [{
    from = "10.1.2.10"
    to   = "10.1.2.20"
  }]
}
```
<!-- END_TF_DOCS -->