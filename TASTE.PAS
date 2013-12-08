const taste=#13; {code fr enter}
begin
 write('Bitte Enter drcken!');
 asm
  @loop:
  mov ah,0 {unterfunktion 0 des}
  int 16h  {interrupts 16h -> Taste abfragen u ergebnis in al ablegen}
  cmp al,taste {Vergleich al mit Taste durchfhren}
  jne @loop {wenn nicht gleich sprung zu loop}
 end;
end.