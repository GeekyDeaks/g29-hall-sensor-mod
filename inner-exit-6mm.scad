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

include <magnet-holder.scad>;
include <sensor-holder.scad>;


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
sensor_holder_inner_exit();