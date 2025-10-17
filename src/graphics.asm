SECTION "GraphicsCode", ROM0

; Export symbols
EXPORT InitCGB
EXPORT InitDisplay
EXPORT DrawPlayfield
EXPORT DrawCurrentPiece

InitCGB:
    ldh a, [rLCDC]
    bit rLCDC_ENABLE, a
    ret nz
    
    ; Set BG palettes
    ld a, $80
    ldh [rBCPS], a
    ld hl, BGPalettes
    ld c, 8*8
.loadBGPal:
    ldi a, [hl]
    ldh [rBCPD], a
    dec c
    jr nz, .loadBGPal
    ret

SECTION "GraphicsData", ROM0

BGPalettes:
    ; Define 8 CGB palettes
    dw %1111111111111111, %0000000000000000, %0000000000000000, %0000000000000000
    dw %1111111111111111, %0000000000000000, %0000000000000000, %0000000000000000
    dw %1111111111111111, %0000000000000000, %0000000000000000, %0000000000000000
    dw %1111111111111111, %0000000000000000, %0000000000000000, %0000000000000000
    dw %1111111111111111, %0000000000000000, %0000000000000000, %0000000000000000
    dw %1111111111111111, %0000000000000000, %0000000000000000, %0000000000000000
    dw %1111111111111111, %0000000000000000, %0000000000000000, %0000000000000000
    dw %1111111111111111, %0000000000000000, %0000000000000000, %0000000000000000

SECTION "GraphicsInit", ROM0

; Initialize display
InitDisplay:
    ; Set LCDC register
    ld a, %10010001
    ldh [rLCDC], a
    
    ; Set background palette
    ld a, %11100100
    ldh [rBGP], a
    
    ; Set scroll position
    xor a
    ldh [rSCX], a
    ldh [rSCY], a
    
    ret

; Draw playfield
DrawPlayfield:
    ld hl, _SCRN0
    ld de, Playfield
    ld bc, PLAYFIELD_WIDTH * PLAYFIELD_HEIGHT
.drawLoop:
    ld a, [de]
    ld [hl+], a
    inc de
    dec bc
    ld a, b
    or c
    jr nz, .drawLoop
    ret

; Draw current piece
DrawCurrentPiece:
    ld a, [CurrentPieceType]
    ld d, a
    ld a, [CurrentPieceRotation]
    call GetRotationData
    
    ld a, [CurrentPieceX]
    ld b, a
    ld a, [CurrentPieceY]
    ld c, a
    
    ld e, 4
.drawBlock:
    ld a, [hl+]
    add b
    ld d, a
    ld a, [hl+]
    add c
    ; Calculate screen position and draw
    ; Implementation would go here
    dec e
    jr nz, .drawBlock
    ret