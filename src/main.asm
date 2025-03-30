INCLUDE "gbhw.inc"
INCLUDE "constants.inc"

SECTION "Header", ROM0[$100]
    jp EntryPoint
    ds $150 - @, 0 ; RGBDS fill directive

SECTION "Main", ROM0
EntryPoint:
    di
    ld sp, $fffe
    
    ; Init display
    call LCDOff
    call LoadGraphics
    call InitCGB
    call LCDOn
    
    ; Init game state
    call InitPlayfield
    call SpawnNewPiece
    
MainLoop:
    call WaitVBlank
    call ReadJoypad
    call ProcessInput
    call HandleGravity
    call UpdateDisplay
    jr MainLoop

INCLUDE "tetromino.asm"
