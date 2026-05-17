---
uid: Operations
---

# Basic Operations

The following topics describe the most common used operations in
TMS Data Modeler.



## Creating a New Project


### New blank project

To create a new blank project:

1. Select *New* / *New project* on the File Menu or select
*New blank project* after clicking on the *New* icon in the
quick access toolbar.

2. On the *New Project* dialog, select the desired target
database and click *Ok*.


You can also use the shortcut *Ctrl+N* or click on the icon
of the project toolbar to open the *New Project* dialog.


### New project from existing database

The [reverse engineering](#reverse-engineering) tool from TMS Data Modeler
creates a project from an existing database, so you can manage,
view and edit all current information easily.

Check the desired DBMS step-by-step process to create your project:


Select *New* / *Import from database* from the File Menu or select
*New project* from database after clicking the *New* icon in quick
access toolbar. On the *Data dictionary import* dialog, you can either
select an existing connection or a new connection.


If you select **Existing connection**:

1. Choose the *Connection* name from the list and click *Next*.

2. The *Data dictionary import* dialog will open, showing a progress bar
so you can follow the import process. When it\'s finished, the message
*Done* will appear and the *Next* button will be enabled again. Click to
continue. This will enable the button *Finish*. After clicking, the
process will be complete.


If you select **New connection**:

1. Choose the *Database type* from the list and click *Next*.

2. Different DBMS will ask you for different information to be filled
in on *Data dictionary import* dialog. It is necessary to complete this
screen before proceeding.

3. Fill in the connection settings then click on \"Test connection\".
If there are no connection problems, click *Next*.

4. The *Data dictionary import* dialog will show a progress bar so you
can follow the import process. When it\'s finished, the message *Done*
will appear and the *Next* button will be enabled again. Click to
continue.

5. The last screen of the *Data dictionary import* dialog will allow you
to save the current connection settings for future use. Select the
checkbox and type the connection name if you wish to do so. Otherwise,
uncheck the option and click *Finish*.



## Creating Objects in Database Model


### Tables

To create a new table:

1. Select *Table* on the *Create* tab on the *Home* ribbon or right-click
on the Project Explorer and select *Add table*. You may also use the
shortcut *Ctrl+T* to create a new table.

2. The *Table editor* will open on the Workspace. You can add or edit all
table data by selecting the different internal tabs: *Fields*, *Indexes*,
*Check constraints*, *Triggers* and *Comments*.


### Table Fields

To create fields in a table:

1. Open the desired table by selecting *Tables* on the Project Explorer
and double clicking on the table\'s name on the list.

2. The *Table editor* opens with the *Fields* tab selected by default.
This tab is divided into three sections: *Fields list*, *Field properties*
tab and *Description* tab.

3. On the Fields list, click on the *Add* button or right-click on the
list background and select *Add field*. You may also create a new field by
using the shortcut *Ctrl+F*.

4. Enter the field data on the *Field properties* section. To get detailed
information, take a look at the [Fields editor](xref:Editors#fields-tab) topic.


### Relationships

To create a new relationship between tables:

1. Select *Relationship* on the *Create* tab on the *Home* ribbon or
right-click on the Project Explorer and select *New relationship*.

2. On the *New relationship* dialog, select the relationship type by
clicking on one of the buttons:

  - *Non-identifying relationship*: it\'s the most usual type of relationship.
It represents a weak connection, a relationship between parent and child
table that does not involve a key field, such as the relationship
between tables \"Products\" and \"Categories\", for example.

  - *Identifying relationship*: a relationship where the related fields from
the child table are part of the key which identifies a unique record in
this table. It indicates a strong connection, such as the relationship
between tables \"Order details\" and \"Products\", for example. There
are no \"Order details\" without a related \"Product\", and the
\"Product\" is part of the key of the \"Order details\" table.

3. Select the *Parent table* and the *Child table* from the lists, and
click *Ok*.

4. The *Add relationship* dialog will open, allowing you to specify all
relationship data:

  - In the **Relationship properties** section, you may visualize or set the
  relationship name and its description, for future reference. A default
  relationship name is created automatically when adding a new
  relationship to the project, combining parent and child table names. The
  relationship name may be edited at any time.

  - In the **Relationship keys** section you may visualize or edit the
  relationship keys by selecting them from the available list.

    - *Parent key*: Lists all available keys (primary keys and indexes)
    from the parent table.

    - *Parent table*: This column shows all fields on the parent table which
    are part of the selected parent key. It is not possible to modify this data.

    - *Child table*: This column lists all fields on the child table that are
    compatible with the selected field on the parent table (same type). By
    default a new field listed as \"field_name(new)\" with the same name and
    type of the parent key is created and selected. It is possible to select
    any other available child field from the list.

  - In the **Relationship options** section, you are able to select the
  relationship behavior when a record on the parent table is deleted or
  updated:
  
    - *No action*: No action is taken when there are changes on the parent table.
    This is the default option.

    - *Cascade*: Automatically deletes all records on the child table when a parent
    record is deleted. Example: Customer/Contact, when deleting a customer,
    all of its contacts are also deleted.

    - *Set null*: when a parent record is deleted, all child records related to it
    get this field set to null. Example: on the Person/Gender deletion, all
    people related to this record would be set to null.

    - *Set default*: similar to \"set null\" option, but instead of setting the
    field to null, it is filled with its default value.

5. The created relationship will be listed under the *Relationship*
branch of the Data Dictionary tree. To edit any of the relationship
data, double-click on the relationship on the Project Explorer and the
*Relationship editor* will open.


You may also create a relationship visually, by using a
[Diagram](xref:Editors#creating-relationships). It will
open the same *New relationship* dialog to allow properties setting.



## Comparing projects

To compare two different projects, you may use the *Merge projects* tool.
It will allow you to visualize their differences and to generate an
impact script to update your database with information on both projects.

1. Select *Merge* on the *Project* tab on the *Home* ribbon.

2. On the *Compare projects* dialog, select the path and the file of the
project you want to merge with the current one and click *Next*.

3. The *Compare projects* dialog will now list each project\'s objects.
All selected objects are organized hierarchically in two synchronized
project trees. You are able to edit the information below:

  - *Hide unchanged items*: When selected, this option hides all items
  that are equivalent in both projects. The only items shown are the ones
  that differ or are present in only one of the projects. By default, this
  option is unchecked and all objects are shown, with the differences
  highlighted in bold.

  - *Filter the desired objects*: Selects which objects are compared on
  the project trees. The options are *Tables*, *Indexes*, *Relationships*,
  *Triggers*, *Domains*, *Procedures* and *Views*. By default all objects
  are checked.

  - *Action*: Defines which action will be taken regarding the differences found
  after project comparison. By default, the option *Generate database script* is
  selected, and results in the generation of an impact script to update
  the database with all the selected differences after clicking *Generate*.

  - *Project trees*: The objects that differ between the projects are in **bold**.

    - The middle column allows you to select changes to be included on the impact
    script. Selected changes are marked with a fingerpoint icon.

    - By expanding the bold objects you will get to the exact item where the
    difference is. For example, if a field exists in one project but does
    not exist on the other, the corresponding tables are in bold. When
    expanding the table, the item *Fields* is in bold, and when expanding
    Fields, only the different fields remain in bold.

    - When clicking on the bold object, the object creation scripts are compared
    side by side highlighting the differences on the text boxes below.

    - When an object is non-existent in one of the projects, it is signalized on
    this project tree with the text \'(not exists)\' besides the equivalent
    field on the other project. In this case, the impact script will
    generate commands to add or remove the item.

4. By clicking *Generate*, an impact script will be created and shown to
allow you to update your current database with the merged projects\'
settings. Selecting *Back* will take you to the dialog to select other
projects to be compared. Selecting *Close* will close the dialog without
saving any changes.



## Generating Database Creation Scripts

TMS Data Modeler\'s database generation tool allows you to plan and
design your database in a single project, creating a script that
generates your database automatically. You may also create impact
scripts to update a database that has already been created before, by
comparing versions or projects.


To generate a database creation script:

1. Select *Generate script* on the *Project* tab on the *Home* ribbon
or press **F9**.

2. The *Script generation* dialog will open with the following information:

  - *Show the script*: Selecting this option will allow you to edit any further
  details by opening a dialog with the script after clicking *Generate*.

  - *Save script to file*: Selecting this option will allow to choose the file
  path and file name and save it for later use without opening it after
  clicking *Generate*.

  - *Workspace*: An item tree where you can check the desired items to be
  deployed. You may check one or more objects.

3. On the *Tables* tab, all project tables are listed by name. All tables
are selected by default. You may choose which tables will be created
through the script.

4. After selecting all desired items and tables, click *Generate*. The
tab *Process* will appear, listing all steps of the script generation.



## Project Validation

TMS Data Modeler offers a tool to validate all project items, checking
consistency and settings of objects.


To validate your project, select *Check* on the *Project* tab on the *Home*
ribbon. All project messages are then shown on the *Messages window*,
which is at the bottom of the application, under the workspace.


- *[Error message](#error-messages)*: Refers to an error on the settings
of a project object that will cause problems when generating a database,
for example a relationship between two tables without defined fields/keys.

- *[Warning message](#warning-messages)*: Refers to a possible consistency
problem that may cause problems when generating a database, for example a
relationship between two tables where the selected fields/keys are not compatible.


Right-clicking on any message opens a context menu will allowing you to
*Go to the related object*, *Clear messages* or *Save messages*. You can
also go to the related object by double-clicking on the message.


Below follows a list with all possible validation messages. Messages
about *\[object\]* are regarding extra objects, such as procedures, views
and generators.


### Error Messages

- Constraint has no name on table \[table\].

- Duplicate constraint name \[constraint\] on table \[table\].

- Duplicate domain name \[domain\].

- Duplicate field name \[field\] on table \[table\].

- Duplicate index name \[index\] on table \[table\] (all DBMS except
Firebird): a table contains more than one index with the same name.
Index names must be unique on the table.

- Duplicate index name \[index\] (table: \[table\]) (only on Firebird):
the project contains more than one index with the same name. Index names
must be unique on the database.

- Duplicate \[object\] name \[name\].

- Duplicate relationship name \[relationship\].

- Duplicate table name \[table\].

- Duplicate trigger name \[trigger\] on table \[table\].

- Empty expression on computed field. Field: \[field\] on table \[table\].

- Field has no name on table \[table\].

- Identity field cannot have a default value. Field: \[field\] on table
\[table\].

- Increment value cannot be zero on identity fields. Field: \[field\] on
table \[table\].

- Index has no name on table \[table\].

- Index \[index\] on table \[table\] has no linked fields.

- Invalid constraint name \[constraint\] on table \[table\].

- Invalid field name \[field\] on table \[table\].

- Invalid index name \[index\] on table \[table\].

- Invalid \[object\] name \[name\].

- Invalid relationship name \[relationship\].

- Invalid table name \[table\].

- Invalid trigger name \[trigger\] on table \[table\].

- Missing child field on relationship \[relationship\] (link \#\[N\]).

- Missing parent field on relationship \[relationship\] (link \#\[N\]).

- \[Object\] has no name.

- Relationship has no name.

- Relationship \[relationship\] has no linked fields.

- Relationship \[relationship\] is self-referencing and can only accept
ON DELETE NO ACTION and ON UPDATE NO ACTION methods (only on SQL Server).

- Size out of range on field \[field\] (table \[table\]). Size must be
between \[min\] and \[max\].

- Table has no name.

- Table \[table\] contains two identity fields.

- Trigger has no name on table \[table\].


### Warning Messages

- Constraint name \[constraint\] on table \[table\] is a reserved word.

- Field name \[field\] on table \[table\] is a reserved word.

- Incompatible data types (\[parent field\]/\[child field\]) on
relationship \[relationship\].

- Index name \[index\] on table \[table\] is a reserved word.

- Missing expression on check constraint \[constraint\] (table \[table\]).

- Name too long for constraint \[constraint\] on table \[table\]. Maximum
size is \[size\] characters.

- Name too long for field \[field\] on table \[table\]. Maximum size is
\[size\] characters.

- Name too long for index \[index\] on table \[table\]. Maximum size is
\[size\] characters.

- Name too long for \[object\] \[name\]. Maximum size is \[size\]
characters.

- Name too long for relationship \[relationship\]. Maximum size is
\[size\] characters.

- Name too long for table \[table\]. Maximum size is \[size\] characters.

- Name too long for trigger \[trigger\] on table \[table\]. Maximum size
is \[size\] characters.

- \[Object\] name \[name\] is a reserved word.

- \[Object\] \[name\] has no create implementation.

- Parent index \[index\] of relationship \[relationship\] is not unique.

- Relationship name \[relationship\] is a reserved word.

- Size was not specified on field \[field\] (table \[table\]).

- Table name \[table\] is a reserved word.

- Table \[table\] has no fields.

- Table \[table\] has no primary key.

- Trigger name \[trigger\] on table \[table\] is a reserved word.

- Trigger \[trigger\] on table \[table\] has no implementation.



## General Project Settings

To edit general project settings:

1. Select *Settings* on the *Project* tab on the *Tools* ribbon.

2. The *Settings* window will open.


To edit general settings click on the *Information* tab. You are able to
edit the *Project name*, *Author* and *Description*.


To select the working directory for your project versions, click on the
*Version control* tab. The working directory where project versions are
saved is shown. You can use the default *\\versions* directory or select a
different directory by clicking on the folder icon.



## Version Control

TMS Data Modeler allows you to version control your database model. This
means you can archive (snapshot) your existing model into versions and
then later compare versions to check differences between them and
generate SQL update scripts to \"upgrade\" the database schema from one
version to another.


### Creating (archiving) versions

To archive the version you are currently working on and start the next
one, select *Archive* on the *Versions* tab in the *Home* ribbon or click
on the File Menu button and select *Archive version*.

The dialog will allow you to add any relevant information to identify
this version later. By clicking *Archive* you will automatically close
this version and start the subsequent one.


### Version management window

To open the version management window, select *Manage* on the *Versions*
tab in the *Home* ribbon.

The *Project versions* window will list all saved versions, the last
date/time of the alterations and the complete file name.


### Compare versions

To perform a comparison between versions:

1. Select *Compare* in the *Versions* tab of the *Home* ribbon.

2. You will be prompted to select the *Base version* and the
*Compare to version*. Any existing version can be chosen.

3. The *Compare versions* window will list each version\'s objects.
All selected objects are organized hierarchically in two synchronized
project trees. You are able to edit the information below:

  - *Hide unchanged items*: When selected, this option hides all items
  that are identical in both versions, unchanged by update/insert/delete.
  The only items shown are the ones that differ. By default, this option
  is unchecked and all objects are shown, with the differences highlighted
  in **bold**.
  
  - *Filter the desired objects*: Select which objects are compared on the
  project trees. The options are *Tables*, *Indexes*, *Relationships*,
  *Triggers*, *Domains*, *Procedures* and *Views*. By default all
  objects are checked.

  - *Action*: Defines which action will be taken regarding the differences
  found after version comparison. By default, the option *Generate database script*
  is selected, and results in the generation of an impact script to update
  the database with all the selected differences after clicking *Generate*.

  - *Project trees*: The objects that differ between the versions are in bold.

    - The middle column allows you to select what changes will be included on the
    impact script. Selected changes are marked with a checkbox icon.

    - By expanding the bold objects you will get to the exact item where the
    difference is. For example, if a field exists in one version but does
    not exist on the other, the corresponding tables are in bold. When
    expanding the table, the item *Fields* is in bold, and when expanding
    Fields, only the different fields remain in bold.

    - When clicking on the bold object, the object creation scripts are compared
    side by side highlighting the differences on the text boxes below.

    - When an object is non-existent in one of the versions, it is signalized on
    this project tree with the text \'(not exists)\' besides the equivalent
    field on the other project. In this case, the impact script will
    generate commands to add or remove the item.

4. By selecting *Generate*, an impact script will be created and shown
to allow you to update your current version with the compared versions\'
settings. Selecting *Back* will take you to the dialog to select other
versions to be compared. Selecting *Close* will close the dialog without
saving any changes.



## Reverse Engineering

The reverse engineering tool from TMS Data Modeler creates a project
from an existing database, so you can manage, view and edit all current
information easily.


To create a new  project from an existing database, select *New* /
*Import from database* from the File Menu or select *New project from database*
after clicking the *New* icon in Quick Access Toolbar. In the
*Data dictionary import* dialog, you can either select an existing
connection or a new connection.


If you select **Existing connection**:

1. Choose the *Connection* name from the list and click *Next*.

2. The *Data dictionary import* dialog will open, showing a progress bar
so you can follow the import process. When it\'s finished, the message
*Done* will appear and the *Next* button will be enabled again. Click to
continue. This will enable the button *Finish*. After clicking, the
process will be complete.


If you select **New connection**:

1. Choose the *Database type* from the list and click *Next*.

2. Different RDBMS will ask you for different information to be filled
in on *Data dictionary import* dialog. It is necessary to complete this
screen before proceeding. Fill in the specific connection settings
according to the RDBMS you have chosen.

3. Click on *Test connection* to make sure your settings are correct. If
there are no connection problems, click *Next*.

4. The *Data dictionary import* dialog will show a progress bar so you
can follow the import process. When it\'s finished, the message *Done*
will appear and the *Next* button will be enabled again. Click to
continue.

5. The last screen of the *Data dictionary import* dialog will allow you
to save the current connection settings for future use. Select the
checkbox and type the connection name if you wish to do so. Otherwise,
uncheck the option and click *Finish*.



## Convert Project to Different Database

Each Data Modeler project has a specified target database. You can
change the target database which will perform a conversion operation in
the project, changing the table column types from one database to
another. To help you in the process, you can use field mapping concept
using conversion maps.


### Conversion Maps

Field mapping is the process of selecting equivalences of data type
between different RDBMS. Using these maps, a project can be converted
from one RDBMS to another without data loss. To view all existing
field/conversion maps open the *Conversion maps* dialog, by selecting
*Conversion maps* in the *General* tab of the *Tools* ribbon.

{{#image}}conversion-maps.png{{/image}}


This dialog enables you to edit or remove existing conversion maps and
to create new ones by clicking on the appropriate button. By default,
only conversion maps created using TMS Data Modeler are displayed. To
see all conversion maps available in your system, select the checkbox
*Show system conversion maps* at the bottom of the screen.


By clicking *Edit*, the *Data type conversion map* dialog will open,
allowing you to visualize and edit all conversion map info:

  - *Source database*.

  - *Target database*.

  - *Name*: Name of this particular conversion map.

  - *Conversion map*:

    - *Source type*: Shows all field types available on the Source database.

    - *Target type*: Shows data types supported by the Target database that are
    compatible to the corresponding Source type. This information will be
    used when converting projects between databases.

    - *Size/length and Precision*: Allows setting of some data types, such as
    numeric fields, which is then used for this data type in conversions to the
    target database. The option *Keep* (default) uses the same property value
    from the source database on the target database.

{{#image}}conversion-map-editor.png{{/image}}


### Database conversion

Before converting your project between databases, make sure you have a
field map for them. Having created the field map, select *Convert* in the
*Project* tab of the *Tools* ribbon. The *Convert database* dialog will open,
enabling you to select your target database. Only mapped databases will
appear on the list. After selection, click *Ok*.

{{#image}}database-conversion.png{{/image}}
