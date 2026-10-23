include <params.scad>

// ── Cart top plate — print this piece ─────────────────────────────────────────
// 200 × 200 mm flat plate with 4 through-holes for alignment pegs.
// Print flat on bed — no supports needed.
//
// Assembly: slide down over the pegs on cart_bottom.scad, apply glue at the
// mating faces, and hold until set.  The pegs protrude ~3 mm above the plate
// surface for grip while the glue cures.

// Peg positions — must match cart_bottom.scad exactly.
peg_x = cart_body_w  / 2 - 4;   // 21 mm from centre
peg_y = cart_body_len / 2 - 5;  // 65 mm from centre

difference() {
    // Plate centred on X=0, Y=0
    cube([cart_plate, cart_plate, plate_t], center = true);

    // Through-holes for alignment pegs — cylinder goes full plate depth + overcut
    for (sx = [-1, 1], sy = [-1, 1])
        translate([sx * peg_x, sy * peg_y, -plate_t / 2 - 0.1])
            cylinder(d = hole_d, h = plate_t + 0.2, $fn = 32);
}
