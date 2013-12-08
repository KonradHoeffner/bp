{                GRAPHICS                                TEXT

15-bit   7-bit    Resolution   Colors   15-bit   7-bit    Columns   Rows
mode     mode                           mode     mode
number   number                         number   number
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
100h     -        640x400      256      108h     -        80        60
101h     -        640x480      256
                                        109h     -        132       25
102h     6Ah      800x600      16       10Ah     -        132       43
103h     -        800x600      256      10Bh     -        132       50
                                        10Ch     -        132       60
104h     -        1024x768     16
105h     -        1024x768     256

106h     -        1280x1024    16
107h     -        1280x1024    256

                      VESA Super VGA Standard VS911022-8

10Dh     -        320x200      32K   (1:5:5:5)
10Eh     -        320x200      64K   (5:6:5)
10Fh     -        320x200      16.8M (8:8:8)
110h     -        640x480      32K   (1:5:5:5)
111h     -        640x480      64K   (5:6:5)
112h     -        640x480      16.8M (8:8:8)
113h     -        800x600      32K   (1:5:5:5)
114h     -        800x600      64K   (5:6:5)
115h     -        800x600      16.8M (8:8:8)
116h     -        1024x768     32K   (1:5:5:5)
117h     -        1024x768     64K   (5:6:5)
118h     -        1024x768     16.8M (8:8:8)
119h     -        1280x1024    32K   (1:5:5:5)
11Ah     -        1280x1024    64K   (5:6:5)
11Bh     -        1280x1024    16.8M (8:8:8)}

unit vesa;
interface
procedure initvesa(mode:word);
implementation
procedure initvesa(mode:word);
begin
 asm
  mov bx,mode
  mov ax,mode
  int 10h
 end;
end;
end.