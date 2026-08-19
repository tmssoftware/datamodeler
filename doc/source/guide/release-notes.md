---
uid: ReleaseNotes
---

# What's New

## Version 4.2 (Aug-2026)

- **New**: Aurelius export now allows choosing how database columns with no native Pascal equivalent are mapped. In previous versions such columns were always exported as `Variant` properties, which is still the default. You can now choose `string` or `Integer` instead, using the new **Map Non-Native Types As** option, in the **Defaults** group of the Aurelius export dialog.

- **Improved**: MySQL importer now imports `enum` columns as `varchar` fields, sized to hold the longest value accepted by the column. In previous versions such columns were imported as computed fields.

## Version 4.1 (July-2026)

- **Improved**: Firebird databases now provide a `Smallint (Identity)` data type, allowing smallint identity columns to be imported and generated.

- **Improved**: SQL Server connection dialog now offers an option to add custom connection ODBS string parameters. You can add, for example, `TrustServerCertificate=yes` to avoid SSL certificate validation errors when connecting to SQL Server.

- **Improved**: Connection dialogs for all databases now display in correct size. In previous versions some connection dialogs were displayed in a smaller size than expected, making it difficult to read and use.

## Version 4.0 (May-2026)

- **New**: **TMS Data Modeler full source code is now publicly available**. You can now browse, study and modify the full source code of TMS Data Modeler. The source code is available in [TMSData Modeler GitHub repository](https://github.com/tmssoftware/datamodeler). You can read more about in our [**blog post TMS Data Modeler source code is now available**](https://www.tmssoftware.com/site/blog.asp?post=2476).

- **Improved**: Licensing mechanism is now removed, and licensing tool is not available anymore. Even though you still need a license for commercial usage, the software will not check for license validity anymore, as source code is now fully available.

- **Improved**: Splash screen removed, and self-update mechanism removed.

- **Improved**: Trial version is not available anymore. Existing binaries are fully functional and must be used according to the license agreement.

## Version 3.13 (May-2022)

- **Fixed**: Exported Aurelius dictionary now also includes parent properties and associations, when the exported entity class is inherited from another entity class. Ref: https://support.tmssoftware.com/t/dictionary-with-inheritance-joined-tables/15429.

## Version 3.12 (Mar-2022)

- **Fixed**: Exported dictionary now also exports properties related to many-valued associations. Ref: https://support.tmssoftware.com/t/dictionary-for-one-to-many-relations/17994/9.

## Version 3.11 (Jan-2022)

- **Fixed**: Firebird importer was creating domains even for internally created data types. Ref: https://support.tmssoftware.com/t/firebird-reverse-engineering-too-many-domains-created/17595.

## Version 3.10 (Oct-2021)

- **New**: TMS Aurelius export now generates the new TMS Aurelius dictionary.

- **New**: Customization script now provide much more classes that allow outputting more Pascal constructions: const sections, var declarations, if, for, for each, while, try..finally and try..except structures, parameter default value.

- **New**: Customization script now supports creating "var" section and inline variable declaration.

- **Improved**: Interbase connection settings dialog now also filters database files by .ib extension.

- **Fixed**: ElevateDB importer didn't work correctly with databases when two or more foreign keys (relationships) had the same name.

## Version 3.9.1 (Jan-2021)

- **Fixed:**
  Firebird 3.0 database importer was incorrectly importing some system domains.

- **Fixed:**
  Singularization of word "Status" was wrong in TMS Aurelius export.

- **Fixed:**
  TMS Aurelius exporter suffixes identifiers that are reserved words with "\_" character.
  But it was not working in some situations, now all is correct.

## Version 3.8 (Nov-2020)

- **New:**
  **\"Export Image\"  button allows exporting the whole diagram to an image file.**

- **Fixed:**
  Could not import SQL Server databases with dot (.) in their names.

## Version 3.7 (Oct-2020)

- **Improved:**
  Project check for SQL Server now warns user
  if there are two or more primary keys in the project with the same name.

- **Improved:**
  Project/version comparer now allows user to
  copy the current diff script to clipboard.

- **Fixed:**
  Access Violation when opening a project in a computer with a default
  printer that has more than 256 paper sizes defined.

## Version 3.6 (Sep-2020)

- **Fixed:**
  SQLite import was failing when types like \"NUMERIC(10 , 4)\" had a
  space before the comma in the original SQL.

## Version 3.5 (Aug-2020)

- **New:**
  PostgreSQL connection settings now offers
  the option to choose the database schema to import structure from.

## Version 3.4 (Jul-2020)

- **New:**
  IsStatic boolean property in TCodeMemberMethod, TCodeMemberField and
  TCodeMemberProperty objects allow creating static (class) methods, fields
  and procedures using [customization script](xref:Aurelius#customization-script).

## Version 3.3.9 (Jun-2020)

- **Fixed:**
  SQLite import was failing when \-- comments were preceded by parenthesis.

## Version 3.3.8 (May-2020)

- **Fixed:**
  SQLite import was failing when \-- comments were preceded by comma.

- **Fixed:**
  SQLite import was failing when field identifiers had non-Latin
  characters.

- **Fixed:**
  SQLite trigger procedures were being generated in a single line.

- **Fixed:**
  SQLite import sometimes was incorrectly importing the referenced field
  in a relationship.

## Version 3.3.7 (Apr-2020)

- **Fixed:**
  Error \"column reference \'oid\' is
  ambiguous\" when importing PostgreSQL 12 databases.

## Version 3.3.6 (Sep-2019)

- **Improved:**
  Added support for XMLType data type in Oracle.

## Version 3.3.5 (Aug-2019)

- **Fixed:**
  Before generating DROP COLUMN statements in
  SQL Server, it\'s now generating DROP CONSTRAINT statements associated
  to the column.

- **Fixed:**
  \"More colors\...\" option was not working
  for fill and text color of diagram objects.

## Version 3.3.4 (Aug-2019)

- **Improved:**
  Added support for range types in PostgreSQL (daterange, int4range, etc.).

## Version 3.3.3 (Jul-2019)

- **Fixed:**
  Firebird 3 did not include data type
  \"Numeric (Identity)\".

## Version 3.3.2 (Jan-2019)

- **New:**
  **PostgreSQL 11 support**, avoiding the error
  \"p.proisagg does not exist. perhaps you meant to reference the column
  p.prolang\".

## Version 3.3.1 (Jan-2019)

- **Improved:**
  Arguments for OnClassGenerated event now includes references to Table
  and Sequence attribute. Used in the example
  [Adding Schema Name to Table Attribute](xref:Aurelius#adding-schema-name-to-table-attribute).

- **Fixed:**
  Performing project checking in ElevateDB
  projects now reports wrong field size for char/binary fields with size
  higher than 1024.

## Version 3.3 (Dec-2018)

- **New:**
  **\"Scripting\" button in Tools tab in ribbon, opens a full scripting IDE
  for low-level and advanced manipulation of the existing data dictionary.**

## Version 3.2.6 (Nov-2018)

- **Improved:**
  List of tables in the Generate Script
  dialog is now sorted.

- **Fixed:**
  Fields in primary keys were being nullable when using nullable domains.
  It broke backward compatibility, fields in primary keys should always be
  not null.

- **Fixed:**
  PostgreSQL database importer was not correctly retrieving foreign keys
  with same name in different tables.

## Version 3.2.5 (Nov-2018)

- **Improved:**
  There is now a check box \"Specific\" for
  the \"Not null\" field. When the field has a domain associated to it,
  this new check box allows explicitly control if the NOT NULL flag should
  come from domain or you would want to ignore the domain setting and use
  a specific value for the field.

## Version 3.2.4 (Nov-2018)

- **Fixed:**
  Foreign keys with multiple fields
  (relationships with composite keys) not being correctly imported from
  Oracle databases.

## Version 3.2.3 (Oct-2018)

- **Fixed:**
  Null/NotNull checkbox was disabled for
  fields associated with logical domains.

- **Fixed:**
  Project window maximizing automatically in
  some situations.

## Version 3.2.2 (Oct-2018)

- **Fixed:**
  SQL Server ALTER TABLE ADD COLUMN statement
  was not including constraint name for default values.

## Version 3.2.1 (Sep-2018)

- **Fixed:**
  Firebird behavior with domains: size, not
  null and constraint was not being retrieved from domain.

## Version 3.2 (Sep-2018)

- **New:**
  Support for Interbase 2017.

- **Fixed:**
  Error when importing MySQL 8 databases
  (Table \'mysql.proc\' doesn\'t exist).

- **Fixed:**
  Firebird/Interbase connection was not working in some situations.

## Version 3.1.2 (Jul-2018)

- **Fixed:**
  Data Modeler version information in VCL
  Subscription Manager showing incorrect after automatic update.

## Version 3.1.1 (Jul-2018)

- **Fixed:**
  SQLite database import was wrongly
  considering SQLite \"TEXT\" datatype as a (char) blob. Now it\'s
  considered as regular string (VARCHAR).

- **Fixed:**
  Importing SQLite tables with field names starting with number was
  raising error.

## Version 3.1 (May-2018)

- **New:**
  **Database metadata objects available in
  [customization script](xref:Aurelius#customization-script) events.**
  One usage example is
  [adding ForeignKey attribute to associations](xref:Aurelius#adding-foreignkey-attribute-to-associations)
  to force Aurelius create FK using the existing database foreign key
  (relationship) name.

## Version 3.0.3 (May-2018)

- **Fixed:**
  Connecting to MS SQL Server LocalDB was
  raising an error \"SQL Server does not exist or access is denied\".

## Version 3.0.2 (Mar-2018)

- **Fixed:**
  Exporting descriptions with single quotes
  to Aurelius classes was generating invalid Pascal code. The single
  quotes are now duplicated to form valid Pascal strings.

## Version 3.0.1 (Nov-2017)

- **New:**
  [OnUnitGenerated event](xref:Aurelius#onunitgenerated-event) in TMS Aurelius Export
  [customization script](xref:Aurelius#customization-script).

- **Improved:**
  Table list in [Mappings Tab](xref:Aurelius#mappings-tab) of TMS Aurelius Export Dialog
  is now sorted in alphabetical order.

- **Improved:**
  Added OID type for PostgreSQL databases.

- **Fixed:**
  When adding a property in a customization script, if property type was
  empty the generated code was adding a colon after property name:
  _\"property Name: ;\"_.

## Version 3.0 (Oct-2017)

- **New:**
  **[Customization scripts in TMS Aurelius export](xref:Aurelius#customization-script).**
  You can now customize the source code
  generated by TMS Aurelius export feature using a
  [customization script](xref:Aurelius#customization-script) that can be written in the
  [Script Tab](xref:Aurelius#script-tab) of export dialog. This adds
  lots of flexibility for you to add specific attributes, fine tune the
  generated code, and even add new fields, properties and methods to the
  classes.

- **New:**
  **[Option to export TMS Aurelius classes to several different units](xref:Aurelius#mappings-tab).**
  You now have the option to specify the name of the unit in which a class will
  be created, allowing you to better organize your classes into several units.
  If there is a cyclical reference between units, Data Modeler will warn you in
  advance giving you the chance to fix the issues.

- **New:**
  **[Model names in TMS Aurelius export](xref:Aurelius#mappings-tab).**
  Now you have an option to specify the models where an export class will
  belong to. This will create \[Model\] attributes in the class. The model
  names can also be automatically set based on the existing diagrams in
  the project (each diagram is considered to be a model).

- **New:**
  **[Source code preview in Aurelius export](xref:Aurelius#export-dialog).**
  In the Aurelius export dialog, you can new preview the source code of the
  unit(s) that will be created. It makes it easier to change settings and
  see how they affect final source code without needing to generate the
  actual files in directory.

- **New:**
  **[Modern User Interface](xref:Interface#ui-overview).**
  Ribbon user interface was updated to a new
  color theme and some ribbon elements were updated. The look and feel is
  now closer to Office 2017 style and provides a more modern and
  refreshing feeling. Splash screen has also been updated.

- **Improved:**
  Documentation has received a significant review. Contains now more
  detailed and organized topics, especially on TMS Aurelius export. The
  look and feel has also been improved in both CHM and PDF formats. A new
  online help is now available for browsing.

- **Fixed:**
  Checkboxes for defining specific default and check constraint were not
  being enabled correctly.

- **Fixed:**
  \"Access Violation\" error when clicking Exit or double click menu
  button.

## Previous Versions

### Version 2.8.1 (Dec-2016)

- Fixed: SQL Server primary key constraint ignoring field order
  (asc/desc).

### Version 2.8 (Dec-2016)

- Improved: Installers for trial and registered versions now signed to
  minimize Windows warnings and false antivirus alerts.

- Improved: Register entities option checked by default (Aurelius
  Export).

- Improved: AllButRemove is default option for association cascade type
  (Aurelius Export).

- Fixed: Data Modeler not appearing as \"installed\" in TMS
  Subscription Manager.

### Version 2.7 (Nov-2016)

- New: Support for Firebird 3 database.

### Version 2.6.1 (Oct-2016)

- Fixed: When generating Aurelius classes, constructor implementation
  is now calling inherited constructor.

### Version 2.6 (Jun-2016)

- Improved: PostgreSQL support for data types JSON and JSONB.

### Version 2.5.1 (Nov-2015)

- Fixed: Firebird database importer was failing with DOMAIN_NULL_FLAG
  error.

### Version 2.5 (Jan-2016)

- New: Option to explicitly define the type of the field/property when
  exporting model to Aurelius classes.

### Version 2.4.10 (Nov-2015)

- Fixed: Firebird stored procedures now being created with header only
  to avoid errors with procedure dependencies.

- Fixed: Firebird CREATE DOMAIN statement incorrectly generated when
  using CHECK constraints.

- Fixed: Visual glitch when displaying comments in stored procedure
  editor.

### Version 2.4.9 (Nov-2015)

- Improved: Firebird configuration allows providing the CHARSET for the
  connection. Default is UTF8.

### Version 2.4.8 (Aug-2015)

- Fixed: PostgreSQL TIMESTAMP fields were wrongly being exported to
  Aurelius as Double properties, instead of TDateTime.

### Version 2.4.7 (Aug-2015)

- Improved: When exporting memo fields to Aurelius classes, a
  _\[DBTypeMemo\]_ attribute is added for better Aurelius handling of memo
  types.

### Version 2.4.6 (Jul-2015)

- Fixed: Text block not displaying text in workflow instance if text
  was edited directly in the block (not using editor).

- New: MySQL script for workflow tables.

### Version 2.4.5 (May-2015)

- Improved: Aurelius Export Tool now supports composite keys in
  inheritance relationships.

### Version 2.4.4 (Apr-2015)

- Improved: CascadeTypeAll included as a cascade option for
  Associations when exporting to Aurelius.

### Version 2.4.3 (Apr-2015)

- Fixed: Import of SQLite databases with field names using different
  characters like \"&\" or \".\".

- Fixed: Import ot SQLite databases with default value using
  identifiers.

### Version 2.4.2 (Nov-2014)

- New: Aurelius export includes an option register all entities using
  RegisterEntity procedure (to avoid linker to remove unused classes).

- New: Firebird connection dialog includes \"Vendor Lib\" option
  allowing specify driver (for example, gds32.dll as alternative to
  fbclient.dll).

### Version 2.4.1 (Oct-2014)

- Fixed: Firebird import now retrieves descriptions using correct
  character set.

### Version 2.4 (Sep-2014)

- New: PostgreSQL 9 support.

- Fixed: Indexes marked as \"Unique Key\" not being generate as
  exclusive indexes (Indexes marked as \"Exclusive\" were working
  correctly) (2.3.3 - Aug/2014).

- Improved: Aurelius classes exported sorted by name (2.3.2 - Jul/2014).

- Fixed: Aurelius classes exported in wrong order in some complex
  inheritance hierarchy (2.3.2 - Jul/2014).

- Fixed: wrong Inheritance attribute value when exporting to Aurelius
  classes (2.3.1 - Jun/2014).

### Version 2.3 (Feb-2014)

- New: Advanced connection options for ElevateDB databases.

- New: Zoom tab in ribbon makes it easier to define diagram zoom, zoom
  to 100% or zoom to fit all.

- New: Export to Aurelius allows defining cascade types for
  associations.

- Improved: Trigger editor now expands to the whole window area making
  it easier to write trigger code.

- Fixed: Several errors reported by automatic error report (mostly
  Access Violations in some specific situations).

### Version 2.2 (May-2013)

- New: Diagram navigator allows overview of entire diagram and easy
  navigation/zooming using navigation cursor.

- Improved: Automatic selection of last used connection when importing
  database structure.

- Fixed: Timestamp fields correctly imported from Oracle databases.

- Fixed: MySQL reverse engineering was not correctly importing
  multi-column foreign keys.

- Fixed: Oracle reverse engineering was retrieving wrong size for
  NVarchar2 fields.

- Fixed: ElevateDB reverse engineering was retriving foreign keys
  incorrectly when composed of more than one field.

- Fixed: Import SQLite tables with /\*..\*/ comments in DDL command.

- Fixed: Rare AV when generating Aurelius classes unit.

### Version 2.1 (Feb-2013)

- New: Support for ElevateDB Unicode Server (in addition to existing
  support to ANSI servers).

- Improved: ElevateDB server name configuration can accept both IP
  address and host name.

- Improved: Support for Windows 8 (2.0.2).

- Improved: Connection settings in NexusDB reverse engineering now
  displays available servers automatically (2.0.1).

- Fixed: Incorrect NexusDB reverse engineering when connecting to 3.10
  and 3.11 databases using internal server (2.0.1).

### Version 2.0 (Feb-2013)

- New: TMS Aurelius Export: option to define Sequence attribute for
  each entity class.

- New: \"Duplicate table\" feature available in diagram toolbar button
  and popup menu in table list.

- New: Find toolbar button makes easy to find a table in diagram by
  name.

- New: Licensing tool which provides a much better, easier way to
  register Data Modeler.

- Improved: Better error message when exporting to Aurelius source code
  fails due to file system error.

- Improved: Id properties exported to TMS Aurelius are now read-write
  instead of read-only.

- Note: 1.9.1 version was released at the same time as 2.0 version,
  including several other improvements and all bugs fixed since version 1.9.

### Version 1.9.1 (Feb-2013)

- New: option to display relationship description/caption in diagram.

- New: support for TGuid properties and Guid/Uuid generators in
  Aurelius export.

- Improved: SQLite reverse engineering sets a default size for varchar
  and decimal data types, when not specified.

- Improved: better detection of Firebird/Interbase database server
  version.

- Improved: Clearer message when updating Data Modeler to avoid
  confusion with Windows/Data Modeler restart.

- Improved: Firebird now differentiates unique indexes from unique
  constraints.

- Improved: Better error message when trying to use unsupported
  versions of MySQL server.

- Fixed: issues with SQLite reverse engineering (incorrect SQL parsing).

- Fixed: Access Violation in Aurelius source code generator (automatic
  report).

- Fixed: When adding new trigger, syntax was incorrect for Firebird
  database.

- Fixed: Uncommon error when importing Firebird databases
  (RDB\$DESCRIPTION column unknown).

- Fixed: Aurelius source generator now generates Int64 properties for
  database fields of type BIGINT and equivalents.

- Fixed: Aurelius exporting foreign key fields that were part of
  primary key was incorrect when the property name was being changed
  manually by the user.

- Fixed: Multi-line descriptions now handled correctly when exporting
  to Aurelius classes.

- Fixed: Script viewer window now being presented correctly in
  multi-monitor desktops.

- Fixed: Wrong Alter Table statement in Firebird databases (add
  non-nullable column).

- Fixed: Importing SQLite databases with spaces in table Name.

- Fixed: All reproduceable automatic error reports up to release date.

### Version 1.9 (May-2012)

- New: Support for SQLite 3.7 databases.

- New: Option for specifying dynamic properties in class when exporting
  to TMS Aurelius.

- New: Aurelius export now has an option to singularize table names
  (convert plural table names into singular class names).

- Improved: Project check now checks if fields in a relationship have
  the same size, besides being of same type.

- Improved: Hint for recent files in menu makes it easier to see full
  file name.

- Improved: Better saving of form position and state
  (maximized/minimized).

- Fixed: issue with ribbon menu when windows is set to use big-sized
  fonts.

- Fixed: Parent and child fields in relationship could have different
  data types in some cases (varchar with different sizes).

- Fixed: duplicated drop constraints in sql server when both default
  value and constraint default name were changed.

- Fixed: internal issue with having duplicated id\'s for objects.

- Fixed: MySQL drop index and drop foreign key statements had incorrect
  syntax.

- Fixed: double data types were being imported incorrectly in MySQL.

- Fixed: 0000748 \[SQL Script\] Check creation order of objects in SQL
  Script (firebird).

- Fixed: 0001084 \[Comparer\] Firebird-Merge Function-Stored
  Procedure-No input parameters generate a header with an integer type but
  no variable name.

- Fixed: 0001083 \[Comparer\] Firebird - Using Merge Function - Stored
  Procedure scripts Terminator missing.

- Fixed: Automatic reports 0001187, 0001162, 0001238.

### Version 1.8 (Jan-2012)

- 0001145: New: Export classes to TMS Aurelius framework.

- 0001158: \[Interface\] New window to find a table in diagram using
  Ctrl+F.

- 0001152: \[Interface\] New: \"Find field\...\" option to search for
  fields in field grid in table editor. Can also use Ctrl+Shift+F.

- 0001151: \[Interface\] New: \"Find in Diagram\" popup menu option in
  table list makes it easy to find a table in the diagram.

- 0001149: \[Reverse engineering\] New: Import field descriptions from
  SQL Server.

- 0001159: \[Interface\] Automatically selects a child field when
  creating a new relationship if same field name and type as parent.

- 0001146: \[Interface\] New: New diagram popup menu options \"All Keys
  and Indexes\" in diagram context menu.

- 0001156: \[Interface\] Diagram popup menu option to create
  relationship using selected table.

- 0001150: \[Interface\] Fixed: Dragging a table to a scrolled or
  zoomed diagram puts the table at wrong position.

- 0001148: \[Interface\] Improved: Deleting a field causes grid
  flickering and scrolling.

- 0001147: \[Interface\] Improved: Put close button on tabs.

- Other bug fixes. Tracker items: 0001142, 0001044, 0001087, 0001119,
  0001109, 0001160, 0001161.

### Version 1.7.1 (Feb-2011)

- 0000902: Object comments imported from Firebird databases in reverse
  engineering.

- 0000903: Script generation and comparison for object comments
  (Firebird).

- Other minor bug fixes and small improvements. Tracker items: 0000505,
  0000506, 0001031, 0001033, 0001034, 0001042.

### Version 1.7 (Dec-2010)

- 0000871: Included support for ElevateDB.

- Bug fixes. Tracker items: 0000945, 0000956.

### Version 1.6 (Nov-2010)

- 0000923: Included support for Microsoft SQL Azure.

- 0000954: \[Reverse engineering\] Database server version check before
  perform reverse engineering.

- 0000933: Fixed: \[Interface\] Window state not restored when main
  form is maximized.

- Other minor bug fixes. Tracker items: 0000886, 0000895, 0000910.

### Version 1.5.1 (Oct-2010)

- 0000392: \[Interface\] Persistence of size and position of windows.

- 0000402: \[Interface\] New keyboard shortcuts and context options on
  interface.

- 0000414: \[Project checking\] Option to update the version files
  after saving a project as a different name.

- 0000489: \[Interface\] New option \"Select all\" in diagram context
  menu.

- 0000680: \[Interface\] New option \"Close all except this\" in tabs
  context menu.

- 0000681: \[Interface\] New option to set text colour on notes.

- 0000852: \[Interface\] Improved resizing of controls in table editor.

- 0000857: \[Reverse engineering\] Issues in reverse engineering from
  MySQL databases.

- 0000828: \[SQL Script\] Issue with expression of check constraints
  retrieved from Firebird databases.

- 0000823: \[Reverse engineering\] Issue importing UTF8 defined fields
  from Firebird databases.

- 0000746: \[SQL Script\] Fixed use of NULL/NOT NULL constraints in SQL
  script for computed columns (SQL Server).

- 0000602: \[Interface\] Fixed not null option in child field created
  automatically for a non-identifying relationship.

- 0000601: \[Interface\] Issues with suggestion of fields in Child
  Table when creating a relationship.

- 0000569: \[Interface\] Issues with editing of check constraint
  fields.

- 0000482: \[Interface\] Issues with editing of domain fields.

- Other bug fixes and small improvements. Tracker items: 0000243,
  0000559, 0000563, 0000649, 0000656, 0000729, 0000735, 0000785, 0000792,
  0000798, 0000802, 0000807, 0000817, 0000841, 0000854.

### Version 1.5 (Aug-2010)

- 0000694: \[SQL Script\] Support for MySQL 5.1 databases.

- 0000734: \[Interface\] Option for inserting any object in popup menu
  of the explorer.

### Version 1.4.0.1 (Mar-2010)

- 0000702: \[Internal\] Error loading project file (reading
  TGDAODiagram.DiagramString).

### Version 1.4 (Mar-2010)

- 0000693: \[SQL Script\] Support to Oracle 10g databases.

- 0000650: \[Reverse engineering\] Allow \"Server:Port\" syntax in
  NexusDB server name connection.

- Other bug fixes and small improvements. Tracker items: 0000696,
  0000688, 0000659, 0000658, 0000664, 0000667, 0000668, 0000686, 0000687.

### Version 1.3.1 (Aug-2009)

- 0000648: \[Interface\] Use default tray icon balloon hint for update
  notification. Allow update notification for trial versions.

- 0000647: \[Interface\] Allow setting font name, size and shape color
  for diagram blocks.

- 0000645: \[SQL Script\] Invalid column name in alter script.

- Other bug fixes and small improvements. Tracker items: 0000644,

604.

### Version 1.3 (Jul-2009)

- 0000622: \[SQL Script\] Support for NexusDB database.

- Other bug fixes and small improvements. Tracker items: 0000626,
  0000636, 0000623, 0000552, 0000617, 0000608.

### Version 1.2 (Jun-2009)

- 0000613: \[SQL Script\] Support for SQL Server 2008.

- 0000615: \[Interface\] Allow setting paper size, orientation and
  measurement units for diagram printing.

- 0000614: \[Reverse engineering\] Char size and domain issues with SQL
  Server 2000 reverse engineering.

- Other bug fixes and small improvements. Tracker items: 0000609,
  0000600, 0000606, 0000605, 0000597, 0000598, 0000534, 0000492.

### Version 1.1 (May-2009)

- 0000405: \[Internal\] Support for Absolute Database.

- 0000589: \[Interface\] Diagram Print Preview feature included.

- Other bug fixes and small improvements. Tracker items: 0000577,

580.

### Version 1.0 (Apr-2009)

\- First official 1.0 release.
