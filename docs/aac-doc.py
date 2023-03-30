# Copyright: (c) 2021, Daniel Schmidt <danischm@cisco.com>

import argparse
import copy
import os
import re
import json
import shutil

import subprocess

import ruamel.yaml
import yamale
from ruamel.yaml.comments import CommentedMap


ANNOTATIONS = [
    "name",
    "ref_name",
    "flatten",
    "hidden",
    "key",
    "ref_table",
    "description",
]

APIC_SCHEMA_PATH = "./schemas/apic_schema.yaml"
APIC_OBJECTS_PATH = "./objects/apic_objects.yaml"
APIC_DEFAULTS_PATH = "./defaults/apic_defaults.yaml"

MSO_SCHEMA_PATH = "./schemas/mso_schema.yaml"
MSO_OBJECTS_PATH = "./objects/mso_objects.yaml"
MSO_DEFAULTS_PATH = "./defaults/mso_defaults.yaml"


def load_yaml_file(path):
    data = CommentedMap()
    if os.path.isfile(path):
        with open(path, "r") as yaml_file:
            data_yaml = yaml_file.read()
            yaml = ruamel.yaml.YAML()
            data = list(yaml.load_all(data_yaml))
    return data


def add_comments(schema, schema_comments):
    for attr in schema.dict:
        comment_item = schema_comments[0].ca.items.get(attr)
        if comment_item:
            schema.dict[attr].comment = comment_item[2].value[1:].strip()
    for include in schema.includes:
        item = schema_comments[1][include]
        for attr in schema.includes[include].dict:
            comment_item = item.ca.items.get(attr)
            if comment_item:
                schema.includes[include].dict[attr].comment = (
                    comment_item[2].value[1:].strip()
                )


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


def parse_annotations(schema_item, comment):
    """Parse annotations from comments in schema yaml and add as attributes to respective schema elements."""
    for annotation in ANNOTATIONS:
        search_regex = "(?<=@{}\\().*?(?=\\))".format(annotation)
        match = re.search(search_regex, comment)
        if match:
            setattr(schema_item, annotation, match.group())


def read_schema_path(schema, path):
    path_elements = path.split(".")

    next_element = schema.includes[path_elements[0]]

    element = None
    name = ""

    if len(path_elements) == 1:
        return schema.dict[path_elements[0]], path_elements[0]

    for p in path_elements[1:]:
        element = next_element.dict[p]
        name = p
        if element.tag == "include":
            next_element = schema.includes[element.include_name]
        elif element.tag == "list":
            if element.validators[0].tag == "include":
                next_element = schema.includes[element.validators[0].include_name]
            else:
                next_element = element
        else:
            next_element = element

    return element, name


def expand_paths(schema, paths):
    new_paths = []
    for path in paths:
        element, _ = read_schema_path(schema, path)
        if element.tag == "include":
            for item in schema.includes[element.include_name].dict:
                new_paths.append(path + "." + item)
        if element.tag == "list":
            if element.validators[0].tag == "include":
                for item in schema.includes[element.validators[0].include_name].dict:
                    new_paths.append(path + "." + item)

    if len(new_paths) > 0:
        new_paths = expand_paths(schema, new_paths)

    paths.extend(new_paths)
    return paths


def parse_schema_type_constraint(element, name=""):
    result_type = ""
    result_constraint = ""
    if element.tag == "str":
        args = []
        for arg, value in element.kwargs.items():
            args.append("{0}: {1}".format(arg, value))
        result_type = "String"
        result_constraint = ", ".join(args)
    elif element.tag == "int":
        args = []
        for arg, value in element.kwargs.items():
            args.append("{0}: {1}".format(arg, value))
        result_type = "Integer"
        result_constraint = ", ".join(args)
    elif element.tag == "num":
        args = []
        for arg, value in element.kwargs.items():
            args.append("{0}: {1}".format(arg, value))
        result_type = "Number"
        result_constraint = ", ".join(args)
    elif element.tag == "bool":
        result_type = "Boolean"
        result_constraint = "`true`, `false`"
    elif element.tag == "null":
        result_type = "Null"
    elif element.tag == "enum":
        result_type = "Choice"
        result_constraint = ", ".join(["`{}`".format(e) for e in element.enums])
    elif element.tag == "list":
        if element.validators[0].tag == "include":
            type = "`[{}]`".format(name)
            constraint = None
        else:
            type, constraint = parse_schema_type_constraint(element.validators[0], name)
        result_type = "List"
        if constraint:
            result_constraint = "{}[{}]".format(type, constraint)
        else:
            result_constraint = type
    elif element.tag == "map":
        result_type = "Map"
    elif element.tag == "ip":
        result_type = "IP"
    elif element.tag == "mac":
        result_type = "MAC"
    elif element.tag == "regex":
        pattern = element.regexes[0].pattern
        pattern = pattern.replace("|", "\|")  # escape pipe in markdown
        pattern = pattern.replace("\n", "\\n")
        pattern = pattern.replace("\r", "\\r")
        result_type = "String"
        result_constraint = "Regex: `{0}`".format(pattern)
    elif element.tag == "include":
        result_type = "Class"
        result_constraint = "`[{}]`".format(name)
    elif element.tag == "any":
        types = []
        enum = True
        enum_constraint = []
        result_type = "Any"
        for validator in element.validators:
            type, constraint = parse_schema_type_constraint(validator)
            if type not in ["Choice", "Boolean"]:
                enum = False
            if type is not None:
                enum_constraint.append(constraint)
                if constraint:
                    types.append("{}[{}]".format(type, constraint))
                else:
                    types.append(type)
            # if Boolean skip other options like enabled/disabled, yes/no, etc.
            if type == "Boolean":
                result_type = "Boolean"
                break
        if enum:
            result_constraint = ", ".join(enum_constraint)
        else:
            result_constraint = " or ".join(types)
    return result_type, result_constraint


def parse_description(element):
    return getattr(element, "description", "")


def parse_mandatory(element):
    if element.is_required:
        return "Yes"
    else:
        return "No"


def get_default(defaults, path):
    path_elements = path.split(".")
    default_value = defaults["defaults"]
    for p in path_elements:
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


def render_class(schema, defaults, class_path, paths):
    class_path_elements = class_path.split(".")
    parent = ".".join(class_path_elements[:-1])
    if parent:
        parent = " *({})*".format(parent)
    output = "\n#### {0}{1}\n\n".format(class_path_elements[-1], parent)
    output += "Name | Type | Constraint | Mandatory | Default Value\n"
    output += "---|---|---|---|---\n"
    for path in paths:
        path_elements = path.split(".")
        cp = ".".join(path_elements[:-1])
        if class_path == cp:
            element, name = read_schema_path(schema, path)
            type, constraint = parse_schema_type_constraint(element, name)
            mandatory = parse_mandatory(element)
            default = get_default(defaults, path)
            default = "`{}`".format(default) if default else default
            output += "**{0}** | {1} | {2} | {3} | {4}".format(
                name,
                type,
                constraint,
                mandatory,
                default,
            ).strip()
            output += "\n"
    output += "\n<br />\n"
    return output


def render_class_list(schema, defaults, class_paths, paths):
    output = "### Classes\n"
    for class_path in class_paths:
        output += render_class(schema, defaults, class_path, paths)
    return output


def render_diagram_path(element, path, mappings={}):
    result = ""
    path_elements = path.split(".")
    if path in mappings:
        name = mappings[path].split(".")[-1]
    else:
        name = path_elements[-1]
    if len(path_elements) > 1:
        parent_path = ".".join(path_elements[:-1])
        if parent_path in mappings:
            parent = mappings[parent_path].split(".")[-1]
        else:
            parent = path_elements[-2]
    else:
        parent = ""
    if element.is_required:
        mandatory = "*"
    else:
        mandatory = ""
    if element.tag == "str":
        result = "{0} : {1}{2} [Str]\n".format(parent, mandatory, name)
    elif element.tag == "int":
        result = "{0} : {1}{2} [Int]\n".format(parent, mandatory, name)
    elif element.tag == "num":
        result = "{0} : {1}{2} [Num]\n".format(parent, mandatory, name)
    elif element.tag == "bool":
        result = "{0} : {1}{2} [Bool]\n".format(parent, mandatory, name)
    elif element.tag == "null":
        result = "{0} : {1}{2} [Num]\n".format(parent, mandatory, name)
    elif element.tag == "enum":
        result = "{0} : {1}{2} [Enum]\n".format(parent, mandatory, name)
    elif element.tag == "list":
        result = "{0} <-- {1}\n".format(parent, name)
        result += "{0} : {1}{2} (List)\n".format(parent, mandatory, name)
    elif element.tag == "map":
        pass
    elif element.tag == "ip":
        result = "{0} : {1}{2} [IP]\n".format(parent, mandatory, name)
    elif element.tag == "mac":
        result = "{0} : {1}{2} [MAC]\n".format(parent, mandatory, name)
    elif element.tag == "regex":
        result = "{0} : {1}{2} [Str]\n".format(parent, mandatory, name)
    elif element.tag == "include":
        result = "{0} *-- {1}\n".format(parent, name)
        result += "{0} : {1}{2} (Dict)\n".format(parent, mandatory, name)
    elif element.tag == "any":
        if element.validators[0].tag == "str":
            result = "{0} : {1}{2} [Str]\n".format(parent, mandatory, name)
        else:
            result = "{0} : {1}{2} [Any]\n".format(parent, mandatory, name)
    return result


def render_diagram_class(schema, defaults, class_path, paths, rendered_paths, mappings):
    output = ""
    for path in paths:
        path_elements = path.split(".")
        cp = ".".join(path_elements[:-1])
        if class_path == cp:
            current_path = []
            for idx, path_element in enumerate(path_elements):
                current_path.append(path_element)
                if idx == 0:
                    continue
                path_string = ".".join(current_path)
                if path_string in rendered_paths:
                    continue
                rendered_paths.append(path_string)
                element, name = read_schema_path(schema, path_string)
                output += render_diagram_path(element, path_string, mappings)
    return output


def get_rename_mappings(class_paths):
    def next_name(c):
        index = 1
        while True:
            new_name = "{}_{}".format(c, index)
            if new_name not in classes:
                return new_name
            index += 1

    mappings = {}
    classes = []
    for class_path in class_paths:
        path_elements = class_path.split(".")
        c = path_elements[-1]
        if c in classes:
            new_name = next_name(c)
            classes.append(new_name)
            mappings[class_path] = ".".join(path_elements[:-1]) + "." + new_name
            continue
        classes.append(c)
    return mappings


def render_diagram(schema, defaults, class_paths, paths):
    output = "### Diagram\n\n"
    output += "<figure markdown>\n"
    output += "```mermaid\nclassDiagram\n"
    rendered_paths = []
    mappings = get_rename_mappings(class_paths)
    # Move apic element to the end to fix mermaid rendering
    ordered_class_paths = copy.copy(class_paths)
    ordered_class_paths.append(ordered_class_paths.pop(0))
    for class_path in ordered_class_paths:
        output += render_diagram_class(
            schema, defaults, class_path, paths, rendered_paths, mappings
        )
    output += "```\n"
    output += "</figure>\n\n"
    return output


def render_diagram_image(schema, defaults, class_paths, paths, name, image_path):
    output = "### Diagram\n\n"
    output += "![Class Diagram](" + name + ".svg)\n"
    output += "\n"
    mm = "%%{init: {'themeVariables': {'mainBkg': '#e3f0f9', 'nodeBorder': '#000000', 'lineColor': '#000000', 'fontSize': '14px', 'fontFamily': 'CiscoSansTT, CiscoSans, Arial'}}}%%\nclassDiagram\n"
    rendered_paths = []
    mappings = get_rename_mappings(class_paths)
    # Move apic element to the end to fix mermaid rendering
    ordered_class_paths = copy.copy(class_paths)
    ordered_class_paths.append(ordered_class_paths.pop(0))
    for class_path in ordered_class_paths:
        mm += render_diagram_class(
            schema, defaults, class_path, paths, rendered_paths, mappings
        )
    mmd_path = image_path[:-4] + ".mmd"
    with open(mmd_path, "w") as file:
        file.write(mm)
    subprocess.run(["mmdc", "-i", mmd_path, "-o", image_path])
    os.remove(mmd_path)
    return output


def extract_class_paths(schema, paths):
    class_paths = []
    schema_names = []
    for path in paths:
        path_elements = path.split(".")
        class_path = ".".join(path_elements[:-1])
        if len(path_elements) > 2:
            element, _ = read_schema_path(schema, class_path)
            schema_name = ""
            if element.tag == "include":
                schema_name = element.include_name
            elif element.tag == "list":
                schema_name = element.validators[0].include_name
            if schema_name and schema_name in schema_names:
                continue
            schema_names.append(schema_name)
        if class_path not in class_paths:
            class_paths.append(class_path)
    return class_paths


def render_doc(system, schema_path, objects_path, defaults_path, pubhub=False):
    schema = load_schema(schema_path)
    objects = load_yaml_file(objects_path)[0]
    defaults = load_yaml_file(defaults_path)[0]
    pubhub_items = {}

    if pubhub:
        pubhub_path = os.path.join(".", "pubhub")
        shutil.rmtree(pubhub_path, ignore_errors=True)

    for item in (
        objects["objects"]
        + objects.get("bootstrap_objects", [])
        + objects.get("leaf_objects", [])
        + objects.get("spine_objects", [])
        + objects.get("tenant_objects", [])
    ):
        if pubhub:
            if item["name"] == "Bootstrap":
                continue
            i = {
                "title": item["name"],
                "content": os.path.join(item["folder"], item["template"] + ".md"),
            }
            if item["folder"] not in pubhub_items:
                pubhub_items[item["folder"]] = {"items": []}
            pubhub_items[item["folder"]]["items"].append(i)
            rendered_image_path = os.path.join(
                ".",
                "pubhub",
                item["folder"],
                item["template"] + ".svg",
            )
            rendered_path = os.path.join(
                ".",
                "pubhub",
                item["folder"],
                item["template"] + ".md",
            )
        else:
            rendered_path = os.path.join(
                ".",
                "docs",
                "data_model",
                system,
                item["folder"],
                item["template"] + ".md",
            )
        template_path = os.path.join(
            ".",
            "docs",
            "templates",
            system,
            item["folder"],
            item["template"] + ".md",
        )
        if os.path.isfile(template_path):
            if not os.path.exists(os.path.dirname(rendered_path)):
                os.makedirs(os.path.dirname(rendered_path))

            paths = item.get("paths")
            paths = expand_paths(schema, paths)
            class_paths = extract_class_paths(schema, paths)
            output = ""
            if pubhub:
                output += render_diagram_image(
                    schema,
                    defaults,
                    class_paths,
                    paths,
                    item["template"],
                    rendered_image_path,
                )
            else:
                output += render_diagram(schema, defaults, class_paths, paths)
            output += render_class_list(schema, defaults, class_paths, paths)

            with open(template_path, "r") as file:
                filedata = file.read()

            filedata = filedata.replace("{{ aac_doc }}", output)

            if pubhub:
                cleaned_data = ""
                for line in iter(filedata.splitlines(keepends=True)):
                    if line.startswith("### ") and not line.startswith("### Terraform"):
                        line = line[1:]
                    elif line.startswith("#### "):
                        line = line[1:]
                    cleaned_data += line
            else:
                cleaned_data = filedata

            with open(rendered_path, "w") as file:
                file.write(cleaned_data)
    if pubhub:
        for file in pubhub_items:
            path = os.path.join(".", "pubhub", file + "-config.json")
            with open(path, "w") as f:
                json.dump(pubhub_items[file], f, indent=4)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--pubhub", help="Render PubHub documentation", action="store_true"
    )
    args = parser.parse_args()
    if args.pubhub:
        render_doc(
            "apic", APIC_SCHEMA_PATH, APIC_OBJECTS_PATH, APIC_DEFAULTS_PATH, pubhub=True
        )
    else:
        render_doc("apic", APIC_SCHEMA_PATH, APIC_OBJECTS_PATH, APIC_DEFAULTS_PATH)
        render_doc("mso", MSO_SCHEMA_PATH, MSO_OBJECTS_PATH, MSO_DEFAULTS_PATH)


if __name__ == "__main__":
    main()
