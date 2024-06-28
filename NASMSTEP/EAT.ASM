; Source file : eat.asm
; Executable file: eat.com
; Code model: Real mode Flat model
; Version: 1.0
; Created date: 28/06/2024
; Updated date: 28/06/2024
; Author: Antony Lao
; Description: Following the EAT.ASM program
;              from the 'Assembly Language Step by Step 2nd Edition'
;              book from Jeff Duntemann

; Code in brackets means that we speak to the assembler NASM
[BITS 16]   ; Set 16-bit code generation. Means that we run on real mode.
[ORG 0100h] ; Set beginning address of the code.

[SECTION .text]  ; Section containing code
START:           ; Start label: like a bookmark for jump fonctions
  mov dx, eatmsg ; Mem data without [] loads the address of the variable
  mov ah, 9      ; Function 9 displays text to standard output
  int 21h        ; int 21h makes the call to DOS
  mov ax, 04C00h ; exits the program
  int 21h        ; returns control to DOS

[SECTION .data]  ; Section containing initialized data
; string is of data type db: size of each character in the string
; a string can be any size, must end with "$" for the display mechanism
; 13,10 (or 0Dh, 0Ah) is CRLF in ASCII code
eatmsg db "Eat at Joe's!", 0Dh, 0Ah, "$"
