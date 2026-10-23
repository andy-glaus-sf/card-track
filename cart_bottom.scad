include <params.scad>

// ── Cart bottom — print this piece ────────────────────────────────────────────
// Includes: cart body, 4 stub-axle posts, 4 alignment pegs.
// Print orientation: lay on one long side face (posts pointing up/down on bed).
//
// After printing, press bearings onto posts.  Mate with cart_top.scad by
// sliding the plate holes over the pegs and gluing the mating faces together.

// Peg centres in body XY (body is centred on X=0, Y=0).
// Placed at the 4 solid corners of the top face — outside the lightening pocket
// which spans (body_w-16) × (body_len-20) centred on the body.
//   Pocket in X: ±(cart_body_w - 16)/2 = ±17 mm  →  solid strip: 17–25 mm
//   Pocket in Y: ±(cart_body_len - 20)/2 = ±60 mm →  solid strip: 60–70 mm
peg_x = cart_body_w  / 2 - 4;    // 21 mm from centre
peg_y = cart_body_len / 2 - 5;   // 65 mm from centre

// ── Stub axle post ─────────────────────────────────────────────────────────────
module stub_axle() {
    cylinder(d = post_d, h = post_len - 1, $fn = 32);
    translate([0, 0, post_len - 1])
        cylinder(d1 = post_d, d2 = post_d - 0.6, h = 1, $fn = 32);
}

// ── Cart body ──────────────────────────────────────────────────────────────────
// Centred in XY.  Bottom face at Z = 0 in this module's local frame.
module cart_body() {
    difference() {
        cube([cart_body_w, cart_body_len, cart_body_h], center = true);

        // Lightening pocket — open at the top toward the plate
        translate([0, 0, 4])
            cube([cart_body_w - 16, cart_body_len - 20, cart_body_h], center = true);

        // Bearing clearance relief — circular recess at each post base so the
        // bearing outer race spins without rubbing the body side face
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
// Sit on the 4 solid corners of the body top face (Z = cart_body_h).
// The body is centred on X=0,Y=0 so peg_x/peg_y are in those same coords.
module alignment_pegs() {
    for (sx = [-1, 1], sy = [-1, 1])
        translate([sx * peg_x, sy * peg_y, cart_body_h])
            cylinder(d = peg_d, h = peg_h, $fn = 32);
}

// ── Assembly — origin at cart body bottom face ─────────────────────────────────
// Z = 0  → body bottom (2 mm above track floor when in track)
// Z = 9  → post / bearing centre
// Z = 22 → body top face
// Z = 29 → top of peg (3 mm above plate top after assembly)

translate([0, 0, cart_body_h / 2])
    cart_body();

alignment_pegs();

for (sx = [-1, 1], sy = [-1, 1]) {
    translate([
        sx * cart_body_w / 2,
        sy * wheelbase / 2,
        post_z
    ])
    rotate([0, sx * 90, 0])
        stub_axle();
}
