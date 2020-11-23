$fn = 50;

MAG_DIAMETER = 6.15;
MAG_HEIGHT = 3;
MAG_DISTANCE = 3.5;  // distance of magnet from the sensor centre

MAG_ROTATION_OFFSET=0;

MAG_HOLDER_RADIUS = sqrt( pow(MAG_DIAMETER / 2, 2) + pow(MAG_HEIGHT + MAG_DISTANCE, 2) );

FRONT_WALL_THICKNESS = 2;
REAR_WALL_THICKNESS = 2;
SIDE_WALL_THICKNESS = 3;

FRONT_SHAFT_LENGTH = 9; // 
FRONT_SHAFT_DIAMETER = 8.95; //



EXPOSED_SHAFT_HEIGHT = 15; // how much of the shaft protrudes from the front cover
SHAFT_HEIGHT = EXPOSED_SHAFT_HEIGHT + FRONT_SHAFT_LENGTH + FRONT_WALL_THICKNESS;
SHAFT_DIAMETER = 6.3;
SHAFT_RECESS = 2.4;
SHAFT_RECESS_HEIGHT = 11;

SENSOR_WIDTH = 4.2;  // physical outer dimensions of the sensor
SENSOR_HEIGHT = 3;
SENSOR_DEPTH = 1.65;
SENSOR_FRONT_DEPTH = 0.79; // distance from front face to pins
SENSOR_LEAD_DEPTH = SENSOR_DEPTH - SENSOR_FRONT_DEPTH;

SENSOR_HOLDER_DIAMETER = SENSOR_WIDTH + 2;

ALIGNMENT_TAB_RADIUS = 1.5;
ALIGNMENT_TAB_OFFSET = 12;
ALIGNMENT_TAB_BASE_RADIUS = 3;
ALIGNMENT_TAB_LENGTH = 1.7;

LOCK_OFFSET = 1.7;
LOCK_WIDTH = 2;

module copy_mirror(vec=[0,1,0]) 
{ 
    children(); 
    mirror(vec) children(); 
}

module lock_ring(r=10, offset=0) {

    rotate_extrude(angle=360)
    translate([r, 0, 0])
    circle(r=0.2 + offset);
}

module shaft() {

    difference() {
        cylinder(d=SHAFT_DIAMETER, h=SHAFT_HEIGHT);
        translate([SHAFT_DIAMETER/2 - SHAFT_RECESS, -SHAFT_DIAMETER/2, SHAFT_HEIGHT - SHAFT_RECESS_HEIGHT])
        cube([SHAFT_RECESS + 0.001, SHAFT_DIAMETER, SHAFT_RECESS_HEIGHT + 0.001]);
    }

}

module mag_holder() {

    height = MAG_DIAMETER * 0.95;

    difference() {
        cylinder(r=MAG_HOLDER_RADIUS, h=height);

        rotate([0, 0, MAG_ROTATION_OFFSET])
        copy_mirror()
        translate([0, -MAG_DISTANCE, height / 2]) 
        rotate([90, 0, 0]) 
        union() {
            cylinder(d1 = MAG_DIAMETER, d2 = MAG_DIAMETER + 0.1, h = MAG_HEIGHT + 0.001);
            translate([0,0, MAG_HEIGHT * 1.5])
            cube([MAG_DIAMETER * 2, MAG_DIAMETER, MAG_HEIGHT], center=true);
        }
        
        // hole for the sensor
        translate([0,0,-0.001])
        cylinder(d=SENSOR_HOLDER_DIAMETER + 0.4, h = SENSOR_HEIGHT + 0.2);
    }
    // add the shaft
    translate([0,0,height])
    shaft();

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


module front_alignment_tabs(offset=0) {

    hull() {
        translate([0, ALIGNMENT_TAB_OFFSET, 0])
        cylinder(r=ALIGNMENT_TAB_BASE_RADIUS + offset, h=FRONT_WALL_THICKNESS + offset );
        translate([0, -ALIGNMENT_TAB_OFFSET, 0])
        cylinder(r=ALIGNMENT_TAB_BASE_RADIUS + offset, h=FRONT_WALL_THICKNESS + offset);
    }

    translate([0, ALIGNMENT_TAB_OFFSET, FRONT_WALL_THICKNESS])
    cylinder(r=ALIGNMENT_TAB_RADIUS, h=ALIGNMENT_TAB_LENGTH);
    translate([0, -ALIGNMENT_TAB_OFFSET, FRONT_WALL_THICKNESS])
    cylinder(r=ALIGNMENT_TAB_RADIUS, h=ALIGNMENT_TAB_LENGTH);

    cylinder(r=MAG_HOLDER_RADIUS + SIDE_WALL_THICKNESS/2 - 0.1, h=FRONT_WALL_THICKNESS + 0.002);
    translate([0,0,FRONT_WALL_THICKNESS/2])
    lock_ring(r=MAG_HOLDER_RADIUS + SIDE_WALL_THICKNESS/2, offset=offset);


}

module front(offset=0) {

    
    difference() {
        union() {
            front_alignment_tabs();
            translate([0, 0, FRONT_WALL_THICKNESS])
            cylinder(d=FRONT_SHAFT_DIAMETER, h=FRONT_SHAFT_LENGTH);
        }
        translate([0, 0, -0.001])
        cylinder(d=SHAFT_DIAMETER + 0.4, h=FRONT_SHAFT_LENGTH + FRONT_WALL_THICKNESS + 0.002);

        // lock ring recess
        translate([0, 0, FRONT_WALL_THICKNESS + LOCK_OFFSET])
        difference() {
            cylinder(d=FRONT_SHAFT_DIAMETER + 0.001, h=LOCK_WIDTH);
            cylinder(d=FRONT_SHAFT_DIAMETER - 1, h=LOCK_WIDTH);
        }
    }

}

module sensor_holder() {

    // small little guide for the sensor
    translate([0,0, REAR_WALL_THICKNESS])
    rotate([0, 0, MAG_ROTATION_OFFSET])
    difference() {

        // overlap cylinder
        cylinder(d = SENSOR_HOLDER_DIAMETER, h = SENSOR_HEIGHT);

        translate([0, 0, -.01])
        rotate([0, 0, 180])
        linear_extrude(height = SENSOR_HEIGHT + 0.02, center = false)
        sensor_profile();
    }

    // base of the holder
    rotate([0, 0, MAG_ROTATION_OFFSET])
    difference() {
        cylinder(r=MAG_HOLDER_RADIUS + SIDE_WALL_THICKNESS, h=REAR_WALL_THICKNESS + FRONT_WALL_THICKNESS + MAG_DIAMETER);
        //translate([0,0, REAR_WALL_THICKNESS + MAG_DIAMETER -0.001])
        //cylinder(r=MAG_HOLDER_RADIUS + SIDE_WALL_THICKNESS/2, h=FRONT_WALL_THICKNESS + 0.002);
        translate([0,0, REAR_WALL_THICKNESS - 0.001])
        cylinder(r=MAG_HOLDER_RADIUS + 0.2, h=MAG_DIAMETER + 0.002);

        translate([0, - (SENSOR_WIDTH / 2), -0.001]) 
        cube([SENSOR_LEAD_DEPTH, SENSOR_WIDTH,REAR_WALL_THICKNESS + 0.002]);

        translate([0,0, REAR_WALL_THICKNESS + MAG_DIAMETER])
        front_alignment_tabs(0.25);

    }

    // lockring
    //translate([0,0, REAR_WALL_THICKNESS + MAG_DIAMETER + FRONT_WALL_THICKNESS / 2])
    //lock_ring(r=MAG_HOLDER_RADIUS + SIDE_WALL_THICKNESS/2);



}



translate([0,0,30 + SHAFT_HEIGHT])
front();

translate([0,0,20])
mag_holder();


sensor_holder();
