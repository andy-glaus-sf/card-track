// ── Shared parameters for card track system ──────────────────────────────────

// 608ZZ skateboard bearing
bearing_od = 22;
bearing_id = 8;
bearing_w  = 7;

// Track channel (straight and corner sections share this profile)
// body 50 mm + posts 10 mm each side = 70 mm total → 3 mm clearance each side in 76 mm channel
track_inner_w   = 76;    // inner width of U-channel
track_wall_h    = 11;    // wall height above floor
track_wall_t    = 5;     // wall thickness
track_floor_t   = 4;     // floor thickness
track_sec_len   = 200;   // length of one straight section

// Bearing contact floor rails — narrow floor strips along the two bearing lines.
// The floor is ONLY present at (a) these two rails and (b) full-width end sections
// under the connector pads.  Everything else is open to save material.
//
//  Floor plan view (bottom of straight section):
//   [=====END FLOOR=====]  ← full width, conn_pad_len deep
//   |  |             |  |
//   |  | rail   rail |  |  ← two 9 mm rails running full length
//   |  |             |  |
//   [=====END FLOOR=====]
//
// Rail X positions: bearing midpoint sits at (channel_centre ± body_half ∓ bearing_w/2)
// Left  rail centre: track_wall_t + track_inner_w/2 − cart_body_w/2 − bearing_w/2
// Right rail centre: track_wall_t + track_inner_w/2 + cart_body_w/2 + bearing_w/2
bear_rail_w = bearing_w + 2;  // 9 mm — bearing width + 2 mm margin

// Track end connectors — puzzle-piece tabs flush with the track floor.
// Tabs extrude from the end face at Z=0, spanning the full floor thickness
// (track_floor_t).  Sockets are through-holes cut from Z=0 to Z=track_floor_t
// in the end-section floor — open top and bottom, so no supports are needed
// when printing flat.  Bottom face of every track section is perfectly flat.
//
//  Side view at end face (track lying on table):
//
//    ════════════════════════  ← track walls (Z = 0 to track_total_h)
//    ┌──────────────────────┐  ← floor (Z = 0 to track_floor_t)
//    │  [socket] [socket]   │  ← through-holes in floor
//    └──────────────────────┘  ← bottom face at Z = 0 (flat)
//
//  +Y end face: tabs protrude beyond end face, spanning Z = 0..track_floor_t
//  -Y end face: sockets are through-holes in the end-section floor

tab_neck_w   = 12;           // neck width
tab_neck_l   = 8;            // neck length (protrusion from end face)
tab_knob_d   = 22;           // knob diameter — wider than neck, creates interlock
tab_clr      = 1.0;          // total clearance on width/diameter (0.5 mm per side)

conn_pad_w   = tab_knob_d + 6;                  // 28 mm — connector cross-section width
conn_pad_len = tab_neck_l + tab_knob_d / 2 + 4; // 23 mm — floor depth / tab reach

// X centres of the two connector pads — quarter-points of the inner channel.
// Pad 1 centre ≈ 24 mm from left edge; Pad 2 centre ≈ 62 mm from left edge.
// (track_wall_t = 5; inner = 76; quarters at 5+19=24 and 5+57=62)
bot_conn_x1 = track_wall_t + track_inner_w * 0.25;
bot_conn_x2 = track_wall_t + track_inner_w * 0.75;

// Cart
cart_plate   = 200;    // 200 × 200 mm top plate
plate_t      = 4;      // plate thickness (thicker to give pegs something to grip)
// body is 50 mm wide; posts (10 mm each side) bring total to 70 mm → 3 mm clearance each side in 76 mm channel
cart_body_w  = 50;
cart_body_h  = 22;     // height of cart body — reduced 4 mm from original 26 mm
wheelbase    = 120;    // front-to-rear axle spacing
cart_body_len = wheelbase + 20;  // 140 mm front-to-rear
cart_wall_t   = 7;               // hollow cart body wall thickness (all four sides)

// Alignment pegs (body → plate)
// Pegs sit at the 4 solid corners of the body top face, outside the lightening pocket.
// Plate holes are through-holes; pegs protrude above the plate surface for grip during gluing.
peg_d    = 4.0;   // peg cylinder diameter
peg_h    = 7.0;   // peg height above body top face (extends 3 mm above plate)
hole_d   = 4.3;   // plate hole diameter (0.3 mm clearance — easy slide, glue fills gap)

// Stub-axle posts (bearing friction-fit over post)
post_d       = 8.2;   // 0.2 mm press-fit onto 608ZZ bore (8 mm)
// post breakdown: 1.5 mm shoulder gap + 7 mm bearing + 1.5 mm retention nose = 10 mm
post_len     = 10;
// post centre sits 9 mm above cart body bottom face:
//   bearing centre = 11 mm above track floor  (= bearing_od/2)
//   cart body bottom clears floor by 2 mm      (= 11 - 9)
post_z       = 9;

// Circular relief cut into the body side face at each post base.
// Prevents the bearing outer race from rubbing against the body during spin.
bearing_relief_d     = bearing_od + 4;   // 26 mm diameter
bearing_relief_depth = 1.5;              // axial depth of relief pocket

// Corner
corner_inner_r = 100;  // inner radius of corner track centre-line
