uses windos,strings;
const maxfilenames=50;
      opath:string='c:\test\';
      path:string='c:\test\*.*';
      FileCount:word=0;
type TFile= record
             name:string[80];
             dt:TDateTime;
            end;
var f:file;
    files:array[1..maxfilenames] of TFile;
    FileInfo:TSearchRec;
    zStr:array[0..79] of char;

procedure ReadFiles;
Begin
{Anmerkung: als erste 2 Files werden "." und ".." gemeldet...}
 if paramcount>0 then path:=paramstr(1);
 StrPCopy(zStr,Path);
 FindFirst(zStr,faAnyFile,FileInfo);
 FindNext(FileInfo);
 FindNext(FileInfo);
 while DOSError=0 do
 begin
  inc(FileCount);
  with Files[Filecount] do begin
   Name:=StrPas(FileInfo.name);
   UnpackTime(FileInfo.time,dt);
  end;
  FindNext(FileInfo);
 end;
End;

procedure Sort(var F:array of TFile;anz:word);
var i,j:integer;
    dummy:TFile;

function aelter(zeit1,zeit2:TDateTime):boolean;
var a,b:array[1..6] of word;
    i:integer;
begin
 aelter:=false;
 with zeit1 do
 begin
  a[1]:=year;a[2]:=month;a[3]:=day;
  a[4]:=hour;a[5]:=min;a[6]:=sec;
 end;
 with zeit2 do
 begin
  b[1]:=year;b[2]:=month;b[3]:=day;
  b[4]:=hour;b[5]:=min;b[6]:=sec;
 end;
 for i:=1 to 6 do if a[i]<b[i] then break else if a[i]>b[i] then begin aelter:=true; break;end;
end;

begin
 for i:=1 to FileCount-1 do
  for j:=j+1 to FileCount do if aelter(files[i].dt,files[j].dt) then
  begin
   dummy:=Files[i];
   Files[i]:=Files[j];
   Files[j]:=dummy;
  end;
end;

Procedure RenameFiles;
var i,code:integer;
    f:file;
    s:string;
Begin
 for i:=1 to FileCount do
 begin
  assign(f,opath+Files[i].name);
  str(i,s);
  if i<10 then s:='0'+s;
  s:=s+'_'+Files[i].name;
  rename(f,opath+s);
 end;
End;

begin
 ReadFiles;
 Sort(files,FileCount);
 RenameFiles;
end.