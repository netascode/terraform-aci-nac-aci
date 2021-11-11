# Overview

A CLI tool supporting conversions between various input file formats using the *ACI as Code* data model.

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
