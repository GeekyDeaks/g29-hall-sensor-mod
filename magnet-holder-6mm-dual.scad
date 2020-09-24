$fn = 50;

MAG_DIAMETER = 6.1;
MAG_HEIGHT = 2;
MAG_DISTANCE = 4;  // distance of magnet from the sensor centre

ASSEMBLY_WIDTH = 22; // width of the assembly up to the flange

SENSOR_OFFSET = 7; // where the midpoint of the sensor will sit from the base of the magnet holder
SENSOR_HOLE_DIAMETER = 5;
SENSOR_WIDTH = 4;  // physical outer dimensions of the sensor
SENSOR_HEIGHT = 3;

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
        cylinder(d = MAG_DIAMETER, h = MAG_HEIGHT * 2 );

        translate([0, 0, MAG_HOLDER_LENGTH + 0.01])
        rotate([0, 180, 0])
        cylinder(d = SENSOR_HOLE_DIAMETER, h = MAG_HOLDER_LENGTH - SENSOR_OFFSET + (SENSOR_HEIGHT /2 ));

        translate([0, 0, MAG_HOLDER_LENGTH + 0.01])
        rotate([0, 180, 0])
        cylinder(d = OVERLAP_DIAMETER + 0.15, h = HOLDER_OVERLAP + 0.15);

    }
    
}


module sensor_holder() {
    overlap = HOLDER_OVERLAP - 0.15;
    main_width = ASSEMBLY_WIDTH - MAG_HOLDER_LENGTH - BASE_INTERFERENCE_WIDTH;
    cylinder(d = OVERLAP_DIAMETER - 0.15, h = overlap);
    translate([0, 0, overlap])
    cylinder(d = SENSOR_HOLDER_DIAMETER, h = main_width, $fn = 6);
    translate([0, 0, overlap + main_width])
    cylinder(d = BASE_HOLE_DIAMETER, h = BASE_INTERFERENCE_WIDTH);
    translate([0, 0, overlap + main_width + BASE_INTERFERENCE_WIDTH])
    cylinder(d = SENSOR_HOLDER_FLANGE_DIAMETER, h = SENSOR_HOLDER_FLANGE_WIDTH, $fn = 6);

}

mag_holder();
translate([0, 0, MAG_HOLDER_LENGTH + HOLDER_OVERLAP]) 
sensor_holder();







