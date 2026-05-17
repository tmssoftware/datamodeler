object dmMainActions: TdmMainActions
  Height = 252
  Width = 361
  object ActionListMenu: TActionList
    Left = 248
    Top = 112
    object acDiagramLayout: TAction
      Category = 'Diagram'
      Caption = 'Layout'
      Hint = 'Automatic Diagram Layout'
      OnExecute = acDiagramLayoutExecute
      OnUpdate = acDiagramLayoutUpdate
    end
    object acFileExit: TAction
      Category = 'File'
      Caption = 'Exit'
      ImageIndex = 0
      OnExecute = acFileExitExecute
    end
    object acWebUpdate: TAction
      Category = 'Help'
      Caption = 'Update'
      OnExecute = acWebUpdateExecute
      OnUpdate = acWebUpdateUpdate
    end
    object acHelpHomePage: TAction
      Category = 'Help'
      Caption = 'Home Page'
      OnExecute = acHelpHomePageExecute
      OnUpdate = acHelpHomePageUpdate
    end
    object acCategoryNewView: TAction
      Tag = 1
      Category = 'Category'
      Caption = 'View'
      OnExecute = acCategoryNewViewExecute
      OnUpdate = acCategoryNewViewUpdate
    end
    object acCategoryNewProcedure: TAction
      Tag = 1
      Category = 'Category'
      Caption = 'Procedure'
      OnExecute = acCategoryNewProcedureExecute
      OnUpdate = acCategoryNewProcedureUpdate
    end
    object acFileNew: TAction
      Category = 'File'
      Caption = 'New...'
      Hint = 'Create a new project'
      ImageIndex = 0
      ShortCut = 16462
      OnExecute = acFileNewExecute
      OnUpdate = acFileNewUpdate
    end
    object acExportAurelius: TAction
      Category = 'File'
      Caption = 'Export to TMS Aurelius...'
      Hint = 'Create Delphi classes for TMS Aurelius '
      OnExecute = acExportAureliusExecute
      OnUpdate = ActionProjectAssignedUpdate
    end
    object acEditUndo: TAction
      Category = 'Edit'
      Caption = 'Undo'
    end
    object acProjectGenerate: TAction
      Category = 'Project'
      Caption = 'Generate database...'
      Hint = 'Generate database'
      ImageIndex = 4
      ShortCut = 120
      OnExecute = acProjectGenerateExecute
      OnUpdate = ActionProjectAssignedUpdate
    end
    object acDiagramPreview: TAction
      Category = 'Diagram'
      Caption = 'Print Preview Diagram'
      Hint = 'Print Preview Diagram'
      OnExecute = acDiagramPreviewExecute
      OnUpdate = acDiagramPreviewUpdate
    end
    object acToolsConnections: TAction
      Category = 'Tools'
      Caption = 'Database connections...'
      OnExecute = acToolsConnectionsExecute
    end
    object acHelpHelp: TAction
      Category = 'Help'
      Caption = 'Help'
      OnExecute = acHelpHelpExecute
      OnUpdate = acHelpHelpUpdate
    end
    object acHelpAbout: TAction
      Category = 'Help'
      Caption = 'About TMS Data Modeler'
      OnExecute = acHelpAboutExecute
    end
    object acFileNewExisting: TAction
      Category = 'File'
      Caption = 'New from an existing database...'
      OnExecute = acFileNewExistingExecute
      OnUpdate = acFileNewExistingUpdate
    end
    object acFileOpen: TAction
      Category = 'File'
      Caption = 'Open...'
      Hint = 'Open an existing project'
      ImageIndex = 1
      ShortCut = 16432
      OnExecute = acFileOpenExecute
      OnUpdate = acFileOpenUpdate
    end
    object acFileSave: TAction
      Category = 'File'
      Caption = 'Save'
      Hint = 'Save current project'
      ImageIndex = 2
      ShortCut = 16467
      OnExecute = acFileSaveExecute
      OnUpdate = acFileSaveUpdate
    end
    object acFileSaveAs: TAction
      Category = 'File'
      Caption = 'Save as...'
      OnExecute = acFileSaveAsExecute
      OnUpdate = ActionProjectAssignedUpdate
    end
    object acFileArchiveVersion: TAction
      Category = 'File'
      Caption = 'Archive version...'
      Hint = 'Archive current version into version control'
      ImageIndex = 13
      OnExecute = acFileArchiveVersionExecute
      OnUpdate = acFileArchiveVersionUpdate
    end
    object acFileReport_dummy: TAction
      Category = 'File'
      Caption = 'Report...'
    end
    object acFileClose: TAction
      Category = 'File'
      Caption = 'Close project'
      ShortCut = 16499
      OnExecute = acFileCloseExecute
      OnUpdate = ActionProjectAssignedUpdate
    end
    object acEditRedo: TAction
      Category = 'Edit'
      Caption = 'Redo'
    end
    object acEditSelectAll: TAction
      Category = 'Edit'
      Caption = 'Select all'
      OnExecute = acEditSelectAllExecute
      OnUpdate = acDiagramNewTableUpdate
    end
    object acDiagramNewTable: TAction
      Category = 'Diagram'
      Caption = 'New table'
      Hint = 'Insert new table'
      ImageIndex = 6
      OnExecute = acDiagramNewTableExecute
      OnUpdate = acDiagramNewTableUpdate
    end
    object acDiagramNewRelationshipID: TAction
      Tag = 1
      Category = 'Diagram'
      Caption = 'New identifying relationship'
      Hint = 'Insert identifying relationship'
      ImageIndex = 7
      OnExecute = acDiagramNewRelationshipIDExecute
      OnUpdate = acDiagramNewRelationshipIDUpdate
    end
    object acDiagramNewRelationshipNonID: TAction
      Tag = 2
      Category = 'Diagram'
      Caption = 'New non-identifying relationship'
      Hint = 'Insert non-identifying relationship'
      ImageIndex = 8
      OnExecute = acDiagramNewRelationshipIDExecute
      OnUpdate = acDiagramNewRelationshipIDUpdate
    end
    object acDiagramNewRelationshipMN: TAction
      Tag = 3
      Category = 'Diagram'
      Caption = 'New many-to-many relationship'
      Hint = 'Insert many-to-many relationship'
      ImageIndex = 9
      OnExecute = acDiagramNewRelationshipIDExecute
      OnUpdate = acDiagramNewRelationshipIDUpdate
    end
    object acDiagramNewRelationshipSelf: TAction
      Tag = 4
      Category = 'Diagram'
      Caption = 'New self-relationship'
      Hint = 'Insert self-relationship'
      ImageIndex = 10
      OnExecute = acDiagramNewRelationshipIDExecute
      OnUpdate = acDiagramNewRelationshipIDUpdate
    end
    object acDiagramNewNote: TAction
      Category = 'Diagram'
      Caption = 'New note'
      Hint = 'Insert note'
      ImageIndex = 11
      OnExecute = acDiagramNewNoteExecute
      OnUpdate = acDiagramNewTableUpdate
    end
    object acDiagramNewStamp: TAction
      Category = 'Diagram'
      Caption = 'New stamp'
      OnUpdate = acDiagramNewTableUpdate
    end
    object acDiagramExport: TAction
      Category = 'Diagram'
      Caption = 'Export image...'
      OnExecute = acDiagramExportExecute
      OnUpdate = acDiagramNewTableUpdate
    end
    object acDiagramPrint: TAction
      Category = 'Diagram'
      Caption = 'Print diagram'
      Hint = 'Print diagram'
      OnExecute = acDiagramPrintExecute
      OnUpdate = acDiagramPrintUpdate
    end
    object acProjectNewTable: TAction
      Category = 'Project'
      Caption = 'New table'
      ShortCut = 16468
      OnExecute = acProjectNewTableExecute
      OnUpdate = ActionProjectAssignedUpdate
    end
    object acProjectNewRelationship: TAction
      Category = 'Project'
      Caption = 'New relationship...'
      OnExecute = acProjectNewRelationshipExecute
      OnUpdate = acProjectNewRelationshipUpdate
    end
    object acProjectDomains: TAction
      Category = 'Project'
      Caption = 'Domains...'
      OnExecute = acProjectDomainsExecute
      OnUpdate = ActionProjectAssignedUpdate
    end
    object acProjectCheck: TAction
      Category = 'Project'
      Caption = 'Check/validation'
      ShortCut = 16504
      OnExecute = acProjectCheckExecute
      OnUpdate = ActionProjectAssignedUpdate
    end
    object acProjectMerge: TAction
      Category = 'Project'
      Caption = 'Merge...'
      OnExecute = acProjectMergeExecute
      OnUpdate = ActionProjectAssignedUpdate
    end
    object acProjectVersionsManage: TAction
      Category = 'Project'
      Caption = 'Manage versions...'
      Hint = 'Manage project versions'
      ImageIndex = 14
      OnExecute = acProjectVersionsManageExecute
      OnUpdate = acProjectVersionsManageUpdate
    end
    object acProjectVersionsCompare: TAction
      Category = 'Project'
      Caption = 'Compare versions...'
      Hint = 'Compare project versions'
      ImageIndex = 15
      OnExecute = acProjectVersionsCompareExecute
      OnUpdate = acProjectVersionsCompareUpdate
    end
    object acProjectConvert: TAction
      Category = 'Project'
      Caption = 'Convert to another database...'
      OnExecute = acProjectConvertExecute
      OnUpdate = ActionProjectAssignedUpdate
    end
    object acProjectConversionsXXXXXX: TAction
      Category = 'Project'
      Caption = 'Database conversions...'
      Visible = False
      OnUpdate = ActionProjectAssignedUpdate
    end
    object acProjectSettings: TAction
      Category = 'Project'
      Caption = 'Project settings...'
      Hint = 'Project settings'
      ImageIndex = 3
      OnExecute = acProjectSettingsExecute
      OnUpdate = ActionProjectAssignedUpdate
    end
    object acToolsSettings: TAction
      Category = 'Tools'
      Caption = 'Environment settings...'
      OnExecute = acToolsSettingsExecute
      OnUpdate = acToolsSettingsUpdate
    end
    object acDiagramAllTables: TAction
      Category = 'Diagram'
      Caption = 'Add all tables'
      Hint = 'Add all tables from data dictionary'
      OnExecute = acDiagramAllTablesExecute
      OnUpdate = acDiagramNewTableUpdate
    end
    object acViewExplorer: TAction
      Category = 'View'
      Caption = 'Project Explorer'
      Hint = 'View project explorer'
      ShortCut = 49221
      OnExecute = acViewExplorerExecute
      OnUpdate = acViewExplorerUpdate
    end
    object acViewMessages: TAction
      Category = 'View'
      Caption = 'Messages Window'
      ShortCut = 49229
      OnExecute = acViewMessagesExecute
      OnUpdate = acViewMessagesUpdate
    end
    object acToolsConversionMaps: TAction
      Category = 'Tools'
      Caption = 'Data Type Conversion Maps...'
      OnExecute = acToolsConversionMapsExecute
    end
    object acNewCategory1: TAction
      Tag = 1
      Category = 'Category'
      Caption = 'acNewCategory1'
      OnExecute = NewCategoryActionExecute
      OnUpdate = NewCategoryActionUpdate
    end
    object acNewCategory2: TAction
      Tag = 2
      Category = 'Category'
      Caption = 'acNewCategory2'
      OnExecute = NewCategoryActionExecute
      OnUpdate = NewCategoryActionUpdate
    end
    object acNewCategory3: TAction
      Tag = 3
      Category = 'Category'
      Caption = 'acNewCategory3'
      OnExecute = NewCategoryActionExecute
      OnUpdate = NewCategoryActionUpdate
    end
    object acNewCategory4: TAction
      Tag = 4
      Category = 'Category'
      Caption = 'acNewCategory4'
      OnExecute = NewCategoryActionExecute
      OnUpdate = NewCategoryActionUpdate
    end
    object acNewCategory5: TAction
      Tag = 5
      Category = 'Category'
      Caption = 'acNewCategory5'
      OnExecute = NewCategoryActionExecute
      OnUpdate = NewCategoryActionUpdate
    end
    object acNewCategory6: TAction
      Tag = 6
      Category = 'Category'
      Caption = 'acNewCategory6'
      OnExecute = NewCategoryActionExecute
      OnUpdate = NewCategoryActionUpdate
    end
    object acNewCategory7: TAction
      Tag = 7
      Category = 'Category'
      Caption = 'acNewCategory7'
      OnExecute = NewCategoryActionExecute
      OnUpdate = NewCategoryActionUpdate
    end
    object acNewCategory8: TAction
      Tag = 8
      Category = 'Category'
      Caption = 'acNewCategory8'
      OnExecute = NewCategoryActionExecute
      OnUpdate = NewCategoryActionUpdate
    end
    object acNewCategory9: TAction
      Tag = 9
      Category = 'Category'
      Caption = 'acNewCategory9'
      OnExecute = NewCategoryActionExecute
      OnUpdate = NewCategoryActionUpdate
    end
    object acNewCategory10: TAction
      Tag = 10
      Category = 'Category'
      Caption = 'acNewCategory10'
      OnExecute = NewCategoryActionExecute
      OnUpdate = NewCategoryActionUpdate
    end
    object acAssignedProject: TAction
      Caption = '(Project Assigned)'
      OnExecute = acAssignedProjectExecute
      OnUpdate = ActionProjectAssignedUpdate
    end
    object acScripting: TAction
      Category = 'Tools'
      Caption = 'Scripting'
      OnExecute = acScriptingExecute
      OnUpdate = acScriptingUpdate
    end
  end
end
