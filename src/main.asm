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

; LCD Control Functions
LCDOff:
    ldh a, [rLCDC]
    res rLCDC_ENABLE, a
    ldh [rLCDC], a
    ret

LCDOn:
    ldh a, [rLCDC]
    set rLCDC_ENABLE, a
    ldh [rLCDC], a
    ret

; Wait for VBlank
WaitVBlank:
    ldh a, [rLY]
    cp 144
    jr c, WaitVBlank
    ret

; Load graphics data
LoadGraphics:
    ; Load tile data to VRAM
    ld hl, $8000
    ld de, TileData
    ld bc, TileDataEnd - TileData
    call CopyData
    ret

; Copy data from DE to HL, BC bytes
CopyData:
    ld a, [de]
    ld [hl+], a
    inc de
    dec bc
    ld a, b
    or c
    jr nz, CopyData
    ret

; Initialize playfield
InitPlayfield:
    ld hl, Playfield
    ld bc, PLAYFIELD_WIDTH * PLAYFIELD_HEIGHT
    xor a
    call FillMemory
    ret

; Fill memory with value A, BC bytes
FillMemory:
    ld [hl+], a
    dec bc
    ld a, b
    or c
    jr nz, FillMemory
    ret

; Spawn new piece
SpawnNewPiece:
    call GetNextPiece
    ld [CurrentPieceType], a
    ld a, PLAYFIELD_START_X + 4
    ld [CurrentPieceX], a
    ld a, PLAYFIELD_START_Y
    ld [CurrentPieceY], a
    xor a
    ld [CurrentPieceRotation], a
    ret

; Get next piece from bag
GetNextPiece:
    ld a, [BagIndex]
    cp 7
    jr nz, .getFromBag
    call RefillBag
    xor a
.getFromBag:
    ld hl, RandomBag
    ld c, a
    ld b, 0
    add hl, bc
    ld a, [hl]
    inc c
    ld [BagIndex], a
    ret

; Read joypad input
ReadJoypad:
    ld a, P1F_GET_DPAD
    ldh [rJOYP], a
    ldh a, [rJOYP]
    ldh a, [rJOYP]
    ldh a, [rJOYP]
    ldh a, [rJOYP]
    cpl
    and $0F
    swap a
    ld b, a
    
    ld a, P1F_GET_BTN
    ldh [rJOYP], a
    ldh a, [rJOYP]
    ldh a, [rJOYP]
    ldh a, [rJOYP]
    ldh a, [rJOYP]
    cpl
    and $0F
    or b
    ld c, a
    
    ld a, [JoypadState]
    ld b, a
    ld a, c
    ld [JoypadState], a
    xor b
    and c
    ld [JoypadPressed], a
    ret

; Process input
ProcessInput:
    ld a, [JoypadPressed]
    bit 4, a ; Right
    jr nz, .moveRight
    bit 5, a ; Left
    jr nz, .moveLeft
    bit 6, a ; Down
    jr nz, .moveDown
    bit 7, a ; Up (rotate)
    jr nz, .rotate
    ret

.moveRight:
    ld a, [CurrentPieceX]
    inc a
    ld b, a
    ld a, [CurrentPieceY]
    ld c, a
    ld a, [CurrentPieceRotation]
    ld d, a
    call CheckCollision
    jr c, .moveLeft
    ld a, b
    ld [CurrentPieceX], a
    ret

.moveLeft:
    ld a, [CurrentPieceX]
    dec a
    ld b, a
    ld a, [CurrentPieceY]
    ld c, a
    ld a, [CurrentPieceRotation]
    ld d, a
    call CheckCollision
    jr c, .moveDown
    ld a, b
    ld [CurrentPieceX], a
    ret

.moveDown:
    ld a, [CurrentPieceX]
    ld b, a
    ld a, [CurrentPieceY]
    inc a
    ld c, a
    ld a, [CurrentPieceRotation]
    ld d, a
    call CheckCollision
    jr c, .rotate
    ld a, c
    ld [CurrentPieceY], a
    ret

.rotate:
    ld a, [CurrentPieceRotation]
    inc a
    and 3
    ld d, a
    ld a, [CurrentPieceX]
    ld b, a
    ld a, [CurrentPieceY]
    ld c, a
    call CheckCollision
    jr c, .end
    ld a, d
    ld [CurrentPieceRotation], a
.end:
    ret

; Handle gravity
HandleGravity:
    ld a, [GravityCounter]
    inc a
    ld [GravityCounter], a
    cp GRAVITY_DELAY
    jr c, .end
    
    xor a
    ld [GravityCounter], a
    
    ld a, [CurrentPieceX]
    ld b, a
    ld a, [CurrentPieceY]
    inc a
    ld c, a
    ld a, [CurrentPieceRotation]
    ld d, a
    call CheckCollision
    jr c, .placePiece
    
    ld a, c
    ld [CurrentPieceY], a
    ret

.placePiece:
    call PlacePiece
    call ClearLines
    call SpawnNewPiece
    ret

.end:
    ret

; Place piece on playfield
PlacePiece:
    ld a, [CurrentPieceType]
    ld d, a
    ld a, [CurrentPieceRotation]
    call GetRotationData
    
    ld a, [CurrentPieceX]
    ld b, a
    ld a, [CurrentPieceY]
    ld c, a
    
    ld e, 4
.placeBlock:
    ld a, [hl+]
    add b
    ld d, a
    ld a, [hl+]
    add c
    call GetPlayfieldIndex
    ld hl, Playfield
    ld c, a
    ld b, 0
    add hl, bc
    ld a, [CurrentPieceType]
    inc a
    ld [hl], a
    dec e
    jr nz, .placeBlock
    ret

; Export symbols
EXPORT GetPlayfieldIndex

; Get playfield index from X,Y coordinates
GetPlayfieldIndex:
    ; A = Y, D = X
    ld b, a
    ld a, PLAYFIELD_WIDTH
    ; Multiply A by B (A = A * B)
    ld c, a
    xor a
.multiply:
    add c
    dec b
    jr nz, .multiply
    add d
    ret

; Clear completed lines
ClearLines:
    ; Implementation would go here
    ret

; Update display
UpdateDisplay:
    ; Implementation would go here
    ret

; Tile data
SECTION "TileData", ROM0
TileData:
    ; Empty tile
    db $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00
    ; I piece tile
    db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    ; Add more tile data as needed
TileDataEnd:
