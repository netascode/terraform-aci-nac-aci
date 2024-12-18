<!-- BEGIN_TF_DOCS -->
# Contract Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_contract" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-contract"
  version = ">= 0.8.0"

  tenant      = "ABC"
  name        = "CON1"
  alias       = "CON1-ALIAS"
  description = "My Description"
  scope       = "global"
  qos_class   = "level4"
  target_dscp = "CS0"
  subjects = [{
    name          = "SUB1"
    alias         = "SUB1-ALIAS"
    description   = "Subject Description"
    service_graph = "SG1"
    qos_class     = "level5"
    target_dscp   = "CS1"
    filters = [{
      filter   = "FILTER1"
      action   = "deny"
      priority = "level1"
      log      = true
      no_stats = true
    }]
    consumer_label_match = "AtleastOne"
    provider_label_match = "AtleastOne"
    consumer_labels = [{
      name          = "Label01"
      tag           = "blue"
      is_complement = false
    }]
    provider_labels = [{
      name          = "Label02"
      tag           = "green"
      is_complement = false
    }]
  }]
}
```
<!-- END_TF_DOCS -->