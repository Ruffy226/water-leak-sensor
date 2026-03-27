// Water Leak Sensor Case
// Xiao ESP32-S3 with probe pins exposed at bottom
// USB-C powered, magnetic mount on back

// ============================================
// PARAMETERS
// ============================================

// Case dimensions
case_width = 40;
case_depth = 20;
case_height = 50;

// Wall thickness
wall = 2;

// Xiao ESP32-S3 dimensions
xiao_width = 21;
xiao_depth = 17.5;
xiao_height = 8;  // With headers

// Probe pins
probe_count = 2;
probe_spacing = 8;
probe_hole = 2;

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
// CASE BODY
// ============================================

module case_body() {
    difference() {
        // Outer shell
        rounded_box(case_width, case_depth, case_height, 3);
        
        // Inner cavity
        translate([wall, wall, wall])
        rounded_box(
            case_width - wall * 2,
            case_depth - wall * 2,
            case_height
        );
        
        // Probe holes at bottom (front face)
        translate([case_width/2 - probe_spacing/2, -1, wall])
        cylinder(d=probe_hole, h=wall + 2, $fn=12);
        
        translate([case_width/2 + probe_spacing/2, -1, wall])
        cylinder(d=probe_hole, h=wall + 2, $fn=12);
        
        // USB-C port (back, top)
        translate([case_width/2, case_depth - 1, case_height - 20])
        rotate([90, 0, 0])
        hull() {
            translate([-usb_width/2 + usb_height/2, 0, 0])
            cylinder(d=usb_height, h=wall + 2, $fn=12);
            translate([usb_width/2 - usb_height/2, 0, 0])
            cylinder(d=usb_height, h=wall + 2, $fn=12);
        }
        
        // LED hole (top)
        translate([case_width/2, case_depth/2, case_height - 1])
        cylinder(d=led_diam, h=wall + 2, $fn=12);
        
        // Mounting slots (back) - for magnetic latch
        translate([-1, case_depth/2, case_height/2])
        rotate([0, 90, 0])
        cylinder(d=4, h=wall + 2, $fn=12);
    }
    
    // Probe contact pads (internal)
    translate([case_width/2 - probe_spacing/2, wall + 2, wall])
    cylinder(d=5, h=1, $fn=12);
    
    translate([case_width/2 + probe_spacing/2, wall + 2, wall])
    cylinder(d=5, h=1, $fn=12);
    
    // Xiao mounting posts
    translate([wall + 3, wall + 3, wall + 5])
    xiao_mount();
}

// ============================================
// XIAO MOUNT
// ============================================

module xiao_mount() {
    post_h = 3;
    post_d = 4;
    hole_d = 1.5;
    
    // Corner posts
    for (x = [0, xiao_width - 4]) {
        for (y = [0, xiao_depth - 4]) {
            translate([x, y, 0])
            difference() {
                cylinder(d=post_d, h=post_h, $fn=12);
                translate([0, 0, 1])
                cylinder(d=hole_d, h=post_h, $fn=8);
            }
        }
    }
}

// ============================================
// LID (optional)
// ============================================

module lid() {
    difference() {
        rounded_box(case_width, case_depth, 3, 3);
        
        // USB-C cutout
        translate([case_width/2, case_depth - wall, -1])
        rotate([90, 0, 0])
        hull() {
            translate([-usb_width/2 + usb_height/2, 0, 0])
            cylinder(d=usb_height, h=wall + 2, $fn=12);
            translate([usb_width/2 - usb_height/2, 0, 0])
            cylinder(d=usb_height, h=wall + 2, $fn=12);
        }
    }
}

// ============================================
// RENDER
// ============================================

// Main case
case_body();

// Lid (positioned beside case)
// translate([case_width + 10, 0, 0]) lid();
