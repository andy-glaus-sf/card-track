include <params.scad>

// ── Cart top plate — print this piece ─────────────────────────────────────────
// 200 × 200 mm flat plate with 4 blind holes for alignment pegs.
// Print flat on bed — no supports needed.
//
// Blind holes open from the bottom face only; the top skin stays solid.
// Peg height (3 mm) is slightly less than hole depth (3.2 mm) so pegs seat fully
// without bottoming out, and the top surface of the plate remains clean and flat.

// Peg positions — must match cart_bottom.scad exactly.
peg_x = cart_body_w  / 2 - cart_wall_t / 2;   // 21.5 mm — mid-wall position
peg_y = cart_body_len / 2 - cart_wall_t / 2;  // 66.5 mm — mid-wall position

difference() {
    // Plate centred on X=0, Y=0
    cube([cart_plate, cart_plate, plate_t], center = true);

    // Blind holes for alignment pegs — open from bottom face, peg_hole_depth deep
    for (sx = [-1, 1], sy = [-1, 1])
        translate([sx * peg_x, sy * peg_y, -plate_t / 2])
            cylinder(d = hole_d, h = peg_hole_depth, $fn = 32);
}
