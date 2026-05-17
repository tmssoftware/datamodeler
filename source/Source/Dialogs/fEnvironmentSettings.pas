unit fEnvironmentSettings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ActnList, ComCtrls;

type
  TfmEnvironmentSettings = class(TForm)
    Panel2: TPanel;
    PageControl1: TPageControl;
    tsDisplay: TTabSheet;
    Label1: TLabel;
    cbMeasUnit: TComboBox;
    btOk: TBitBtn;
    BitBtn2: TBitBtn;
    procedure btOkClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure LoadSettings;
    procedure SaveSettings;
  public
    function Execute: boolean;
  end;

implementation

uses
  uAppUtils, uAppRegistry;

{$R *.dfm}

procedure TfmEnvironmentSettings.btOkClick(Sender: TObject);
begin
  SaveSettings;
  ModalResult := mrOk;
end;

function TfmEnvironmentSettings.Execute: boolean;
begin                                           
  LoadSettings;
  result := (ShowModal = mrOk);
  if result then
    SaveSettings;  
end;

procedure TfmEnvironmentSettings.FormCreate(Sender: TObject);
begin
  CreateFormSize(Self);
end;

procedure TfmEnvironmentSettings.FormShow(Sender: TObject);
begin
  LoadSettings;
end;

procedure TfmEnvironmentSettings.LoadSettings;
begin
  with cbMeasUnit.Items do
  begin
    Clear;
    Add('Centimeters');
    Add('Milimeters');
    Add('Inches');
  end;
  case DMRegistry.MeasurementUnit of
    dmuMilimeter:
      cbMeasUnit.Itemindex := 1;
    dmuInch:
      cbMeasUnit.Itemindex := 2;
  else
    //dmuCentimeter
    cbMeasUnit.Itemindex := 0;
  end;
end;

procedure TfmEnvironmentSettings.SaveSettings;
begin
  case cbMeasUnit.ItemIndex of
    0:
      DMRegistry.MeasurementUnit := dmuCentimeter;
    1:
      DMRegistry.MeasurementUnit := dmuMilimeter;
    2:
      DMRegistry.MeasurementUnit := dmuInch;
  end;
end;

end.

