include <params.scad>

// ── 90° corner track section ──────────────────────────────────────────────────
// Sweeps the same U-channel profile through a 90-degree arc.
// Centre-line radius = corner_inner_r + track_inner_w/2 + track_wall_t
// Male pegs on one exit face, female sockets on the other.

track_total_w = track_inner_w + 2 * track_wall_t;
track_total_h = track_floor_t + track_wall_h;

// Radius to the outer edge of the corner track
corner_cl_r   = corner_inner_r + track_wall_t + track_inner_w / 2;
corner_outer_r = corner_cl_r + track_total_w / 2;

module corner_section() {
    difference() {
        // Outer solid sweep
        rotate_extrude(angle = 90, $fn = 120)
            translate([corner_inner_r, 0, 0])
                square([track_total_w, track_total_h]);

        // Inner channel sweep
        rotate_extrude(angle = 91, $fn = 120)
            translate([corner_inner_r + track_wall_t, track_floor_t, 0])
                square([track_inner_w, track_wall_h + 0.1]);
    }
}

module male_peg() {
    cylinder(d = peg_d, h = peg_h, $fn = 24);
}

module female_socket() {
    cylinder(d = peg_d + 0.3, h = peg_h + 0.2, $fn = 24);
}

// Peg positions along a face (at 25% and 75% of track width)
peg_offsets = [track_total_w * 0.25, track_total_w * 0.75];

module corner_with_pegs() {
    union() {
        corner_section();

        // Male pegs on the 90° exit face (points in +X direction after rotation)
        rotate([0, 0, 90])
        translate([corner_inner_r, 0, 0])
            for (xo = peg_offsets)
                translate([xo, 0, track_floor_t / 2])
                    rotate([-90, 0, 0])
                        male_peg();
    }
}

difference() {
    corner_with_pegs();

    // Female sockets on the 0° entry face (points in +Y direction)
    translate([corner_inner_r, 0, 0])
        for (xo = peg_offsets)
            translate([xo, 0, track_floor_t / 2])
                rotate([90, 0, 0])
                    female_socket();
}
