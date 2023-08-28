# Copyright: (c) 2023, Daniel Schmidt <danischm@cisco.com>

import os
import re
import json
import sys

import ruamel.yaml
import yamale
from ruamel.yaml.comments import CommentedMap
from types import SimpleNamespace

ANNOTATIONS = [
    "name",
    "ref_name",
    "flatten",
    "hidden",
    "key",
    "ref_table",
    "description",
    "no_doc",
    "no_external_doc",
]

WORD_MAPPINGS = {
    "apic": "APIC",
    "nae": "NAE",
    "ptp": "PTP",
    "isis": "ISIS",
    "bgp": "BGP",
    "bfd": "BFD",
    "as": "AS",
    "rr": "RR",
    "dscp": "DSCP",
    "vmm": "VMM",
    "coop": "COOP",
    "aaa": "AAA",
    "ep": "EP",
    "dns": "DNS",
    "gui": "GUI",
    "cli": "CLI",
    "epg": "EPG",
    "ip": "IP",
    "mcp": "MCP",
    "bpdu": "BPDU",
    "snmp": "SNMP",
    "ntp": "NTP",
    "id": "ID",
    "psu": "PSU",
    "dom": "DOM",
    "vswitch": "vSwitch",
    "vcenters": "vCenters",
    "cdp": "CDP",
    "lldp": "LLDP",
    "dvs": "DVS",
    "ca": "CA",
    "ssh": "SSH",
    "mst": "MST",
    "fex": "FEX",
    "vpc": "vPC",
    "aaeps": "AAEPs",
    "qos": "QoS",
    "cos": "CoS",
    "mtu": "MTU",
    "fec": "FEC",
    "pps": "PPS",
    "aaep": "AAEP",
    "tep": "TEP",
    "inb": "INB",
    "oob": "OOB",
    "fexes": "FEXes",
    "vrfs": "VRFs",
    "ext": "EXT",
    "mgmt": "MGMT",
    "arp": "ARP",
    "mac": "MAC",
    "vrf": "VRF",
    "dhcp": "DHCP",
    "igmp": "IGMP",
    "nd": "ND",
    "ra": "RA",
    "ospf": "OSPF",
    "svi": "SVI",
    "ttl": "TTL",
    "lsa": "LSA",
    "rx": "RX",
    "tx": "TX",
    "l4l7": "L4L7",
    "vcenter": "vCenter",
    "vm": "VM",
    "vnic": "vNIC",
    "mso": "MSO",
    "ndo": "NDO",
    "urls": "URLs",
    "useg": "uSeg",
    "vpn": "VPN",
    "cidrs": "CIDRs",
    "bum": "BUM",
    "wan": "WAN",
    "ips": "IPs",
}

APIC_SCHEMA_PATH = "../schemas/apic_schema.yaml"
APIC_DEFAULTS_PATH = "../defaults/apic_defaults.yaml"

NDO_SCHEMA_PATH = "../schemas/ndo_schema.yaml"
NDO_DEFAULTS_PATH = "../defaults/ndo_defaults.yaml"

JSON_SCHEMA_PATH = "../schemas/schema.json"


def load_yaml_file(path):
    data = CommentedMap()
    if os.path.isfile(path):
        with open(path, "r") as yaml_file:
            data_yaml = yaml_file.read()
            yaml = ruamel.yaml.YAML()
            data = list(yaml.load_all(data_yaml))
    return data


def parse_annotations(schema_item, comment):
    """Parse annotations from comments in schema yaml and add as attributes to respective schema elements."""
    for annotation in ANNOTATIONS:
        search_regex = "(?<=@{}\\().*?(?=\\))".format(annotation)
        match = re.search(search_regex, comment)
        if match:
            setattr(schema_item, annotation, match.group())


def load_schema(path):
    """Load a yamale schema and add annotations as attributes to schema elements."""
    schema = yamale.make_schema(path, parser="ruamel")
    schema_comments = load_yaml_file(path)
    for attr in schema.dict:
        comment_item = schema_comments[0].ca.items.get(attr)
        if comment_item:
            parse_annotations(schema.dict[attr], comment_item[2].value[1:].strip())
    for include in schema.includes:
        item = schema_comments[1][include]
        for attr in schema.includes[include].dict:
            comment_item = item.ca.items.get(attr)
            if comment_item:
                parse_annotations(
                    schema.includes[include].dict[attr],
                    comment_item[2].value[1:].strip(),
                )
    return schema


def get_title_name(name):
    """Translates snake case (yaml) to capital case."""
    words = name.split("_")
    cap_words = [word.title() for word in words]
    pretty_name = " ".join(cap_words)
    for word in cap_words:
        if word.lower() in WORD_MAPPINGS:
            pretty_name = pretty_name.replace(word, WORD_MAPPINGS[word.lower()])
    return pretty_name


def get_default_value(path):
    default_value = DEFAULTS["defaults"]
    for p in path:
        if not isinstance(default_value, dict):
            break
        default_value = default_value.get(p)
        if default_value is None:
            default_value = ""
            break
    if isinstance(default_value, dict) or isinstance(default_value, list):
        return ""
    if default_value is True:
        default_value = "true"
    elif default_value is False:
        default_value = "false"
    return default_value


def translate_schema_element(yamale_schema, path=[]):
    required_elements = []
    json_elements = {}
    for name, element in yamale_schema.dict.items():
        element_path = path + [name]
        description_helper = ""
        description_type = ""
        if element.tag == "include":
            json_element = {"type": "object", "additionalProperties": False}
            e, required_properties = translate_schema_element(
                yamale_schema.includes[element.include_name], element_path
            )
            json_element["properties"] = e
            json_elements[name] = json_element
            json_elements[name]["required"] = required_properties
            description_helper += "\n\nElements:" + "".join(
                [
                    "\n- {}".format(key)
                    + (" (required)" if key in required_properties else "")
                    for key in e
                ]
            )
        elif element.tag == "list":
            json_element = {"type": "array"}
            if element.validators[0].tag == "include":
                json_element["items"] = {
                    "type": "object",
                    "additionalProperties": False,
                }
                e, required_properties = translate_schema_element(
                    yamale_schema.includes[element.validators[0].include_name],
                    element_path,
                )
                json_element["items"]["properties"] = e
                json_element["items"]["required"] = required_properties
                description_type = "List - Object"
                description_helper += "\n\nElements:" + "".join(
                    [
                        "\n- {}".format(key)
                        + (" (required)" if key in required_properties else "")
                        for key in e
                    ]
                )
            else:
                json_element["items"] = {}
                e, required_properties = translate_schema_element(
                    SimpleNamespace(dict={"items": element.validators[0]}), element_path
                )
                json_element["items"] = e["items"]
                description_type = "List - {}".format(e["items"]["type"].title())
            json_elements[name] = json_element
        elif element.tag == "str":
            json_element = {"type": "string"}
            min = element.kwargs.get("min")
            if min:
                json_element["minLength"] = min
                description_helper += "\n- Minimum length: {}".format(min)
            max = element.kwargs.get("max")
            if max:
                json_element["maxLength"] = max
                description_helper += "\n- Maximum length: {}".format(max)
            json_elements[name] = json_element
        elif element.tag == "enum":
            json_element = {"type": "string"}
            json_element["enum"] = element.enums
            json_elements[name] = json_element
            description_helper += "\n- Allowed values: {}".format(
                ", ".join([str(e) for e in element.enums])
            )
        elif element.tag == "regex":
            pattern = element.regexes[0].pattern
            json_element = {"type": "string", "pattern": pattern}
            json_elements[name] = json_element
        elif element.tag == "ip":
            json_element = {
                "anyOf": [
                    {
                        "type": "string",
                        "pattern": "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$",
                    },
                    {
                        "type": "string",
                        "pattern": "^(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))$",
                    },
                ],
            }
            json_element = {"type": "string"}
            json_elements[name] = json_element
            description_helper += "\n- IPv4 or IPv6 address"
        elif element.tag == "mac":
            pattern = "^([0-9A-Fa-f]{2}[:]){5}([0-9A-Fa-f]{2})$"
            json_element = {"type": "string", "pattern": pattern}
            json_elements[name] = json_element
            description_helper += "\n- MAC address (XX:XX:XX:XX:XX:XX)"
        elif element.tag == "int":
            json_element = {"type": "integer"}
            min = element.kwargs.get("min")
            if min:
                json_element["minimum"] = min
                description_helper += "\n- Minimum value: {}".format(min)
            max = element.kwargs.get("max")
            if max:
                json_element["maximum"] = max
                description_helper += "\n- Maximum value: {}".format(max)
            json_elements[name] = json_element
        elif element.tag == "num":
            json_element = {"type": "number"}
            min = element.kwargs.get("min")
            if min:
                json_element["minimum"] = min
                description_helper += "\n- Minimum value: {}".format(min)
            max = element.kwargs.get("max")
            if max:
                json_element["maximum"] = max
                description_helper += "\n- Maximum value: {}".format(max)
            json_elements[name] = json_element
        elif element.tag == "bool":
            json_element = {"type": "boolean"}
            json_elements[name] = json_element
        elif element.tag == "null":
            json_element = {"type": "null"}
            json_elements[name] = json_element
        elif element.tag == "any":
            json_element = {}
            json_element["anyOf"] = []
            types = []
            for validator in element.validators:
                e, required_properties = translate_schema_element(
                    SimpleNamespace(dict={"anyOf": validator}), element_path
                )
                if e:
                    json_element["anyOf"].append(e.get("anyOf"))
                    types.append(e.get("anyOf", {}).get("type"))
            if types:
                description_type = ", ".join([t.title() for t in types])
            if not element.validators:
                json_element = {}
            # if boolean included, hide legacy options
            if "boolean" in types:
                description_type = ""
                json_element = {"type": "boolean"}
            json_elements[name] = json_element
        elif element.tag == "timestamp":
            json_element = {"type": "string"}
            json_elements[name] = json_element
            description_helper += "\n- Timestamp"
        elif element.tag == "map":
            json_element = {"type": "object"}
            json_elements[name] = json_element
            description_helper += "\n- Map (key-value pairs)"
        else:
            sys.exit("Unknown tag: {}".format(element.tag))

        if name not in ["items", "anyOf"]:
            default_value = get_default_value(element_path)
            if default_value:
                json_elements[name]["default"] = default_value
            json_elements[name]["title"] = get_title_name(name)
            json_elements[name]["description"] = get_title_name(name)
            title = json_elements[name].get("type", "").title()
            if description_type:
                title = description_type
            json_elements[name]["description"] += " ({})".format(title)
            if hasattr(element, "description"):
                json_elements[name]["description"] += "\n{}".format(element.description)
            if default_value:
                json_elements[name]["description"] += "\n- Default value: {}".format(
                    default_value
                )
            if description_helper:
                json_elements[name]["description"] += description_helper
        if element.is_required:
            required_elements.append(name)
    return json_elements, required_elements


def main():
    global DEFAULTS
    DEFAULTS = load_yaml_file(APIC_DEFAULTS_PATH)[0]
    ndo_defaults = load_yaml_file(NDO_DEFAULTS_PATH)[0]
    DEFAULTS.get("defaults")["ndo"] = ndo_defaults.get("defaults", {}).get("ndo")
    json_schema = {}
    json_schema["$schema"] = "https://json-schema.org/draft/2020-12/schema"
    json_schema["$id"] = "https://developer.cisco.com/docs/nexus-as-code/schema.json"
    json_schema["title"] = "Cisco Nexus-as-Code Schema"
    json_schema["description"] = "Cisco Nexus-as-Code Data Model JSON Schema"
    json_schema["type"] = "object"
    json_schema["additionalProperties"] = False
    json_schema["properties"] = {}
    json_schema["required"] = []
    schema = load_schema(APIC_SCHEMA_PATH)
    e, _ = translate_schema_element(schema)
    json_schema["properties"].update(e)
    schema = load_schema(NDO_SCHEMA_PATH)
    e, _ = translate_schema_element(schema)
    json_schema["properties"].update(e)
    with open(JSON_SCHEMA_PATH, "w") as json_schema_file:
        json.dump(json_schema, json_schema_file, indent=4)


if __name__ == "__main__":
    main()
