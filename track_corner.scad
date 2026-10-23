include <params.scad>

// ── 90° corner track section ──────────────────────────────────────────────────
// Entry face at θ=0° (aligns with straight section +Y boss end).
// Exit  face at θ=90° (aligns with straight section -Y socket end).
// External connector pads match the straight section exactly.

track_total_w = track_inner_w + 2 * track_wall_t;
track_total_h = track_floor_t + track_wall_h;

// Corner centre-line radius
corner_cl_r   = corner_inner_r + track_wall_t + track_inner_w / 2;

// Pad centre offsets (same as straight section — ensures sections align)
pad_cx_L =  -(conn_pad_w / 2);
pad_cx_R = track_total_w + (conn_pad_w / 2);

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

// ── Entry-face connector pads (θ=0°, face points in +Y) ──────────────────────
// The entry face of the corner is at Y=0, X = corner_inner_r … corner_inner_r+track_total_w
// Pads sit outside that face (X < corner_inner_r and X > corner_inner_r+track_total_w)

module entry_pads() {
    for (cx = [pad_cx_L, pad_cx_R]) {
        x0 = corner_inner_r + cx - conn_pad_w / 2;
        translate([x0, 0, 0])
            cube([conn_pad_w, conn_pad_len, conn_pad_h]);
    }
}

// Entry sockets — cut into the +Y-pointing entry face (opening toward +Y)
module entry_sockets() {
    for (cx = [pad_cx_L, pad_cx_R]) {
        translate([corner_inner_r + cx, 0, conn_pad_h / 2])
            rotate([90, 0, 0])
                cylinder(d = conn_d + conn_clr, h = conn_h + 1, $fn = 48);
    }
}

// ── Exit-face connector pads (θ=90°, face points in +X) ──────────────────────
// At θ=90° the face runs along X = 0, Y = corner_inner_r … corner_inner_r+track_total_w
// "Outside the wall" in the rotated frame means Y < corner_inner_r or Y > corner_inner_r+track_total_w

module exit_pads() {
    for (cx = [pad_cx_L, pad_cx_R]) {
        y0 = corner_inner_r + cx - conn_pad_w / 2;
        translate([0, y0, 0])
            cube([conn_pad_len, conn_pad_w, conn_pad_h]);
    }
}

// Exit bosses — protrude from exit face in -X direction (toward incoming section)
module exit_bosses() {
    for (cx = [pad_cx_L, pad_cx_R]) {
        translate([0, corner_inner_r + cx, conn_pad_h / 2])
            rotate([0, 90, 0])
                cylinder(d = conn_d, h = conn_h, $fn = 48);
    }
}

// ── Assembled corner ──────────────────────────────────────────────────────────
difference() {
    union() {
        corner_section();
        entry_pads();
        exit_pads();
        exit_bosses();
    }
    entry_sockets();
}
