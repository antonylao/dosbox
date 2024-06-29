; Source file: EAT5.ASM
; Executable file: EAT5.COM
; Code model: Real mode Flat model
; Version: 1.0
; Created date: 29/06/2024
; Update date: 29/06/2024
; Author: Antony Lao
; Description: Following Assembly Language Step by Step 2nd Edition
;              book by Jeff Duntemann.
;              Require MYLIB.MAC


[BITS 16]            ; Set 16 bit code generation. Means we run in Real mode
[ORG 0100h]          ; Set code start address at 0100h (COM file)

[SECTION .text]      ; Section containing code

%include "MYLIB.MAC" ; Load in screen control macro library

Start:               ; Label defining the start of program execution
  Clear VidOrigin, 07B0h, 2000 ; Replace B0 with 20 for space clear
                               ; 07H is the attribute (colors), 
                               ; B0 the character (make it 20 for "space")
                               ; 2000 is the number of "characters" to replace

  GotoXY 14H, 09H            ; Position cursor
  Write Eat1, Eat1Length     ; and display first text line
  GotoXY 14H, 0AH            ; Position cursor
  Write Eat2, Eat2Length     ; and display second text line

  ; exits the program
  mov ax, 04C00h   ; Select DOS service 4CH: exits the program.
                   ;   ErrorLevel is set to AL (0)
  int 21h          ; and returns control to DOS

[SECTION .data]      ; Section containing initialized data
  
LRXY DW 184Fh        ; index of lower-right screen corner
                     ; (4Fh, 18h) -> (79, 24)
VidOrigin DD 0B8000000h ; Double (32 bits).
                        ; Change to 0B0000000h if monochrome screen
Eat1 DB "Eat at Joe's..."
Eat1Length EQU $-Eat1  ; ??
Eat2 DB "...ten million flies can't ALL be wrong!"
Eat2Length EQU $-Eat2  ; ??
CRLF DB 0Dh, 0Ah

