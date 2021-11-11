*** Settings ***
Documentation   Verify Date and Time Format
Suite Setup     Login APIC
Default Tags    apic   day0   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
Verify Date and Time Format
    GET   "api/node/mo/uni/fabric/format-default.json"
    String   $..datetimeFormat.attributes.displayFormat   {{ apic.fabric_policies.date_time_format.display_format| default(defaults.apic.fabric_policies.date_time_format.display_format) }}
    String   $..datetimeFormat.attributes.tz   {{ apic.fabric_policies.date_time_format.timezone| default(defaults.apic.fabric_policies.date_time_format.timezone) }}
    String   $..datetimeFormat.attributes.showOffset   {{ apic.fabric_policies.date_time_format.show_offset| default(defaults.apic.fabric_policies.date_time_format.show_offset) }}  