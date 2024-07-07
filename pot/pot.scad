/* [General] */

// Minimum angle
$fa = 0.1; //[0:0.01:5]

// Minimum size
$fs = 0.1; //[0:0.01:5]

PART = "explode";

EPS = 1e-3;

KERF = 0.1;

/* [SPECIFICS] */

MAG_DIAMETER = 5;
MAG_HEIGHT = 2;
MAG_DISTANCE = 3.3;  // distance of magnet from the sensor centre

MAG_ROTATION_OFFSET=0;

MAG_HOLDER_RADIUS = sqrt( pow(MAG_DIAMETER / 2, 2) + pow(MAG_HEIGHT + MAG_DISTANCE, 2) ) + KERF;
MAG_HOLDER_HEIGHT = MAG_DIAMETER - KERF;

DIMPLE_RADIUS = 0.8;

DUPONT_WIDTH=8.1;
DUPONT_HEIGHT=3;

FRONT_WALL_THICKNESS = 2;
REAR_WALL_THICKNESS = 2 + DUPONT_HEIGHT;
SIDE_WALL_THICKNESS = 3;

FRONT_SHAFT_LENGTH = 9;
FRONT_SHAFT_DIAMETER = 9;

EXPOSED_SHAFT_HEIGHT = 15; // how much of the shaft protrudes from the front cover
SHAFT_HEIGHT = EXPOSED_SHAFT_HEIGHT + FRONT_SHAFT_LENGTH + FRONT_WALL_THICKNESS + MAG_HOLDER_HEIGHT;
SHAFT_DIAMETER = 6.3;
SHAFT_RECESS = 2.2;
SHAFT_RECESS_HEIGHT = 11;

SENSOR_WIDTH = 4.25;  // physical outer dimensions of the sensor
SENSOR_HEIGHT = 3;
SENSOR_DEPTH = 1.7;
SENSOR_FRONT_DEPTH = 0.85; // distance from front face to pins
SENSOR_LEAD_DEPTH = SENSOR_DEPTH - SENSOR_FRONT_DEPTH;

SENSOR_HOLDER_DIAMETER = SENSOR_WIDTH + 2;
SENSOR_HOLDER_INNER_HEIGHT = MAG_HOLDER_HEIGHT + 2 * KERF;

ALIGNMENT_TAB_DIAMETER = 3;
ALIGNMENT_TAB_INNER_DISTANCE = 18.85;
ALIGNMENT_TAB_BASE_RADIUS = 3;
ALIGNMENT_TAB_LENGTH = 1.6;

LOCK_OFFSET = 1.6;
LOCK_WIDTH = 2;
LOCK_RECESS = 1;

CLIP_WIDTH = FRONT_SHAFT_DIAMETER + 2;
CLIP_LENGTH = 15.5;
CLIP_HEIGHT = LOCK_WIDTH - KERF;


module copy_mirror(vec=[0,1,0])
{
    children();
    mirror(vec) children();
}


module shaft() {
    difference() {
        // complete shaft, just a cylinder
        cylinder(d=SHAFT_DIAMETER, h=SHAFT_HEIGHT);

        // shaft recess,
        translate([SHAFT_DIAMETER/2 - (SHAFT_RECESS + KERF), -SHAFT_DIAMETER/2, SHAFT_HEIGHT - SHAFT_RECESS_HEIGHT])
        cube([SHAFT_DIAMETER, SHAFT_DIAMETER, SHAFT_RECESS_HEIGHT + EPS]);
    }
}

module mag_holder() {
    difference() {
        // shaft and magnet holding body
        union(){
            shaft();
            cylinder(r=MAG_HOLDER_RADIUS, h=MAG_HOLDER_HEIGHT);
        }

        // holes for magnets
        rotate([0, 0, MAG_ROTATION_OFFSET])
        copy_mirror()
        translate([0, -MAG_DISTANCE, MAG_HOLDER_HEIGHT / 2])
        rotate([90, 0, 0])
        union() {
            // actual cylinder for the magnet
            cylinder(d1 = MAG_DIAMETER + KERF, d2 = MAG_DIAMETER + 2 * KERF, h = MAG_HEIGHT + EPS);

            // square cut planar surface to magnet holder outside where magnets reside
            translate([0,0, MAG_HEIGHT * 1.5])
            cube([MAG_DIAMETER * 2, MAG_DIAMETER, MAG_HEIGHT], center=true);
        }

        // hole for the sensor
        translate([0,0,-EPS])
        cylinder(d=SENSOR_HOLDER_DIAMETER + 2 * KERF, h = SENSOR_HEIGHT + 2 * KERF);
    }
}

module sensor_profile() {

    translate([-SENSOR_LEAD_DEPTH, -SENSOR_WIDTH / 2, 0])
    polygon([
        [0, 0],
        [0, SENSOR_WIDTH],
        [SENSOR_DEPTH - SENSOR_FRONT_DEPTH, SENSOR_WIDTH],
        [SENSOR_DEPTH, SENSOR_WIDTH - SENSOR_FRONT_DEPTH],
        [SENSOR_DEPTH, 0 + SENSOR_FRONT_DEPTH],
        [SENSOR_DEPTH - SENSOR_FRONT_DEPTH, 0]
    ]);

}


// add_kerf parameter makes this part bigger, allowing for cutouts with some slack
module front_alignment_tabs(add_kerf = false) {
    offset = add_kerf ? KERF : 0;
    alignment_tab_offset = (ALIGNMENT_TAB_INNER_DISTANCE + ALIGNMENT_TAB_DIAMETER) / 2;
    alignment_tab_base_offset = ALIGNMENT_TAB_INNER_DISTANCE / 2 + ALIGNMENT_TAB_BASE_RADIUS;

    hull() copy_mirror () {
        translate([0, alignment_tab_base_offset, -offset])
        cylinder(r=ALIGNMENT_TAB_BASE_RADIUS + offset, h=FRONT_WALL_THICKNESS + offset * 2 );
    }

    // alignment tabs
    copy_mirror() {
        translate([0, alignment_tab_offset, FRONT_WALL_THICKNESS])
        hull(){
        cylinder(d=ALIGNMENT_TAB_DIAMETER, h=ALIGNMENT_TAB_LENGTH);
        translate([0, ALIGNMENT_TAB_DIAMETER/2, 0])
        cylinder(d=ALIGNMENT_TAB_DIAMETER, h=ALIGNMENT_TAB_LENGTH);
        }
    }

    // front wall
    translate([0, 0, -offset])
    cylinder(r=MAG_HOLDER_RADIUS + SIDE_WALL_THICKNESS/2 + offset, h=FRONT_WALL_THICKNESS + offset * 2);
    translate([0,0,FRONT_WALL_THICKNESS/2])

    // Dimples for the locking mechanism
    copy_mirror(vec=[1,0,0])
    translate([MAG_HOLDER_RADIUS + SIDE_WALL_THICKNESS/2 + DIMPLE_RADIUS * (-1/4), 0, 0])
    sphere(d= 2 * DIMPLE_RADIUS + offset);
}

module front(add_kerf = false) {
    offset = add_kerf ? KERF : 0;
    difference() {
        union() {
            front_alignment_tabs();

            // front shaft section
            translate([0, 0, FRONT_WALL_THICKNESS])

            // only 0.5 * KERF because we want a very tight fit here
            cylinder(d=FRONT_SHAFT_DIAMETER - 0.5 * KERF, h=FRONT_SHAFT_LENGTH);
        }

        // shaft cutout
        translate([0, 0, -EPS])
        // TODO This is a bearing, maybe tighter fit?
        cylinder(d=SHAFT_DIAMETER + 1 * KERF, h=FRONT_SHAFT_LENGTH + FRONT_WALL_THICKNESS + 2 * EPS);

        // lock ring recess
        translate([0, 0, FRONT_WALL_THICKNESS + LOCK_OFFSET ])
        difference() {
            // only 1 * KERF because we want a tight fit here
            height = LOCK_WIDTH;
            cylinder(d=FRONT_SHAFT_DIAMETER + EPS, h=height);
            cylinder(d=FRONT_SHAFT_DIAMETER - LOCK_RECESS, h=height);
        }
    }
}

module sensor_holder() {

    union(){
        // imediate housing arround sensor
        translate([0,0, REAR_WALL_THICKNESS])
        difference() {

            // overlap cylinder
            translate([0,0, - 2 * EPS])
            cylinder(d = SENSOR_HOLDER_DIAMETER, h = SENSOR_HEIGHT + 2 * EPS);

            translate([0, 0, -.01])
            rotate([0, 0, 180])
            linear_extrude(height = SENSOR_HEIGHT + 0.02, center = false)
            sensor_profile();
        }

        // base of the holder
        difference() {
            // outer body
            cylinder(r=MAG_HOLDER_RADIUS + SIDE_WALL_THICKNESS, h=REAR_WALL_THICKNESS + FRONT_WALL_THICKNESS + SENSOR_HOLDER_INNER_HEIGHT);

            // inner cylinder shaped pocket in body
            translate([0,0, REAR_WALL_THICKNESS - EPS])
            cylinder(r=MAG_HOLDER_RADIUS + 0.3, h=SENSOR_HOLDER_INNER_HEIGHT + 2 * EPS);

            // sensor wire tunnel
            translate([0, - (SENSOR_WIDTH / 2), -EPS])
            cube([SENSOR_LEAD_DEPTH, SENSOR_WIDTH,REAR_WALL_THICKNESS + 2 * EPS]);

            // front alignment tab wing cutout
            translate([0,0, REAR_WALL_THICKNESS + SENSOR_HOLDER_INNER_HEIGHT])
            front_alignment_tabs(0.1);

            // little indentation to show Vcc for the sensor
            translate([SENSOR_LEAD_DEPTH + .7, SENSOR_WIDTH * .4, -EPS])
            linear_extrude(1)
            polygon([ [0, 0], [2, 1], [2, -1]]);

            // dupont connector

            translate([ - (MAG_HOLDER_RADIUS + SIDE_WALL_THICKNESS + EPS), 0, 0]) {
                translate([0, -DUPONT_WIDTH / 2, 1])
                cube([MAG_HOLDER_RADIUS + SENSOR_LEAD_DEPTH + 2 * EPS, DUPONT_WIDTH, DUPONT_HEIGHT]);

                translate([0, -(DUPONT_WIDTH - 1) / 2, -EPS])
                cube([MAG_HOLDER_RADIUS + SIDE_WALL_THICKNESS + 2 * EPS, DUPONT_WIDTH - 1, DUPONT_HEIGHT]);
            }
        }
    }

}

module clip() {
    inner_diameter = FRONT_SHAFT_DIAMETER - 1;
    difference() {
        union() {
            // main body
            hull() {
                cylinder(d=CLIP_WIDTH, h=CLIP_HEIGHT);
                translate([-CLIP_WIDTH/2, CLIP_LENGTH - CLIP_WIDTH, 0])
                cube([CLIP_WIDTH , CLIP_WIDTH, CLIP_HEIGHT]);
            }
            // grip at end
            translate([-CLIP_WIDTH/2, CLIP_LENGTH , 0])
            cube([CLIP_WIDTH , CLIP_WIDTH * 0.25, CLIP_HEIGHT * 2]);
        }
        translate([0,0, -EPS])
        cylinder(d=inner_diameter, h=CLIP_HEIGHT + 2 * EPS);
        translate([0, -inner_diameter/2, CLIP_HEIGHT/2])
        cube([inner_diameter - 1.5 * LOCK_RECESS, inner_diameter, CLIP_HEIGHT + 2 * EPS], center=true);
    }

}

if(PART == "explode") {
    sensor_holder();

    translate([0,0,30 + SHAFT_HEIGHT])
    front();

    translate([0,0,20])
    mag_holder();

    translate([0, 0, 40 + SHAFT_HEIGHT + FRONT_SHAFT_LENGTH])
    clip();
}

if(PART == "clip") clip();
if(PART == "sensor") sensor_holder();
if(PART == "mag") mag_holder();
if(PART == "front") front();
