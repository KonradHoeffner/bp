type person=           set of(haus,auto,familie);
var  martin_mustermann,
     max_mueller:      person;
begin
 martin_mustermann:=[haus,auto];
 max_mueller:=[familie,auto];
 writeln(sizeof(max_mueller)); {ausgabe : 1}
 if max_mueller=[familie,auto] then write('was der alles hat!');
 readln;
end.