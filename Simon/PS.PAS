šbrigens: ich habe jetzt einen neuen Palettenbefehl in die Konrad.pas/tpu
integriert: "SetMypalette"
1. Syntax
SetMyPalette(Nr der Farbe,R,G,B:byte); -> "Setpalette" gibts schon
2. Aufbau
Procedure SetmyPalette(nr,r,g,b:byte);assembler;
asm
 mov dx,03c8h
 mov al,nr
 out dx,al
 inc dx
 mov al,r
 out dx,al
 mov al,g
 out dx,al
 mov al,b
 out dx,al
End;

}
