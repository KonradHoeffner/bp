uses crt,dos;

const num:boolean=false;
      caps:boolean=false;
      scroll:boolean=false;
      warte=100;
var   b:byte;
      t,w:word;

PROCEDURE Setlock1;
BEGIN
     MEM[$0040:$0017]:=
     (MEM[$0040:$0017]AND NOT $70) OR (Byte(Scroll) SHL 4) OR (Byte(Num) SHL 5) OR (Byte(Caps) SHL 6);
END;

PROCEDURE SetLock2;
VAR Regs:Registers;
BEGIN
 MEM[$0040:$0017]:=(MEM[$0040:$0017] AND NOT $70) OR
(Byte(Scroll) SHL 4) OR (Byte(Num) SHL 5) OR (Byte(Caps) SHL 6);
 Regs.AH := 1;
 Intr($16,Regs);
END;


procedure an;
begin
 num:=true;
 caps:=true;
 scroll:=true;
end;

procedure aus;
begin
 num:=false;
 caps:=false;
 scroll:=false;
end;


begin
 repeat
 inc(b);
 an;
 case b mod 5 of
 1:begin caps:=false;scroll:=false; end;
 2:scroll:=false;
 3:num:=false;
 4:begin num:=false; caps:=false; end;
 else aus;
 end;
 setlock2;
 delay(warte);
 until keypressed;
 aus;
 setlock1;
end.