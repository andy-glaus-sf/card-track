include <params.scad>

// ── Straight track section (200 mm) ──────────────────────────────────────────
// Print flat on bed.
//
// Floor is open between the two bearing-contact rails and the end connector
// sections — only material that is structurally required is printed.
//
// +Y end: two puzzle tabs protrude below the floor level from the bottom pads.
// -Y end: two matching puzzle sockets cut into the bottom pads.

track_total_w = track_inner_w + 2 * track_wall_t;
track_total_h = track_floor_t + track_wall_h;

// ── Bearing rail X positions in track coordinates ─────────────────────────────
// Left  bearing contact: channel_centre − cart_body_half − bearing_mid
// Right bearing contact: channel_centre + cart_body_half + bearing_mid
bear_cx_L = track_wall_t + track_inner_w / 2 - cart_body_w / 2 - bearing_w / 2;
bear_cx_R = track_wall_t + track_inner_w / 2 + cart_body_w / 2 + bearing_w / 2;

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

// ── Track body ────────────────────────────────────────────────────────────────
// Built as a union of discrete structural elements — no subtractive floor.
module track_body() {
    union() {
        // Left wall — full length, full height, plus bot_ext below Z=0
        translate([0, 0, -bot_ext])
            cube([track_wall_t, track_sec_len, track_total_h + bot_ext]);
        // Right wall
        translate([track_total_w - track_wall_t, 0, -bot_ext])
            cube([track_wall_t, track_sec_len, track_total_h + bot_ext]);

        // End floor — full width, conn_pad_len deep at each end
        cube([track_total_w, conn_pad_len, track_floor_t]);
        translate([0, track_sec_len - conn_pad_len, 0])
            cube([track_total_w, conn_pad_len, track_floor_t]);

        // Bearing contact rails — narrow strips running the full length
        translate([bear_cx_L - bear_rail_w / 2, 0, 0])
            cube([bear_rail_w, track_sec_len, track_floor_t]);
        translate([bear_cx_R - bear_rail_w / 2, 0, 0])
            cube([bear_rail_w, track_sec_len, track_floor_t]);
    }
}

// ── Bottom connector pads (between walls, below floor face) ───────────────────
module bot_conn_pads(y0) {
    for (cx = [bot_conn_x1, bot_conn_x2])
        translate([cx - conn_pad_w / 2, y0, -bot_ext])
            cube([conn_pad_w, conn_pad_len, bot_ext]);
}

// ── Bottom tab: protrudes beyond end face in +Y ───────────────────────────────
module bot_tab(cx, y_face) {
    translate([cx, y_face, -bot_ext])
        linear_extrude(height = bot_ext)
            puzzle_tab_2d();
}

// ── Bottom socket: cut into pad, opening at y_face ────────────────────────────
module bot_socket(cx, y_face) {
    translate([cx, y_face, -bot_ext - 0.1])
        linear_extrude(height = bot_ext + 0.2)
            puzzle_socket_2d();
}

// ── Assembled straight section ────────────────────────────────────────────────
difference() {
    union() {
        track_body();
        bot_conn_pads(0);
        bot_conn_pads(track_sec_len - conn_pad_len);
        for (cx = [bot_conn_x1, bot_conn_x2])
            bot_tab(cx, track_sec_len);
    }
    for (cx = [bot_conn_x1, bot_conn_x2])
        bot_socket(cx, 0);
}
