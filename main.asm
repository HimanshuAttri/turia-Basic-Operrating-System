[org 0x7c00]  ;default space for boot sector starts at this location
mov si, STR  ; It is used as source index for string operations.
call print

mov si, STR0
call print

mov si, STR1
call print

mov al , 1 ; no of sectors to read 
mov cl , 2 ; bootloader is at sector 1 so we choose latter
    
call readDisk
jmp test_sector2



jmp $ ; infinite wait after print is done

print:
  pusha ;Pushes the contents of the general-purpose registers onto the stack. The registers are stored on the stack in the following order: EAX, ECX, EDX, EBX, EBP, ESP


  str_loop:
    mov al, [si]   ; char by char move the str value to al resister

    cmp al, 0      ; str ends with 0 com if al is 0 then print is complete
    jne print_char ; jne is jump only if not equal hence print char is it is not 0 ie. not end end

    popa        ; pops the contents of the general-purpose registers out of stack
    ret         ; print is done return to  jmp$ infinite wait

print_char:      ; prints the char present at si
  mov ah, 0x0e    ; interrupt 10h needs a value in AH/AL/AX to know what to do. To print characters on the screen, interrupt 10h needs AH set to 0x0e.
  int 0x10         ; it moves the cursor to next location on screen;
  add si, 1         ; it increments si and set to the next char in str
  jmp str_loop       ; it moves to the next char as si is  incremented.



  readDisk:
    pusha 
    mov ah, 0x02
    mov dl,  0x80  ; flopy 0x80 from hard disk , 0x0 for floppy/usb/cd, 
    mov ch , 0 ; select firstcylinder
    mov dh, 0 ; select first head
    push bx 
    mov bx, 0 
    mov es ,bx  ; segment register to 0
    pop bx ; Everything you push, you MUST pop again at some point afterwards, or your code will crash almost immediately!
    mov bx, 0x7c00 + 512 ; after the boot sector
    int 0x13

    jc disk_err
    popa
    ret

    disk_err:
      mov si, DISK_ERR_MSG
      call print 
      jmp $


STR: db "Hello Code" , 0xd, 0 ; db literally places that byte right there in the executable.
STR0: db "This is Atr-OS 1.0",0x0a, 0x0d, 0

DISK_ERR_MSG: db "Error Loading Disk.", 0x0a, 0xd, 0
TEST_STR: db "Welcome to second sector, ",0x0a,0xd,0 
STR1: db "Learning Right Now...", 0x0a,0xd, 0


times 510-($-$$) db 0 ; padding first sector with magic number

dw 0xaa55

test_sector2:

mov si, TEST_STR
call print 


times 512 dw 0 ; padding for the second sector 
