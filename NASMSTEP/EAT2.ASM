; Source file : eat2.asm
; Executable file: eat2.com
; Code model: Real mode Flat model
; Version: 1.0
; Created date: 29/06/2024
; Updated date: 29/06/2024
; Author: Antony Lao
; Description: Following the EAT2.ASM program
;              from the 'Assembly Language Step by Step 2nd Edition'
;              book from Jeff Duntemann

[BITS 16]    ; Set 16 bit code generation. Means we run on Real Mode
[ORG 0100h]  ; Set code start at 0100h (COM file)

[SECTION .text]     ; section containing code
Start:              ; Start label: like a bookmark for jump functions
   mov dx, EatMsg1  ; loads the offset address of the var EatMsg1 into DX
   call Writeln      ; and display it (address DS:DX)
   mov dx, EatMsg2  ; loads the offset address of the var EatMsg2 into DX
   call Writeln      ; and display it (address DS:DX)

   mov ax, 04C00h   ; Select DOS service 4CH: exits the program.
                    ;   ErrorLevel is set to AL (0)
   int 21h          ; and returns control to DOS

;----------------------|
;  PROCEDURE SECTION   |
;----------------------|

; string to write is stored in DS:DX
Write:
   mov ah, 09h      ; Select DOS service 09: Print String
   int 21h          ; call DOS
   ret              ; Return to the caller

Writeln:
   call Write       ; display the string stored in DX through Write
   mov dx, CRLF     ; loads offset address of the var CRLF into DX
   call Write       ; display the newline string through Write
   ret              ; return to the caller

;----------------------|
;     DATA SECTION     |
;----------------------|

[SECTION .data]  ; Section containing initialized data
; string is of data type db: size of each character in the string
; a string can be any size, must end with "$" for the display mechanism
; 13,10 (or 0Dh, 0Ah) is CRLF in ASCII code

EatMsg1 db "Eat at Joe's . . .", "$"
EatMsg2 db "...ten million flies can't ALL be wrong!", "$"
CRLF    db 0Dh, 0Ah, "$"
