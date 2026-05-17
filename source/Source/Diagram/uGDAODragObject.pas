unit uGDAODragObject;

interface

uses
  Controls;

type
  TGDAODragObject = class(TDragControlObjectEx)
  private
    FGDAOObject : TObject;
  protected
    function GetDragImages: TDragImageList; override;
  public
    property GDAOObject : TObject read FGDAOObject write FGDAOObject;
  end;

implementation

{ TGDAODragObject }

function TGDAODragObject.GetDragImages: TDragImageList;
begin
  result := nil;
end;                             

end.
 