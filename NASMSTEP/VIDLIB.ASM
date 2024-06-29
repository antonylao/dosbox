; Source name: VIDLIB.ASM                                                
; Executable name: VIDLIB.ASM
; Code model: Real mode Segmented model
; Version: 1.0
; Created date: 29/06/2024
; Updated date: 29/06/2024
; Author: Antony Lao
; Description: Following Assembly Language Step by Step 2nd Edition
;              by Jeff Duntemann
;              Library including print CLRSCR, GOTOXY, WRITE, WRITELN
; Notes: 
;   - To be imported: data CRLF, LRXY (lower-right XY, in format <y><x>

                                                       
[BITS 16]    ; Set 16 bit code generation. Means we run on Real Mode

;------------------------|
;      CODE SEGMENT      |
;------------------------|

      SEGMENT code PUBLIC ; This segment may be accessed externally

; Only includes GLOBAL procedures (to be exported)
      GLOBAL ClrScr, ClrWin, ScrlScr, ScrlWin, VIDEO6
      GLOBAL GoToXY
      GLOBAL Write, Writeln

;----------------------------------------------------------
; CLRSCR - Clears or scroll the screen or a window
; Last Updated: 29/06/2024
; 
; 5 entry points
; 
; ClrScr:
; no input, no output
; Action: clears the screen entirely
; Notes: Cursor is at the bottom of the screen
;
; ClrWin:
; input: 
;   (CL, CH): coordinates of upper-left region
;   (DH, DL): coordinates of lower-right region
; Action: clears the window specified by CX and DX
;
; ScrlWin:
; input: 
;   (CL, CH): coordinates of upper-left region
;   (DH, DL): coordinates of lower-right region
;   AL: number of lines to scroll window by (0 clears it)
; Action: scrolls the window specified by CX and DX
;         by the number of lines specied by AL.
; Notes: still don't understand it completely. 
;   Apparently if you scroll a 2-line window by 1 line, 
;   you end up with a a region cleared of 1 line.  
;
; ScrlScr:
; input: 
;   AL: number of lines to scroll window by (0 clears it)
; Action: scrolls the whole screen
; Procedure(s) called: ScrlWin
; Notes:
;   - technically another procedure, but similar in logic than the others
;   - not sure of the difference with ClrScr in practice
;
; VIDEO6:
; input:
;   (CL, CH): coordinates of upper-left region
;   (DH, DL): coordinates of lower-right region
;   AL: number of lines to scroll window by (0 clears it)
;   BH: display attribute for blanked lines (07H is "normal")
; Action: generic access to BIOS VIDEO service 6. 
;-------------------------------------------------------------------

ClrScr:
   MOV CX, 0  ; upper left region set to (0, 0)
   MOV DX, [LRXY] ; lower down region set to (4FH, 18H) -> (79, 24)
ClrWin:  ; user must define CX, DX
   MOV AL, 0   ; make service VIDEO 6 clears the region
ScrlWin: ; user must define AL : number of lines scrolled
   MOV BH, 07H ; 07H defines 'normal' display for blanked lines
VIDEO6: ; call VIDEO service no 6
   MOV AH, 06H  ; service no 6: initialize / scroll
   INT 10H      ; call VIDEO service
   ret          ; return to caller

ScrlScr:
   MOV CX, 0  ; upper left region set to (0, 0)
   MOV DX, [LRXY] ; lower down region set to (4FH, 18H) -> (79, 24)
   call ScrlWin   ; call service ScrlWin   
   ret            ; return to caller

;---------------------------------------------------------------|
; GoToXY - position the hardware cursor to X,Y                  |
; Last Updated: 29/06/2024                                      |
;                                                               |
; 1 entry point                                                 |
;                                                               |
; GoToXY                                                        |
; Input: DL: X, DH: Y                                           |
; No output.                                                    |
;                                                               |
; Action: Moves the cursor to the position the X, Y position    |
;         defined on DX                                         |
; Notes: Indexes are 0-based. Screen in DOSBox is 80x25         |
;        => max index position is (79,24)                       |
;----------------------------------------------------------------

GoToXY:  ;Procedure to move the cursor to position X=DL, Y=DH (0-based)
   mov AH, 02H   ; Select VIDEO service 02H: Position cursor
   mov BH, 0     ; Stay with display page 0
                 ; Only use another value if you intend to 
                 ; tinker with multiple text display pages 
                 ; (not useful nowadays)
   int 10H       ; call service 10: BIOS VIDEO
   ret           ; Return to the caller

;--------------------------------------------------------------------
; WRITE - Write to standard output via DOS service 9: Print String
; Last updated: 29/06/2024
; 
; 1 entry point
; 
; Write:
; Input: 
;   DS: segment address of the string to be displayed
;   DX: offset address of the string to be displayed
; No output
; Secondary effects: Display string at address DS:DX
; 
; Action: Displays string at address DS:DX, up to '$' marker
; Notes: String must be terminated by '$'
;--------------------------------------------------------------------   

; string to write is at offset address stored in DS:DX
Write:
   mov ah, 09h      ; Select DOS service 09: Print String
   int 21h          ; call DOS
   ret              ; Return to the caller

;--------------------------------------------------------------------
; WRITELN - Write to standard output via DOS service 9: Print String,
;           and print a new line
; Last updated: 29/06/2024
; 
; 1 entry point
; 
; Writeln:
; Input: 
;   DS: segment address of the string to be displayed
;   DX: offset address of the string to be displayed
; No output
; Secondary effects: Display string at address DS:DX and a newline
; 
; Action: Displays string at address DS:DX, up to '$' marker, and 
;   a newline. 
; Notes: 
;   - String must be terminated by '$'
;   - Hardware cursor will move to the left margin of the following line
;   - If the display is to the bottom screen line, the screen will scroll
;-------------------------------------------------------------------------   


Writeln:
   call Write       ; display the string stored in DX through Write
   mov dx, CRLF     ; loads offset address of the var CRLF into DX
   call Write       ; display the newline string through Write
   ret              ; return to the caller


;----------------------|
;     DATA SEGMENT     |
;----------------------|
      SEGMENT data PUBLIC

      ; better to type variables ? CRLF and LRXY should be double word
      EXTERN CRLF, LRXY





                                                             
