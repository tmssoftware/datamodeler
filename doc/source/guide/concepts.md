---
uid: Concepts
---

# Concepts

All database objects are listed under the appropriate data dictionary
object button on the Project explorer. This chapter lists and gives a
brief explanation about the main objects on a project.



## Tables

Tables are the basic elements of a project. They can be imported from an
existing database or be easily created in a TMS Data Modeler project and
later implemented in the database.


All tables in the project are listed under
*Tables* on the Project Explorer, and can
also be visualized in a diagram.


Double-clicking on a table from the list opens the
*Table editor*, where you can view and update all
of its properties including fields and indexes.


Using TMS Data Modeler you may also create *Constraints*, which are
restrictions/rules applied to a table, and *Triggers*, which are
procedures executed every time an update / insert / delete is executed
in a given table.



## Relationships

Relationships are connections between tables.  A relationship is shown
in diagrams as a line between the child and parent table, or around a
single table in the case of a self-relationship. TMS Data Modeler uses a
key from the parent table to manipulate relationships, therefore
previous creation of a key, such as a primary key or other exclusive
index, is mandatory. By selecting a field on the parent key you are able
to select all compatible fields on the child table.


The supported relationship types are:

- *Non-identifying relationship*: it\'s the
most usual type of relationship. It represents a weak connection, a
relationship between parent and child table that does not involve a key
field, such as the relationship between tables \"Products\" and
\"Categories\", for example.

- *Identifying relationship*: a relationship
where the related fields from the child table are part of the key which
identifies a unique record in this table. It indicates a strong
connection, such as the relationship between tables \"Order details\"
and \"Products\", for example. There are no \"Order details\" without a
related \"Product\", and the \"Product\" is part of the key of the
\"Order details\" table.


All relationships present in the project are listed under *Relationships*
on the Project explorer, and can also be visualized in a diagram.


Double-clicking on a relationship from the list opens the
*Relationship editor*, where you can view and update all
of its properties and settings.



## Diagrams

In TMS Data Modeler a diagram acts as a view from the system or part of
the system, unlike most database tools where diagrams are the main
element of the project, defining all tables and structures.


Several different diagrams can be created, each of them with selected
tables so you can better examine and edit their properties and
relationships. Diagrams show all relationships between the inserted
tables automatically, and allows full edition of the database structure.
It is possible to update and remove objects, create new tables and
relationships and so on.


All diagrams created in the project are listed under *Diagrams* on the
Project explorer. Double-clicking on a diagram opens the *Diagrams editor*
where you can view and update all of its tables and settings.



## Extra objects

Besides the main elements tables and relationships, you may also create
and edit extra objects: generic database objects that do not present a
strong connection with the tables in a  TMS Data Modeler project. Note
that not all target DBMS support all project objects, such as
procedures, generators and views.



## Procedures

Procedures (or \"stored procedures\") are functions programmed into the
database, like triggers.  Through TMS Data modeler, you can edit and
create procedures as shortcuts to regularly executed actions, and store
them for future use.


All procedures created in the project are listed under *Procedures* on the
Project explorer. Double-clicking on a procedure opens the
*Procedures editor*, where you can view and update all of
its properties and settings.



## Generators

Generators are a resource to generate number sequences. You are able to
specify an initial number and the desired increment, and each time a
value is selected in this Generator, a new number is generated. It is an
useful tool to fill sequential fields, automatically numbering them.
Some DBMS such as SQL Server have automatic auto-increment options
(available on the fields editor when selecting *Int(identity)* as
logic type).


All Generators created in the project are listed under *Generators* on
the Project explorer. Double-clicking on a Generator opens the
*Generators editor*, where you can view and update all of its
properties and settings.



## Views

Views are a stored queries into databases. By creating a view, you are
able to select frequently used query processes and save them for future
use. For example, you can create a view called *AlphabeticalList* using
the structure:

```sql
create view "AlphabeticalList" AS
SELECT Products.*, Categories.CategoryName
FROM Categories INNER JOIN Products ON Categories.CategoryID = Products.CategoryID
WHERE Products.Discontinued = 0
```


This will list all products on the database in alphabetical order.


All views created in the project are listed under *Views* on the Project
explorer. Double-clicking on a view the *Views editor*, where you can view
and update all of its properties and settings.



## Domains

Domains are resources that allow you to define a special type of field
and reuse efficiently these definitions in various fields in the
database. Selecting *Domains* on the *Create* tab on the Home ribbon,
it is possible to create a domain called \"ZIPCODE\" for example and
define its properties in the *Domains editor*, such as:
data type text, size 5, default value \"00000\" and so on.


Afterwards, when creating a zip code field in a table, you are able to
select the domain ZIPCODE and import all of these settings. Specifying
all field properties again becomes unnecessary, which is extremely
useful not only to avoid reworking when creating fields but also for
maintenance and consistency. If it ever becomes necessary to increase
the field size, for example, instead of making this change field by
field, table by table, you just need to adjust a single domain.



## The Project Files

TMS Data Modeler works with a model that represents the physical
database. Through this model, scripts can be generated to implement
changes in an existing physical database or to create a physical
database from scratch.


Creating a project will generate the following files:

- A single *.dgp* file is created for each project, containing project
settings and the structure of all data dictionary objects. You may
select the file directory and name when saving your project.

- Conversion maps created by users are saved in the *Application Data*
folder, inside *TMS Software\\Data Modeler\\Conversions* subdirectory.
Data Modeler\'s default conversion maps are located in the application
directory.

- Connections are saved on the file *UsrConnections.bin*, located in the
*Application Data* folder inside *TMS Software\\Data modeler* subdirectory.

- Different project versions are saved by default in the subdirectory
*\\versions* inside the project directory (*%projectdir%*). This working
directory can be changed on the *General* settings dialog. To open this
dialog, select *Settings* on the *Project* tab on the Tools ribbon,
and click on the *Version control* tab.


Each new version file is saved under the project file name with its
extension corresponding to the version number, e.g. *demo.1*, *demo.2* etc.
