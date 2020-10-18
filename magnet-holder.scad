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