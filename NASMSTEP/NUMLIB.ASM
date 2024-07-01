; Source file: NUMLIB.ASM
; Executable file: NUMLIB.COM
; Code model: Real mode Segmented Model
; Version: 1.0
; Created date: 30/06/2024
; Updated date: 30/06/2024
; Author: Antony Lao
; Description: Library of methods using numbers (procedures inspired by
;               Assembly Step by Step 2nd Edition by Jeff Duntemann)

[BITS 16] ; Use 16-bit code generation. Means we run in real mode

;------------------------|
;      CODE SEGMENT      |
;------------------------|

      SEGMENT code PUBLIC ; This segment may be accessed externally
; Using Flat model for test
;[ORG 0x0100]  ; Set code start at 0100h (COM file)
;[SECTION .text]     ; section containing code


; Only includes GLOBAL procedures (to be exported)
      GLOBAL Byte2Str, Word2Str

;---------------------------------------------------------
; Byte2Str - Converts a byte passed in AL 
;             to a string in DS:SI
; Last update 30/06/2024
; 
; 1 entry point:
; 
; Byte2Str:
;   input: 
;   - AL: Byte to be converted
;   - DS: Segment of the destination string
;   - SI: Offset of the destination string
;   output:
;   - 2-digit hexadecimal string, at address DS:SI 
;     (2 characters => 2 slots in memory => 4 bytes)
;   side-effects:
;   - change registers: AH (AL stays the same), BX? (not with current), DI
;
;   Action: Converts the 8-bit value stored in AL into a 2-digit
;      hexadecimal string at address DS:SI.
;   Notes:
;   - the "H" specifier is not included
;   - uses the Digits variable, which is defined in the library
;   - part of the instruction require 286 CPU or better
;   Examples: 02  B7 
;
;-------------------------------------------------------------------- 

Byte2Str: 
  MOV DI, AX       ; copy the whole AX register. We only want AL into DI
  and DI, 000FH    ; first, we only keep the 4 last bits of DI
                   ; by using a bitmask. 
  MOV AH, [Digits + DI] ; Copy char of right digit to AH
  MOV [SI + 1], AH ; store right digit in value of address (SI+1)
  XOR AH, AH       ; Zero out AH 
  MOV DI, AX       ; copy again the whole AX register into DI. 
  ; Warning: following instruction require 286 or better
  SHR DI, 4        ; we want the 4 left bits of DI
  MOV AH, [Digits + DI] ; Copy char of left digit to AH
  MOV [SI], AH     ; store left digit in value of address SI
  ret              ; Return to the caller

;---------------------------------------------------------
; Word2Str - Converts a word (16-bits) passed in AX 
;             to a string in DS:SI
; Last update 30/06/2024
; 
; 1 entry point:
; 
; Word2Str:
;   input: 
;   - AX: Byte to be converted
;   - DS: Segment of the destination string
;   - SI: Offset of the destination string
;   output:
;   - 4-digit hexadecimal string, at address DS:SI 
;     (4 slots in memory => 8 bytes)
;   side-effects:
;   - change registers: AH (AL stays the same), CX, DI
;                       SI: becomes SI+2
;
;   Action: Converts the 16-bit value stored in AX into a 4-digit
;      hexadecimal string at address DS:SI.
;   Procedures used: Byte2Str
;   Notes:
;   - the "H" specifier is not included
;   - uses the Digits variable, which is defined in the library
;   - part of the instruction require 286 CPU or better
;   
;
;-------------------------------------------------------------------- 

Word2Str:
  MOV CX, AX    ; copy AX to another not used register: CX
  XCHG AH, AL   ; load AL to high 8-bits
  CALL Byte2Str ; call Byte2Str with value AL at address DS:SI
  MOV AL, CL    ; load AL to low 8-bits
  ADD SI, 2     ; change address to 2 slots in memory after
  CALL Byte2Str ; call Byte2Str with value AL at address DS:SI 
  ret           ; return the the caller

;----------------------|
;     DATA SEGMENT     |
;----------------------|

      SEGMENT data ; no need for public?
; Using flat model for test
;[SECTION .data]

Digits DB "0123456789ABCDEF"

