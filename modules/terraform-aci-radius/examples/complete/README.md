<!-- BEGIN_TF_DOCS -->
# RADIUS Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_radius" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-radius"
  version = ">= 0.8.1"

  hostname_ip         = "1.1.1.1"
  description         = "My Description"
  protocol            = "chap"
  monitoring          = true
  monitoring_username = "USER1"
  monitoring_password = "PASSWORD1"
  key                 = "ABCDEFGH"
  port                = 1812
  retries             = 3
  timeout             = 10
  mgmt_epg_type       = "oob"
  mgmt_epg_name       = "OOB1"
}
```
<!-- END_TF_DOCS -->