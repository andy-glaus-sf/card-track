include <params.scad>

// ── Cart — assembled view (for visualisation only) ────────────────────────────
// Print cart_bottom.scad and cart_top.scad separately.
// This file shows the two pieces in their assembled position.
//
// Z = 0  → body bottom (2 mm above track floor when seated in track)
// Z = 9  → bearing / post centre
// Z = 22 → body top face / plate bottom face
// Z = 26 → plate top face
// Z = 29 → peg tips

peg_x = cart_body_w  / 2 - 4;
peg_y = cart_body_len / 2 - 5;

module stub_axle() {
    cylinder(d = post_d, h = post_len - 1, $fn = 32);
    translate([0, 0, post_len - 1])
        cylinder(d1 = post_d, d2 = post_d - 0.6, h = 1, $fn = 32);
}

module cart_body() {
    difference() {
        cube([cart_body_w, cart_body_len, cart_body_h], center = true);
        translate([0, 0, 4])
            cube([cart_body_w - 16, cart_body_len - 20, cart_body_h], center = true);
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

// ── Bottom piece ───────────────────────────────────────────────────────────────
translate([0, 0, cart_body_h / 2])
    cart_body();

for (sx = [-1, 1], sy = [-1, 1]) {
    translate([sx * cart_body_w / 2, sy * wheelbase / 2, post_z])
    rotate([0, sx * 90, 0])
        stub_axle();
}

// Alignment pegs
for (sx = [-1, 1], sy = [-1, 1])
    translate([sx * peg_x, sy * peg_y, cart_body_h])
        cylinder(d = peg_d, h = peg_h, $fn = 32);

// ── Top plate (assembled position) ────────────────────────────────────────────
translate([0, 0, cart_body_h + plate_t / 2])
    difference() {
        cube([cart_plate, cart_plate, plate_t], center = true);
        for (sx = [-1, 1], sy = [-1, 1])
            translate([sx * peg_x, sy * peg_y, -plate_t / 2 - 0.1])
                cylinder(d = hole_d, h = plate_t + 0.2, $fn = 32);
    }
