<!-- BEGIN_TF_DOCS -->
# VSPAN Session Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_access_vspan_session" {
  source  = "netascode/vspan-session/aci"
  version = ">= 0.1.0"

  name                    = "SESSION1"
  description             = "VSPAN Session 1"
  admin_state             = true
  destination_name        = "DST_GRP1"
  destination_description = "Destination Group 1"
  sources = [
    {
      description         = "Source 1"
      name                = "SRC1"
      direction           = "both"
      tenant              = "TENANT-1"
      application_profile = "AP1"
      endpoint_group      = "EGP1"
      endpoint            = "00:50:56:96:6B:4F"
      access_paths = [
        {
          node_id = 101
          port    = 3
        },
        {
          node_id = 101
          port    = 1
        }
      ]
    },
    {
      description         = "Source 2"
      name                = "SRC2"
      direction           = "in"
      tenant              = "TENANT-2"
      application_profile = "AP1"
      endpoint_group      = "EGP1"
      access_paths = [
        {
          node_id = 101
          port    = 1
        },
        {
          node_id  = 101
          node2_id = 102
          channel  = VPC1
        },
        {
          node_id = 101
          channel = PC1
        }
      ]
    }
  ]
}
```
<!-- END_TF_DOCS -->