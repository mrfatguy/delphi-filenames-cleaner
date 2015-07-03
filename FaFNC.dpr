program FaFNC;

uses
  Forms,
  frmMain in 'frmMain.pas' {MainForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'FaFNC - Files and Folders Names Cleaner 1.00';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
