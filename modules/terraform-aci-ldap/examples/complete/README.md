<!-- BEGIN_TF_DOCS -->
# LDAP Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_ldap" {
  source  = "netascode/ldap/aci"
  version = ">= 0.1.0"

  ldap_providers = [{
    hostname_ip          = "1.1.1.1"
    description          = "My Description"
    port                 = 149
    bind_dn              = "CN=testuser,OU=Employees,OU=Cisco users,DC=cisco,DC=com"
    base_dn              = "OU=Employees,OU=Cisco users,DC=cisco,DC=com"
    password             = "ABCDEFGH"
    timeout              = 10
    retries              = 3
    enable_ssl           = true
    filter               = "cn=$userid"
    attribute            = "memberOf"
    ssl_validation_level = "permissive"
    mgmt_epg_type        = "oob"
    mgmt_epg_name        = "OOB1"
    monitoring           = true
    monitoring_username  = "USER1"
    monitoring_password  = "PASSWORD1"
  }]
  group_map_rules = [{
    name        = "test-users-rules"
    description = "description"
    group_dn    = "CN=test-users,OU=Cisco groups,DC=cisco,DC=com"
    security_domains = [{
      name = "all"
      roles = [{
        name           = "admin"
        privilege_type = "read"
      }]
    }]
  }]
  group_maps = [{
    name  = "test-users-map"
    rules = ["test-users-rules"]
  }]
}
```
<!-- END_TF_DOCS -->