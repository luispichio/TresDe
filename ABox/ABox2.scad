ABox2(
    length = 85, width = 45, height = 25, thickness = 2,
    box = true, cap = true, chargeHole = false, foot = false, window = false,
    windowLength = 60, windowWidth = 55,
    gap = 0.4, holes = false, lighten = true,
    screwTowerDiameter = 7, screwDiameter = 2.5
);

module ABox2(
    length, width, height, thickness,
    box, cap, chargeHole, foot, window,
    windowLength, windowWidth,
    gap, holes, lighten,
    screwTowerDiameter, screwDiameter,
){
    holes = [
        [thickness + screwTowerDiameter / 2 - gap, thickness + screwTowerDiameter / 2 - gap, 0],
        [thickness + screwTowerDiameter / 2 - gap, width - thickness - screwTowerDiameter / 2 + gap, 0],
        //[length / 2, width - thickness - screwTowerDiameter / 2 + gap, 0],
        [length - screwTowerDiameter / 2 + gap - thickness, thickness + screwTowerDiameter / 2 - gap, 0],
        [length - screwTowerDiameter / 2 + gap - thickness, width - thickness - screwTowerDiameter / 2 + gap, 0],
        //[length / 2, thickness + screwTowerDiameter / 2 - gap, 0],
    ];    
    if (box){
        union(){
            difference(){
                cube ([length, width, height], center = false);
                translate([thickness, thickness, thickness]) cube ([length - 2 * thickness, width - 2 * thickness, height], center = false);
                translate([thickness, thickness, thickness]) cube ([length - 2 * thickness, width - 2 * thickness, height], center = false);
                if (window){
                    translate([(length - windowLength) / 2, (width - windowWidth) / 2, 0]) cube ([windowLength, windowWidth, thickness], center = false);
                }
            }
            for (hole = holes)
                translate(hole) Tube(screwTowerDiameter, screwDiameter, height - thickness);
        }
    }
    if (cap){
        union(){
            difference(){
                translate([thickness + gap, thickness + gap, 2 * height]) cube ([length - 2 * (thickness + gap), width - 2 * (thickness + gap), thickness - gap], center = false);
                for (hole = holes)
                    translate(hole) translate([0, 0, 2 * height]) cylinder(r = screwDiameter / 2, thickness - gap, center = false, $fn = 30);
                if (chargeHole)
                    translate([length / 2, width - thickness - 15, 2 * height]) cylinder(d = 15, thickness - gap, $fn = 30);
                for (i = [-2:2])
                    translate([length / 2 - 6 * i - 1, 10, 2 * height]) cube([2, width / 2, thickness - gap]);
            }
            if (foot){
                difference(){
                    union(){
                        translate([10 + thickness + gap, width / 2 + thickness + gap, 2 * height + thickness - gap]) rotate([90, 0, 180]) rotate([0, 90, 0]) linear_extrude(height = 10) polygon(points = [[0, 0], [0, width / 2], [width / 2, 0]]);
                        translate([length - gap - thickness, width / 2 + thickness + gap, 2 * height + thickness - gap]) rotate([90, 0, 180]) rotate([0, 90, 0]) linear_extrude(height = 10) polygon(points = [[0, 0], [0, width / 2], [width / 2, 0]]);
                    }
                    for (hole = holes)
                        translate(hole) translate([0, 0, 2 * height + thickness - gap]) cylinder(r = 1.3 * screwDiameter / 2, h = height, center = false, $fn = 30);
                    translate([5 + thickness, width / 2, 2 * height + width / 2]) cube([20, 10, 10], center = true);
                    translate([length - 10 + thickness, width / 2, 2 * height + width / 2]) cube([20, 10, 10], center = true);
                    #translate([0, width / 2 - 8, 2 * height + 8 + 2 * thickness]) rotate([0, 90, 0]) rotate([0, 0, 60]) cylinder(d = 16, length, $fn = 30);
                }
            }
            if (chargeHole)
                translate([length / 2, width - thickness - 15, 2 * height])
                    difference(){
                        cylinder(d = 15, 10, $fn = 30);
                        cylinder(d = 12, 7, $fn = 30);
                        cylinder(d = 8, 10, $fn = 30);
                    }
            
        }
    }
}

module Tube(outerDiameter, innerDiameter, height){
    difference(){
        cylinder(r = outerDiameter / 2, h = height, center = false, $fn = 30);
        cylinder(r = innerDiameter / 2, h = height, center = false, $fn = 30);
    }
}