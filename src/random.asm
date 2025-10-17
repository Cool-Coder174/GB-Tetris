SECTION "RNG", WRAM0
RandomBag: ds 7
BagIndex: db
Seed: dw

SECTION "RandomCode", ROM0

; Export symbols
EXPORT RandomBag
EXPORT BagIndex
EXPORT Seed
EXPORT InitRandom
EXPORT RefillBag
EXPORT RandomByte

InitRandom:
    ; Initialize seed with DIV register
    ld hl, Seed
    ldh a, [rDIV]
    ld [hl+], a
    ldh a, [rDIV]
    ld [hl], a
    call RefillBag
    ret

RefillBag:
    ; Fisher-Yates shuffle implementation
    ld hl, RandomBag
    ld c,7
.fill:
    ld a, 7
    sub c
    ld [hl+], a
    dec c
    jr nz, .fill
    
    ld hl, RandomBag
    ld c,7
.shuffle:
    call RandomByte
    ld b,a
    and $0F
    cp c
    jr nc, .shuffle
    ld d,0
    ld e,a
    add hl,de
    ld a,[hl]
    push af
    ld a,l
    sub e
    ld l,a
    pop af
    ld [hl],a
    dec c
    jr nz, .shuffle
    xor a
    ld [BagIndex], a
    ret

RandomByte:
    ; Simple LFSR random number generator
    ld hl, Seed
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    
    ; LFSR: if bit 0 is set, XOR with 0xB400
    bit 0, l
    jr z, .noXor
    ld a, h
    xor $B4
    ld h, a
    ld a, l
    xor $00
    ld l, a
.noXor:
    
    ; Shift right
    srl h
    rr l
    
    ; Store back
    ld a, l
    ld [Seed], a
    ld a, h
    ld [Seed+1], a
    
    ; Return random byte
    ld a, l
    ret