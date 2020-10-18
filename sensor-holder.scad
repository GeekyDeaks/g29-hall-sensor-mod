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
