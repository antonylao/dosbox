; Source name: EATSEG.ASM
; Executable name: EATSEG.COM
; Code model: Real mode Segmented model
; Version: 1.0
; Created date: 28/06/2024
; Updated date: 29/06/2024
; Author: Antony Lao
; Description: Following Assembly Step by Step Book
;              by Jeff Duntemann

; Commands to assemble
; nasm eatseg.asm -f obj -o eatseg.obj
; link eatseg.obj

[BITS 16] ; Set 16 bit code generation. To run in real mode
      
      SEGMENT code ; in the book, it is named junk..

..start: ; The two dots tell the linker to Start here
         ; Special syntax: MUST BE LOWERCASE. Still a label

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
   mov ax, data        ; Move segment address of data segment into AX
   mov ds, ax          ; Copy address from AX to DS (data segment)
   mov ax, stack       ; Move segment address of stack segment into AX 
   mov ss, ax          ; Copy address from AX to SS (Stack Segment)

   mov sp, stacktop    ; Point SP to the top of the stack

   mov dx, eatmsg      ; Mem data ref without [] loads the offset address
   mov ah, 9           ; Function 9 displays text at DS:DX to standard output
   int 21H             ; makes the call into DOS

   mov ax, 04C00H      ; Exits the program. ErrorLevel is set to AL (here 0)
   int 21H             ; returns control to DOS

      SEGMENT data     ; segment containing initialized data
   ; db is the type of data for each character of the string
   ; 0Dh, 0Ah is CRLF
   ; we end the string with "$" for the display
   eatmsg db "Eat at Joe's", 0Dh, 0Ah, "$"

      SEGMENT stack stack ; segment of type "stack", named "stack"
                          ; some linkers demand the specific type "stack"
                          ; syntax: SEGMENT <name> <type>
         resb64 ; reserve 64 bytes for the program stack
    stacktop:   ; this label points to the LAST of the reserved 64 bytes
