unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,


type
  TDF = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    Button2: TButton;
    Timer1: TTimer;
    Edit1: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    procedure WMDropFiles(var msg: TWMDROPFILES); message  WM_DROPFILES;
  public
    { Public declarations }
  end;

var
  DF: TDF;

implementation

{$R *.dfm}

var
   h: HWND;
procedure TDF.WMDropFiles(var msg: TWMDropFiles);
var
   dropH: HDROP;
   d: nativeUint;
   FileLength: Integer;
   I: Integer;
   FileName: string;
   FileCount: Integer;
begin
     inherited;
     droph:=msg.Drop;

     FileCount:=DragQueryFile(dropH, $FFFFFFFF, nil, 0);
     for I := 0 to FileCount-1 do begin
         FileLength:=DragQueryFile(dropH, I, nil, 0);
         SetLength(FileName, FileLength);
         DragQueryFile(dropH, I, PWideChar(FileName), FileLength+1);
         setwindowlong(h, GWL_STYLE, WS_EX_ACCEPTFILES);
         postmessage(h, wm_dropFiles,msg.Drop , 0);
         ShowMessage(FileName);
     end;
     DragFinish(dropH);
     msg.Result:=0;
end;

procedure TDF.Button1Click(Sender: TObject);
var
   t: array [0..255] of widechar;
   c: array [0..255] of widechar;
begin
     memo1.Lines.Clear;
     h:= FindWindow(nil, nil);
     while h<>0 do begin
           GetWindowText(h, t, 128);
           GetClassName(h, c, 128);
           Memo1.Lines.Add(t+' handle: '+IntToStr(h));
 {          if LowerCase(Copy(t, 1, 4))= 'toad' then begin
              Memo1.Lines.Add(Copy(t, 1, 4)+' handle: '+IntToStr(h));
              break;
           end;}
           h:=GetNextWindow(h, GW_HWNDNEXT);
     end;
end;

procedure TDF.Button2Click(Sender: TObject);
begin
     PostMessage(h, WM_CLOSE, 0, 0);
end;

procedure TDF.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     DragAcceptFiles(DF.Handle, False);
end;

procedure TDF.FormCreate(Sender: TObject);
var
   t: array [0..255] of widechar;
   c: array [0..255] of widechar;
begin
     DragAcceptFiles(DF.Handle, True);
     memo1.Lines.Clear;
     h:= FindWindow(nil, nil);
     while h<>0 do begin
           GetWindowText(h, t, 128);
           GetClassName(h, c, 128);
           if LowerCase(Copy(t, 1, 1))= 'á' then begin
              Memo1.Lines.Add(Copy(t, 1, 4)+' handle: '+IntToStr(h));
              break;
           end;
           h:=GetNextWindow(h, GW_HWNDNEXT);
     end;
     h:=1770838;
end;

procedure TDF.FormShow(Sender: TObject);
begin
     SetForegroundWindow(DF.Handle);
     SetWindowPos(DF.Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOACTIVATE or SWP_NOMOVE or
        SWP_NOSIZE);
end;

procedure TDF.Timer1Timer(Sender: TObject);
var
  p: TPoint;
begin
     GetCursorpos(p);
     Edit1.Text:=IntToStr(windowfrompoint(p));


end;

end.
