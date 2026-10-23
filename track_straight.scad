include <params.scad>

// ── Straight track section (200 mm) ──────────────────────────────────────────
// Print flat on bed.
// +Y end: two cylindrical bosses protrude from external wall pads.
// -Y end: two matching sockets cut into external wall pads.
// Pads sit entirely OUTSIDE the channel — cart path is never obstructed.

track_total_w = track_inner_w + 2 * track_wall_t;
track_total_h = track_floor_t + track_wall_h;

// X centre of each pad (left = negative, right = beyond track width)
pad_cx_L =  -(conn_pad_w / 2);
pad_cx_R = track_total_w + (conn_pad_w / 2);

// ── U-channel profile ─────────────────────────────────────────────────────────
module track_profile(length) {
    difference() {
        cube([track_total_w, length, track_total_h]);
        translate([track_wall_t, -0.1, track_floor_t])
            cube([track_inner_w, length + 0.2, track_wall_h + 0.1]);
    }
}

// ── External connector pads ───────────────────────────────────────────────────
// Rectangular pad anchored to the outside of each wall at a given Y position.
// y0 = start of pad in Y, runs conn_pad_len toward +Y.
module conn_pads(y0) {
    for (cx = [pad_cx_L, pad_cx_R]) {
        translate([cx - conn_pad_w / 2, y0, 0])
            cube([conn_pad_w, conn_pad_len, conn_pad_h]);
    }
}

// ── Boss (protrudes in +Y from the pad end face) ──────────────────────────────
module bosses_at(y_face) {
    for (cx = [pad_cx_L, pad_cx_R]) {
        translate([cx, y_face, conn_pad_h / 2])
            rotate([-90, 0, 0])
                cylinder(d = conn_d, h = conn_h, $fn = 48);
    }
}

// ── Socket (cut into pad end face, opening faces -Y) ─────────────────────────
module sockets_at(y_face) {
    for (cx = [pad_cx_L, pad_cx_R]) {
        translate([cx, y_face, conn_pad_h / 2])
            rotate([90, 0, 0])
                cylinder(d = conn_d + conn_clr, h = conn_h + 1, $fn = 48);
    }
}

// ── Assembled straight section ────────────────────────────────────────────────
difference() {
    union() {
        track_profile(track_sec_len);
        // Pads at -Y end (socket end) — anchored from Y=0 to Y=conn_pad_len
        conn_pads(0);
        // Pads at +Y end (boss end) — anchored from Y=(sec_len - conn_pad_len) to Y=sec_len
        conn_pads(track_sec_len - conn_pad_len);
        // Bosses protrude beyond +Y face
        bosses_at(track_sec_len);
    }
    // Sockets cut into -Y face
    sockets_at(0);
}
