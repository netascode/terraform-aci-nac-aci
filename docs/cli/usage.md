# Usage

Supported formats:

Format | Description
---|---
json | APIC JSON file or directory (e.g., configuration backup)
xml | APIC XML file or directory (e.g., configuration backup)
dafe | [DAFE](https://wwwin-github.cisco.com/AS-Community/DAFE) Excel workbook
xls | AAC (ACI as Code) Excel workbook
yaml | AAC (ACI as Code) YAML inventory files
robot | ROBOT Framework test suites

Supported conversions:

Data Model | From | To | Description
---|---|---|---
apic | json | xls | Create an AAC Excel workbook from an APIC JSON configuration
apic | xml | xls | Create an AAC Excel workbook from an APIC XML configuration
apic | json | yaml | Create AAC YAML inventory files from an APIC JSON configuration
apic | xml | yaml | Create AAC YAML inventory files from an APIC XML configuration
apic | json | dafe | Create a DAFE Excel workbook from an APIC JSON configuration
apic | xml | dafe | Create a DAFE Excel workbook from an APIC XML configuration
apic | xls | yaml | Create AAC YAML inventory files from an AAC Excel workbook
apic | xls | json | Create APIC JSON configuration from an AAC Excel workbook
apic | xls | robot | Create ROBOT Framework test suites from an AAC Excel workbook
apic | yaml | xls | Create an AAC Excel workbook from AAC YAML inventory files
apic | yaml | json | Create APIC JSON configuration from AAC YAML inventory files
apic | yaml | robot | Create ROBOT Framework test suites from AAC YAML inventory files
ndo | xls | yaml | Create AAC YAML inventory files from an AAC Excel workbook
ndo | yaml | xls | Create an AAC Excel workbook from AAC YAML inventory files
generic | xls | yaml | Create a YAML inventory file from an Excel workbook
generic | yaml | xls | Create an Excel workbook from YAML inventory files

CLI usage:

```
aac-tool {DATA_MODEL} {FROM_FORMAT} {TO_FORMAT} [ARGS]...
```

### Examples

Create a DAFE Excel workbook from a configuration backup:

```
aac-tool apic json dafe --input "/tmp/config_backup.json" --output "/tmp/nip.xlsx"
```

Create AAC inventory files from a configuration backup:

```
aac-tool apic xml yaml --input "/tmp/config_backup.xml" --output "/tmp"
```

Create an empty AAC Excel workbook:

```
aac-tool apic yaml xls --output "/tmp/template.xlsx"
```

Create AAC NDO YAML inventory files from an AAC NDO Excel workbook:

```
aac-tool ndo xls yaml --input "/tmp/aac.xlsx" --output "/tmp/aac/"
```
