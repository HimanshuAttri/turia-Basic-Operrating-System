
printh:
 
 mov si, HEX_PATTERN

 mov bx,dx; 
 shr bx, 12 ; rightshift 12 bits 
 mov bx, [bx+HEX_TABLE];repacing ascii
 ;add bx, 48
 mov  [HEX_PATTERN+2], bl

 mov bx, dx
 shr bx,8
  and bx, 0x000f
 mov bx, [bx+HEX_TABLE]
 mov [HEX_PATTERN +3], bl

 mov bx,dx
 shr bx, 4
 and bx, 0x000f
 mov bx, [bx+HEX_TABLE]
 mov [HEX_PATTERN+4], bl

mov bx, dx
shr bx, 0
and bx, 0x000f
mov bx, [bx+HEX_TABLE]
mov  [HEX_PATTERN+5], bl

 call print
 ret
 HEX_PATTERN: db '0x****', 0x0a, 0x0d, 0 

 HEX_TABLE: db '0123456789abcdef'