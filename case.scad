// Water Leak Sensor Case - First Pass
// Simple enclosure for Xiao ESP32-S3 + UHPPOTE probe wire
// USB-C powered, snap-fit or screw lid

// ============================================
// PARAMETERS
// ============================================

// Case dimensions (compact)
case_width = 35;
case_depth = 20;
case_height = 50;

// Wall thickness
wall = 2;

// Xiao ESP32-S3 dimensions
xiao_width = 21;
xiao_depth = 17.5;
xiao_height = 6;  // Without headers

// Probe wire
wire_diam = 5;

// USB-C port
usb_width = 9;
usb_height = 3.5;

// LED indicator
led_diam = 3;

// Lid
lid_overlap = 3;
lid_thickness = 2;

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
// MAIN CASE
// ============================================

module case() {
    difference() {
        // Outer shell
        rounded_box(case_width, case_depth, case_height, 3);
        
        // Inner cavity
        translate([wall, wall, wall])
        rounded_box(
            case_width - wall * 2,
            case_depth - wall * 2,
            case_height - wall + 1
        );
        
        // Lid ledge (top inner rim for snap-fit)
        translate([wall - lid_overlap, wall - lid_overlap, case_height - lid_thickness])
        rounded_box(
            case_width - wall * 2 + lid_overlap * 2,
            case_depth - wall * 2 + lid_overlap * 2,
            lid_thickness + 1
        );
        
        // Probe wire exit (bottom center) - LARGE obvious slot
        translate([case_width/2 - 6, case_depth/2 - 3, -1])
        cube([12, 6, wall + 4]);
        
        // USB-C port (side, near top)
        translate([-1, case_depth/2, case_height - 20])
        rotate([0, 90, 0])
        hull() {
            translate([-usb_width/2 + usb_height/2, 0, 0])
            cylinder(d=usb_height, h=wall + 2, $fn=12);
            translate([usb_width/2 - usb_height/2, 0, 0])
            cylinder(d=usb_height, h=wall + 2, $fn=12);
        }
        
        // LED hole (front, near top)
        translate([case_width/2, -1, case_height - 12])
        rotate([-90, 0, 0])
        cylinder(d=led_diam, h=wall + 2, $fn=12);
        
        // Mounting hole (back, top) - keyhole style
        translate([case_width/2, case_depth - 1, case_height - 10])
        rotate([90, 0, 0]) {
            cylinder(d=4, h=wall + 2, $fn=12);
            translate([-2, -6, 0])
            cube([4, 6, wall + 2]);
        }
        
        // Vent holes (sides, bottom half) - for air circulation
        for (z = [15, 25, 35]) {
            // Left
            translate([-1, case_depth/2, z])
            rotate([0, 90, 0])
            cylinder(d=4, h=wall + 2, $fn=8);
            
            // Right
            translate([case_width - wall - 1, case_depth/2, z])
            rotate([0, 90, 0])
            cylinder(d=4, h=wall + 2, $fn=8);
        }
    }
    
    // Xiao mounting posts (inside)
    translate([wall + 4, wall + 2, wall])
    xiao_mount();
    
    // Wire strain relief (internal, near wire exit)
    translate([case_width/2 - 4, case_depth/2 - 4, wall])
    cable_anchor();
}

// ============================================
// XIAO MOUNT
// ============================================

module xiao_mount() {
    post_h = 4;
    post_d = 4;
    hole_d = 1.5;
    
    // Four corner posts
    for (x = [0, xiao_width - 3]) {
        for (y = [0, xiao_depth - 3]) {
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
// CABLE ANCHOR
// ============================================

module cable_anchor() {
    difference() {
        // Base
        cube([8, 8, 4]);
        
        // Cable channel
        translate([4, 4, -1])
        cylinder(d=wire_diam - 1, h=6, $fn=12);
        
        // Zip tie slot
        translate([-1, 3, 2])
        cube([10, 2, 2]);
    }
}

// ============================================
// LID
// ============================================

module lid() {
    difference() {
        union() {
            // Top plate
            rounded_box(case_width, case_depth, lid_thickness, 3);
            
            // Inner rim (snap-fit)
            translate([wall, wall, 0])
            rounded_box(
                case_width - wall * 2,
                case_depth - wall * 2,
                lid_overlap
            );
        }
        
        // USB-C notch (if needed for cable clearance)
        translate([case_width/2, case_depth - wall + 1, lid_thickness])
        rotate([90, 0, 0])
        hull() {
            translate([-usb_width/2 + usb_height/2, 0, 0])
            cylinder(d=usb_height, h=wall, $fn=12);
            translate([usb_width/2 - usb_height/2, 0, 0])
            cylinder(d=usb_height, h=wall, $fn=12);
        }
    }
}

// ============================================
// RENDER OPTIONS
// ============================================

// Print both (side by side)
case();
translate([case_width + 10, 0, 0]) lid();

// Print case only
// case();

// Print lid only
// lid();
