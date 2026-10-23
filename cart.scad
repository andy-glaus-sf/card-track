include <params.scad>

// ── Cart ─────────────────────────────────────────────────────────────────────
// 4 horizontal stub-axle posts; 608ZZ bearings friction-fit (press) onto posts.
// Bearing outer race (22 mm OD) rolls on the track floor.
//
// Print orientation: lay on one long side face (posts pointing up/down on bed).
// No support needed — posts are horizontal and short.
//
// Assembly:
//   1. Press each bearing onto its post from the outside.  The 0.2 mm
//      interference keeps it seated; the 1.5 mm retention nose prevents it
//      sliding off during use.
//   2. Lower the cart into the track channel.  The 200 mm plate overhangs
//      both track walls.

cart_body_len = wheelbase + 20;   // 140 mm front-to-rear

// ── Stub axle post ────────────────────────────────────────────────────────────
// Origin at the post base (flush with cart body side face), pointing in +X.
// Bearing slides on from the +X end.
module stub_axle() {
    // Shoulder gap first (1.5 mm) — bearing face never contacts body side
    // (the post is solid all the way; the gap is created by the relief recess
    //  in the body — see cart_body() below)

    // Main shaft — bearing bore press-fits here
    cylinder(d = post_d, h = post_len - 1, $fn = 32);

    // Retention nose: tapered last 1 mm keeps bearing from walking off
    translate([0, 0, post_len - 1])
        cylinder(d1 = post_d, d2 = post_d - 0.6, h = 1, $fn = 32);
}

// ── Cart body ─────────────────────────────────────────────────────────────────
// Centred in XY.  Bottom face at Z = 0.
module cart_body() {
    difference() {
        // Main block
        cube([cart_body_w, cart_body_len, cart_body_h], center = true);

        // Lightening pocket — open at the top (toward the plate)
        translate([0, 0, 4])
            cube([cart_body_w - 16, cart_body_len - 20, cart_body_h],
                 center = true);

        // Bearing clearance relief — one pocket per post, cut into the
        // body side face.  Diameter = bearing OD + 4 mm so the outer
        // race spins without touching the body.
        for (sx = [-1, 1], sy = [-1, 1]) {
            translate([
                sx * cart_body_w / 2,           // flush with body side face
                sy * wheelbase / 2,              // front / rear axle position
                -cart_body_h / 2 + post_z       // post-centre height
            ])
            rotate([0, sx * 90, 0])             // face outward
                cylinder(
                    d = bearing_relief_d,
                    h = bearing_relief_depth,
                    center = false,
                    $fn = 48
                );
        }
    }
}

// ── Top plate ─────────────────────────────────────────────────────────────────
module top_plate() {
    cube([cart_plate, cart_plate, plate_t], center = true);
}

// ── Assembly — origin at cart body bottom face ────────────────────────────────
// In the assembled track:
//   Z = 0  → track floor
//   Z = 2  → cart body bottom  (2 mm clearance from floor)
//   Z = 11 → post / bearing centre  (= bearing_od/2, so bearing just touches floor)
//   Z = 28 → cart body top
//   Z = 31 → top of plate

// Cart body — bottom at Z = 0 in this local frame
translate([0, 0, cart_body_h / 2])
    cart_body();

// Top plate
translate([0, 0, cart_body_h + plate_t / 2])
    top_plate();

// 4 stub axles — two per side (±X), front and rear (±Y)
for (sx = [-1, 1], sy = [-1, 1]) {
    translate([
        sx * cart_body_w / 2,    // start at body side face
        sy * wheelbase / 2,      // front / rear
        post_z                   // post-centre height above body bottom
    ])
    rotate([0, sx * 90, 0])      // point outward in ±X
        stub_axle();
}
