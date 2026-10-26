include <params.scad>

// ── Cart bottom — print this piece ────────────────────────────────────────────
// Includes: cart body, 4 stub-axle posts, 4 alignment pegs.
// Print orientation: lay on one long side face (posts pointing up/down on bed).
//
// The body is hollow all the way through (open top AND bottom) with cart_wall_t
// (7 mm) walls on all four sides.  Pegs are centred in the wall thickness at
// the four corners so they sit on fully solid material.

// Peg centres: mid-wall position in both axes
//   X wall spans: ±(cart_body_w/2 - cart_wall_t) to ±cart_body_w/2
//                = ±18 to ±25  →  mid at ±21.5 mm
//   Y wall spans: ±(cart_body_len/2 - cart_wall_t) to ±cart_body_len/2
//                = ±63 to ±70  →  mid at ±66.5 mm
peg_x = cart_body_w  / 2 - cart_wall_t / 2;   // 21.5 mm from centre
peg_y = cart_body_len / 2 - cart_wall_t / 2;  // 66.5 mm from centre

// ── Stub axle post ─────────────────────────────────────────────────────────────
module stub_axle() {
    cylinder(d = post_d, h = post_len - 1, $fn = 32);
    translate([0, 0, post_len - 1])
        cylinder(d1 = post_d, d2 = post_d - 0.6, h = 1, $fn = 32);
}

// ── Cart body (fully hollow, 7 mm walls on all sides) ─────────────────────────
module cart_body() {
    difference() {
        cube([cart_body_w, cart_body_len, cart_body_h], center = true);

        // Full-height hollow — open top AND bottom
        cube([cart_body_w - 2 * cart_wall_t,
              cart_body_len - 2 * cart_wall_t,
              cart_body_h + 0.2],
             center = true);

        // Bearing clearance relief at each post base
        for (sx = [-1, 1], sy = [-1, 1]) {
            translate([
                sx * cart_body_w / 2,
                sy * wheelbase / 2,
                -cart_body_h / 2 + post_z
            ])
            rotate([0, sx * 90, 0])
                cylinder(d = bearing_relief_d, h = bearing_relief_depth,
                         center = false, $fn = 48);
        }
    }
}

// ── Alignment pegs ─────────────────────────────────────────────────────────────
module alignment_pegs() {
    for (sx = [-1, 1], sy = [-1, 1])
        translate([sx * peg_x, sy * peg_y, cart_body_h])
            cylinder(d = peg_d, h = peg_h, $fn = 32);
}

// ── Assembly — body bottom at Z = 0 ───────────────────────────────────────────
// Z = 0  → body bottom (open)
// Z = 9  → post / bearing centre
// Z = 22 → body top (open) / pegs start
// Z = 25 → peg tips (flush with or below plate top face after assembly)

translate([0, 0, cart_body_h / 2])
    cart_body();

alignment_pegs();

for (sx = [-1, 1], sy = [-1, 1]) {
    translate([sx * cart_body_w / 2, sy * wheelbase / 2, post_z])
    rotate([0, sx * 90, 0])
        stub_axle();
}
