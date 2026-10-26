include <params.scad>

// ── Straight track section (200 mm) ──────────────────────────────────────────
// Print flat on bed — bottom face is perfectly flat at Z=0, no supports needed.
//
// Floor is open between the two bearing-contact rails and the end connector
// sections — only material that is structurally required is printed.
//
// +Y end: two puzzle tabs extrude from the end face, flush with the floor
//         (Z=0 to Z=track_floor_t).  Fully supported during printing.
// -Y end: two matching puzzle sockets are through-holes in the end-section floor
//         (open bottom and top — prints without supports).

// track_total_w, bear_cx_L, bear_cx_R now defined in params.scad
track_total_h = track_floor_t + rail_ch_wall_h;

// ── 2D puzzle profiles ────────────────────────────────────────────────────────
module puzzle_tab_2d() {
    circle(d = tab_knob_d, $fn = 64);
}

module puzzle_socket_2d() {
    circle(d = tab_knob_d + tab_clr, $fn = 64);
}

// ── Single bearing groove channel (extrudes along Y) ─────────────────────────
// Origin at outer-left corner of the cross-section.
module bearing_groove(len) {
    // Outer wall
    cube([rail_ch_wall_t, len, track_total_h]);
    // Floor
    translate([rail_ch_wall_t, 0, 0])
        cube([rail_ch_w, len, track_floor_t]);
    // Inner wall
    translate([rail_ch_wall_t + rail_ch_w, 0, 0])
        cube([rail_ch_wall_t, len, track_total_h]);
}

// ── Track body ────────────────────────────────────────────────────────────────
module track_body() {
    union() {
        // Left bearing groove
        translate([bear_cx_L - rail_ch_w / 2 - rail_ch_wall_t, 0, 0])
            bearing_groove(track_sec_len);
        // Right bearing groove
        translate([bear_cx_R - rail_ch_w / 2 - rail_ch_wall_t, 0, 0])
            bearing_groove(track_sec_len);

        // End cross-bridges — span only the gap between rails, conn_pad_len deep
        translate([gap_inner_L, 0, 0])
            cube([gap_w, conn_pad_len, track_floor_t]);
        translate([gap_inner_L, track_sec_len - conn_pad_len, 0])
            cube([gap_w, conn_pad_len, track_floor_t]);
    }
}

// ── Tab: protrudes beyond end face in +Y, spans full floor thickness ──────────
module bot_tab(cx, y_face) {
    translate([cx, y_face, 0])
        linear_extrude(height = track_floor_t)
            puzzle_tab_2d();
}

// ── Socket: through-hole in end-section floor (open bottom and top) ───────────
module bot_socket(cx, y_face) {
    translate([cx, y_face, -0.1])
        linear_extrude(height = track_floor_t + 0.2)
            puzzle_socket_2d();
}

// ── Assembled straight section ────────────────────────────────────────────────
difference() {
    union() {
        track_body();
        bot_tab(bot_conn_x, track_sec_len);
    }
    bot_socket(bot_conn_x, 0);
}
