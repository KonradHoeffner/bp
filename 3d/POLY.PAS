uses crt,konrad,_13h;

procedure HLine(var d;x1,y1,x2:integer;col:byte);assembler;
asm
 push es
 les di,d
 mov ax,320
 mul y1
 add ax,x1
 add di,ax
 mov ax,x2
 sub ax,x1
 inc ax
 shr ax,1
 mov cx,ax
 mov al,col
 mov ah,al
 jnc @weiter
 stosb
 @weiter:
 rep stosw
 pop es
End;

procedure drawpoly(var d;x1,y1,x2,y2,x3,y3:integer;col:byte);
var xl,xr,y:word;
begin
{ for y:=y1 to}
 line(d,x1,y1,x2,y2,15);
 line(d,x1,y1,x3,y3,15);
 line(d,x2,y2,x3,y3,15);
 for y:=y1 to y3 do
 begin
  xl:=(y-y1)*(x2-x1) div (y2-y1)+x1;
  xr:=(y-y1)*(x3-x1) div (y3-y1)+x1;
  hline(d,xl,y,xr,15)
 end;

 for y:=y3 to y2 do
 begin
  xl:=(y-y1)*(x2-x1) div (y2-y1)+x1;
  xr:=(y2-y)*(x3-x2) div (y2-y3)+x2;
  if xr>xl then hline(d,xl,y,xr,15)
            else hline(d,xr,y,xl,15);
 end;

end;

begin
 init13h;
 drawpoly(screen,1,1,10,70,250,30,15);
 readkey;
end.