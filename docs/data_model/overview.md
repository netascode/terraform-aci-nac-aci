# Overview

The data model formally defines the format of the data input files. The schema (yamale) is then based on the data model and used to validate the data input files.

## Notation

- `*` before the member denotes a mandatory member
- After the member typically the data type follows (eg. Str, Int, Enum, Dict, List, etc.)
- As class names within the data model must be unique, if needed a suffix with a single digit (eg. `_1`) is added to the name

## Relationships

The composition relationship is used for dictionary child elements.

<figure markdown>
```mermaid
%%{init: {'themeVariables': {'nodeBorder': '#009688', 'fontSize': '14px', 'fontFamily': 'Roboto'}}}%%
classDiagram
apic *-- pod_policies
apic : pod_policies (Dict)
pod_policies : pods (List)
```
</figure>

The association relationship is used for list elements (1:n relationship).

<figure markdown>
```mermaid
%%{init: {'themeVariables': {'nodeBorder': '#009688', 'fontSize': '14px', 'fontFamily': 'Roboto'}}}%%
classDiagram
node_policies <-- upgrade_groups
node_policies : upgrade_groups (List)
upgrade_groups : *name [Str]
```
</figure>

The dependency relationship is used for other classes being referenced by one of its members.

<figure markdown>
```mermaid
%%{init: {'themeVariables': {'nodeBorder': '#009688', 'fontSize': '14px', 'fontFamily': 'Roboto'}}}%%
classDiagram
pod_policy_group <.. date_time_policy
pod_policy_group : name [Str]
pod_policy_group : date_time_policy [Str]
date_time_policy : *name [Str]
```
</figure>
