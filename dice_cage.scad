include <params.scad>

// ── Dice cage — snaps onto cart top plate ─────────────────────────────────────
// Open-top, open-bottom box that sits over the 200 × 200 mm cart top plate and
// snaps under its edge to contain dice during use.
//
// PRINT UPSIDE DOWN — flip 180° in slicer so the clip hooks rest on the bed
// (fully supported).  After printing, flip right-side up and press onto plate.
//
// Assembly: press straight down over the plate.  The chamfered clip hooks flex
// outward over the plate edge, then spring back underneath — locked.
// Release: flex all four clips outward simultaneously and lift.

cage_wall_h  = 25;    // wall height above plate — clears standard 16 mm dice
cage_wall_t  = 3.0;   // wall thickness
cage_clr     = 0.5;   // per-side clearance between cage inner wall and plate edge

clip_w       = 30;    // clip width, centred on each wall
clip_arm_t   = 2.0;   // clip arm thickness — thin enough to flex by hand
clip_arm_len = plate_t + 0.5;   // 4.5 mm — arm reaches just past plate bottom face
clip_bite    = 1.5;   // hook depth below plate bottom (catches plate when lifting)
clip_reach   = cage_wall_t + cage_clr + 1.5;  // 5 mm inward reach of hook

cage_inner = cart_plate + 2 * cage_clr;     // 201 mm
cage_ow    = cage_inner + 2 * cage_wall_t;  // 207 mm

// ── Cage walls (open top and bottom) ─────────────────────────────────────────
module cage_walls() {
    difference() {
        translate([-cage_ow/2, -cage_ow/2, 0])
            cube([cage_ow, cage_ow, cage_wall_h]);
        translate([-cage_inner/2, -cage_inner/2, 0])
            cube([cage_inner, cage_inner, cage_wall_h + 0.1]);
    }
}

// ── Single snap clip (faces +Y; rotate to place on other sides) ───────────────
// Z=0 = cage wall bottom = plate top surface when assembled.
// Clip arm hangs below Z=0, wraps just past plate bottom face.
// Hook shape (hull of two planes):
//   - Top plane (z=-clip_arm_len): full width yh→yw2, creates flat top of hook
//   - Bottom plane (z=-(clip_arm_len+clip_bite)): inner portion only yh→yw
//     → outer face slopes inward-downward = chamfer that rides plate edge on press-fit
//   - Inner vertical face at yh: catches plate bottom face when cage is lifted
module snap_clip() {
    yw  = cage_ow / 2;           // cage wall outer face
    yw2 = yw + clip_arm_t;       // clip arm outer face
    yh  = yw - clip_reach;       // hook inner face (1.5 mm under plate edge)

    // Arm — hangs below cage bottom alongside plate edge
    translate([-clip_w/2, yw, -clip_arm_len])
        cube([clip_w, clip_arm_t, clip_arm_len]);

    // Hook — chamfered wedge; hull of top-wide and bottom-narrow planes
    hull() {
        translate([-clip_w/2, yh, -clip_arm_len])
            cube([clip_w, yw2 - yh, 0.01]);   // top: full width
        translate([-clip_w/2, yh, -(clip_arm_len + clip_bite)])
            cube([clip_w, yw - yh, 0.01]);    // bottom: inner only → outer chamfer
    }
}

// ── Four clips, one per side ──────────────────────────────────────────────────
module all_clips() {
    snap_clip();
    rotate([0, 0, 180]) snap_clip();
    rotate([0, 0,  90]) snap_clip();
    rotate([0, 0, -90]) snap_clip();
}

union() {
    cage_walls();
    all_clips();
}
