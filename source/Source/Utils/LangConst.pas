unit LangConst;

interface

resourcestring
  SASeqNciaSNOPodeSerExcluDa = 'The %s sequence cannot be excluded';
  SConfirmTriggerDeletion = 'Are you sure you want to delete trigger %s?';
  SMissingTriggerCollection = 'Error: The trigger collection is missing';
  SProjectHasUnsavedChanges = 'The modifications in the current project have not been saved.'#13#10;
  SSaveChangesBeforeClosing = 'Save changes before closing?';
  SConfirmItemExclusion = 'Confirm the exclusion of %s?';
  SRelationshipType = 'Relationship type: ';
  SProjectUpdatedMustBeSaved = 'The project has been updated automatically and it must to be saved.';
  SDatabaseVersionWarning = 'TMS Data Modeler detected you are connecting to a database server whose version is older than the selected one (%s). Reverse engineering may not work properly. Do you want to proceed?';
  SDBToolCaption = 'TMS Data Modeler';

  SProjectInformationValid = 'The project informations are valid.';
  SNotInformed = '%s not informed';
  SOpenProject = 'Open project';
  SProjectsCaption = 'TMS Data Modeler Projects (*%s)|*%s|';
  SSaveProject = 'Save project ';
  SMissingDirectoryCreateNow = 'The %s directory does not exists. Do you wish to create it now?';

  SMasterFieldEmpty = 'Master field is empty';
  SDetailFieldEmpty = 'Detail field is empty';
  SOneToOne = 'ONE TO ONE';
  SOneToMany = 'ONE TO MANY';
  SNoDomain = '(no domain)';
  SNewTableName = 'NewTable';
  SNewFieldName = 'NewField';
  SNewIndexName = 'NewIndex';
  SNewPrimaryKeyName = 'PrimaryKey';
  SNewRelationshipName = 'NewRelationship';
  SNewTriggerName = 'NewTrigger';
  SNewDomainName  = 'NewDomain';
  SNewConstraintName = 'NewConstraint';
  STempPrimaryKeyName = '___PrimaryKey___';

implementation

end.
