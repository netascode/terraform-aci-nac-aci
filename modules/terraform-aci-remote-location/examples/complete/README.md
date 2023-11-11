<!-- BEGIN_TF_DOCS -->
# Remote Location Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_remote_location" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-remote-location"
  version = ">= 0.8.0"

  name          = "RL1"
  description   = "My Description"
  hostname_ip   = "1.1.1.1"
  auth_type     = "password"
  protocol      = "ftp"
  path          = "/"
  port          = 21
  username      = "user1"
  password      = "password"
  mgmt_epg_type = "oob"
  mgmt_epg_name = "OOB1"
}
```
<!-- END_TF_DOCS -->