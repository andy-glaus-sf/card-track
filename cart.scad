include <params.scad>

// ── Cart ─────────────────────────────────────────────────────────────────────
// Print orientation: upside-down (plate face-down on bed).
// 4 × 608ZZ bearings press-fit into pockets; M8 bolts are the axles.

module bearing_pocket() {
    // Cylindrical recess for 608ZZ bearing (press fit: +0.1 mm on OD)
    cylinder(d = bearing_od + 0.1, h = bearing_w + 0.2, center = false, $fn = 48);
}

module axle_hole() {
    cylinder(d = axle_d + 0.2, h = cart_body_w + 2, center = true, $fn = 24);
}

module nut_trap(side) {
    // Hex nut trap on one end of each axle (captured during assembly)
    rotate([0, 90 * side, 0])
    translate([0, 0, -0.1])
    cylinder(d = axle_nut_af / cos(30) + 0.4, h = axle_nut_h + 0.2,
             center = false, $fn = 6);
}

module cart_body() {
    difference() {
        // Main block
        cube([cart_body_w, wheelbase + 20, cart_body_h], center = true);

        // Axle holes (front and rear)
        for (y = [-wheelbase/2, wheelbase/2]) {
            translate([0, y, -(cart_body_h/2 - bearing_od/2 - 1)])
                rotate([90, 0, 0])
                    axle_hole();
        }

        // Bearing pockets — four corners, open downward
        for (x = [-1, 1], y = [-1, 1]) {
            translate([
                x * (cart_body_w/2 - bearing_w/2 - 0.1),
                y * wheelbase/2,
                -(cart_body_h/2)
            ])
            rotate([90, 0, x * 90])
                bearing_pocket();
        }

        // Nut traps on left side of each axle
        for (y = [-wheelbase/2, wheelbase/2]) {
            translate([-(cart_body_w/2), y, -(cart_body_h/2 - bearing_od/2 - 1)])
                rotate([90, 0, 0])
                    nut_trap(-1);
        }

        // Weight-reduction pockets (top side)
        translate([0, 0, cart_body_h/4])
            cube([cart_body_w - 20, wheelbase - 10, cart_body_h/2 + 1],
                 center = true);
    }
}

module top_plate() {
    cube([cart_plate, cart_plate, plate_t], center = true);
}

// ── Assembly ──────────────────────────────────────────────────────────────────
translate([0, 0, cart_body_h/2]) {
    cart_body();
    translate([0, 0, cart_body_h/2 + plate_t/2])
        top_plate();
}
