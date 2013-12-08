uses konrad,crt,_32bit;

Procedure Init;
Begin
 Init13h;
End;

Procedure Final;
Begin
 Textmode(3);
End;

begin
 Init;
 Final;
end.