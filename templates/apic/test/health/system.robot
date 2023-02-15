*** Settings ***
Documentation   Verify System Health
Suite Setup     Login APIC
Default Tags    apic   day2   health   system   non-critical
Resource        ../apic_common.resource

*** Test Cases ***
Verify System Health Pre-Check
    [Tags]   pre-check
    ${r}=   GET On Session   apic   /api/node/mo/topology/health.json
    ${health}=   Get Value From Json   ${r.json()}   $..fabricHealthTotal.attributes.cur
    &{json}=    Create Dictionary   health=${health}[0]
    Create Directory   ${STATE_PATH}
    evaluate   json.dump($json, open('${STATE_PATH}system_health.json', 'w'))   modules=json

Verify System Health Post-Check
    [Tags]   post-check
    ${r}=   GET On Session   apic   /api/node/mo/topology/health.json
    ${health}=   Get Value From Json   ${r.json()}   $..fabricHealthTotal.attributes.cur
    &{previous}=   evaluate   json.load(open('${STATE_PATH}system_health.json'))   modules=json
    Run Keyword If   ${health}[0] < ${previous["health"]}   Run Keyword And Continue On Failure
    ...   Fail  "System health score degraded from ${previous["health"]} to ${health}[0]"
