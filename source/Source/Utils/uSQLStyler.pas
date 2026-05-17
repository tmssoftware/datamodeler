unit uSQLStyler;

interface
uses
  Graphics, AdvMemo;

procedure ImproveSQLMemoStyler(AStyler: TAdvCustomMemoStyler);

implementation

procedure ImproveSQLMemoStyler(AStyler: TAdvCustomMemoStyler);
var
  itm:TElementStyle;
begin
  {maybe there will be a need to set the comment character
   according to the database being used}
  AStyler.LineComment := '!--';

  //----------MULTI LINE COMMENT --------------
  itm := AStyler.AllStyles.Add;
  itm.StyleType := stComment;
  itm.Info := 'Multi line comment';
  itm.CommentLeft := '/*';
  itm.CommentRight := '*/';

  with AStyler.AllStyles[0] do
  begin
    Font.Color := clBlue;
    with Keywords do
    begin
      Clear;
      {Added keywords}
      Add('ADD');
      Add('ALTER');
      Add('Begin');
      //Add('BREAK');
      Add('By');
      Add('CHECK');
      Add('Close');
      Add('CONSTRAINT');
      //Add('CONTINUE');
      Add('Create');
      //Add('Deallocate');
      Add('Declare');
      Add('DEFAULT');
      Add('Delete');
      Add('DO');
      Add('DROP');
      Add('ELSE');
      Add('End');
      Add('EXEC');
      Add('Fetch');
      Add('FOR');
      Add('FOREIGN');
      Add('From');
      Add('Group');
      Add('Having');
      Add('IF');
      Add('INDEX');
      Add('Inner');
      Add('Insert');
      Add('Join');
      Add('KEY');
      Add('Left');
      Add('MODIFY');
      Add('On');
      Add('Open');
      Add('Order');
      Add('Outer');
      Add('Procedure');
      Add('PRIMARY');
      Add('REFERENCES');
      Add('REPEAT');
      Add('Return');
      Add('Right');
      Add('Rollback');
      Add('Select');
      Add('Set');
      Add('TABLE');
      Add('TO');
      Add('Transaction');
      Add('Update');
      Add('UNIQUE');
      Add('UNTIL');
      Add('Values');
      Add('VIEW');
      Add('Where');
      Add('While');

      {Data types}
      Add('integer');
      Add('Bigint');
      Add('Binary');
      Add('Bit');
      Add('Char');
      Add('Datetime');
      Add('Decimal');
      Add('Float');
      Add('Identity');
      Add('Image');
      Add('Int');
      Add('Money');
      Add('NChar');
      Add('NText');
      Add('Numeric');
      Add('NVarChar');
      Add('Real');
      Add('SmallDateTime');
      Add('SmallInt');
      Add('SmallMoney');
      Add('Sql_Variant');
      Add('Text');
      Add('TimeStamp');
      Add('TinyInt');
      Add('TinyInt');
      Add('UniqueIdentifier');
      Add('VarBinary');
      Add('VarChar');
      Add('XML');
    end;
  end;

  {expressions}
  with AStyler.AllStyles.Add do
  begin
    Font.Color := clGray;
    Font.Style := [];
    StyleType := stKeyword;
    With Keywords do
    begin
      Add('and');
      Add('between');
      Add('IS');
      Add('Like');
      Add('NOT');
      Add('NULL');
      Add('or');
      Add('xor');
    end;
  end;
end;


end.
