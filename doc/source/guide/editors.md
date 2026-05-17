---
uid: Editors
---

# Editors

The following topics present the different TMS Data Modeler editors.


## Table Editor

The table editor allows you to view and edit all table settings, such as
its [Fields](#fields-tab), [Indexes](#indexes-tab),
[Constraints](#check-constraints-tab), [Triggers](#triggers-tab)
and Comments. Each of these items has all settings organized inside 
tabs on the Table editor, to improve visualization.


To access the table editor, double-click on the desired table on the
Project explorer or on a Diagram. When opening a table by
double-clicking on a diagram, the *Back to diagram* button is enabled, so
you can easily return to the original diagram.


### Fields Tab

The fields tab inside the table editor is divided into three sections:
*Fields list*, *Field properties* tab and *Description* tab.


The fields list shows all field names and types. You may add, remove or
reorder all fields using the icons on the top left of the list.
Right-clicking on any part of the list will open a context menu with
these same functions, plus a *duplicate field* option and the option to
*copy field to clipboard*.

Copying to clipboard offers three options: List of fields, which will
create a comma-separated list of all fields in this table; INSERT command,
which will create an insert script to generate a record with all the fields;
and UPDATE command, which will create an update script.


All required fields are shown in **bold**. The vertical key icon identifies
fields which are part of the table\'s primary key. The horizontal key
icon/FK text identifies a foreign key related to a parent table.


Selecting the desired field, all of its properties can be edited in the
Field properties tab:

- *Field name*.

- *Domain*: the domain that will be used to define settings such as type
and size of the selected field. All settings automatically loaded from
the domain will be filled and their respective editors will be disabled.

- *Primary key*: defines if the selected field is part of the table\'s
primary key. These keys may be set by selecting the checkbox or through the
*Indexes* tab where specification and ordering of these fields can be done.

- *Logic type*: defines the concept type of the selected field, usually
corresponding to the physical type in the database. All data types supported
by the DBMS in use are available for selection. Depending on your choice of
logic type, different options will be enabled in the editor. Selecting any
*Identity* type, such as *Int (identity)* on SQL Server, the *Identity*
section will be enabled, allowing you to set automatic increments on the field.

  - *Seed*:  defines the initial number of an auto-increment field.

  - *Increment*: defines the increment value of an auto-increment field.

- *Size*: this editor will be enabled when applicable, as for alphanumeric types.

- *Precision*: decimal and numeric types will enable this editor. It defines
precision for these data types.

- *Physical type*: non-editable. It displays the settings of the physical type
applied in the field when the database is generated, based on specifications of
logic type, size etc. This editor shows the exact definition of this field on
the generated script.

- *Not null constraint*: it will require a not-null value for the field when
inserting or updating a record, making this a required field.

- *Check constraint*:

  - *Check expr.*: a formula for validation / condition that must always be true.
  For example, the field *Age* could have a check constraint of *\"Age \> 18\"*.
  It will not be possible to insert a record in this table that does not satisfy
  this condition. This editor is automatically filled and disabled for changes
  if an existing domain with a check constraint is selected on the Domain list.

  - *Specific*: is only enabled when an existing domain with a check constraint
  is selected on the Domain list. If checked, it allows changes on the expression
  only applied to this specific field. It\'s unchecked by default.

  - *Constraint name*: optional information, enabled when an expression is entered
  on the *Check expr.* editor.

- *Default value*:

  - *Default value*: the field is automatically filled with a specific value when
  inserting a new record in the table. This editor is automatically filled and
  disabled for changes if an existing domain with a default value is selected on
  the Domain list.

  - *Specific*: is only enabled when an existing domain with a default value is
  selected on the Domain list. If checked, it allows changes on the value only
  applied to this specific field. It\'s unchecked by default.

  - *Constraint name*: optional information, enabled when a value is entered on
  the *Default value* editor.


### Indexes Tab

The indexes tab inside the table editor is divided in three sections:
*Indexes list*, *Index properties* and *Index fields*.

The Indexes list shows all indexes present on a table. You may add or
remove indexes by using the buttons on the top right of the indexes list
or by right-clicking anywhere on its area. A key field is identified by
the key symbol.


In the Index properties section you may have two data editors:

- *Index name*: it is always enabled, allowing you to add or change the
index name.

- *Index type*: is only enabled when a non-primary index is selected.
Valid options are:

  - *Non exclusive*: index does not enforce any validation, it\'s just
  used for performance.

  - *Exclusive*: index is exclusive (unique) which means it won\'t allow
  duplicated values for the index fields.

  - *Unique Key*: index is actually an Unique Key constraint. Exclusive
  and UniqueKey usually have the same effect, the difference is when
  index is \"Unique Key\", it will be created as unique constraint in
  table (usually the database will create an internal exclusive index
  to enforce the unique key).


In the Index fields section, you may add or remove fields from the index.
When clicking *Add field to index*, all available fields on the table will
be shown for your selection. The fields in the index can be ordered by
clicking on the heading of the column order, allowing Ascending (default)
or Descending options.


### Check Constraints Tab

The Check constraints tab inside the table editor is divided in two
sections: *Constraints list* and *Constraints properties*.


In the Constraints editor you may view all constraints related to the
selected table on the Constraints list. By selecting them, you can edit
its name and expression in the Constraint properties section. You may
add or remove constraints by using the buttons on the top right of the
constraints list or by right-clicking anywhere on its area.


### Triggers Tab

The Triggers tab inside the table editor is divided in tree sections:
*Triggers list*, *Trigger properties* and *Implementation*.


In the Triggers list, all triggers related to the selected table are
listed. Triggers are procedures executed every time an update / insert /
delete is executed in a given table. It works as a code programmed in
the DBMS language.


In Trigger properties, you may edit the name of this trigger and its
description.


In Implementation, the complete command to generate the trigger in the
database is shown for edition. When you create a trigger, it
automatically implements:

```sql
CREATE TRIGGER <%TriggerName%> ON <%TableName%>
```

These macros `<%...%>` are replaced by the trigger\'s and the table\'s
names, so you can rename both trigger and table without having to update
this implementation.



## Domains

To create domains:

1. Select *Domains* on the *Create* tab on the *Home* ribbon.

2. On the *Domains editor* dialog, you may create a domain by
right-clicking on the Domains lists or selecting of the *Add* buttons.
This dialog allows creation of two types of domains, which are indicated
at the bottom of the screen as \'Logical domain (not in database)\' or
\'Physical domain (kept in database)\':

  - *Physical domain*: created as a \'domain\' object and kept in the
  database (command \'CREATE DOMAIN\'). A field using this type of
  domain is generated through a direct reference to this object.

  - *Logical domain*: used only on Data Modeler\'s project, not created
  physically in the database. A field using this type of domain is
  generated with the properties defined by this domain.

3. You are able to set all domain data on the *General* tab:

  - *Domain name*.

  - *Data type*: lists all available data types on the DBMS in use.

  - *Physical type*: non-editable. It displays the settings of the
  physical type applied in the domain/field when the database is
  generated, based on specifications of logic type, size etc. This
  editor shows the exact type definition on the generated script.

  - *Size*: this editor will be enabled when applicable, as for
  alphanumeric types.

  - *Precision*: decimal and numeric types will enable this editor.
  It defines precision for these data types.

  - *Seed*: identity types will enable this editor. It defines the
  initial number of an auto-increment field.

  - *Increment*: identity types will enable this editor. It defines
  the increment value of an auto-increment field.

  - *Default value*: the field is automatically filled with a specific
  value when inserting a new record in the table.

  - *Constraint*: a formula for validation / condition that must
  always be true. For example, the field *Age* could have a check
  constraint of *\"Age \> 18\"*. It will not be possible to insert
  a record in this table that does not satisfy this condition.

4. On the *Information* tab, you are able to add any documentation or
description info to better identify the domain later. The *Usage* tab
allows you to visualize all the domain\'s related fields on all project
tables.

5. By clicking *Close*, all updates will be saved.


### Using Domains

To associate a field with an existing domain, go to the *Fields* tab on
the *Table editor*. On the *Properties* tab, select the desired domain from
the list. All settings automatically loaded from the domain will be
filled and editors related to these settings will be disabled.


You can manage all domain information in the *Domain editor*. To open the
editor, select *Domains* on the *Create* tab on the *Home* ribbon.


By selecting a domain from the Domain list, you are able to view and
edit its settings on the *General* tab, automatically adjusting all
related fields. You can also update its description by editing the
*Information* tab, or visualize its related fields on all project tables
on the *Usage* tab.



## Diagrams

To create new diagrams:

1. Right-click on the project explorer and select *New diagram* or press
*CTRL+D*.

2. A new blank diagram will open in the workspace.

3. The *Design* ribbon is enabled. You may edit and add objects to the
diagrams on the workspace:

  - by selecting the desired option on the *Insert* tab on the *Design*
  ribbon and dropping the item on the diagram;

  - or right-clicking on the existing diagram items or on the workspace.


### Inserting Tables

To insert tables in a diagram:

- To insert an existing table, drag and drop the desired table from the
Project explorer to the Workspace.

- To add all tables and their relationships, right-click the workspace and
select *Add all tables*.

- To add a new table, select *Table* on the *Insert* tab on the *Design*
ribbon and release it into the Workspace.


You are able to edit the tables\' properties by double-clicking on them,
which opens a new *Table editor* tab on the Workspace.

 
### Creating Relationships

All existing relationships are automatically shown in a diagram when its
related tables are inserted. To create a new relationship between two
tables in the diagram:

1. Click *Relationship* or *Non-ID Relationship* on the *Insert* tab on
the *Design* ribbon.

  - *Non-ID Relationship*: This is the most usual type of relationship.
  It represents a weak connection, a relationship between parent and
  child table that does not involve a key field, such as the relationship
  between tables \"Products\" and \"Categories\", for example.

  - *(ID) Relationship*: A relationship where the related fields from the
  child table are part of the key which identifies a unique record in
  this table. It indicates a strong connection, such as the relationship
  between tables \"Order details\" and \"Products\", for example. There
  are no \"Order details\" without a related \"Product\", and the
  \"Product\" is part of the key of the \"Order details\" table.

2. Drag a line from the Parent table to the Child table. Upon release,
the *Add relationship* dialog will open.

3. On the *Add relationship* dialog, fill in with the relationship data:

  - In the *Relationship properties* section, you may visualize or set the
  relationship name and its description, for future reference. A default
  relationship name is created automatically when adding a new
  relationship to the project, combining parent and child table names.
  The relationship name may be edited at any time.

  - In the *Relationship keys* section you may visualize or edit the
  relationship keys by selecting them from the available list.

    - *Parent key*: Lists all available keys (primary keys and indexes)
    from the parent table.

    - *Parent table*: This column shows all fields on the parent table
    which are part of the selected parent key. It is not possible to
    modify this data.

    - *Child table*: This column lists all fields on the child table
    that are compatible with the selected field on the parent table
    (same type). By default a new field listed as \"field_name(new)\"
    with the same name and type of the parent key is created and selected.
    It is possible to select any other available child field from the list.

  - In the *Relationship options* section, you are able to select the
  relationship behavior when a record on the parent table is deleted or
  updated:

    - *No action*: no action is taken when there are changes on the parent
    table. This is the default option.

    - *Cascade*: automatically deletes all records on the child table when
    a parent record is deleted. Example: Customer/Contact, when deleting a
    customer, all of its contacts are also deleted.

    - *Set null*: when a parent record is deleted, all child records related
    to it get this field set to null. Example: on the Person/Gender deletion,
    all people related to this record would be set to null.

    - *Set default*: similar to \"set null\" option, but instead of setting
    the field to null, it is filled with its default value.

4. The relationship will appear on the diagram, connecting both tables.
Relationship lines allow easy visualization of different properties on
the relationship, such as:

  - Identifying relationships are represented by continuous lines,
  while non-identifying relationships are represented by dotted lines.

  - A crow\'s foot at the end of the line indicates many records,
  while single line ends represent a single record.

  - A red line represents a weakly defined relationship, missing specific
  fields, for example.

5. The created relationship will be listed under the *Relationship*
branch of the Data dictionary tree. To edit any of the relationship
data, double-click on the relationship on the Project explorer and the
*Relationship editor* will open.


### Adding Notes

To add notes to a diagram:

1. Select *Note* on the *Insert* tab on the *Design* ribbon and release the
note on the desired point of the Workspace.

2. You may edit the note by right-clicking on it. The context menu will
allow you to Edit text, change color or font and remove the note.


### Customizing the Diagram

By right-clicking on the diagram\'s background and objects, context
menus allow you to customize many aspects of its visualization and
organization.


**Background context menu**

{{#image}}diagram-popup-menu.png{{/image}}

- *Background color*: changes the Diagram background color.

- *Relationships*:

  - *Display names*: shows each relationship\'s name next to the relationship
  line/visual connection.

  - *Linked to fields*: moves the relationship line/visual connection so each end
  links to the exact related fields on each table. If there are relationships
  connecting tables through more than one field, the line then links the first
  field of the relationship, both for parent and for child tables.

  - *Straight lines*: moves the relationship line/visual connection so each line
  will run straight between the tables, without breaks.

- *Add all tables*: adds all of the project\'s tables to the Diagram.


**Table context menu**

{{#image}}diagram-table-popup-menu.png{{/image}}

- *Edit table*: opens the Table editor.

- *Color*: changes the color on each table\'s background.

- *Display*: adjusts the visualization of tables by selecting options on the context menu:

  - *All fields*: all fields are displayed (default).

  - *All keys*: only fields on the primary key of the table or foreign key fields are displayed.

  - *All primary fields*: only fields on the primary key of the table are displayed.

  - *Table name*: only the table name is displayed, no field names.

  - *Show field types*: shows or hides field types.

  - *Recalculate size*: automatically adjusts the displayed table size.

- *Remove table from diagram*: removes a table from the diagram without deleting it
from the project. You can also use the shortcut *CTRL+R*. By using *DEL*, you will delete
the table from the project.

- *Add related tables to diagram*: adds to the diagram all tables related to the
selected table.


**Relationship context menu**

- *Edit relationship*: opens the Relationship editor.

- *Color*: changes the color on each relationship line.


**Note context menu**

- *Edit text*: allows text edition.

- *Color*: changes the color on a note\'s background.

- *Font*: adjusts all font options (face, size etc.).



## Relationship Editor

To open the relationship editor, you should double-click on the desired
relationship on the Project explorer. This editor is divided in tree
sections: *Relationship properties*, *Relationship keys* and
*Relationship options*.


In the **Relationship properties** section, you may visualize or set the
relationship name and its description, for future reference. A default
relationship name is created automatically when adding a new relationship
to the project, combining parent and child table names. The relationship
name may be edited at any time.


In the **Relationship keys** section you may visualize or edit the
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


In the **Relationship options** section, you are able to select the relationship
behavior when a record on the parent table is deleted or updated:

- *No action*: no action is taken when there are changes on the parent table.
This is the default option.

- *Cascade*: automatically deletes all records on the child table when a parent
record is deleted. Example: Customer/Contact, when deleting a customer,
all of its contacts are also deleted.

- *Set null*: when a parent record is deleted, all child records related to it
get this field set to null. Example: on the Person/Gender deletion, all people
related to this record would be set to null.

- *Set default*: similar to \"set null\" option, but instead of setting the
field to null, it is filled with its default value.


When opening a relationship by double-clicking on a diagram, the
*Back to diagram* button is enabled, so you can easily return to
the original diagram.



## Procedures and Functions

To open the procedure editor, you should double-click on the desired
procedure/function on the Project explorer.


Procedures (or \"stored procedures\"), like triggers, are functions
programmed into the database. Through TMS Data modeler, you can edit and
create procedures as shortcuts to regularly executed actions, and store
them for future use. In this editor, you are able to set:

- *Object name*: procedure name.

- *Description*.

- *Create implementation code*: full command to create the stored procedure
in the database.


When you create a procedure, it automatically implements:

```sql
CREATE PROCEDURE <%ObjectName%>
```

This macro `<%...%>` is replaced by the procedure\'s name, so you can
rename it without having to update this implementation.



## Generators/Sequences

Generators/Sequences are supported by some databases like Firebird,
Oracle, SQLite, etc.. To open the generator editor, you should
double-click on the desired generator on the Project explorer.


Generators are a resource to generate number sequences. You can specify
an initial number and the desired increment, and each time a value is
selected in this Generator, a new number is generated. To create a new
generator, select *Object* / *Generator* on the *Create* tab on the
*Home* ribbon.


All Generators created in the project are listed under *Generators*
section in the Project explorer. By double-clicking on the desired
Generator, the *Generators editor* will open showing:

- *Sequence name*.

- *Start with*: initial value of the sequence generator
(specified when creating the object).



## Views

Views are queries stored into databases. By creating a view, you are
able to select frequently used query processes and save them for future
use. To open the views editor, you should double-click on the desired
view on the Project explorer.


In this editor, you are able to edit the information below:

- *Object name*: view name.

- *Description*.

- *Create implementation code*: full command to create the view in the database.


When you create a view, it automatically implements:

```sql
CREATE VIEW <%ObjectName%> AS
```

This macro `<%...%>` is replaced by the view\'s name, so you can rename it
without having to update this implementation.
