include <params.scad>

// ── 90° corner track section ──────────────────────────────────────────────────
// Entry face at θ=0° (Y=0 plane): sockets receive tabs from a straight section.
// Exit  face at θ=90° (X=0 plane): tabs protrude in −X.
//
// Floor treatment: full floor at entry/exit connector-end arcs; open in the
// middle.  Two bearing-arc strips run the full 90° to give bearings a rolling
// surface throughout the turn.

// track_total_w and bear_cx_L/R now defined in params.scad
track_total_h = track_floor_t + rail_ch_wall_h;

// Bearing arc radii — distance from corner origin to bearing centre
bear_r_L = corner_inner_r + bear_cx_L;
bear_r_R = corner_inner_r + bear_cx_R;

// Arc angle to cover conn_pad_len at the floor centreline radius
corner_cl_r = corner_inner_r + track_total_w / 2;
pad_angle   = conn_pad_len / corner_cl_r * 180 / PI;

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

// ── Single bearing groove 2D profile (for rotate_extrude) ────────────────────
// r_cx = radius from corner origin to bearing centre.
// In rotate_extrude: X = radial distance, Y = axial height (becomes Z in 3D).
module corner_groove_2d(r_cx) {
    // Outer wall
    translate([r_cx - rail_ch_w / 2 - rail_ch_wall_t, 0])
        square([rail_ch_wall_t, track_total_h]);
    // Floor
    translate([r_cx - rail_ch_w / 2, 0])
        square([rail_ch_w, track_floor_t]);
    // Inner wall
    translate([r_cx + rail_ch_w / 2, 0])
        square([rail_ch_wall_t, track_total_h]);
}

// ── Swept bearing groove channels (full 90°) ──────────────────────────────────
module corner_bearing_grooves() {
    rotate_extrude(angle = 90, $fn = 120)
        corner_groove_2d(bear_r_L);
    rotate_extrude(angle = 90, $fn = 120)
        corner_groove_2d(bear_r_R);
}

// ── End floor arcs (full track width, pad_angle deep at each end) ─────────────
module corner_end_floors() {
    // Entry end (0° to pad_angle)
    rotate_extrude(angle = pad_angle, $fn = 120)
        translate([corner_inner_r, 0, 0])
            square([track_total_w, track_floor_t]);
    // Exit end (90° - pad_angle to 90°)
    rotate([0, 0, 90 - pad_angle])
        rotate_extrude(angle = pad_angle, $fn = 120)
            translate([corner_inner_r, 0, 0])
                square([track_total_w, track_floor_t]);
}

// ── Entry face (θ=0°, Y=0): through-hole sockets in end-section floor ─────────
module entry_bot_sockets() {
    for (cx = [corner_inner_r + bot_conn_x1, corner_inner_r + bot_conn_x2])
        translate([cx, 0, -0.1])
            linear_extrude(height = track_floor_t + 0.2)
                puzzle_socket_2d();
}

// ── Exit face (θ=90°, X=0): tabs protruding in −X, flush with floor ───────────
module exit_bot_tabs() {
    for (cy = [corner_inner_r + bot_conn_x1, corner_inner_r + bot_conn_x2])
        translate([0, cy, 0])
            rotate([0, 0, 90])
                linear_extrude(height = track_floor_t)
                    puzzle_tab_2d();
}

// ── Assembled corner ──────────────────────────────────────────────────────────
difference() {
    union() {
        corner_bearing_grooves();
        corner_end_floors();
        exit_bot_tabs();
    }
    entry_bot_sockets();
}
