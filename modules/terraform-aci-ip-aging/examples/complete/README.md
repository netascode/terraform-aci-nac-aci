<!-- BEGIN_TF_DOCS -->
# IP Aging Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_ip_aging" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-ip-aging"
  version = ">= 0.8.0"

  admin_state = true
}
```
<!-- END_TF_DOCS -->