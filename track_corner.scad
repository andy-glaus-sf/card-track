include <params.scad>

// ── 90° corner track section ──────────────────────────────────────────────────
// Entry face at θ=0° (Y=0 plane): sockets receive tabs from a straight section.
// Exit  face at θ=90° (X=0 plane): tabs protrude in −X.
//
// Floor treatment: full floor at entry/exit connector-end arcs; open in the
// middle.  Two bearing-arc strips run the full 90° to give bearings a rolling
// surface throughout the turn.

track_total_w = track_inner_w + 2 * track_wall_t;
track_total_h = track_floor_t + track_wall_h;

// Bearing arc radii (distance from rotation axis to bearing contact line)
bear_r_L = corner_inner_r + track_wall_t + track_inner_w / 2 - cart_body_w / 2 - bearing_w / 2;
bear_r_R = corner_inner_r + track_wall_t + track_inner_w / 2 + cart_body_w / 2 + bearing_w / 2;

// Arc angle to cover conn_pad_len at the floor centreline radius
corner_cl_r = corner_inner_r + track_wall_t + track_inner_w / 2;
pad_angle   = conn_pad_len / corner_cl_r * 180 / PI;  // ≈ 9.2°

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

// ── Swept walls (inner + outer, full 90°, flush at Z=0) ───────────────────────
// In rotate_extrude, profile Y = 3D Z.  Y = 0 → Z = 0 (flat bottom).
module corner_walls() {
    // Inner wall
    rotate_extrude(angle = 90, $fn = 120)
        translate([corner_inner_r, 0, 0])
            square([track_wall_t, track_total_h]);
    // Outer wall
    rotate_extrude(angle = 90, $fn = 120)
        translate([corner_inner_r + track_inner_w + track_wall_t, 0, 0])
            square([track_wall_t, track_total_h]);
}

// ── End floor arcs (full inner width, pad_angle deep at each end) ─────────────
module corner_end_floors() {
    // Entry end (0° to pad_angle)
    rotate_extrude(angle = pad_angle, $fn = 120)
        translate([corner_inner_r + track_wall_t, 0, 0])
            square([track_inner_w, track_floor_t]);
    // Exit end (90° - pad_angle to 90°)
    rotate([0, 0, 90 - pad_angle])
        rotate_extrude(angle = pad_angle, $fn = 120)
            translate([corner_inner_r + track_wall_t, 0, 0])
                square([track_inner_w, track_floor_t]);
}

// ── Bearing contact arc strips (full 90°, narrow rings at each bearing radius) ─
module corner_bearing_rails() {
    rotate_extrude(angle = 90, $fn = 120)
        translate([bear_r_L - bear_rail_w / 2, 0, 0])
            square([bear_rail_w, track_floor_t]);
    rotate_extrude(angle = 90, $fn = 120)
        translate([bear_r_R - bear_rail_w / 2, 0, 0])
            square([bear_rail_w, track_floor_t]);
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
        corner_walls();
        corner_end_floors();
        corner_bearing_rails();
        exit_bot_tabs();
    }
    entry_bot_sockets();
}
