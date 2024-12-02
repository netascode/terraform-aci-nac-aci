*** Settings ***
Documentation   Verify Fabric SR MPLS Global Configuration
Suite Setup     Login APIC
Default Tags    apic   day0   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% if apic.fabric_policies.sr_mpls_global_configuration is defined %}
{% set smgc = apic.fabric_policies.sr_mpls_global_configuration %}

Verify Fabric SR MPLS Global Configuration
    ${r}=   GET On Session   apic   /api/node/mo/uni/tn-infra/mplslabelpol-default/mplssrgblabelpol-1.json
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}    $..mplsSrgbLabelPol.attributes.minSrgbLabel   {{ smgc.sr_global_block_minimum | default(defaults.apic.fabric_policies.sr_mpls_global_configuration.sr_global_block_minimum) }}
    Should Be Equal Value Json String   ${r.json()}    $..mplsSrgbLabelPol.attributes.maxSrgbLabel   {{ smgc.sr_global_block_maximum | default(defaults.apic.fabric_policies.sr_mpls_global_configuration.sr_global_block_maximum) }}
{% endif %}
