unit kcrt;
interface
uses dos;

function keypressed:boolean;
function readkey:char;
procedure textmode(mode:byte);

implementation

var r:registers;
function keypressed:boolean;
begin
 r.ah:=1;
 intr($16,r);
 if r.al=0 then keypressed:=true else keypressed:=false;

end;

function readkey:char;
begin
 r.ah:=0;
 intr($16,r);
 if r.al <>0 then readkey:=chr(r.al) else readkey:=chr(r.ah);
end;

procedure textmode(mode:byte);
begin
 r.al:=mode;
 intr($10,r);
end;

end.