$fn = 50;

MAG_DIAMETER = 6.15;
MAG_HEIGHT = 3;
MAG_DISTANCE = 3.5;  // distance of magnet from the sensor centre

ASSEMBLY_WIDTH = 22; // width of the assembly up to the flange

SENSOR_OFFSET = 7; // where the midpoint of the sensor will sit from the base of the magnet holder
SENSOR_HOLE_DIAMETER = 5.5;
SENSOR_WIDTH = 4.15;  // physical outer dimensions of the sensor
SENSOR_HEIGHT = 3;
SENSOR_DEPTH = 1.55;
SENSOR_FRONT_DEPTH = 0.79; // distance from front face to pins
SENSOR_LEAD_LENGTH = 9;
SENSOR_LEAD_DEPTH = SENSOR_DEPTH - SENSOR_FRONT_DEPTH;

SENSOR_HOLDER_DIAMETER = 14;
SENSOR_HOLDER_FLANGE_DIAMETER = 20; // bit outside the base
SENSOR_HOLDER_FLANGE_WIDTH = 4;

BASE_HOLE_DIAMETER = 16.1;
BASE_INTERFERENCE_WIDTH = 3;

OVERLAP_DIAMETER = 8;

MAG_HOLDER_DIAMETER = (MAG_HEIGHT + MAG_DISTANCE) * 2;
MAG_HOLDER_LENGTH = 12;
MAG_ROTATION_OFFSET = 80;

POT_SHAFT_HEIGHT = 5;
POT_SHAFT_DIAMETER = 6.4;
POT_SHAFT_RECESS = 2.6;

HOLDER_OVERLAP = MAG_HOLDER_LENGTH - SENSOR_OFFSET - (SENSOR_HEIGHT / 2);

CONN_WIDTH = 8.5;
CONN_DEPTH = 3.5;
CONN_LENGTH = ASSEMBLY_WIDTH - SENSOR_LEAD_LENGTH - MAG_HOLDER_LENGTH + SENSOR_HOLDER_FLANGE_WIDTH + HOLDER_OVERLAP;


module copy_mirror(vec=[0,1,0]) 
{ 
    children(); 
    mirror(vec) children(); 
}

module pot_shaft_hole() {

    radius = POT_SHAFT_DIAMETER / 2;
    width = POT_SHAFT_DIAMETER - POT_SHAFT_RECESS;

    translate([0,0,POT_SHAFT_HEIGHT])
    rotate([180,0,0])
    linear_extrude(height = POT_SHAFT_HEIGHT, scale = 1.1) 
    intersection() {
        circle(radius);
        translate([-radius, -radius]) square([POT_SHAFT_DIAMETER, width]);
    }

}

module mag_holder() {

    difference() {
        cylinder(d = MAG_HOLDER_DIAMETER, h = MAG_HOLDER_LENGTH);
        translate([0, 0, -0.01])
        pot_shaft_hole();

        // holes for magnets
        rotate([0, 0, MAG_ROTATION_OFFSET])
        copy_mirror()
        translate([0, -MAG_DISTANCE , SENSOR_OFFSET]) 
        rotate([90, 0, 0]) 
        cylinder(d1 = MAG_DIAMETER, d2 = MAG_DIAMETER + 0.2, h = MAG_HEIGHT * 2 );

        // hole for sensor between magnets
        translate([0, 0, MAG_HOLDER_LENGTH + 0.01])
        rotate([0, 180, 0])
        cylinder(d = SENSOR_HOLE_DIAMETER, h = MAG_HOLDER_LENGTH - SENSOR_OFFSET + (SENSOR_HEIGHT /2 ));

        // hole for overlap between the holders
        translate([0, 0, MAG_HOLDER_LENGTH + 0.01])
        rotate([0, 180, 0])
        cylinder(d = OVERLAP_DIAMETER + 0.15, h = HOLDER_OVERLAP + 0.15);

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


module sensor_holder_body() {

    // solid model of the sensor holder to allow different 
    // lead cutout configurations
    overlap = HOLDER_OVERLAP - 0.15;
    main_width = ASSEMBLY_WIDTH - MAG_HOLDER_LENGTH - BASE_INTERFERENCE_WIDTH;


    // small little guide for the sensor
    difference() {

        translate([0, 0, -SENSOR_HEIGHT * 0.6])
        cylinder(d = SENSOR_WIDTH, h = SENSOR_HEIGHT * 0.6);

        translate([0, 0, -SENSOR_HEIGHT ])
        rotate([0, 0, 270])
        linear_extrude(height = SENSOR_HEIGHT, center = false)
        sensor_profile();
    }


    // overlap cylinder
    cylinder(d = OVERLAP_DIAMETER - 0.15, h = overlap);
    // main hex shaped part
    translate([0, 0, overlap])
    cylinder(d = SENSOR_HOLDER_DIAMETER, h = main_width, $fn = 6);
    // interference cylinder
    translate([0, 0, overlap + main_width])
    cylinder(d1 = BASE_HOLE_DIAMETER - 0.15, d2 = BASE_HOLE_DIAMETER, h = BASE_INTERFERENCE_WIDTH);
    // outer flange
    translate([0, 0, overlap + main_width + BASE_INTERFERENCE_WIDTH])
    cylinder(d = SENSOR_HOLDER_FLANGE_DIAMETER, h = SENSOR_HOLDER_FLANGE_WIDTH, $fn = 6);
}


module sensor_holder_side_exit() {

    difference() {
        sensor_holder_body();

        // hole for leads
        // offset hole for leads a little to help centre the sensor
        translate([- (SENSOR_WIDTH / 2), 0, -0.1]) cube([SENSOR_WIDTH, SENSOR_LEAD_DEPTH, (SENSOR_LEAD_LENGTH / 2) + 0.2]);
        hull() {
            translate([- (SENSOR_WIDTH / 2), 0, SENSOR_LEAD_LENGTH / 2]) 
            cube([SENSOR_WIDTH, SENSOR_LEAD_DEPTH, .1]);
            
            // hole for the connector
            translate([- CONN_WIDTH / 2, - CONN_DEPTH / 2, SENSOR_LEAD_LENGTH]) 
            cube([ CONN_WIDTH, CONN_DEPTH, CONN_LENGTH ]);
        }
    }

}

module sensor_holder_inner_exit() {

    d = 18;
    d2 = d * 0.7;

    difference() {
        sensor_holder_body();
        //rotate([0, 0, 180])
        difference() {
            translate([-SENSOR_WIDTH / 2, d / 2, 0])
            rotate([0, 90, 0]) 
            cylinder(d = d, h = SENSOR_WIDTH);

            translate([-SENSOR_WIDTH, d2 / 2 + SENSOR_LEAD_DEPTH, 0])
            rotate([0, 90, 0]) 
            cylinder(d = d2, h = SENSOR_WIDTH * 2);
            
            translate([-d/2, 0, -d - 0.1]) cube([d, d, d]);
        }
    }

}


mag_holder();
translate([0, 0, MAG_HOLDER_LENGTH + HOLDER_OVERLAP * 2])
sensor_holder_side_exit();


translate([30, 0, 0]) mag_holder();

translate([30, 0, MAG_HOLDER_LENGTH + HOLDER_OVERLAP * 2])
sensor_holder_inner_exit();

     










