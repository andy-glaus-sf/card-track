include <params.scad>

// ── Track end stops ───────────────────────────────────────────────────────────
// Two variants are produced here side by side — print one of each.
//
//   End stop A (left)  — SOCKET type — fits the +Y TAB end of a straight section.
//                        The track's +Y tabs click into the stop's sockets.
//
//   End stop B (right) — TAB type   — fits the -Y SOCKET end of a straight section.
//                        The stop's tabs click into the track's -Y sockets.
//
// The barrier wall is high enough to catch the cart body (24 mm above the track
// floor) and prevent it rolling off the end.

track_total_w = track_inner_w + 2 * track_wall_t;
track_total_h = track_floor_t + track_wall_h;

stop_len      = conn_pad_len + track_wall_t + 4;  // 32 mm — connector pad + barrier + clearance
barrier_h     = cart_body_h + 6;                  // 28 mm — above cart body top

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

// ── Shared body: two walls + full floor + barrier wall ────────────────────────
module stop_body() {
    union() {
        // Left wall
        translate([0, 0, -bot_ext])
            cube([track_wall_t, stop_len, track_total_h + bot_ext]);
        // Right wall
        translate([track_total_w - track_wall_t, 0, -bot_ext])
            cube([track_wall_t, stop_len, track_total_h + bot_ext]);
        // Full-width floor (short section — full floor is fine here)
        cube([track_total_w, stop_len, track_floor_t]);
        // Barrier wall at +Y end — blocks the cart from rolling out
        translate([0, stop_len - track_wall_t, 0])
            cube([track_total_w, track_wall_t, barrier_h]);
    }
}

// ── Connector pads at -Y face (socket-type stop) ──────────────────────────────
module socket_pads() {
    for (cx = [bot_conn_x1, bot_conn_x2])
        translate([cx - conn_pad_w / 2, 0, -bot_ext])
            cube([conn_pad_w, conn_pad_len, bot_ext]);
}

module socket_cuts() {
    for (cx = [bot_conn_x1, bot_conn_x2])
        translate([cx, 0, -bot_ext - 0.1])
            linear_extrude(height = bot_ext + 0.2)
                puzzle_socket_2d();
}

// ── Connector pads at +Y face (tab-type stop) ─────────────────────────────────
// Pads back the tabs at Y = stop_len; tabs protrude beyond the +Y face.
module tab_pads() {
    for (cx = [bot_conn_x1, bot_conn_x2])
        translate([cx - conn_pad_w / 2, stop_len - conn_pad_len, -bot_ext])
            cube([conn_pad_w, conn_pad_len, bot_ext]);
}

module tab_protrusions() {
    for (cx = [bot_conn_x1, bot_conn_x2])
        translate([cx, stop_len, -bot_ext])
            linear_extrude(height = bot_ext)
                puzzle_tab_2d();
}

// ── End stop A — SOCKET type (fits +Y tab end of straight section) ────────────
module end_stop_socket() {
    difference() {
        union() {
            stop_body();
            socket_pads();
        }
        socket_cuts();
    }
}

// ── End stop B — TAB type (fits -Y socket end of straight section) ────────────
module end_stop_tab() {
    union() {
        stop_body();
        tab_pads();
        tab_protrusions();
    }
}

// ── Render both side by side (10 mm gap) ─────────────────────────────────────
end_stop_socket();

translate([track_total_w + 10, 0, 0])
    end_stop_tab();
