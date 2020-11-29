$fn = 50;

MAG_DIAMETER = 6.15;
MAG_HEIGHT = 3;
MAG_DISTANCE = 3.8;  // distance of magnet from the sensor centre

ASSEMBLY_WIDTH = 22; // width of the assembly up to the flange

SENSOR_OFFSET = 7.5; // where the midpoint of the sensor will sit from the base of the magnet holder
SENSOR_HOLE_DIAMETER = 5.5;
SENSOR_WIDTH = 4.4;  // physical outer dimensions of the sensor
SENSOR_HEIGHT = 3;
SENSOR_DEPTH = 1.6;
SENSOR_FRONT_DEPTH = 0.85; // distance from front face to pins
SENSOR_LEAD_LENGTH = 9;
SENSOR_LEAD_DEPTH = SENSOR_DEPTH - SENSOR_FRONT_DEPTH;

SENSOR_HOLDER_DIAMETER = 15.5;
SENSOR_HOLDER_FLANGE_DIAMETER = 20; // bit outside the base
SENSOR_HOLDER_FLANGE_WIDTH = 4;

BASE_HOLE_DIAMETER = 16.15;
BASE_INTERFERENCE_WIDTH = 3.5;

OVERLAP_DIAMETER = 7.7;

MAG_HOLDER_DIAMETER = (MAG_HEIGHT + MAG_DISTANCE) * 2;
MAG_HOLDER_LENGTH = 11;
MAG_ROTATION_OFFSET = 100;

POT_SHAFT_HEIGHT = 5;
POT_SHAFT_DIAMETER = 6.4;
POT_SHAFT_RECESS = 2.6;

HOLDER_OVERLAP = MAG_HOLDER_LENGTH - SENSOR_OFFSET + (SENSOR_HEIGHT / 2);

CONN_WIDTH = 7.6;
CONN_PIN_WIDTH = 5.5; // distance between the outer two pins
CONN_DEPTH = 2.6;
CONN_LENGTH = ASSEMBLY_WIDTH - SENSOR_LEAD_LENGTH - MAG_HOLDER_LENGTH + SENSOR_HOLDER_FLANGE_WIDTH + HOLDER_OVERLAP;

include <magnet-holder.scad>;
include <sensor-holder.scad>;


SPLIT_POINT = 8;
DOWEL_DIAMETER = 3;
DOWEL_DEPTH = 2.75;

module upper() {

    difference() {
        intersection() {
            sensor_holder_body();
            translate([0, 0, -SENSOR_HEIGHT])
            cylinder(d = SENSOR_HOLDER_FLANGE_DIAMETER + 0.1, h = SPLIT_POINT + SENSOR_HEIGHT);
        }
        // hole for leads
        // offset hole for leads a little to help centre the sensor
        translate([- (SENSOR_WIDTH / 2), 0, -0.1])
        cube([SENSOR_WIDTH, SENSOR_LEAD_DEPTH, SPLIT_POINT + 0.2]);

        // hole for the connector
        translate([- (CONN_WIDTH / 2), SENSOR_HOLDER_DIAMETER / 5, SPLIT_POINT - CONN_DEPTH / 2 ])
        cube([CONN_WIDTH, SENSOR_HOLDER_DIAMETER / 2, CONN_DEPTH / 2 + 0.1]);

        // recess for leads to be pinched
        translate([0, 0, SPLIT_POINT - 0.3])
        hull() {
            translate([- (SENSOR_WIDTH / 2), 0, 0])
            cube([SENSOR_WIDTH, SENSOR_LEAD_DEPTH, 0.4]);
            
            translate([- (CONN_PIN_WIDTH / 2), SENSOR_HOLDER_DIAMETER / 5, 0])
            cube([CONN_PIN_WIDTH, SENSOR_HOLDER_DIAMETER / 2, 0.4]);
        }

        // dowel holes
        translate([SENSOR_HOLDER_DIAMETER / 2 - DOWEL_DIAMETER, 0, SPLIT_POINT - DOWEL_DEPTH - 0.1])
        cylinder(d = DOWEL_DIAMETER + 0.2, h = DOWEL_DEPTH + 0.2);

        translate([-SENSOR_HOLDER_DIAMETER / 2 + DOWEL_DIAMETER, 0, SPLIT_POINT - DOWEL_DEPTH - 0.1])
        cylinder(d = DOWEL_DIAMETER + 0.2, h = DOWEL_DEPTH + 0.2);

        
    }

    // dowels
    *translate([SENSOR_HOLDER_DIAMETER / 2 - DOWEL_DIAMETER, 0, SPLIT_POINT])
    cylinder(d = DOWEL_DIAMETER - 0.3, h = DOWEL_DEPTH - 0.3);


    *translate([-SENSOR_HOLDER_DIAMETER / 2 + DOWEL_DIAMETER, 0, SPLIT_POINT])
    cylinder(d = DOWEL_DIAMETER - 0.3, h = DOWEL_DEPTH - 0.3);


}

module lower() {
    difference() {
        intersection() {
            sensor_holder_body();
            translate([0, 0, SPLIT_POINT])
            cylinder(d = SENSOR_HOLDER_FLANGE_DIAMETER + 0.1, h = ASSEMBLY_WIDTH);

        }
        // dowel holes
        *translate([SENSOR_HOLDER_DIAMETER / 2 - DOWEL_DIAMETER, 0, SPLIT_POINT - 0.1])
        cylinder(d = DOWEL_DIAMETER + 0.2, h = DOWEL_DEPTH + 0.2);

        *translate([-SENSOR_HOLDER_DIAMETER / 2 + DOWEL_DIAMETER, 0, SPLIT_POINT - 0.1])
        cylinder(d = DOWEL_DIAMETER + 0.2, h = DOWEL_DEPTH + 0.2);

        // connection lower hole
        translate([0, 0, SPLIT_POINT - 0.1])
        translate([- (CONN_WIDTH / 2), SENSOR_HOLDER_DIAMETER / 5, 0])
        cube([CONN_WIDTH, SENSOR_HOLDER_DIAMETER / 2, CONN_DEPTH / 2 + 0.1]);

    }

    // dowels
    translate([SENSOR_HOLDER_DIAMETER / 2 - DOWEL_DIAMETER, 0, SPLIT_POINT - DOWEL_DEPTH + 0.3])
    cylinder(d1 = DOWEL_DIAMETER - 0.25, d2 = DOWEL_DIAMETER - 0.15, h = DOWEL_DEPTH);

    translate([-SENSOR_HOLDER_DIAMETER / 2 + DOWEL_DIAMETER, 0, SPLIT_POINT - DOWEL_DEPTH + 0.3])
    cylinder(d1 = DOWEL_DIAMETER - 0.25, d2 = DOWEL_DIAMETER - 0.15, h = DOWEL_DEPTH);

}

if(PART == "explode") {
    mag_holder();
    translate([0, 0, MAG_HOLDER_LENGTH * 2])
    upper();
    translate([0, 0, MAG_HOLDER_LENGTH * 3])
    lower();
}

if(PART == "mag") mag_holder();
if(PART == "lower") lower();
if(PART == "upper") upper();