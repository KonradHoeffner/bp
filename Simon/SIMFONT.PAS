uses crt,konrad;
const  hoehe=6;
       breite=6;
type Tbstb=array[0..hoehe-1,0..breite-1] of byte;
const a=ord('A');
      z=ord('Z');
      B_A:TBstb=
     ((0,0,1,1,0,0),
      (0,1,0,0,1,0),
      (0,1,1,1,1,0),
      (0,1,0,0,1,0),
      (0,1,0,0,1,0),
      (0,0,0,0,0,0));

      B_B:TBstb=
     ((0,1,1,0,0,0),
      (0,1,0,1,0,0),
      (0,1,1,1,1,0),
      (0,1,0,0,1,0),
      (0,1,1,1,0,0),
      (0,0,0,0,0,0));

      B_C:TBstb=
     ((0,0,1,1,1,0),
      (0,1,0,0,0,0),
      (0,1,0,0,0,0),
      (0,1,0,0,0,0),
      (0,0,1,1,1,0),
      (0,0,0,0,0,0));

var alphabet:array[0..255] of tbstb;

Procedure Init;
var i:integer;
Begin
 Init13h;
 alphabet[ord('A')]:=B_A;
 alphabet[ord('B')]:=B_B;
 alphabet[ord('C')]:=B_C;
End;

Procedure MyWrite(x,y:integer;var bstb:Tbstb);
var mx,my:integer;
Begin
 for my:=0 to hoehe-1 do
  for mx:=0 to breite-1 do
   screen[y+my,x+mx]:=bstb[my,mx]*15;
End;

Procedure PutC(x,y:integer;ch:char);
Begin
 mywrite(x,y,alphabet[ord(ch)]);
End;

Procedure PutS(x,y:integer;s:string);
var i:integer;
Begin
 for i:=1 to length(s) do
 Begin
  Putc(x,y,Upcase(s[i]));
  inc(x,breite);
 End;
End;

begin
 Init;
 PutS(10,10,'abcabccbabbbaa');
 readln;
end.