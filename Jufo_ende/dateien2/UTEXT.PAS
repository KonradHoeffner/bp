{훃nit UText컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
 MWrite ist eine Prozedur zum Ausgeben von
 Strings mit hervorgehobenen Buchstaben
 f걊 den Einsatz in Men걌
 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
unit utext;
interface
 procedure mwrite(s:string);
implementation
uses crt;
procedure mwrite(s:string);
var b:byte;
begin
 for b:=1 to ord(s[0]) do if s[b]<>'&' then write(s[b])
     else begin textcolor(white);inc(b);write(s[b]);textcolor(lightgray); end;;
end;

end.