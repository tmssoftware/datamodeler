# TMS Data Modeler

A visual database design and modeling tool written in Delphi with support for SQL Server, Firebird, Oracle, PostgreSQL, MySQL, SQLite.

![Platform](https://img.shields.io/badge/platform-Windows-blue)
[![Latest Release](https://img.shields.io/github/v/release/tmssoftware/datamodeler)](https://github.com/tmssoftware/datamodeler/releases)
[![License](https://img.shields.io/badge/license-Source--Available-orange)](LICENSE.txt)

## Overview

TMS Data Modeler is a desktop tool for designing, versioning, and maintaining database schemas through entity-relationship diagrams. It targets developers and database designers who want to model a schema visually, generate DDL scripts for multiple database systems, compare versions, and reverse-engineer existing databases.

It is also intended for [TMS Aurelius](https://www.tmssoftware.com/site/aurelius.asp) developers who prefer a database-first workflow: model the schema in Data Modeler and generate the corresponding Aurelius entity-mapped classes from it.

## Screenshots

![Diagram editor](https://www.tmssoftware.com/site/img/screen_diagram.png)

![Project validation](https://www.tmssoftware.com/site/img/screen_validation.png)

## Key Features

- Entity-relationship (ER) diagram editor with a multi-diagram interface
- Design tables, fields, domains, indexes, triggers, relationships, constraints, views, procedures, generators, and other database objects
- Logical (application-level) domains
- Reverse engineering of existing databases
- DDL (SQL) script generation to create databases
- Alter-script generation to update databases between versions
- Version archiving and management; comparison between versions or projects
- Cross-database conversion
- Project validation to trace model errors
- Aurelius database-first integration: generate entity-mapped classes from a model
- Modern ribbon interface with tab-organized objects and full keyboard accessibility

A full feature description is available on the [product page](https://www.tmssoftware.com/site/tmsdm.asp).

## Supported Databases

SQL Server, Firebird, Oracle, PostgreSQL, MySQL, SQLite.

The corresponding database client libraries must be installed on the machine running Data Modeler; Data Modeler does not bundle them.

## Installation

Official installers are published on the [Releases](https://github.com/tmssoftware/datamodeler/releases) page of this repository.

**System requirements**

- Windows 10 or later (recommended)
- Standard Windows desktop hardware (no special memory or disk requirements beyond the OS baseline)
- Database client libraries for the database systems you intend to connect to

There is no separate trial build. Per the [license](LICENSE.txt), non-commercial use (personal learning, education, evaluation, open-source projects) does not require a paid license; commercial use does.

## Documentation

Full user documentation is available at [doc.tmssoftware.com/biz/datamodeler](https://doc.tmssoftware.com/biz/datamodeler/).

## Building from Source

Data Modeler is built with **Delphi 13**. Earlier Delphi versions are not tested and may or may not work.

### Third-party dependencies

The required third-party libraries are listed in [tms.snapshot.yaml](tms.snapshot.yaml):

- [JAM Software Virtual TreeView](https://github.com/JAM-Software/Virtual-TreeView)
- [TMS Aurelius](https://www.tmssoftware.com/site/aurelius.asp)
- [TMS Scripter](https://www.tmssoftware.com/site/scriptstudiopro.asp)
- [TMS Diagram Studio](https://www.tmssoftware.com/site/diagram.asp)
- [TMS VCL UI Pack](https://www.tmssoftware.com/site/tmsvcluipack.asp)

### Recommended: build with TMS Smart Setup

From the repository root, run:

```
tms restore tms.snapshot.yaml -skip-register
```

Smart Setup will automatically resolve all dependencies and build the project, generating the `dm.exe` binary.

### Manual build

Install all third-party dependencies listed above manually, open `dm/dm.dproj` in Delphi 13, and build.

## License

TMS Data Modeler is **source-available, not open source**. A paid commercial license is required for business and professional use. See [LICENSE.txt](LICENSE.txt) for full terms.

## Purchasing

Licenses can be purchased from the [product page](https://www.tmssoftware.com/site/tmsdm.asp).

## Support

All support is handled through the TMS Support Center. The Data Modeler category is at:

[support.tmssoftware.com/c/business/tms-data-modeler/35](https://support.tmssoftware.com/c/business/tms-data-modeler/35)

## Contributing

Pull requests and contributions are accepted. By submitting a contribution you agree to the terms in section 5 of [LICENSE.txt](LICENSE.txt), which grants TMS Software the rights needed to incorporate your contribution into the Software.

## Changelog

Release notes are published at [doc.tmssoftware.com/biz/datamodeler/guide/release-notes.html](https://doc.tmssoftware.com/biz/datamodeler/guide/release-notes.html).

---

Copyright © tmssoftware.com bv — [tmssoftware.com](https://www.tmssoftware.com)
