unit text;
interface
procedure mwrite(s:string);
implementation

uses crt;

procedure mwrite(s:string);
var b:byte;
begin
 for b:=1 to length(s) do
 if s[b]<>'&' then write(s[b]) else
 begin
  inc(b);
  textcolor(white);
  write(s[b]);
  textcolor(lightgray);
 end;
end;


end.