# Overview

## Translating the ACI object model to AAC

So called [mapping files](https://wwwin-github.cisco.com/netascode/aac-tool/tree/master/aac_tool/mappings/aac) are used to specify how data from the ACI object model maps to the AAC data model. Mappings are specified using YAML files and look like this:

```yaml
---
files:
  - name: access_policies.yaml
    elements:
      - name: apic
        type: dict
        elements:
          - name: access_policies
            type: dict
            elements:
              - name: infra_vlan
                class: infraRsFuncToEpg
                type: int
                attribute: encap
                attribute_match_regex: '(?<=vlan-).*'
```

The root element is `files` which is a list of YAML files to be created. Each file then has a list of elements describing the structure of the YAML data and how data from the ACI object model is mapped.
