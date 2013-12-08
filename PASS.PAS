uses crt;
const passwort='pokemon';
var s:string;

begin
 repeat
  write('Bitte Passwort eingeben: ');
  readln(s);
  if s<>passwort then delay(2000);
 until s=passwort;
end.