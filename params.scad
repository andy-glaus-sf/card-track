// ── Shared parameters for card track system ──────────────────────────────────

// 608ZZ skateboard bearing
bearing_od = 22;
bearing_id = 8;
bearing_w  = 7;

// Track channel (straight and corner sections share this profile)
track_inner_w   = 150;   // inner width of U-channel
track_wall_h    = 32;    // wall height above floor
track_wall_t    = 5;     // wall thickness
track_floor_t   = 4;     // floor thickness
track_sec_len   = 200;   // length of one straight section

// Alignment peg (male/female) at section ends
peg_d = 5;
peg_h = 4;

// Cart
cart_plate   = 200;    // 200 × 200 mm top plate
plate_t      = 3;      // plate thickness
// body is 124 mm wide; posts (10 mm each side) bring total to 144 mm → 3 mm clearance each side in 150 mm channel
cart_body_w  = 124;
cart_body_h  = 26;     // height of cart body (must be ≤ track_wall_h)
wheelbase    = 120;    // front-to-rear axle spacing

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
// Diameter = bearing OD + 4 mm (2 mm radial clearance all around)
bearing_relief_d = bearing_od + 4;   // 26 mm
bearing_relief_depth = 1.5;          // axial depth of relief pocket

// Corner
corner_inner_r = 100;  // inner radius of corner track centre-line
