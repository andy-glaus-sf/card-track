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
cart_body_w  = 144;    // fits inside 150 mm channel (3 mm clearance each side)
cart_body_h  = 26;     // height of cart body (must be ≤ track_wall_h)
wheelbase    = 120;    // front-to-rear axle spacing
axle_d       = 8;      // M8 bolt axle
axle_nut_af  = 13;     // M8 hex nut across-flats
axle_nut_h   = 6.5;    // M8 nut height

// Corner
corner_inner_r = 100;  // inner radius of corner track centre-line
