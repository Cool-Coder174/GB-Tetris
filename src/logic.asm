SECTION "LogicCode", ROM0

; Export symbols
EXPORT CheckCollision

CheckCollision:
    ; Input: B = X position, C = Y position, D = rotation state
    ; Output: Carry set if collision
    ld a, [CurrentPieceType]
    call GetRotationData
    
    ld e, 4
.checkBlock:
    ; Calculate absolute position
    ld a, [hl+] ; dx
    add b ; current X
    cp PLAYFIELD_WIDTH
    jr nc, .collision
    
    ld a, [hl+] ; dy
    add c ; current Y
    cp PLAYFIELD_HEIGHT
    jr nc, .collision
    
    ; Check playfield
    push hl
    push bc
    ld b, a
    ld a, c
    call GetPlayfieldIndex
    ld hl, Playfield
    ld c, a
    ld b, 0
    add hl, bc
    ld a, [hl]
    and a
    pop bc
    pop hl
    jr nz, .collision
    
    dec e
    jr nz, .checkBlock
    ret

.collision:
    scf
    ret