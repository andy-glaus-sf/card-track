include <params.scad>

// ── Straight track section (200 mm) ──────────────────────────────────────────
// Print flat on bed (channel facing up).
//
// The two outer walls extend bot_ext mm below the floor face; the track rests
// on those wall bottoms.  Connector pads sit between the walls at each end.
//
// +Y end: two puzzle tabs protrude from the bottom pads beyond the end face.
// -Y end: two matching puzzle sockets cut into the bottom pads.

track_total_w = track_inner_w + 2 * track_wall_t;
track_total_h = track_floor_t + track_wall_h;

// ── 2D puzzle profiles ────────────────────────────────────────────────────────
module puzzle_tab_2d() {
    translate([-tab_neck_w / 2, 0])
        square([tab_neck_w, tab_neck_l]);
    translate([0, tab_neck_l])
        circle(d = tab_knob_d, $fn = 64);
}

// Socket = tab + clearance on all sides
module puzzle_socket_2d() {
    translate([-(tab_neck_w + tab_clr) / 2, 0])
        square([tab_neck_w + tab_clr, tab_neck_l + tab_clr / 2]);
    translate([0, tab_neck_l])
        circle(d = tab_knob_d + tab_clr, $fn = 64);
}

// ── U-channel body with wall extensions below floor ───────────────────────────
module track_body() {
    difference() {
        union() {
            cube([track_total_w, track_sec_len, track_total_h]);
            // Left wall extended below floor face (Z=0)
            translate([0, 0, -bot_ext])
                cube([track_wall_t, track_sec_len, bot_ext]);
            // Right wall extended below floor face
            translate([track_total_w - track_wall_t, 0, -bot_ext])
                cube([track_wall_t, track_sec_len, bot_ext]);
        }
        // Inner channel
        translate([track_wall_t, -0.1, track_floor_t])
            cube([track_inner_w, track_sec_len + 0.2, track_wall_h + 0.1]);
    }
}

// ── Bottom connector pads (between the walls, below floor face) ───────────────
// y0 = Y start of the pad; pad extends from y0 to y0+conn_pad_len.
module bot_conn_pads(y0) {
    for (cx = [bot_conn_x1, bot_conn_x2])
        translate([cx - conn_pad_w / 2, y0, -bot_ext])
            cube([conn_pad_w, conn_pad_len, bot_ext]);
}

// ── Bottom tab: protrudes beyond end face in +Y, full bot_ext height ──────────
module bot_tab(cx, y_face) {
    translate([cx, y_face, -bot_ext])
        linear_extrude(height = bot_ext)
            puzzle_tab_2d();
}

// ── Bottom socket: cut into pad from the end face, opening at Y=y_face ────────
// puzzle_socket_2d() protrudes in +Y so it cuts into the pad material (Y > y_face).
module bot_socket(cx, y_face) {
    translate([cx, y_face, -bot_ext - 0.1])
        linear_extrude(height = bot_ext + 0.2)
            puzzle_socket_2d();
}

// ── Assembled straight section ────────────────────────────────────────────────
difference() {
    union() {
        track_body();
        // Pads at socket end (Y = 0)
        bot_conn_pads(0);
        // Pads at tab end (Y = track_sec_len − conn_pad_len)
        bot_conn_pads(track_sec_len - conn_pad_len);
        // Tabs protrude beyond +Y end face
        for (cx = [bot_conn_x1, bot_conn_x2])
            bot_tab(cx, track_sec_len);
    }
    // Sockets cut into -Y end pads
    for (cx = [bot_conn_x1, bot_conn_x2])
        bot_socket(cx, 0);
}
