include <params.scad>

// ── Straight track section (200 mm) ──────────────────────────────────────────
// Print flat on bed. Connects end-to-end via alignment pegs.
// Male peg on +Y end, female socket on -Y end.

track_total_w = track_inner_w + 2 * track_wall_t;
track_total_h = track_floor_t + track_wall_h;

module track_profile(length) {
    difference() {
        cube([track_total_w, length, track_total_h]);
        // Inner channel
        translate([track_wall_t, -0.1, track_floor_t])
            cube([track_inner_w, length + 0.2, track_wall_h + 0.1]);
    }
}

module male_peg() {
    translate([track_total_w/2, 0, track_floor_t/2])
        cylinder(d = peg_d, h = peg_h, $fn = 24);
}

module female_socket() {
    translate([track_total_w/2, 0, track_floor_t/2])
        cylinder(d = peg_d + 0.3, h = peg_h + 0.2, $fn = 24);
}

module straight_section() {
    difference() {
        union() {
            track_profile(track_sec_len);
            // Male pegs on +Y face
            translate([0, track_sec_len, 0])
                for (x = [track_total_w * 0.25, track_total_w * 0.75])
                    translate([x, 0, 0]) male_peg();
        }
        // Female sockets on -Y face
        translate([0, 0, 0])
            for (x = [track_total_w * 0.25, track_total_w * 0.75])
                translate([x, 0, 0]) female_socket();
    }
}

straight_section();
