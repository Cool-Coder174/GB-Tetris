SECTION "RNG", WRAM0
RandomBag: ds 7
BagIndex: db
Seed: dw

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
