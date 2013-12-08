uses crt;
var s:string;

begin
clrscr;
repeat
write('C:\>');
readln(s);
if s= '' then writeln('C:\>')
          else begin writeln('Befehl oder Dateiname nicht gefunden.'); writeln; end;
until s= 'James';

end.
