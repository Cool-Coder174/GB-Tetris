CheckCollision:
    ; Input: BC = new X/Y position
    ;        D = rotation state
    ; Output: Carry set if collision
    ld hl, CurrentPieceType
    ld a, [hl]
    call GetRotationData
    
    ld b,4
.checkBlock:
    ; Calculate absolute position
    ld a, [hl+] ; dx
    add c ; current X
    cp 10
    jr nc, .collision
    
    ld a, [hl+] ; dy
    add e ; current Y
    cp 20
    jr nc, .collision
    
    ; Check playfield
    call GetPlayfieldIndex
    ld a, [Playfield + a]
    and a
    jr nz, .collision
    
    dec b
    jr nz, .checkBlock
    ret

.collision:
    scf
    ret
