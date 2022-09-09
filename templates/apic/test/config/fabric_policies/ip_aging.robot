*** Settings ***
Documentation   Verify IP Aging
Suite Setup     Login APIC
Default Tags    apic   day0   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
Verify IP Aging
    ${r}=   GET On Session   apic   /api/mo/uni/infra/ipAgingP-default.json
    Should Be Equal Value Json String   ${r.json()}    $..epIpAgingP.attributes.adminSt   {{ apic.fabric_policies.ip_aging | default(defaults.apic.fabric_policies.ip_aging) | cisco.aac.aac_bool("enabled") }}
