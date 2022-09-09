*** Settings ***
Documentation   Verify Fabric ISIS BFD
Suite Setup     Login APIC
Default Tags    apic   day0   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
Verify Fabric ISIS BFD
    ${r}=   GET On Session   apic   /api/mo/uni/fabric/l3IfP-default.json
    Should Be Equal Value Json String   ${r.json()}    $..l3IfPol.attributes.bfdIsis   {{ apic.fabric_policies.fabric_isis_bfd | default(defaults.apic.fabric_policies.fabric_isis_bfd) | cisco.aac.aac_bool("enabled") }}
