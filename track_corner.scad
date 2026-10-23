include <params.scad>

// ── 90° corner track section ──────────────────────────────────────────────────
// Entry face at θ=0° → aligns with straight section +Y tab end (receives tab).
// Exit  face at θ=90° → presents tabs to the next straight section socket end.
// Puzzle connectors match the straight section exactly.

track_total_w = track_inner_w + 2 * track_wall_t;
track_total_h = track_floor_t + track_wall_h;
corner_cl_r   = corner_inner_r + track_wall_t + track_inner_w / 2;

pad_cx_L =  -(conn_pad_w / 2);
pad_cx_R = track_total_w + (conn_pad_w / 2);

// ── 2D profiles (shared with straight section logic) ─────────────────────────
module puzzle_tab_2d() {
    translate([-tab_neck_w / 2, 0])
        square([tab_neck_w, tab_neck_l]);
    translate([0, tab_neck_l])
        circle(d = tab_knob_d, $fn = 64);
}

module puzzle_socket_2d() {
    translate([-(tab_neck_w + tab_clr) / 2, 0])
        square([tab_neck_w + tab_clr, tab_neck_l + tab_clr / 2]);
    translate([0, tab_neck_l])
        circle(d = tab_knob_d + tab_clr, $fn = 64);
}

// ── Swept corner body ─────────────────────────────────────────────────────────
module corner_section() {
    difference() {
        rotate_extrude(angle = 90, $fn = 120)
            translate([corner_inner_r, 0, 0])
                square([track_total_w, track_total_h]);
        rotate_extrude(angle = 91, $fn = 120)
            translate([corner_inner_r + track_wall_t, track_floor_t, 0])
                square([track_inner_w, track_wall_h + 0.1]);
    }
}

// ── Entry face connectors (θ=0°, face points in +Y) ──────────────────────────
// Entry face is at Y=0, track spans X = corner_inner_r … corner_inner_r+track_total_w
// Pads sit outside that span in X.

module entry_pads() {
    for (cx = [pad_cx_L, pad_cx_R]) {
        translate([corner_inner_r + cx - conn_pad_w / 2, 0, 0])
            cube([conn_pad_w, conn_pad_len, conn_pad_h]);
    }
}

// Entry sockets — opening at Y=0, cut toward +Y
module entry_sockets() {
    for (cx = [pad_cx_L, pad_cx_R]) {
        translate([corner_inner_r + cx, 0, -0.1])
            linear_extrude(height = conn_pad_h + 0.2)
                mirror([0, 1, 0])
                    puzzle_socket_2d();
    }
}

// ── Exit face connectors (θ=90°, face points in -X, i.e. X=0 plane) ──────────
// At θ=90° the swept track exits at X=0, track spans Y = corner_inner_r … corner_inner_r+track_total_w
// Pads sit outside that span in Y.

module exit_pads() {
    for (cx = [pad_cx_L, pad_cx_R]) {
        translate([0, corner_inner_r + cx - conn_pad_w / 2, 0])
            cube([conn_pad_len, conn_pad_w, conn_pad_h]);
    }
}

// Exit tabs — protrude from X=0 face in -X direction
// Tab 2D profile protrudes in +Y; rotate so +Y → -X
module exit_tabs() {
    for (cx = [pad_cx_L, pad_cx_R]) {
        translate([0, corner_inner_r + cx, conn_pad_h])
            rotate([0, 90, 0])          // +Z of extrusion → -X
                rotate([0, 0, 90])      // align neck protrusion to point in -X
                    linear_extrude(height = tab_neck_l + tab_knob_d / 2)
                        mirror([0, 1, 0])
                            puzzle_tab_2d();
    }
}

// ── Assembled corner ──────────────────────────────────────────────────────────
difference() {
    union() {
        corner_section();
        entry_pads();
        exit_pads();
        exit_tabs();
    }
    entry_sockets();
}
