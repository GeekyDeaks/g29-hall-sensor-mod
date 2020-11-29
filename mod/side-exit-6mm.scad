$fn = 50;

PART = "explode";

MAG_DIAMETER = 6.15;
MAG_HEIGHT = 3;
MAG_DISTANCE = 3.5;  // distance of magnet from the sensor centre

ASSEMBLY_WIDTH = 22; // width of the assembly up to the flange

SENSOR_OFFSET = 9; // where the midpoint of the sensor will sit from the base of the magnet holder
SENSOR_HOLE_DIAMETER = 5.5;
SENSOR_WIDTH = 4.4;  // physical outer dimensions of the sensor
SENSOR_HEIGHT = 3;
SENSOR_DEPTH = 1.6;
SENSOR_FRONT_DEPTH = 0.79; // distance from front face to pins
SENSOR_LEAD_LENGTH = 9;
SENSOR_LEAD_DEPTH = SENSOR_DEPTH - SENSOR_FRONT_DEPTH;

SENSOR_HOLDER_DIAMETER = 15;
SENSOR_HOLDER_FLANGE_DIAMETER = 20; // bit outside the base
SENSOR_HOLDER_FLANGE_WIDTH = 4;

BASE_HOLE_DIAMETER = 16.15;
BASE_INTERFERENCE_WIDTH = 3.5;

OVERLAP_DIAMETER = 7.7;

MAG_HOLDER_DIAMETER = (MAG_HEIGHT + MAG_DISTANCE) * 2;
MAG_HOLDER_LENGTH = 14;
MAG_ROTATION_OFFSET = 90;

POT_SHAFT_HEIGHT = 5;
POT_SHAFT_DIAMETER = 6.4;
POT_SHAFT_RECESS = 2.6;

HOLDER_OVERLAP = MAG_HOLDER_LENGTH - SENSOR_OFFSET - (SENSOR_HEIGHT / 2);

CONN_WIDTH = 7.6;
CONN_DEPTH = 2.6;
CONN_LENGTH = ASSEMBLY_WIDTH - SENSOR_LEAD_LENGTH - MAG_HOLDER_LENGTH + SENSOR_HOLDER_FLANGE_WIDTH + HOLDER_OVERLAP;

include <magnet-holder.scad>;
include <sensor-holder.scad>;

module sensor_holder_side_exit() {

    difference() {
        sensor_holder_body();

        // hole for leads
        // offset hole for leads a little to help centre the sensor
        translate([- (SENSOR_WIDTH / 2), 0, -0.1]) 
        cube([SENSOR_WIDTH, SENSOR_LEAD_DEPTH, (SENSOR_LEAD_LENGTH / 2) + 0.2]);
        hull() {
            translate([- (SENSOR_WIDTH / 2), 0, SENSOR_LEAD_LENGTH / 2]) 
            cube([SENSOR_WIDTH, SENSOR_LEAD_DEPTH, .1]);
            
            // hole for the connector
            translate([- CONN_WIDTH / 2, - CONN_DEPTH / 2, SENSOR_LEAD_LENGTH]) 
            cube([ CONN_WIDTH, CONN_DEPTH, CONN_LENGTH  ]);
        }
    }

}

if(PART == "explode") {
    mag_holder();
    translate([0, 0, MAG_HOLDER_LENGTH + HOLDER_OVERLAP * 2])
    sensor_holder_side_exit();
}

if(PART == "mag") mag_holder();
if(PART == "sensor") mag_holder();

