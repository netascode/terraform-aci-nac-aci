*** Settings ***
Documentation   System Global GIPo
Suite Setup     Login APIC
Default Tags    apic   day0   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
Verify System Global GIPo
    GET   "/api/mo/uni/infra/systemgipopol.json"
    String   $..fmcastSystemGIPoPol.attributes.useConfiguredSystemGIPo   {{ apic.fabric_policies.use_infra_gipo | default(defaults.apic.fabric_policies.use_infra_gipo) }}
