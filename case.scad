// Water Leak Sensor Case
// Xiao ESP32-S3 with UHPPOTE probe
// USB-C powered, screw-on access panel

// ============================================
// PARAMETERS
// ============================================

// Case dimensions
case_width = 45;
case_depth = 25;
case_height = 55;

// Wall thickness
wall = 2.5;

// Access panel (back)
panel_thickness = 2;
screw_diam = 2.5;  // M2.5 screws
screw_head_diam = 4.5;
screw_head_depth = 2;

// Xiao ESP32-S3 dimensions
xiao_width = 21;
xiao_depth = 17.5;

// Probe wire exit
wire_hole = 6;  // For probe cable

// USB-C port
usb_width = 9;
usb_height = 3.5;

// LED indicator
led_diam = 3;

// ============================================
// HELPERS
// ============================================

module rounded_box(l, w, h, r) {
    hull() {
        translate([r, r, 0]) cylinder(r=r, h=h);
        translate([l-r, r, 0]) cylinder(r=r, h=h);
        translate([r, w-r, 0]) cylinder(r=r, h=h);
        translate([l-r, w-r, 0]) cylinder(r=r, h=h);
    }
}

// ============================================
// CASE BODY (main enclosure)
// ============================================

module case_body() {
    difference() {
        // Outer shell
        rounded_box(case_width, case_depth, case_height, 4);
        
        // Inner cavity (open at back)
        translate([wall, wall, wall])
        rounded_box(
            case_width - wall * 2,
            case_depth - wall * 2,
            case_height
        );
        
        // Probe wire exit (bottom, back)
        translate([case_width/2, case_depth/2, -1])
        cylinder(d=wire_hole, h=wall + 2, $fn=16);
        
        // USB-C port (side, near top)
        translate([-1, case_depth/2, case_height - 25])
        rotate([0, 90, 0])
        hull() {
            translate([-usb_width/2 + usb_height/2, 0, 0])
            cylinder(d=usb_height, h=wall + 2, $fn=12);
            translate([usb_width/2 - usb_height/2, 0, 0])
            cylinder(d=usb_height, h=wall + 2, $fn=12);
        }
        
        // LED hole (front, near top)
        translate([case_width/2, -1, case_height - 15])
        rotate([-90, 0, 0])
        cylinder(d=led_diam, h=wall + 2, $fn=12);
        
        // Screw holes for access panel (back)
        // Top left
        translate([wall + 5, case_depth - wall - 5, case_height - wall])
        cylinder(d=screw_diam, h=wall + 2, $fn=12);
        // Top right
        translate([case_width - wall - 5, case_depth - wall - 5, case_height - wall])
        cylinder(d=screw_diam, h=wall + 2, $fn=12);
        // Bottom left
        translate([wall + 5, case_depth - wall - 5, wall])
        cylinder(d=screw_diam, h=wall + 2, $fn=12);
        // Bottom right
        translate([case_width - wall - 5, case_depth - wall - 5, wall])
        cylinder(d=screw_diam, h=wall + 2, $fn=12);
        
        // Screw head recesses
        // Top left
        translate([wall + 5, case_depth - wall - 5, case_height - panel_thickness - screw_head_depth])
        cylinder(d=screw_head_diam, h=screw_head_depth + 1, $fn=12);
        // Top right
        translate([case_width - wall - 5, case_depth - wall - 5, case_height - panel_thickness - screw_head_depth])
        cylinder(d=screw_head_diam, h=screw_head_depth + 1, $fn=12);
        // Bottom left
        translate([wall + 5, case_depth - wall - 5, wall + panel_thickness])
        cylinder(d=screw_head_diam, h=screw_head_depth + 1, $fn=12);
        // Bottom right
        translate([case_width - wall - 5, case_depth - wall - 5, wall + panel_thickness])
        cylinder(d=screw_head_diam, h=screw_head_depth + 1, $fn=12);
        
        // Mounting holes (back panel) - for wall/cabinet mounting
        translate([case_width/4, case_depth + 1, case_height/2])
        rotate([90, 0, 0])
        cylinder(d=4, h=wall + 2, $fn=12);
        
        translate([case_width * 3/4, case_depth + 1, case_height/2])
        rotate([90, 0, 0])
        cylinder(d=4, h=wall + 2, $fn=12);
    }
    
    // Internal mounting posts for Xiao
    translate([wall + 5, wall + 5, wall + 8])
    xiao_mount();
    
    // Cable strain relief (internal, near wire exit)
    translate([case_width/2 - 4, case_depth/2 - 4, wall])
    difference() {
        cube([8, 8, 3]);
        translate([4, 4, -1])
        cylinder(d=wire_hole - 1, h=5, $fn=16);
    }
}

// ============================================
// XIAO MOUNT
// ============================================

module xiao_mount() {
    post_h = 4;
    post_d = 5;
    hole_d = 2;
    
    // Corner posts with holes for Xiao
    for (x = [0, xiao_width - 5]) {
        for (y = [0, xiao_depth - 5]) {
            translate([x, y, 0])
            difference() {
                cylinder(d=post_d, h=post_h, $fn=12);
                translate([0, 0, 1])
                cylinder(d=hole_d, h=post_h, $fn=8);
            }
        }
    }
    
    // Support rail under USB-C
    translate([xiao_width/2 - 3, xiao_depth + 2, 0])
    cube([6, 3, post_h]);
}

// ============================================
// ACCESS PANEL (back cover)
// ============================================

module access_panel() {
    panel_w = case_width - wall * 2;
    panel_h = case_height - wall * 2;
    
    difference() {
        // Panel body
        translate([wall, wall, 0])
        rounded_box(panel_w, wall, panel_h, 2);
        
        // Screw holes (countersunk from outside)
        // Top left
        translate([wall + 5, wall/2, case_height - wall - 5])
        rotate([90, 0, 0]) {
            cylinder(d=screw_diam, h=panel_thickness + 2, $fn=12);
            translate([0, 0, panel_thickness - screw_head_depth])
            cylinder(d=screw_head_diam, h=screw_head_depth + 1, $fn=12);
        }
        // Top right
        translate([case_width - wall - 5, wall/2, case_height - wall - 5])
        rotate([90, 0, 0]) {
            cylinder(d=screw_diam, h=panel_thickness + 2, $fn=12);
            translate([0, 0, panel_thickness - screw_head_depth])
            cylinder(d=screw_head_diam, h=screw_head_depth + 1, $fn=12);
        }
        // Bottom left
        translate([wall + 5, wall/2, wall + 5])
        rotate([90, 0, 0]) {
            cylinder(d=screw_diam, h=panel_thickness + 2, $fn=12);
            translate([0, 0, panel_thickness - screw_head_depth])
            cylinder(d=screw_head_diam, h=screw_head_depth + 1, $fn=12);
        }
        // Bottom right
        translate([case_width - wall - 5, wall/2, wall + 5])
        rotate([90, 0, 0]) {
            cylinder(d=screw_diam, h=panel_thickness + 2, $fn=12);
            translate([0, 0, panel_thickness - screw_head_depth])
            cylinder(d=screw_head_diam, h=screw_head_depth + 1, $fn=12);
        }
    }
}

// ============================================
// RENDER OPTIONS
// ============================================

// === Print both parts ===
case_body();
translate([case_width + 15, 0, 0]) access_panel();

// === Print case only ===
// case_body();

// === Print panel only ===
// access_panel();
