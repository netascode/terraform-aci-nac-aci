# Overview

The [aac-tool](https://wwwin-github.cisco.com/aac/aac-tool) CLI application enables conversions between various file formats using the *ACI as Code* data model. Some example use-cases are:

* Render *ACI as Code* YAML inventory files from an APIC configuration snapshot
* Render JSON configuration files from *ACI as Code* YAML inventory files that can be directly posted to APIC
* Render a set of ROBOT test suites from *ACI as Code* YAML inventory files
* Convert *ACI as Code* YAML inventory files from or to an Excel workbook

!!! info

    This is only a subset of the available use-cases. A complete list can be found under [Usage](../usage/).

The tool can be consumed in different ways:

* Consumed as a service using [this](https://aide-tools.cisco.com/datacenter/aci/aac--aac-tool) frontend
* Installed and managed using the *Cisco CX AIDE Toolkit* ([CAT](https://cisco.sharepoint.com/sites/AIDE/SitePages/CX-AIDE-Toolkit.aspx)) application
* Using a ready-to-use container image
* Installed locally as a CLI application

!!! warning

    The hosted version does not support every option available in the CLI application.

```shell
$ aac-tool -h
Usage: aac-tool [OPTIONS] COMMAND [ARGS]...

  Allows conversions between various file formats using the AAC (ACI as
  Code) data model.

Options:
  --version            Show the version and exit.
  -v, --verbosity LVL  Either CRITICAL, ERROR, WARNING, INFO or DEBUG
  -h, --help           Show this message and exit.

Commands:
  apic     Conversion using the AAC APIC Data Model
  generic  Conversion using a provided schema
  mso      Conversion using the AAC MSO Data Model
```
