unit DXInflector;

interface

uses
  Generics.Defaults,
  Generics.Collections,
  RegularExpressions;

type

  TDXInflectionRule = class(TObject)
  private
    FRegex: TRegex;
    FReplacement: String;
  public
    constructor Create(pattern: String; replacement: String);
    function Apply(word: String): String;
  end;

  /// <summary>
  /// TInflector provides methods to singularize, pluralize, capitalize etc
  /// English words.
  /// </summary>
  TDXInflector = class(TObject)
  private
    class constructor Create;
    class destructor Destroy;

    class var FPlurals: TList<TDXInflectionRule>;
    class var FSingulars: TList<TDXInflectionRule>;
    class var FUncountables: TList<String>;

    class procedure AddIrregular(const ASingular, APlural: String);
    class procedure AddUncountable(AWord: String);
    class procedure AddPlural(const ARule, AReplacement: String);
    class procedure AddSingular(ARule: String; AReplacement: String);
    class function ApplyRules(const ARules: TList<TDXInflectionRule>; const AWord: String): String;
    class function MatchEvaluatorTitelize(const AMatch: TMatch): String;
    class function MatchEvaluatorPascalize(const AMatch: TMatch): String;

  public
    class function Pluralize(word: String): String;
    class function Singularize(word: String): String;
    class function Titleize(word: String): String;
    class function Humanize(lowercaseAndUnderscoredWord: String): String;
    class function Pascalize(lowercaseAndUnderscoredWord: String): String;
    class function Camelize(lowercaseAndUnderscoredWord: String): String;
    class function Underscore(pascalCasedWord: String): String;
    class function Capitalize(word: String): String;
    class function Uncapitalize(word: String): String;
    class function Ordinalize(number: String): String;
    class function Dasherize(underscoredWord: String): String;
  end;

implementation

uses
  SysUtils;

class constructor TDXInflector.Create;
begin
  FPlurals := TObjectList<TDXInflectionRule>.Create;
  FSingulars := TObjectList<TDXInflectionRule>.Create;
  FUncountables := TList<String>.Create;

  //Rules are evaluated from top to bottom

  AddIrregular('person', 'people');
  AddIrregular('man', 'men');
  AddIrregular('child', 'children');
  AddIrregular('sex', 'sexes');
  AddIrregular('tax', 'taxes');
  AddIrregular('move', 'moves');
  AddIrregular('foot', 'feet');
  AddIrregular('tooth', 'teeth');
  AddIrregular('goose', 'geese');


  AddUncountable('equipment');
  AddUncountable('information');
  AddUncountable('rice');
  AddUncountable('money');
  AddUncountable('species');
  AddUncountable('series');
  AddUncountable('fish');
  AddUncountable('sheep');
  AddUncountable('police');
  AddUncountable('deer');
  AddUncountable('means');
  AddUncountable('offspring');
  AddUncountable('status');

  AddPlural('(quiz)$', '$1zes');
  AddPlural('^(ox)$', '$1en');
  AddPlural('([m|l])ouse$', '$1ice');
  AddPlural('(matr|vert|ind|append)(ix|ex)$', '$1ices');
  AddPlural('(x|ch|ss|sh)$', '$1es');
  AddPlural('([^aeiouy]|qu)y$', '$1ies');
  AddPlural('(hive)$', '$1s');
  AddPlural('(?:([^f])fe|([lr])f)$', '$1$2ves');
  AddPlural('(s)is$', '$1es');
  AddPlural('([ti])um$', '$1a');
  AddPlural('(buffal|tomat)o$', '$1oes');
  AddPlural('((bu)|(ga))s$', '$1ses');
  AddPlural('(alias|status)$', '$1es');
  AddPlural('(octop|vir)us$', '$1i');
  AddPlural('(ax|test)is$', '$1es');
  AddPlural('s$', 's');
  //Default - matches if no other rule matches
  AddPlural('(.*)$', '$1s');

  AddSingular('(quiz)zes$', '$1');
  AddSingular('(matr)ices$', '$1ix');
  AddSingular('(vert|ind)ices$', '$1ex');
  AddSingular('(append)ices$', '$1ix');

  AddSingular('^(ox)en', '$1');
  AddSingular('(alias|status)es$', '$1');
  AddSingular('(octop|vir)i$', '$1us');
  AddSingular('(cris|ax|test)es$', '$1is');
  AddSingular('(shoe)s$', '$1');
  AddSingular('(o)es$', '$1');
  AddSingular('(bus|gas)es$', '$1');
  AddSingular('([m|l])ice$', '$1ouse');
  AddSingular('(x|ch|ss|sh)es$', '$1');
  AddSingular('(m)ovies$', '$1ovie');
  AddSingular('(s)eries$', '$1eries');
  AddSingular('([^aeiouy]|qu)ies$', '$1y');
  AddSingular('([lr])ves$', '$1f');
  AddSingular('(tive)s$', '$1');
  AddSingular('(hive)s$', '$1');
  AddSingular('([^f])ves$', '$1fe');
  AddSingular('(^analy)ses$', '$1sis');
  AddSingular('((a)naly|(b)a|(d)iagno|(p)arenthe|(p)rogno|(s)ynop|(t)he)ses$', '$1$2sis');
  AddSingular('([ti])a$', '$1um');
  AddSingular('(n)ews$', '$1ews');
  AddSingular('(g)as$', '$1as');

  AddSingular('(x|s)is$', '$1is');
  AddSingular('(.*)ss$', '$1ss');
  //Default - matches if no other rule matches
  AddSingular('(.*)s$', '$1');
end;

class procedure TDXInflector.AddIrregular(const ASingular, APlural: String);
begin
  AddPlural('(' + ASingular[1] + ')' + Copy(ASingular, 2, MaxInt) + '$', '$1' + Copy(APlural, 2, MaxInt));
  AddSingular('(' + APlural[1] + ')' + Copy(APlural, 2, MaxInt) + '$', '$1' + Copy(ASingular, 2, MaxInt));
end;

class procedure TDXInflector.AddUncountable(AWord: String);
begin
  FUncountables.Add(LowerCase(AWord));
end;

class procedure TDXInflector.AddPlural(const ARule, AReplacement: String);
begin
  FPlurals.Add(TDXInflectionRule.Create(ARule, AReplacement))
end;

class procedure TDXInflector.AddSingular(ARule: String; AReplacement: String);
begin
  FSingulars.Add(TDXInflectionRule.Create(ARule, AReplacement))
end;

class function TDXInflector.Pluralize(word: String): String;
begin
  //First try to singularize it - it might already be a plural
  result :=  ApplyRules(FSingulars, word);
  result := ApplyRules(FPlurals, result)
end;

class function TDXInflector.Singularize(word: String): String;
begin
  result := ApplyRules(FSingulars, word)
end;

class function TDXInflector.ApplyRules(const ARules: TList<TDXInflectionRule>; const AWord: String): String;
var
  LRule: TDXInflectionRule;
begin
  if not FUncountables.Contains(LowerCase(AWord)) then
  begin
    for LRule in ARules do
    begin
      result := LRule.Apply(AWord);
      if (result) <> '' then
        break;
    end;
  end;
  if result = '' then
    result := AWord;
end;

class function TDXInflector.MatchEvaluatorTitelize(const AMatch: TMatch): String;
begin
  result := UpperCase(AMatch.Value);
end;

class function TDXInflector.MatchEvaluatorPascalize(const AMatch: TMatch): String;
begin
  result := UpperCase(AMatch.Groups[1].Value);
end;

class function TDXInflector.Titleize(word: String): String;
begin
  result := TRegex.Replace(Humanize(Underscore(word)), '\b([a-z])', MatchEvaluatorTitelize);
end;

class function TDXInflector.Humanize(lowercaseAndUnderscoredWord: String): String;
begin
  result := Capitalize(TRegex.Replace(lowercaseAndUnderscoredWord, '_', ' '))
end;

class function TDXInflector.Pascalize(lowercaseAndUnderscoredWord: String): String;
begin
  result := TRegex.Replace(lowercaseAndUnderscoredWord, '(?:^|_)(.)', MatchEvaluatorPascalize);
end;

class function TDXInflector.Camelize(lowercaseAndUnderscoredWord: String): String;
begin
  result := Uncapitalize(Pascalize(lowercaseAndUnderscoredWord))
end;

class function TDXInflector.Underscore(pascalCasedWord: String): String;
begin
  result := LowerCase(TRegex.Replace(TRegex.Replace(TRegex.Replace(pascalCasedWord, '([A-Z]+)([A-Z][a-z])', '$1_$2'),
    '([a-z\d])([A-Z])', '$1_$2'), '[-\s]', '_'));
end;

class function TDXInflector.Capitalize(word: String): String;
begin
  result := UpperCase(Copy(word, 1, 1)) + LowerCase(Copy(word, 2, MaxInt));
end;

class function TDXInflector.Uncapitalize(word: String): String;
begin
  result := LowerCase(Copy(word, 1, 1)) + Copy(word, 2, MaxInt);
end;

class function TDXInflector.Ordinalize(number: String): String;
var
  n: Integer;
  nMod100: Integer;
begin
  n := StrToInt(number);
  nMod100 := n mod 100;

  if (nMod100 >= 11) and (nMod100 <= 13) then
  begin
    result := number + 'th'
  end;

  case n mod 10 of
    1:
      result := number + 'st';
    2:
      result := number + 'nd';
    3:
      result := number + 'rd'
  else
    result := number + 'th';
  end
end;

class function TDXInflector.Dasherize(underscoredWord: String): String;
begin
  result := StringReplace(underscoredWord, '_', '-', []);
end;

class destructor TDXInflector.Destroy;
begin
  FPlurals.Free;
  FSingulars.Free;
  FUncountables.Free;
end;

constructor TDXInflectionRule.Create(pattern: String; replacement: String);
begin
  FRegex := TRegex.Create(pattern, [roIgnoreCase]);
  FReplacement := replacement
end;

function TDXInflectionRule.Apply(word: String): String;
begin
  if not FRegex.IsMatch(word) then
  begin
    result := ''
  end
  else
  begin
    result := FRegex.Replace(word, FReplacement)
  end;
end;

end.
