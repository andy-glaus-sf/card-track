// ── Shared parameters for card track system ──────────────────────────────────

// 608ZZ skateboard bearing
bearing_od = 22;
bearing_id = 8;
bearing_w  = 7;

// Track section
track_sec_len = 200;   // length of one straight section
track_floor_t = 4;     // floor thickness

// Cart body width — defined here early because rail spacing depends on it
cart_body_w  = 50;

// Bearing groove rails — two narrow U-channels (one per bearing) replace the
// single large U-channel.  Each groove captures one 608ZZ bearing laterally;
// the floor carries vertical load.  No outer containment walls needed.
//
//  Cross-section view (one groove):
//
//    ┌─┐         ┌─┐
//    │ │  O OOO  │ │   ← 608ZZ bearing (22 mm OD) riding in groove
//    └─┴─────────┴─┘
//    ←t→← ch_w →←t→
//
rail_ch_w      = 8.0;   // inner groove width — bearing_w (7 mm) + 1 mm clearance
rail_ch_wall_t = 3.5;   // groove wall thickness each side
rail_ch_wall_h = 6.0;   // groove wall height above floor

// Bearing centre X positions, gap geometry, and total track width.
post_shoulder = 1.5;   // axial gap between body face and bearing inner race
bear_cx_L     = rail_ch_wall_t + rail_ch_w / 2;
bear_cx_R     = bear_cx_L + cart_body_w + 2 * (post_shoulder + bearing_w / 2);
track_total_w = bear_cx_R + rail_ch_w / 2 + rail_ch_wall_t;

// Inner faces of the gap between the two rails
gap_inner_L = bear_cx_L + rail_ch_w / 2 + rail_ch_wall_t;
gap_inner_R = bear_cx_R - rail_ch_w / 2 - rail_ch_wall_t;
gap_w       = gap_inner_R - gap_inner_L;

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

// X centres of the two connector pads — at 1/3 and 2/3 of the gap between rails.
// Both connectors land inside the gap, away from the rail bodies.
bot_conn_x1 = gap_inner_L + gap_w / 3;
bot_conn_x2 = gap_inner_R - gap_w / 3;

// Cart
cart_plate   = 200;    // 200 × 200 mm top plate
plate_t      = 4;      // plate thickness (thicker to give pegs something to grip)
// cart_body_w defined above (rail spacing depends on it)
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
