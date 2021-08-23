ABox (
    length = 64, width = 149, height = 28, thickness = 3, frontBackThickness = 3,
    box = true, frontPanel = true, gap = 0.4, holes = false, lighten = true,
    pcb = false, pcbLength = 52, pcbWidth = 130, pcbThickness = 20,
    lockDistance = 40, minHoleWidth = 8
);

/*
ABox (
    length = 50, width = 50, height = 20, thickness = 2, frontBackThickness = 3,
    box = true, frontPanel = true, gap = 0.4, lighten = true,
    pcb = false, pcbLength = 75, pcbWidth = 80, pcbThickness = 1.6
);
*/

module RoundBox(length, width, height, thickness){
    translate([thickness, 0, thickness]) {
        minkowski (){                                              
            cube ([length - 2 * thickness, width - 0.1, height - 2 * thickness], center = false);
            rotate([-90, 0, 0]){
                cylinder(r=thickness, h=0.1, center = false, $fn=180);  
            }
        }
    }
}

module ABox(
    length, width, height, thickness, frontBackThickness,
    box, frontPanel, gap, lighten, holes,
    pcb, pcbLength, pcbWidth, pcbThickness,
    lockDistance, minHoleWidth
){
    
    //trabas
    lockWidth = 8;
    lockHeight = min(8, height - 4 * thickness);
    lockThickness = min(2, thickness);
    lockCount = max(1, floor(width / lockDistance));
    lockSpacing = width / (lockCount + 1);
    drillRadius = 1;
    lockHypotenuse = sqrt(2 * lockThickness * lockThickness);
    frontBackThickness = max(2, frontBackThickness);
    holesLength = length;
    holesWidth = width - 6 * frontBackThickness;
    holeDiameter = min(minHoleWidth, max(width / 5, minHoleWidth));
    holesInLength = floor(holesLength / (1.8 * holeDiameter));
    holesInWidth = floor(holesWidth / (1.8 * holeDiameter));
    echo(holeDiameter, holesInLength, holesInWidth);
    
    if (box){
        //caja
        union(){
            //base
            difference(){
                //caja
                RoundBox(length, width, height, thickness);
                //corte de media caja
                translate([0, 0, height / 2]) cube ([length, width, height / 2], center = false);
                //corte de frente / fondo
                translate([1.5 * frontBackThickness, 0, 1.5 * thickness]) RoundBox(length - 3 * frontBackThickness, width, height - 2 * thickness, thickness);
                //corte interior
                translate([thickness, 3 * frontBackThickness, thickness]) RoundBox(length - 2 * thickness, width - 6 * frontBackThickness, height, thickness);
                //guias de frente / fondo
                translate([thickness, frontBackThickness, thickness]) RoundBox(length - 2 * thickness, frontBackThickness, height, frontBackThickness);
                translate([thickness, width - 2 * frontBackThickness, thickness]) RoundBox(length - 2 * thickness, frontBackThickness, height, frontBackThickness);       
                
                if (lighten){
                    //alivianador de base
                    translate([2.5 * thickness, 3 * frontBackThickness, thickness / 2]) cube ([length - 5 * thickness, width - 6 * frontBackThickness, thickness], center = false);
                    //alivianador de laterales
                    translate([thickness / 2, 3 * frontBackThickness, 2 * thickness]) cube ([thickness / 2, width - 6 * frontBackThickness, height / 2], center = false);
                    translate([length - thickness, 3 * frontBackThickness, 2 * thickness]) cube ([thickness / 2, width - 6 * frontBackThickness, height / 2], center = false);
                }
                //huecos para trabas
                for(lock = [1 : lockCount]){
                    translate([lockThickness / 2, lockSpacing * lock, (height - lockHeight) / 2 + lockHeight / 4]) rotate ([0, 90, 0]) cylinder(r = drillRadius, h = lockThickness, center = true, $fn = 30);
                }
                
                if (holes){
                    for(x = [1 : holesInLength]){  //holesInLength
                        for(y = [1 : holesInWidth]){  //holesInWidth
                            #translate([(length - holesLength) / 2 + holesLength / (holesInLength + 1) * x, (width - holesWidth) / 2 + holesWidth / (holesInWidth + 1) * y, thickness / 2]) //cube([holeDiameter, holeDiameter, thickness], center = true);
                            cylinder(r = holeDiameter / 2, h = thickness, center = true, $fn = 30);
                        }
                    }
                }
            }
            //trabas
            for(lock = [1 : lockCount]){
                translate([length - thickness * (lighten ? 0.5 : 1) - lockThickness, lockSpacing * lock - lockWidth / 2, (height - lockHeight) / 2]){
                    difference(){
                        cube ([lockThickness, lockWidth, lockHeight]);
                        translate([0, 0, - lockThickness]) rotate ([45, 0, 90]) cube([lockWidth, lockHypotenuse, lockHypotenuse]);
                        translate([lockThickness / 2, lockWidth / 2, lockHeight - lockHeight / 4]) rotate ([0, 90, 0]) cylinder(r = drillRadius, h = lockThickness, center = true, $fn = 30);
                        translate([lockThickness - gap, 0, lockHeight / 2]) cube ([gap, lockWidth, lockHeight / 2]);
                    }
                }
            }
            //guias para trabas
            for(lock = [1 : lockCount]){
                translate([thickness * (lighten ? 0.5 : 1), lockSpacing * lock - lockWidth / 2 - 2 - gap, (height - lockHeight) / 2]){
                    difference(){
                        cube ([lockThickness, 2, lockHeight / 2]);
                        translate([lockThickness, 0, - lockThickness]) rotate ([45, 0, 90]) cube([lockWidth, lockHypotenuse, lockHypotenuse]);
                    }
                }
                translate([thickness * (lighten ? 0.5 : 1), lockSpacing * lock + lockWidth / 2 + gap, (height - lockHeight) / 2]){
                    difference(){
                        cube ([lockThickness, 2, lockHeight / 2]);
                        translate([lockThickness, 0, - lockThickness]) rotate ([45, 0, 90]) cube([lockWidth, lockHypotenuse, lockHypotenuse]);
                    }
                }                
            }            
        }
    }
    
    if (frontPanel){
        //frente
        union(){
            translate([thickness + gap, frontBackThickness + gap, thickness + gap]) RoundBox(length - 2 * thickness - 2 * gap, frontBackThickness - 2 * gap, height - 2 * thickness - 2 * gap, frontBackThickness - 2 * gap);
        }
    }

    if (pcb){
        translate([length / 2, width / 2, pcbThickness / 2 + 1 * thickness]) cube ([pcbLength, pcbWidth, pcbThickness], center = true);
    }
}