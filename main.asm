[org 0x7c00]  ; boot sector starts at this location
mov si, STR  ; It is used as source index for string operations.


call print
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



STR: db "Hello God" , 0 ; db literally places that byte right there in the executable.

times 510-($-$$) db 0 ; padding and magic number
dw 0xaa55
