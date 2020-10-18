
$fn = 60;

difference() {
    
    cylinder( h = 13.5, r = 5.5);

    // hole for the pot spindle
    intersection() {
        
        // create a tapered cylinder 
        hull() {
            translate([0,0,4.9]) cylinder(h = 0.1, r = 3.15);
            cylinder(h = 0.1, r = 3.45);
        }
        translate([-3.45,-0.65,0])
            cube([7,5,5]);
        
    }
    
    // magnet hole
    rotate(a = [90, 0, 0]) translate([0,9.45,-6])  cylinder(h = 12, r = 4);
}

