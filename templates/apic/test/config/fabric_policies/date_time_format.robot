*** Settings ***
Documentation   Verify Date and Time Format
Suite Setup     Login APIC
Default Tags    apic   day0   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
Verify Date and Time Format
    ${r}=   GET On Session   apic   api/node/mo/uni/fabric/format-default.json
    Should Be Equal Value Json String   ${r.json()}    $..datetimeFormat.attributes.displayFormat   {{ apic.fabric_policies.date_time_format.display_format| default(defaults.apic.fabric_policies.date_time_format.display_format) }}
    Should Be Equal Value Json String   ${r.json()}    $..datetimeFormat.attributes.tz   {{ apic.fabric_policies.date_time_format.timezone| default(defaults.apic.fabric_policies.date_time_format.timezone) }}
    Should Be Equal Value Json String   ${r.json()}    $..datetimeFormat.attributes.showOffset   {{ apic.fabric_policies.date_time_format.show_offset| default(defaults.apic.fabric_policies.date_time_format.show_offset) | cisco.aac.aac_bool("enabled") }}  