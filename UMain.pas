unit UMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.OleCtrls, SHDocVw, Vcl.ExtCtrls,
  Vcl.StdCtrls;

type
  TFrmMain = class(TForm)
    wb_BG: TWebBrowser;
    procedure FormCreate(Sender: TObject);
    procedure FormMouseActivate(Sender: TObject; Button: TMouseButton; Shift:
        TShiftState; X, Y, HitTest: Integer; var MouseActivate: TMouseActivate);
    procedure wb_BGBeforeScriptExecute(ASender: TObject; const pDispWindow:
        IDispatch);
    procedure wb_BGDocumentComplete(ASender: TObject; const pDisp: IDispatch; const
        URL: OLEVariant);
        procedure Update_Browser(Sender: TObject);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  private
    { Private declarations }
    procedure SetPermissions;
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation
 uses
   System.Win.Registry, UFunctions;
{$R *.dfm}

procedure TFrmMain.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
    WindowClass.style := WindowClass.style and not
      (CS_HREDRAW or CS_VREDRAW);

end;

procedure TFrmMain.FormCreate(Sender: TObject);
var path :string;
begin
  SetPermissions;
  path := ExpandFileName(GetCurrentDir) + '\index.html';
  wb_BG.Navigate('file://' + path) ;
end;

procedure TFrmMain.FormMouseActivate(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y, HitTest: Integer; var MouseActivate:
    TMouseActivate);
begin
  if Button=mbRight then
  begin
    if (x >= wb_BG.Left) and
       (x <= wb_BG.Left + wb_BG.Width ) and
       (y >= wb_BG.Top) and
       (y <= wb_BG.Top + wb_BG.Height ) then
      MouseActivate := maNoActivateAndEat;
  end;
end;

procedure TFrmMain.SetPermissions;
const
  cHomePath = 'SOFTWARE';
  cFeatureBrowserEmulation =
    'Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_BROWSER_EMULATION\';
  cIE11 = 11001;

var
  Reg: TRegIniFile;
  sKey: string;
begin

  sKey := ExtractFileName(ParamStr(0));
  Reg := TRegIniFile.Create(cHomePath);
  try
    if Reg.OpenKey(cFeatureBrowserEmulation, True) and
      not(TRegistry(Reg).KeyExists(sKey) and (TRegistry(Reg).ReadInteger(sKey)
      = cIE11)) then
      TRegistry(Reg).WriteInteger(sKey, cIE11);
  finally
    Reg.Free;
  end;
end;


procedure TFrmMain.Update_Browser(Sender: TObject);
begin
//  wb_BG.OleObject.Document.Body.Style.background := clBlack;
  wb_BG.Align := alClient;
//  wb_BG.Refresh;
end;

procedure TFrmMain.wb_BGBeforeScriptExecute(ASender: TObject; const pDispWindow:
    IDispatch);
begin
// WE USE IT INSIDE HTML INDEX
//  wb_BG.OleObject.Document.Body.Style.OverflowX := 'hidden';
//  wb_BG.OleObject.Document.Body.Style.OverflowY := 'hidden';
end;

procedure TFrmMain.wb_BGDocumentComplete(ASender: TObject; const pDisp:
    IDispatch; const URL: OLEVariant);
begin
  Update_Browser(ASender);
end;

end.
