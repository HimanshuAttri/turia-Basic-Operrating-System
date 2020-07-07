


[org 0x7c00]  ;default space for boot sector starts at this location
[bits 16]

section .text
    global main

main:

jmp 0x0000: ZeroSeg

ZeroSeg:
    xor ax,ax ; ax xor ax =0 ax <- 0 2 byte code fewer then mov ax,0
    mov ss,ax ; setting resiters to 0
    mov ds, ax ; to make sure bios isnt busyie. not segmenting
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov sp, main  ; stack pointer to entry point
    cld ; clear flag read string left to right higher to lower addr
    sti

push ax
xor ax, ax
int 0x13
pop ax

mov si, STR  ; It is used as source index for string operations.
call print

;mov si, STR0
;call print

;mov si, STR1
;call print

mov al , 1 ; no of sectors to read 
mov cl , 2 ; bootloader is at sector 1 so we choose latter
    
call readDisk
jmp test_sector2



jmp $ ; infinite wait after print is done

%include "print.asm"   ; cannot be above the first print call
%include "readDisk.asm" ; includes containing function must be included below the first fuction call
                         

STR: db "Hello Code" , 0x0a, 0xd, 0 ; db literally places that byte right there in the executable.
;STR0: db "This is Atr-OS 1.0",0x0a, 0x0d, 0

DISK_ERR_MSG: db "Error Loading Disk.", 0x0a, 0xd, 0
TEST_STR: db "Welcome to second sector, ",0x0a,0xd,0 
;STR1: db "Learning Right Now...", 0x0a,0xd, 0


times 510-($-$$) db 0 ; padding first sector with magic number

dw 0xaa55

test_sector2:

mov si, TEST_STR
call print 


times 512 db 0 ; padding for the second sector 
