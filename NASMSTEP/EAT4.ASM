; Source name: EAT4.ASM                                                        
; Executable name: EAT4.ASM
; Code model: Real mode Flat model
; Version: 1.0
; Created date: 29/06/2024
; Updated date: 29/06/2024
; Author: Antony Lao
; Description: Following Assembly Language Step by Step 2nd Edition
;              by Jeff Duntemann
;              Using BIOS VIDEO service to control the cursor
;              Must be linked with VIDLIB.ASM

; Commands to assemble
; (if not assembled, or updated VIDLIB.ASM)
; nasm vidlib.asm -f obj -o vidlib.asm
; nasm eat4.asm -f obj -o eat4.obj
; link eatseg.obj


[BITS 16]    ; Set 16 bit code generation. Means we run on Real Mode

;------------------------
;     CODE SEGMENT
;------------------------

      SEGMENT code PUBLIC

      ; items from VIDLIB.ASM to be imported
      EXTERN ClrScr
      EXTERN GoToXY
      EXTERN Write, Writeln


; SEGMENT SETUP
; The program uses three segments: code, data, stack
; Larger programs can have more code and data segment, 
;   but only one stack segment at a time
; Each segment indicate a segment address
; Those segment addresses are moved into each segment register
; NB: we don't do anything with CS: 
;     the ..start: label tells the linker where the code segment begins
; NB: you can't load immediate data (nor memory data?) to segment register
;     directly

..start:
  ; begin segment register setup
  mov ax, data        ; Move segment address of data segment into AX
  mov ds, ax          ; Copy address from AX to DS (data segment)
  mov ax, stack       ; Move segment address of stack segment into AX 
  mov ss, ax          ; Copy address from AX to SS (Stack Segment)

  mov sp, stacktop    ; Point SP to the top of the stack
  ; end segment register setup


  call ClrScr                ; Clear the full display
  mov word [TextPos], 0914H  ; 0914H -> X=20, Y=9

  mov DX, [TextPos]          ; Put coordinates (20,9) to DX
  call GoToXY                ; Position cursor at (DL:20, DH:9) coordinates
  mov DX, EatMsg1            ; copy offset address of EatMsg1 into DX
  call Write                 ; display value of DX (without newline)

  mov DX, [TextPos]          ; reuse value of var TextPor 
                             ; (apparently Write procedure change it)
  mov DH, 10                 ; change Y to 10, keep same X
  call GoToXY                ; Position cursor at (DL: 20, DH: 10) coordinates
  mov DX, EatMsg2            ; copy offset address of EatMsg2 into DX
  call Write                 ; display value of DX (without newline)

  ; exits the program
  mov ax, 04C00h   ; Select DOS service 4CH: exits the program.
                   ;   ErrorLevel is set to AL (0)
  int 21h          ; and returns control to DOS

;----------------------|
;     DATA SEGMENT     |
;----------------------|
      
      SEGMENT data PUBLIC

      GLOBAL LRXY, CRLF   ; exported to VIDLIB.ASM
      ; EatMsg1, EatMsg2, TextPos are PRIVATE variables because
      ;   they are not declared as global

; string is of data type db: size of each character in the string
; a string can be any size, must end with "$" 
;   for the display mechanism of DOS service 9
; 13,10 (or 0Dh, 0Ah) is CRLF in ASCII code

EatMsg1 db "Eat at Joe's . . .", "$"
EatMsg2 db "...ten million flies can't ALL be wrong!", "$"
CRLF    db 0Dh, 0Ah, "$"

LRXY    dw 184FH              ; Lower-right XY coordinates as <y><x>
                              ;  (4FH, 18H) -> (79, 24)   
TextPos dw 0000H              ; Stores position of cursor
                                                             
;----------------------|
;    STACK SEGMENT     |
;----------------------|

      SEGMENT stack stack ; segment of type "stack", named "stack"
                          ; some linkers demand the specific type "stack"
                          ; syntax: SEGMENT <name> <type>
      resb64 ; reserve 64 bytes for the program stack
stacktop:   ; this label points to the LAST of the reserved 64 bytes

