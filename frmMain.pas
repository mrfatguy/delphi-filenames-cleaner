unit frmMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, FileCtrl, ExtCtrls, Grids, ComCtrls,
  ImgList, ShellAPI, Menus, FolderDialog;

type
  TMainForm = class(TForm)
    gbChanges: TGroupBox;
    chbPolishLetters: TCheckBox;
    chbBreakSigns: TCheckBox;
    btnGo: TButton;
    cbLettersMode: TComboBox;
    lblLettersMode: TLabel;
    btnExit: TButton;
    ListView: TListView;
    ilImages: TImageList;
    lblList: TLabel;
    pnlChangedFilesCap: TPanel;
    pnlChangedFilesVal: TPanel;
    gbView: TGroupBox;
    chbAlsoDirs: TCheckBox;
    chbShowOnlyThoseToBeChanged: TCheckBox;
    lblCopyright: TLabel;
    lblWeb: TLabel;
    pnlPathCap: TPanel;
    pnlPathVal: TPanel;
    pmList: TPopupMenu;
    mnuSelectAll: TMenuItem;
    mnuDeselectAll: TMenuItem;
    mnuChangeSelection: TMenuItem;
    N1: TMenuItem;
    mnuRefreshList: TMenuItem;
    N2: TMenuItem;
    mnuOpenActual: TMenuItem;
    mnuExploreActual: TMenuItem;
    pnlMenu: TPanel;
    gbProgramSettings: TGroupBox;
    chbConfirmations: TCheckBox;
    chbShowPathInTitle: TCheckBox;
    mnuSelectFolder: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    fdFolder: TFolderDialog;
    cbWordSpace: TComboBox;
    Label1: TLabel;
    lblSeparator: TLabel;
    eSeparator: TEdit;
    chbAutoSelect: TCheckBox;
    chbAutoFocus: TCheckBox;
    gbChanges2: TGroupBox;
    chbChangeString1: TCheckBox;
    edChangeFrom1: TEdit;
    edChangeTo1: TEdit;
    chbChangeString2: TCheckBox;
    edChangeFrom2: TEdit;
    edChangeTo2: TEdit;
    chbChangeString3: TCheckBox;
    edChangeFrom3: TEdit;
    edChangeTo3: TEdit;
    lblChangeString1: TLabel;
    lblChangeString2: TLabel;
    lblChangeString3: TLabel;
    chbUppercaseAlso: TCheckBox;
    chbExtensionAlso: TCheckBox;
    chbErrors: TCheckBox;
    mnuExecuteSelected: TMenuItem;
    mnuOpenSelected: TMenuItem;
    mnuExploreSelected: TMenuItem;
    chbLockMarks: TCheckBox;

    function GetVolumeLabel(Drive: Char): String;
    function GetVolumeSize(Drive: Char; Total: Boolean): String;
    function GetFileSize(const FileName: String): LongInt;
    function GetIndexOfItem(ItemCaption: String): Integer;
    function CreateNewNameByRule(aName: String; isDir: Boolean): String;
    function AnsiUpperCaseFirstLetterInWord(S: String): String;

    procedure ReadDir(Dir: String; IsUpdating: Boolean);
    procedure ReadRoot();
    procedure SaveSettings();
    procedure LoadSettings();
    procedure AddDisksToMenu();

    procedure DiskMenuClickHandler(Sender: TObject);
    procedure ParameterClick(Sender: TObject);

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnExitClick(Sender: TObject);
    procedure ListViewDblClick(Sender: TObject);
    procedure lblWebClick(Sender: TObject);
    procedure chbConfirmationsClick(Sender: TObject);
    procedure ListViewKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure chbShowPathInTitleClick(Sender: TObject);
    procedure mnuRefreshListClick(Sender: TObject);
    procedure pnlMenuMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure pnlMenuMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure mnuSelectFolderClick(Sender: TObject);
    procedure mnuOpenActualClick(Sender: TObject);
    procedure mnuExploreActualClick(Sender: TObject);
    procedure mnuSelectAllClick(Sender: TObject);
    procedure mnuDeselectAllClick(Sender: TObject);
    procedure mnuChangeSelectionClick(Sender: TObject);
    procedure btnGoClick(Sender: TObject);
    procedure chbChangeString1Click(Sender: TObject);
    procedure chbChangeString2Click(Sender: TObject);
    procedure chbChangeString3Click(Sender: TObject);
    procedure mnuExecuteSelectedClick(Sender: TObject);
    procedure pmListPopup(Sender: TObject);
    procedure mnuOpenSelectedClick(Sender: TObject);
    procedure mnuExploreSelectedClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormActivate(Sender: TObject);

  private
    { Private declarations }
  public
    cDirectory: String;
    IsLoading: Boolean;
    iColumnSize: array[0..2] of Integer;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}
{$R WinXP.res}

function TMainForm.GetVolumeLabel(Drive: Char): String;
var
        SearchString: String;
        Buffer: array[0..255] of Char;
        a, b: DWORD;
begin
        SearchString := Drive + ':\' + #0;

        if GetVolumeInformation(@SearchString[1], Buffer, SizeOf(Buffer), nil, a, b, nil, 0) then
                Result := Buffer
        else
                Result := '';
end;

function TMainForm.GetVolumeSize(Drive: Char; Total: Boolean): String;
var
        SearchString, sPercentSize, sFreeSize: String;
        FreeSpace, TotalSpace: Int64;
begin
        SearchString := Drive + ':\' + #0;

        if GetDiskFreeSpaceEx(@SearchString[1], FreeSpace, TotalSpace, nil) then
        begin
                if not Total then
                begin
                        sPercentSize := IntToStr(Round((FreeSpace / TotalSpace) * 100)) + ' %';

                        sFreeSize := IntToStr(FreeSpace) + ' B';
                        if FreeSpace > 1024 then sFreeSize := IntToStr(Round(FreeSpace / 1024)) + ' kB';
                        if FreeSpace > 1048576 then sFreeSize := FloatToStrF(FreeSpace / 1048576, ffFixed, 7, 2) + ' MB';
                        if FreeSpace > 1073741824 then sFreeSize := FloatToStrF(FreeSpace / 1073741824, ffFixed, 7, 2) + ' GB';

                        Result := sFreeSize + ' (' + sPercentSize + ') wolne';
                end
                else
                begin
                        Result := IntToStr(TotalSpace) + ' B';
                        if TotalSpace > 1024 then Result := IntToStr(Round(TotalSpace / 1024)) + ' kB';
                        if TotalSpace > 1048576 then Result := FloatToStrF(TotalSpace / 1048576, ffFixed, 7, 2) + ' MB';
                        if TotalSpace > 1073741824 then Result := FloatToStrF(TotalSpace / 1073741824, ffFixed, 7, 2) + ' GB';
                end;
        end
        else Result := '--';
end;

function TMainForm.GetFileSize(const FileName: string): LongInt;
var
        SearchRec: TSearchRec;
begin
        if FindFirst(ExpandFileName(FileName), faAnyFile, SearchRec) = 0 then
        begin
                Result := SearchRec.Size;
                SysUtils.FindClose(SearchRec);
        end
        else Result := 0;
end;

function TMainForm.CreateNewNameByRule(aName: String; isDir: Boolean): String;
var
        a, c: Integer;
        sExt: String;
        ReplaceFlags: TReplaceFlags;
begin
        if not isDir then
        begin
                sExt := ExtractFileExt(aName);
                aName := ChangeFileExt(aName, '');
        end
        else aName := Copy(aName, 2, Length(aName) - 2);

        //Words separation...
        case cbWordSpace.ItemIndex of
                0: aName := StringReplace(aName, ' ', '', [rfReplaceAll, rfIgnoreCase]);
                1:
                begin
                        for a:=1 to Length(aName) do
                        begin
                                if aName[a]=' ' then
                                begin
                                        c:=Ord(aName[a+1]);
                                        if c>=97 then Dec(c,32);
                                        aName:=Copy(aName,1,a-1)+Char(c)+Copy(aName,a+2,Length(aName));
                                end;
                        end;
                end;
                3: aName := StringReplace(aName, ' ', eSeparator.Text, [rfReplaceAll, rfIgnoreCase]);
                4:
                begin
                        for a := 65 to 90 do aName := StringReplace(aName, Chr(a), ' ' + Chr(a), [rfReplaceAll]);
                        aName := StringReplace(aName, '  ', ' ', [rfReplaceAll]);
                        aName := Trim(aName);
                end;
                5:
                begin
                        for a := 65 to 90 do aName := StringReplace(aName, Chr(a), ' ' + Chr(a), [rfReplaceAll]);
                        aName := StringReplace(aName, '  ', ' ', [rfReplaceAll]);
                        aName := Trim(aName);

                        for a := 48 to 57 do aName := StringReplace(aName, Chr(a), ' ' + Chr(a), [rfReplaceAll]);
                        aName := StringReplace(aName, '  ', ' ', [rfReplaceAll]);
                        aName := Trim(aName);
                end;
                6: aName := StringReplace(aName, eSeparator.Text, ' ', [rfReplaceAll, rfIgnoreCase]);
        end;

        //Interpunction characters
        if chbBreakSigns.Checked then for a:=1 to Length(aName) do if aName[a]='.' then aName:=Copy(aName,1,a-1)+Copy(aName,a+1,Length(aName));
        if chbBreakSigns.Checked then for a:=1 to Length(aName) do if aName[a]=',' then aName:=Copy(aName,1,a-1)+Copy(aName,a+1,Length(aName));
        if chbBreakSigns.Checked then for a:=1 to Length(aName) do if aName[a]='''' then aName:=Copy(aName,1,a-1)+Copy(aName,a+1,Length(aName));

        //Polish letters
        if chbPolishLetters.Checked then for a:=1 to Length(aName) do
        begin
                if aName[a]='Í' then aName[a]:=Char('e');
                if aName[a]='Û' then aName[a]:=Char('o');
                if aName[a]='π' then aName[a]:=Char('a');
                if aName[a]='ú' then aName[a]:=Char('s');
                if aName[a]='≥' then aName[a]:=Char('l');
                if aName[a]='ø' then aName[a]:=Char('z');
                if aName[a]='ü' then aName[a]:=Char('z');
                if aName[a]='Ê' then aName[a]:=Char('c');
                if aName[a]='Ò' then aName[a]:=Char('n');
                if aName[a]=' ' then aName[a]:=Char('E');
                if aName[a]='”' then aName[a]:=Char('O');
                if aName[a]='•' then aName[a]:=Char('A');
                if aName[a]='å' then aName[a]:=Char('S');
                if aName[a]='£' then aName[a]:=Char('L');
                if aName[a]='Ø' then aName[a]:=Char('Z');
                if aName[a]='è' then aName[a]:=Char('Z');
                if aName[a]='∆' then aName[a]:=Char('C');
                if aName[a]='—' then aName[a]:=Char('N');
        end;

        if chbUppercaseAlso.Checked then ReplaceFlags := [rfReplaceAll] else ReplaceFlags := [rfReplaceAll, rfIgnoreCase];

        //Spelling mistakes
        aName := StringReplace(aName, ' ( ', ' (', [rfReplaceAll]);
        aName := StringReplace(aName, '( ', ' (', [rfReplaceAll]);
        aName := StringReplace(aName, ' ) ', ') ', [rfReplaceAll]);
        aName := StringReplace(aName, ' )', ') ', [rfReplaceAll]);
        aName := StringReplace(aName, ' !', '!', [rfReplaceAll]);
        aName := StringReplace(aName, ' ?', '?', [rfReplaceAll]);
        aName := StringReplace(aName, ' :', ':', [rfReplaceAll]);
        aName := StringReplace(aName, ' .', '.', [rfReplaceAll]);
        aName := StringReplace(aName, ' ,', ',', [rfReplaceAll]);
        aName := StringReplace(aName, ' ;', ';', [rfReplaceAll]);
        aName := StringReplace(aName, '  ', ' ', [rfReplaceAll]);

        if chbExtensionAlso.Checked then
        begin
                if not isDir then aName := aName + sExt;
                if chbChangeString1.Checked then aName := StringReplace(aName, edChangeFrom1.Text, edChangeTo1.Text, ReplaceFlags);
                if chbChangeString2.Checked then aName := StringReplace(aName, edChangeFrom2.Text, edChangeTo2.Text, ReplaceFlags);
                if chbChangeString3.Checked then aName := StringReplace(aName, edChangeFrom3.Text, edChangeTo3.Text, ReplaceFlags);
        end
        else
        begin
                if chbChangeString1.Checked then aName := StringReplace(aName, edChangeFrom1.Text, edChangeTo1.Text, ReplaceFlags);
                if chbChangeString2.Checked then aName := StringReplace(aName, edChangeFrom2.Text, edChangeTo2.Text, ReplaceFlags);
                if chbChangeString3.Checked then aName := StringReplace(aName, edChangeFrom3.Text, edChangeTo3.Text, ReplaceFlags);
                if not isDir then aName := aName + sExt;
        end;

        case cbLettersMode.ItemIndex of
                1: aName := AnsiLowerCase(aName);
                2: aName := AnsiUpperCase(aName);
                3: aName := AnsiUpperCase(Copy(aName, 1, 1)) + AnsiLowerCase(Copy(aName, 2, Length(aName)));
                4: aName := AnsiUpperCase(Copy(aName, 1, 1)) + Copy(aName, 2, Length(aName));
                5: aName := AnsiUpperCaseFirstLetterInWord(aName);
                6:
                begin
                        aName := AnsiUpperCaseFirstLetterInWord(aName);
                        aName := aName + ' ';

                        aName := StringReplace(aName, ' Is ', ' is ', [rfReplaceAll]);
                        aName := StringReplace(aName, ' The ', ' the ', [rfReplaceAll]);
                        aName := StringReplace(aName, ' In ', ' in ', [rfReplaceAll]);
                        aName := StringReplace(aName, ' It ', ' it ', [rfReplaceAll]);
                        aName := StringReplace(aName, ' It''s ', ' it''s ', [rfReplaceAll]);
                        aName := StringReplace(aName, ' As ', ' as ', [rfReplaceAll]);
                        aName := StringReplace(aName, ' At ', ' at ', [rfReplaceAll]);
                        aName := StringReplace(aName, ' On ', ' on ', [rfReplaceAll]);
                        aName := StringReplace(aName, ' Of ', ' of ', [rfReplaceAll]);
                        aName := StringReplace(aName, ' By ', ' by ', [rfReplaceAll]);
                        aName := StringReplace(aName, ' Or ', ' or ', [rfReplaceAll]);
                        aName := StringReplace(aName, ' To ', ' to ', [rfReplaceAll]);
                        aName := StringReplace(aName, ' A ', ' a ', [rfReplaceAll]);
                        aName := StringReplace(aName, ' Is ', ' is ', [rfReplaceAll]);
                        aName := StringReplace(aName, ' De ', ' de ', [rfReplaceAll]);
                        aName := StringReplace(aName, ' La ', ' la ', [rfReplaceAll]);
                        aName := StringReplace(aName, ' Off ', ' off ', [rfReplaceAll]);
                        aName := StringReplace(aName, ' For ', ' for ', [rfReplaceAll]);
                        aName := StringReplace(aName, ' Not ', ' not ', [rfReplaceAll]);
                        aName := StringReplace(aName, ' So ', ' so ', [rfReplaceAll]);
                        aName := StringReplace(aName, ' Do ', ' do ', [rfReplaceAll]);
                        aName := StringReplace(aName, ' An ', ' an ', [rfReplaceAll]);
                        aName := StringReplace(aName, ' Be ', ' be ', [rfReplaceAll]);
                        aName := StringReplace(aName, ' And ', ' and ', [rfReplaceAll]);
                        aName := StringReplace(aName, ' Am ', ' am ', [rfReplaceAll]);
                        aName := StringReplace(aName, ' With ', ' with ', [rfReplaceAll]);

                        aName := Trim(aName);
                end;
        end;

        if isDir then aName := '[' + aName +']';

        Result := aName;
end;

function TMainForm.AnsiUpperCaseFirstLetterInWord(S: String): String;
var
        a: Integer;
        SkipNext: Boolean;
begin
        SkipNext:=False;
        for a:=2 to Length(S) do
        begin
                if S[a]=' ' then
                begin
                        Result:=Result+' '+AnsiUpperCase(Copy(S,a+1,1));
                        SkipNext:=True;
                end
                else
                begin
                        if SkipNext=True then
                                SkipNext:=False
                        else
                                Result:=Result+AnsiLowerCase(S[a]);
                end;
        end;
        Result:=AnsiUpperCase(Copy(S,1,1))+Result;
end;

procedure TMainForm.SaveSettings();
var
        sFile: TStringList;
        a: Integer;
begin
        sFile := TStringList.Create;

        sFile.Values['WordSpaces'] := IntToStr(cbWordSpace.ItemIndex);
        sFile.Values['LettersMode'] := IntToStr(cbLettersMode.ItemIndex);

        sFile.Values['PolishLetters'] := IntToStr(Ord(chbPolishLetters.Checked));
        sFile.Values['BreakSigns'] := IntToStr(Ord(chbBreakSigns.Checked));
        sFile.Values['Errors'] := IntToStr(Ord(chbErrors.Checked));
        sFile.Values['AlsoDirs'] := IntToStr(Ord(chbAlsoDirs.Checked));
        sFile.Values['ShowOnlyThoseToBeChanged'] := IntToStr(Ord(chbShowOnlyThoseToBeChanged.Checked));
        sFile.Values['Confirmations'] := IntToStr(Ord(chbConfirmations.Checked));
        sFile.Values['ShowPathInTitle'] := IntToStr(Ord(chbShowPathInTitle.Checked));
        sFile.Values['AutoFocus'] := IntToStr(Ord(chbAutoFocus.Checked));
        sFile.Values['AutoSelect'] := IntToStr(Ord(chbAutoSelect.Checked));
        sFile.Values['UppercaseAlso'] := IntToStr(Ord(chbUppercaseAlso.Checked));
        sFile.Values['ExtensionAlso'] := IntToStr(Ord(chbExtensionAlso.Checked));

        sFile.Values['Directory'] := cDirectory;
        sFile.Values['Separator'] := eSeparator.Text;
        sFile.Values['WindowState'] := IntToStr(Ord(WindowState = wsNormal));

        if cDirectory <> '' then for a := 1 to ListView.Columns.Count do sFile.Values['Column' + IntToStr(a)] := IntToStr(ListView.Columns[a - 1].Width);

        sFile.SaveToFile(ExtractFilePath(Application.ExeName)+'settings.dat');
        sFile.Free;
end;

procedure TMainForm.LoadSettings();
var
        sFile: TStringList;
        sSettingsFile: String;
        a: Integer;
begin
        sFile := TStringList.Create;

        sSettingsFile := ExtractFilePath(Application.ExeName)+'settings.dat';
        if FileExists(sSettingsFile) then sFile.LoadFromFile(sSettingsFile);

        cbWordSpace.ItemIndex := StrToIntDef(sFile.Values['WordSpaces'],0);
        cbLettersMode.ItemIndex := StrToIntDef(sFile.Values['LettersMode'],0);

        chbPolishLetters.Checked := (StrToIntDef(sFile.Values['PolishLetters'],1) = 1);
        chbBreakSigns.Checked := (StrToIntDef(sFile.Values['BreakSigns'],1) = 1);
        chbErrors.Checked := (StrToIntDef(sFile.Values['Errors'],1) = 1);
        chbAlsoDirs.Checked := (StrToIntDef(sFile.Values['AlsoDirs'],1) = 1);
        chbShowOnlyThoseToBeChanged.Checked := (StrToIntDef(sFile.Values['ShowOnlyThoseToBeChanged'],0) = 1);
        chbConfirmations.Checked := (StrToIntDef(sFile.Values['Confirmations'],1) = 1);
        chbShowPathInTitle.Checked := (StrToIntDef(sFile.Values['ShowPathInTitle'],0) = 1);
        chbAutoFocus.Checked := (StrToIntDef(sFile.Values['AutoFocus'],0) = 1);
        chbAutoSelect.Checked := (StrToIntDef(sFile.Values['AutoSelect'],1) = 1);
        chbUppercaseAlso.Checked := (StrToIntDef(sFile.Values['UppercaseAlso'],0) = 1);
        chbExtensionAlso.Checked := (StrToIntDef(sFile.Values['ExtensionAlso'],0) = 1);

        if (StrToIntDef(sFile.Values['WindowState'],1) = 0) then
                WindowState := wsMaximized
        else
                WindowState := wsNormal;

        for a := 1 to ListView.Columns.Count do
        begin
                ListView.Columns[a - 1].Width := StrToIntDef(sFile.Values['Column' + IntToStr(a)], 207);
                iColumnSize[a - 1] := ListView.Columns[a - 1].Width;
        end;

        if ListView.Columns[2].Width = 207 then ListView.Columns[2].Width := 77;
        iColumnSize[2] := ListView.Columns[2].Width;

        eSeparator.Text := sFile.Values['Separator'];

        cDirectory := sFile.Values['Directory'];
        if not DirectoryExists(cDirectory) then
        begin
                cDirectory := '';
                ReadRoot();
        end
        else ReadDir(cDirectory, True);        

        sFile.Free;
        IsLoading := False;
end;

procedure TMainForm.ReadDir(Dir: String; IsUpdating: Boolean);
var
        iTopItemIndex, tlSelected, cTopItem, cChanged, isDir, Attr, a: Integer;
        fSize: Longint;
        SearchRec: TSearchRec;
        lst: TListItem;
        sSize, sSourceItem, sDestItem: String;
        CheckMatrix: array of ShortInt;
begin
        if not DirectoryExists(Dir) then exit;
        if not IsUpdating then if Dir = cDirectory then exit;

        Screen.Cursor := crHourglass;

        ListView.SortType := stNone;

        cTopItem := 0;
        if ListView.Items.Count > 0 then cTopItem := ListView.TopItem.Index;
        if not IsUpdating then cTopItem := 0;

        tlSelected := 0;
        if ListView.Selected <> nil then tlSelected := ListView.Selected.Index;
        if not IsUpdating then tlSelected := 0;

        SetLength(CheckMatrix, ListView.Items.Count);

        if chbLockMarks.Checked and (ListView.Items.Count > 0) then
                for a := 0 to ListView.Items.Count - 1 do
                        if ListView.Items[a].Checked then CheckMatrix[a] := 1 else CheckMatrix[a] := 0;

        cChanged := 0;
        ListView.Items.BeginUpdate;
        ListView.Items.Clear;

        for a := 1 to ListView.Columns.Count do ListView.Columns[a - 1].Width := iColumnSize[a - 1];
        ListView.Columns[0].Caption := 'Current name';
        ListView.Columns[1].Caption := 'Name after change';
        ListView.Columns[2].Caption := 'File size';

        Attr := faReadOnly + faHidden + faSysFile + faArchive;
        if chbAlsoDirs.Checked then Attr := Attr + faDirectory;

        cDirectory := Dir;
        pnlPathVal.Caption := ' ' + Dir;
        ListView.Checkboxes := True;

        if chbShowPathInTitle.Checked then
        begin
                Caption := 'FaFNC - Files and Folders Names Cleaner 1.00 - ' + Dir;
                Application.Title := Dir + ' - FaFNC 1.00';
        end
        else
        begin
                Caption := 'FaFNC - Files and Folders Names Cleaner 1.00';
                Application.Title := 'FaFNC 1.00';
        end;

        lst := MainForm.ListView.Items.Add;
        lst.Caption := '[..]';
        lst.ImageIndex := 4;

        a := FindFirst(Dir + '\' + '*.*', Attr, SearchRec);
        while a = 0 do
        begin
                if SearchRec.Name[1] <> '.' then
                begin
                        if (SearchRec.Attr and faDirectory) > 0 then
                        begin
                                sSourceItem := '[' + SearchRec.Name + ']';
                                sDestItem := CreateNewNameByRule(sSourceItem, True);
                                isDir := 2;
                        end
                        else
                        begin
                                sSourceItem := SearchRec.Name;
                                sDestItem := CreateNewNameByRule(sSourceItem, False);
                                isDir := 0;
                        end;

                        fSize := GetFileSize(Dir + '\' + sSourceItem);
                        sSize := IntToStr(fSize) + ' B';
                        if fSize > 1024 then sSize := IntToStr(Round(fSize / 1024)) + ' kB';
                        if fSize > 1048576 then sSize := FloatToStrF(fSize / 1048576, ffFixed, 7, 2) + ' MB';
                        if fSize > 1073741824 then sSize := FloatToStrF(fSize / 1073741824, ffFixed, 7, 2) + ' GB';

                        if sSourceItem <> sDestItem then
                        begin
                                lst := MainForm.ListView.Items.Add;
                                lst.Caption := sSourceItem;
                                lst.SubItems.Add(sDestItem);

                                if chbAutoSelect.Checked then lst.Checked := True;

                                if isDir <> 2 then
                                        lst.SubItems.Add(sSize)
                                else
                                        lst.SubItems.Add('--');

                                lst.ImageIndex := 1 + isDir;
                                Inc(cChanged);
                        end;

                        if (sSourceItem = sDestItem) and (not chbShowOnlyThoseToBeChanged.Checked) then
                        begin
                                lst := MainForm.ListView.Items.Add;
                                lst.Caption := sSourceItem;
                                lst.SubItems.Add(sDestItem);

                                if isDir <> 2 then
                                        lst.SubItems.Add(sSize)
                                else
                                        lst.SubItems.Add('--');

                                lst.ImageIndex := 0 + isDir;
                        end;

                end;
                a := FindNext(SearchRec);
        end;

       if chbLockMarks.Checked and (ListView.Items.Count > 0) then
                for a := 0 to ListView.Items.Count - 1 do
                        if CheckMatrix[a] = 1 then ListView.Items[a].Checked := True else ListView.Items[a].Checked := False;


        ListView.SortType := stText;
        ListView.SortType := stNone;

        iTopItemIndex := GetIndexOfItem('[..]');
        if iTopItemIndex <> 0 then
        begin
                ListView.Items.Delete(iTopItemIndex);
                lst := ListView.Items.Insert(0);
                lst.Caption := '[..]';
                lst.ImageIndex := 4;
        end;

        FindClose(SearchRec);
        ListView.Items.EndUpdate;

        if IsUpdating then
        begin
                ListView.Scroll(0, ListView.Items[cTopItem].Position.y - 20);
                ListView.Items[tlSelected].Selected := True;
                if chbAutoFocus.Checked then ActiveControl := ListView;
        end
        else ListView.Items[0].Selected := True;

        btnGo.Enabled := ((ListView.Items.Count > 1) and (cChanged > 0));
        pnlChangedFilesVal.Caption := IntToStr(cChanged);

        cbWordSpace.Enabled := True;
        gbChanges.Enabled := True;
        lblLettersMode.Enabled := True;
        cbLettersMode.Enabled := True;
        chbPolishLetters.Enabled := True;
        chbBreakSigns.Enabled := True;
        chbErrors.Enabled := True;
        lblSeparator.Enabled := True;
        eSeparator.Enabled := True;
        chbAlsoDirs.Enabled := True;
        chbShowOnlyThoseToBeChanged.Enabled := True;
        chbAutoSelect.Enabled := True;
        chbAutoFocus.Enabled := True;
        gbChanges2.Enabled := True;
        gbView.Enabled := True;
        chbUppercaseAlso.Enabled := True;
        chbExtensionAlso.Enabled := True;
        chbChangeString1.Enabled := True;
        chbChangeString2.Enabled := True;
        chbChangeString3.Enabled := True;

        mnuSelectAll.Enabled := True;
        mnuDeselectAll.Enabled := True;
        mnuChangeSelection.Enabled := True;
        mnuOpenActual.Enabled := True;
        mnuExploreActual.Enabled := True;
        mnuOpenSelected.Enabled := True;
        mnuExploreSelected.Enabled := True;

        Screen.Cursor := crDefault;
end;

procedure TMainForm.ReadRoot();
var
        iDrive: Integer;
        cDrive: Char;
        lst: TListItem;
begin
        Screen.Cursor := crHourglass;
        
        cDirectory := '';
        pnlPathVal.Caption := ' My computer';
        ListView.Checkboxes := False;

        ListView.Columns[0].Width := 142;
        ListView.Columns[1].Width := 257;
        ListView.Columns[2].Width := 110;
        ListView.Columns[0].Caption := 'Disk or physical drive';
        ListView.Columns[1].Caption := 'Type and space left';
        ListView.Columns[2].Caption := 'Total capacity';

        if chbShowPathInTitle.Checked then
        begin
                Caption := 'FaFNC - Files and Folders Names Cleaner 1.00 - MÛj komputer';
                Application.Title := 'My computer - FaFNC 1.00';
        end
        else
        begin
                Caption := 'FaFNC - Files and Folders Names Cleaner 1.00';
                Application.Title := 'FaFNC 1.00';
        end;

        ListView.Items.BeginUpdate;
        ListView.Items.Clear;

        for cDrive := 'a' to 'z' do
        begin
                iDrive := GetDriveType(PChar(cDrive + ':\'));
                if (iDrive <> 0) and (iDrive <> 1) then
                begin
                        lst := MainForm.ListView.Items.Add;
                        lst.ImageIndex := iDrive + 3;
                        lst.Caption := UpperCase(cDrive) + ':\ [' + GetVolumeLabel(cDrive) + ']';

                        case iDrive of
                                DRIVE_REMOVABLE: lst.SubItems.Add('Removable drive');
                                DRIVE_FIXED: lst.SubItems.Add('Fixed drive');
                                DRIVE_REMOTE: lst.SubItems.Add('Network drive');
                                DRIVE_CDROM: lst.SubItems.Add('CD or DVD drive');
                                DRIVE_RAMDISK: lst.SubItems.Add('RAM disk');
                        end;
                        lst.SubItems[0] := lst.SubItems[0] + ' [' + GetVolumeSize(cDrive, False) + ']';

                        lst.SubItems.Add(GetVolumeSize(cDrive, True));
                end;
        end;

        ListView.Items.EndUpdate;

        btnGo.Enabled := False;
        pnlChangedFilesVal.Caption := '0';

        cbWordSpace.Enabled := False;
        gbChanges.Enabled := False;
        lblLettersMode.Enabled := False;
        cbLettersMode.Enabled := False;
        chbPolishLetters.Enabled := False;
        chbBreakSigns.Enabled := False;
        chbErrors.Enabled := False;
        lblSeparator.Enabled := False;
        eSeparator.Enabled := False;
        chbAlsoDirs.Enabled := False;
        chbShowOnlyThoseToBeChanged.Enabled := False;
        chbAutoSelect.Enabled := False;
        chbAutoFocus.Enabled := False;
        gbChanges2.Enabled := False;
        gbView.Enabled := False;
        chbUppercaseAlso.Enabled := False;
        chbExtensionAlso.Enabled := False;
        chbChangeString1.Enabled := False;
        chbChangeString2.Enabled := False;
        chbChangeString3.Enabled := False;

        mnuSelectAll.Enabled := False;
        mnuDeselectAll.Enabled := False;
        mnuChangeSelection.Enabled := False;
        mnuOpenActual.Enabled := False;
        mnuExploreActual.Enabled := False;
        mnuOpenSelected.Enabled := False;
        mnuExploreSelected.Enabled := False;

        Screen.Cursor := crDefault;
end;

procedure TMainForm.AddDisksToMenu();
var
        a, iDrive: Integer;
        cDrive: Char;
        sDrive: String;
        mnu: TMenuItem;
begin
        for a := pmList.Items.Count - 1 downto 0 do if (pmList.Items[a].Tag = 77) or (pmList.Items[a].Tag = 33) then pmList.Items.Delete(a);

        for cDrive := 'a' to 'z' do
        begin
                iDrive := GetDriveType(PChar(cDrive + ':\'));
                if (iDrive <> 0) and (iDrive <> 1) then
                begin
                        case iDrive of
                                DRIVE_REMOVABLE: sDrive('Removable drive');
                                DRIVE_FIXED: sDrive('Fixed drive');
                                DRIVE_REMOTE: sDrive('Network drive');
                                DRIVE_CDROM: sDrive('CD or DVD drive');
                                DRIVE_RAMDISK: sDrive('RAM disk');
                        end;

                        mnu := TMenuItem.Create(pmList);
                        mnu.Caption := sDrive + UpperCase(cDrive) + ':\ [' + GetVolumeLabel(cDrive) + ']';
                        mnu.Tag := 77;
                        mnu.OnClick := DiskMenuClickHandler;
                        pmList.Items.Add(mnu);
                end;
        end;

        mnu := TMenuItem.Create(pmList);
        mnu.Caption := '-';
        mnu.Tag := 77;
        pmList.Items.Add(mnu);

        mnu := TMenuItem.Create(pmList);
        mnu.Caption := 'Display all drives and disks';
        mnu.Tag := 33;
        mnu.OnClick := DiskMenuClickHandler;
        pmList.Items.Add(mnu);
end;

procedure TMainForm.ParameterClick(Sender: TObject);
begin
        ReadDir(cDirectory, True);
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
        SaveSettings();
end;

procedure TMainForm.btnExitClick(Sender: TObject);
begin
        Close;
end;

procedure TMainForm.ListViewDblClick(Sender: TObject);
var
        sSelected: String;
begin
        if ListView.Selected = nil then exit;

        sSelected := ListView.Selected.Caption;

        if ListView.Selected.ImageIndex > 4 then
        begin
                ReadDir(Copy(sSelected, Pos(':\', sSelected) - 1, 3), False);
                exit;
        end;

        if (ListView.Selected.ImageIndex > 1) and (ListView.Selected.ImageIndex < 5) then
        begin
                sSelected := Copy(sSelected, 2, Length(sSelected) - 2);

                if sSelected = '..' then
                begin
                        sSelected := ExcludeTrailingBackslash(cDirectory);
                        if Pos ('\', sSelected) = 0 then
                        begin
                                ReadRoot();
                                exit;
                        end
                        else while sSelected[Length(sSelected)] <> '\' do sSelected := Copy(sSelected, 1, Length(sSelected) - 1);
                end
                else sSelected := IncludeTrailingBackslash(cDirectory) + sSelected;

                ReadDir(sSelected, False);
                exit;
        end;

        sSelected := IncludeTrailingBackslash(cDirectory) + sSelected;
        if chbConfirmations.Checked then if Application.MessageBox(PChar('Execute following file:'+chr(13)+sSelected+chr(13)+chr(13)+'A program selected to open this type of files will be run'),'Execute file...',MB_YESNO+MB_ICONQUESTION+MB_DEFBUTTON2) = ID_NO then exit;
        ShellExecute(Handle, 'open', PChar(sSelected), '', '', SW_SHOW);
end;

procedure TMainForm.lblWebClick(Sender: TObject);
begin
        ShellExecute(Handle, 'open', 'http://www.gaman.pl/', '', '', SW_SHOW);
end;

procedure TMainForm.chbConfirmationsClick(Sender: TObject);
begin
        if IsLoading then exit;
        if not chbConfirmations.Checked then if Application.MessageBox('When this checkbox is not check, any accidental press of DEL button, when on list will delete file permanently!'+chr(13)+'(files are deleted WITHOUT using system bin -- this operation CANNOT BE UNDONE!)'+chr(13)+''+chr(13)+'Are you sure, that you want to disable warnings?','Warnings!',MB_YESNO+MB_ICONWARNING+MB_DEFBUTTON2) = ID_NO then chbConfirmations.Checked := True;
end;

procedure TMainForm.ListViewKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
var
        sSelected, sSource, sDest, sFile: String;
begin
        if ListView.Selected = nil then exit;

        if (Key = VK_F2) and (ListView.Selected.ImageIndex < 2) then
        begin
                sSource := ListView.Selected.Caption;
                sDest := InputBox('Rename', 'Enter new name for selected file:', sSource);

                if sDest = sSource then exit;

                if not RenameFile(IncludeTrailingBackslash(cDirectory) + sSource, cDirectory + '\' + sDest) then
                        Application.MessageBox('File rename failed!','Error...',MB_OK+MB_ICONWARNING+MB_DEFBUTTON1)
                else
                        ReadDir(cDirectory, True);
        end;

        if (Key = VK_DELETE) and (ListView.Selected.ImageIndex < 2) then
        begin
                sFile := IncludeTrailingBackslash(cDirectory) + ListView.Selected.Caption;

                if chbconfirmations.Checked then if Application.MessageBox(PChar('Following file will be PERMANENTLY deleted:' + chr(13) + chr(13) + sFile + chr(13) + chr(13) + 'Are you sure, you want to proceed?' + chr(13) + '(files are deleted WITHOUT using system bin -- this operation CANNOT BE UNDONE!)'),'Deleting a file..',MB_YESNO+MB_ICONQUESTION+MB_DEFBUTTON2) = ID_NO then exit;

                if DeleteFile(sFile) then
                begin
                        ListView.Selected.Delete;
                        ReadDir(cDirectory, True);
                end
                else Application.MessageBox('File deletion failed!','Error...',MB_OK+MB_ICONWARNING+MB_DEFBUTTON1)
        end;

        if Key = VK_RETURN then ListViewDblClick(self);

        if Key = VK_BACK then
        begin
                sSelected := ExcludeTrailingBackslash(cDirectory);
                if Pos ('\', sSelected) = 0 then
                begin
                        ReadRoot();
                        exit;
                end
                else while sSelected[Length(sSelected)] <> '\' do sSelected := Copy(sSelected, 1, Length(sSelected) - 1);

                ReadDir(sSelected, False);
        end;
end;

procedure TMainForm.chbShowPathInTitleClick(Sender: TObject);
begin
        if chbShowPathInTitle.Checked then
        begin
                if cDirectory <> '' then
                begin
                        Caption := 'FaFNC - Files and Folders Names Cleaner 1.00 - ' + cDirectory;
                        Application.Title := cDirectory + ' - FaFNC 1.00';
                end
                else
                begin
                        Caption := 'FaFNC - Files and Folders Names Cleaner 1.00 - MÛj komputer';
                        Application.Title := 'My computer - FaFNC 1.00';
                end;
        end
        else
        begin
                Caption := 'FaFNC - Files and Folders Names Cleaner 1.00';
                Application.Title := 'FaFNC 1.00';
        end;
end;

procedure TMainForm.mnuRefreshListClick(Sender: TObject);
begin
        AddDisksToMenu();

        if cDirectory = '' then
                ReadRoot()
        else
                ReadDir(cDirectory, True);
end;

procedure TMainForm.pnlMenuMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
        p: TPoint;
begin
        pnlMenu.BevelOuter := bvRaised;
        p := pnlMenu.ClientToScreen(Point(X, Y));
        pmList.Popup(p.X, p.Y);
end;

procedure TMainForm.pnlMenuMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
        pnlMenu.BevelOuter := bvLowered;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
        IsLoading := True;
        LoadSettings();

        AddDisksToMenu();

        Application.OnActivate := FormActivate;
end;

procedure TMainForm.DiskMenuClickHandler(Sender: TObject);
begin
        if (Sender as TMenuItem).Tag = 33 then
        begin
                ReadRoot();
                exit;
        end;
        
        if (Sender as TMenuItem).Tag = 77 then ReadDir(Copy((Sender as TMenuItem).Caption, Pos(':\', (Sender as TMenuItem).Caption) - 1, 3), False);
end;

procedure TMainForm.mnuSelectFolderClick(Sender: TObject);
begin
        fdFolder.Directory := cDirectory;
        
        if not fdFolder.Execute then exit;
        ReadDir(fdFolder.Directory, False);
end;

procedure TMainForm.mnuOpenActualClick(Sender: TObject);
begin
        ShellExecute(Handle, 'open', PChar(cDirectory), '', '', SW_SHOWNORMAL);
end;

procedure TMainForm.mnuExploreActualClick(Sender: TObject);
begin
        ShellExecute(Handle, 'explore', PChar(cDirectory), '', '', SW_SHOWNORMAL);
end;

procedure TMainForm.mnuSelectAllClick(Sender: TObject);
var
        a: Integer;
begin
        for a := 0 to ListView.Items.Count - 1 do ListView.Items[a].Checked := True;
end;

procedure TMainForm.mnuDeselectAllClick(Sender: TObject);
var
        a: Integer;
begin
        for a := 0 to ListView.Items.Count - 1 do ListView.Items[a].Checked := False;
end;

procedure TMainForm.mnuChangeSelectionClick(Sender: TObject);
var
        a: Integer;
begin
        for a := 0 to ListView.Items.Count - 1 do ListView.Items[a].Checked := not ListView.Items[a].Checked;
end;

procedure TMainForm.btnGoClick(Sender: TObject);
var
        AllUnChecked, AllAlreadyReady, AllDone: Boolean;
        a: Integer;
        sOldFile, sNewFile: String;
begin
        AllUnChecked := True;
        for a := 1 to ListView.Items.Count - 1 do if ListView.Items[a].Checked then AllUnChecked := False;

        if AllUnchecked then
        begin
                Application.MessageBox('No items selected on list.','Information...',MB_OK+MB_ICONINFORMATION+MB_DEFBUTTON1);
                exit;
        end;

        AllAlreadyReady := True;
        for a := 1 to ListView.Items.Count - 1 do if ListView.Items[a].Checked then if ListView.Items[a].Caption <> ListView.Items[a].SubItems[0] then AllAlreadyReady := False;

        if AllAlreadyReady then
        begin
                Application.MessageBox('All selected items are already renamed.','Information...',MB_OK+MB_ICONINFORMATION+MB_DEFBUTTON1);
                exit;
        end;

        AllDone := True;
        for a := 1 to ListView.Items.Count - 1 do
        begin
                if ListView.Items[a].Checked and (ListView.Items[a].ImageIndex < 4) then
                begin
                        if ListView.Items[a].ImageIndex = 1 then
                        begin
                                sOldFile := IncludeTrailingBackslash(cDirectory) + ListView.Items[a].Caption;
                                sNewFile := IncludeTrailingBackslash(cDirectory) + ListView.Items[a].SubItems[0];
                                if not RenameFile(sOldFile, sNewFile) then AllDone := False;
                        end;

                        if ListView.Items[a].ImageIndex = 3 then
                        begin
                                sOldFile := IncludeTrailingBackslash(cDirectory) + Copy(ListView.Items[a].Caption, 2, Length(ListView.Items[a].Caption) - 2);
                                sNewFile := IncludeTrailingBackslash(cDirectory) + Copy(ListView.Items[a].SubItems[0], 2, Length(ListView.Items[a].SubItems[0]) - 2);
                                if not MoveFile(PChar(sOldFile), PChar(sNewFile))then AllDone := False;
                        end;
                end;
        end;

        if not AllDone then
        begin
                Application.MessageBox('An error occurred when trying to rename one or more files or folders!' + #10#13 + 'If these files or folders have read-only attribute set, then remove it and repeat this operation','Information...',MB_OK+MB_ICONEXCLAMATION+MB_DEFBUTTON1);
                exit;
        end;

        ReadDir(cDirectory, True);
end;

procedure TMainForm.chbChangeString1Click(Sender: TObject);
begin
        if not chbChangeString1.Checked then
        begin
                edChangeFrom1.Enabled := False;
                edChangeTo1.Enabled := False;
                edChangeFrom1.Text := '';
                edChangeTo1.Text := '';
        end
        else
        begin
                edChangeFrom1.Enabled := True;
                edChangeTo1.Enabled := True;
                edChangeFrom1.SetFocus;
        end;

        ParameterClick(self);
end;

procedure TMainForm.chbChangeString2Click(Sender: TObject);
begin
        if not chbChangeString2.Checked then
        begin
                edChangeFrom2.Enabled := False;
                edChangeTo2.Enabled := False;
                edChangeFrom2.Text := '';
                edChangeTo2.Text := '';
        end
        else
        begin
                edChangeFrom2.Enabled := True;
                edChangeTo2.Enabled := True;
                edChangeFrom2.SetFocus;
        end;

        ParameterClick(self);
end;

procedure TMainForm.chbChangeString3Click(Sender: TObject);
begin
        if not chbChangeString3.Checked then
        begin
                edChangeFrom3.Enabled := False;
                edChangeTo3.Enabled := False;
                edChangeFrom3.Text := '';
                edChangeTo3.Text := '';
        end
        else
        begin
                edChangeFrom3.Enabled := True;
                edChangeTo3.Enabled := True;
                edChangeFrom3.SetFocus;
        end;

        ParameterClick(self);
end;

procedure TMainForm.mnuExecuteSelectedClick(Sender: TObject);
var
        sSelected: String;
begin
        if ListView.Selected.ImageIndex > 1 then exit;

        sSelected := IncludeTrailingBackslash(cDirectory) + ListView.Selected.Caption;

        if chbConfirmations.Checked then if Application.MessageBox(PChar('Execute following file:'+chr(13)+sSelected+chr(13)+chr(13)+'A program selected to open this type of files will be run'),'Execute file...',MB_YESNO+MB_ICONQUESTION+MB_DEFBUTTON2) = ID_NO then exit;
        ShellExecute(Handle, 'open', PChar(sSelected), '', '', SW_SHOW);
end;

procedure TMainForm.pmListPopup(Sender: TObject);
begin
        if ListView.Selected = nil then
        begin
                mnuOpenSelected.Enabled := False;
                mnuExploreSelected.Enabled := False;
                mnuExecuteSelected.Enabled := False;
                exit
        end;

        if ListView.Selected.ImageIndex > 1 then mnuExecuteSelected.Enabled := False else mnuExecuteSelected.Enabled := True;

        if (ListView.Selected.ImageIndex > 1) and (ListView.Selected.ImageIndex < 4) then
        begin
                mnuOpenSelected.Enabled := True;
                mnuExploreSelected.Enabled := True;
        end
        else
        begin
                mnuOpenSelected.Enabled := False;
                mnuExploreSelected.Enabled := False;
        end;
end;

procedure TMainForm.mnuOpenSelectedClick(Sender: TObject);
var
        sSelected: String;
begin
        sSelected := Copy(ListView.Selected.Caption, 2, Length(ListView.Selected.Caption) - 2);
        sSelected := IncludeTrailingBackslash(cDirectory) + sSelected;
        ShellExecute(Handle, 'open', PChar(sSelected), '', '', SW_SHOWNORMAL);
end;

procedure TMainForm.mnuExploreSelectedClick(Sender: TObject);
var
        sSelected: String;
begin
        sSelected := Copy(ListView.Selected.Caption, 2, Length(ListView.Selected.Caption) - 2);
        sSelected := IncludeTrailingBackslash(cDirectory) + sSelected;
        ShellExecute(Handle, 'explore', PChar(sSelected), '', '', SW_SHOWNORMAL);
end;

procedure TMainForm.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
        if Key = VK_F5 then mnuRefreshListClick(self);
end;

procedure TMainForm.FormActivate(Sender: TObject);
begin
        mnuRefreshListClick(self);
end;

function TMainForm.GetIndexOfItem(ItemCaption: String): Integer;
var
        a: Integer;
begin
        Result := -1;

        for a := 0 to ListView.Items.Count - 1 do if ListView.Items[a].Caption = ItemCaption then Result := a;
end;

end.


