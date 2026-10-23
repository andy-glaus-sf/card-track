include <params.scad>

// ── Straight track section (200 mm) ──────────────────────────────────────────
// Print flat on bed.
// +Y end: two puzzle tabs protrude from external wall pads.
// -Y end: two matching puzzle sockets cut into external wall pads.
// Pads are outside the channel — cart path is unobstructed.
//
// Puzzle shape (top view of tab):
//
//        .───.
//       (     )   ← round knob, wider than neck
//        `───'
//        |   |    ← neck
//        |   |
//   ─────┘   └─────  ← pad end face
//
// Tab snaps in end-to-end; slight flex in PLA/PETG lets the knob click through.

track_total_w = track_inner_w + 2 * track_wall_t;
track_total_h = track_floor_t + track_wall_h;

// X centre of each connector pad (outside the channel walls)
pad_cx_L =  -(conn_pad_w / 2);
pad_cx_R = track_total_w + (conn_pad_w / 2);

// Total protrusion of tab beyond the pad face
tab_reach = tab_neck_l + tab_knob_d / 2;

// ── 2D puzzle profile (local coords, protrusion in +Y, centred on X=0) ───────
module puzzle_tab_2d() {
    // Neck
    translate([-tab_neck_w / 2, 0])
        square([tab_neck_w, tab_neck_l]);
    // Round knob
    translate([0, tab_neck_l])
        circle(d = tab_knob_d, $fn = 64);
}

// Socket profile = tab + clearance on all sides
module puzzle_socket_2d() {
    translate([-(tab_neck_w + tab_clr) / 2, 0])
        square([tab_neck_w + tab_clr, tab_neck_l + tab_clr / 2]);
    translate([0, tab_neck_l])
        circle(d = tab_knob_d + tab_clr, $fn = 64);
}

// ── 3D tab — base at (cx, y_face), protrudes in +Y, full pad height ───────────
module puzzle_tab(cx, y_face) {
    translate([cx, y_face, 0])
        linear_extrude(height = conn_pad_h)
            puzzle_tab_2d();
}

// ── 3D socket — opening at (cx, y_face), cuts in +Y direction ────────────────
module puzzle_socket(cx, y_face) {
    translate([cx, y_face, -0.1])
        linear_extrude(height = conn_pad_h + 0.2)
            mirror([0, 1, 0])           // flip so opening faces -Y (toward y_face)
                puzzle_socket_2d();
}

// ── U-channel profile ─────────────────────────────────────────────────────────
module track_profile(length) {
    difference() {
        cube([track_total_w, length, track_total_h]);
        translate([track_wall_t, -0.1, track_floor_t])
            cube([track_inner_w, length + 0.2, track_wall_h + 0.1]);
    }
}

// ── Connector pads (rectangular blocks outside each wall) ─────────────────────
module conn_pads(y0) {
    for (cx = [pad_cx_L, pad_cx_R])
        translate([cx - conn_pad_w / 2, y0, 0])
            cube([conn_pad_w, conn_pad_len, conn_pad_h]);
}

// ── Assembled straight section ────────────────────────────────────────────────
difference() {
    union() {
        track_profile(track_sec_len);
        // Pads at socket end (-Y): Y = 0 → conn_pad_len
        conn_pads(0);
        // Pads at tab end (+Y): Y = sec_len-conn_pad_len → sec_len
        conn_pads(track_sec_len - conn_pad_len);
        // Puzzle tabs protrude beyond +Y face
        for (cx = [pad_cx_L, pad_cx_R])
            puzzle_tab(cx, track_sec_len);
    }
    // Puzzle sockets cut into -Y face
    for (cx = [pad_cx_L, pad_cx_R])
        puzzle_socket(cx, 0);
}
