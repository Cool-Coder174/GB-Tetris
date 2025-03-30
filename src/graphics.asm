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

BGPalettes:
    ; Define 8 CGB palettes
    dw %1111111111111111, %0000000000000000, %0000000000000000, %0000000000000000
    ; Add more palette definitions...
