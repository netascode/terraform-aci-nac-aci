<!-- BEGIN_TF_DOCS -->
# Scaffolding Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_redirect_backup_policy" {
  source  = "netascode/redirect-backup-policy/aci"
  version = ">= 0.1.0"

  tenant      = "ABC"
  name        = "REDIRECT1"
  description = "My Description"
  l3_destinations = [{
    name                  = "DEST1"
    description           = "L3 description"
    ip                    = "1.1.1.1"
    ip_2                  = "1.1.1.2"
    mac                   = "00:01:02:03:04:05"
    redirect_health_group = "HEALTH_GRP1"
  }]
}
```
<!-- END_TF_DOCS -->