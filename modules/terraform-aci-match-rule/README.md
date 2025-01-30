<!-- BEGIN_TF_DOCS -->
# Terraform ACI Match Rule Module

Manages ACI Match Rule

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `Match Rules`

## Examples

```hcl
module "aci_match_rule" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-match-rule"
  version = ">= 0.8.0"

  tenant      = "ABC"
  name        = "MR1"
  description = "My Description"
  regex_community_terms = [{
    name        = "REGEX1"
    regex       = "1234"
    type        = "extended"
    description = "REGEX1 description"
  }]
  community_terms = [{
    name        = "COM1"
    description = "COM1 description"
    factors = [{
      community   = "regular:as2-nn2:1:2345"
      description = "2345 description"
      scope       = "non-transitive"
    }]
  }]
  prefixes = [{
    ip          = "10.1.1.0"
    description = "Prefix Description"
    aggregate   = true
    from_length = 25
    to_length   = 32
  }]
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 2.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aci"></a> [aci](#provider\_aci) | >= 2.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_tenant"></a> [tenant](#input\_tenant) | Match rule tenant. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Match rule name. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Description. | `string` | `""` | no |
| <a name="input_regex_community_terms"></a> [regex\_community\_terms](#input\_regex\_community\_terms) | List of regex community terms. Default value `type`: `regular`. Allowed values `type`: `regular`, `extended`. | <pre>list(object({<br/>    name        = string<br/>    regex       = string<br/>    type        = optional(string, "regular")<br/>    description = optional(string, "")<br/>  }))</pre> | `[]` | no |
| <a name="input_community_terms"></a> [community\_terms](#input\_community\_terms) | List of community terms. Default value `scope`: `transitive`. Allowed values `scope`: `transitive`, `non-transitive`. | <pre>list(object({<br/>    name        = string<br/>    description = optional(string, "")<br/>    factors = optional(list(object({<br/>      community   = string<br/>      description = optional(string, "")<br/>      scope       = optional(string, "transitive")<br/>    })), [])<br/>  }))</pre> | `[]` | no |
| <a name="input_prefixes"></a> [prefixes](#input\_prefixes) | List of prefixes. Default value `aggregate`: false. Allowed values `from_length`: 0-128. Allowed values `to_length`: 0-128. | <pre>list(object({<br/>    ip          = string<br/>    description = optional(string, "")<br/>    aggregate   = optional(bool, false)<br/>    from_length = optional(number, 0)<br/>    to_length   = optional(number, 0)<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `rtctrlSubjP` object. |
| <a name="output_name"></a> [name](#output\_name) | Match rule name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.rtctrlMatchCommFactor](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.rtctrlMatchCommRegexTerm](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.rtctrlMatchCommTerm](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.rtctrlMatchRtDest](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.rtctrlSubjP](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->