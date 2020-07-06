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