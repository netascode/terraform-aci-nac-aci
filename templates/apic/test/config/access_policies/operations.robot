*** Settings ***
Documentation   Verify Atomic Counter
Suite Setup     Login APIC
Default Tags    apic   day0   config   access_policies
Resource        ../../apic_common.resource

*** Test Cases ***
Verify Atomic Counter
${r}=   GET On Session   apic   /api/mo/uni/fabric/ogmode.json
Set Suite Variable   ${r}
