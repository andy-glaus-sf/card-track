include <params.scad>

// ── 90° corner track section ──────────────────────────────────────────────────
// Entry face at θ=0° (Y=0 plane): sockets receive tabs from the +Y end of a
// straight section.
// Exit  face at θ=90° (X=0 plane): tabs protrude in −X toward the next section.
//
// Both walls are swept bot_ext mm below Z=0, matching the straight section.
// Connector pads sit at entry/exit faces, between or backing the swept walls.

track_total_w = track_inner_w + 2 * track_wall_t;
track_total_h = track_floor_t + track_wall_h;

// ── 2D puzzle profiles ────────────────────────────────────────────────────────
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
// In rotate_extrude, the 2D profile's Y axis = 3D Z axis.
// So Y = -bot_ext in 2D → Z = -bot_ext in 3D.
module corner_body() {
    difference() {
        union() {
            // Main U-channel
            rotate_extrude(angle = 90, $fn = 120)
                translate([corner_inner_r, 0, 0])
                    square([track_total_w, track_total_h]);
            // Inner wall extension below floor
            rotate_extrude(angle = 90, $fn = 120)
                translate([corner_inner_r, -bot_ext, 0])
                    square([track_wall_t, bot_ext]);
            // Outer wall extension below floor
            rotate_extrude(angle = 90, $fn = 120)
                translate([corner_inner_r + track_inner_w + track_wall_t, -bot_ext, 0])
                    square([track_wall_t, bot_ext]);
        }
        // Inner channel
        rotate_extrude(angle = 91, $fn = 120)
            translate([corner_inner_r + track_wall_t, track_floor_t, 0])
                square([track_inner_w, track_wall_h + 0.1]);
    }
}

// ── Entry face (θ=0°, Y=0): sockets receiving tabs from a straight section ────
// Pads: from Y=0 to Y=conn_pad_len, between the walls.
module entry_bot_pads() {
    for (cx = [corner_inner_r + bot_conn_x1, corner_inner_r + bot_conn_x2])
        translate([cx - conn_pad_w / 2, 0, -bot_ext])
            cube([conn_pad_w, conn_pad_len, bot_ext]);
}

// Sockets: open at Y=0, cut into pad in +Y direction.
module entry_bot_sockets() {
    for (cx = [corner_inner_r + bot_conn_x1, corner_inner_r + bot_conn_x2])
        translate([cx, 0, -bot_ext - 0.1])
            linear_extrude(height = bot_ext + 0.2)
                puzzle_socket_2d();
}

// ── Exit face (θ=90°, X=0): tabs protruding in −X ────────────────────────────
// Pads: from X=0 to X=conn_pad_len (into the corner body), backing the tab roots.
module exit_bot_pads() {
    for (cy = [corner_inner_r + bot_conn_x1, corner_inner_r + bot_conn_x2])
        translate([0, cy - conn_pad_w / 2, -bot_ext])
            cube([conn_pad_len, conn_pad_w, bot_ext]);
}

// Tabs protrude in −X from X=0.
// rotate([0,0,90]) maps +Y → −X so puzzle_tab_2d() (which protrudes in +Y)
// ends up protruding in −X after the rotation.
module exit_bot_tabs() {
    for (cy = [corner_inner_r + bot_conn_x1, corner_inner_r + bot_conn_x2])
        translate([0, cy, -bot_ext])
            rotate([0, 0, 90])
                linear_extrude(height = bot_ext)
                    puzzle_tab_2d();
}

// ── Assembled corner ──────────────────────────────────────────────────────────
difference() {
    union() {
        corner_body();
        entry_bot_pads();
        exit_bot_pads();
        exit_bot_tabs();
    }
    entry_bot_sockets();
}
