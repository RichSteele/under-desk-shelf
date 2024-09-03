$fn=100;

size_x = 89;
size_y = 105;
size_z = 122;
cornerRadius = 5;
wallThickness = 2;
ventHoleRadius = cornerRadius / 2;
ventHoleSpacing = 2;
borderWidth = cornerRadius * 2;
mountingHoleRadius = 5.5/2;


difference() {
    hollowBox(size_y, size_x, size_z, cornerRadius);
    sideVents(ventHoleRadius, ventHoleSpacing);
    mountingHoles(mountingHoleRadius);
}

module hollowBox(length, width, height, radius) {
    difference() {
        roundedBox(length, width, height, radius); 
        translate([wallThickness, wallThickness,-wallThickness]) {
            roundedBox(length-(wallThickness*2), width-(wallThickness*2), height+(wallThickness*2), radius); 
        }
    }
}

module roundedBox(length, width, height, cornerRadius) {
    dRadius = 2*cornerRadius;
    translate([cornerRadius,cornerRadius,0]) minkowski() {
        cube(size=[width-dRadius,length-dRadius, height]);
        cylinder(r=cornerRadius, h=0.01);
    }
}

module sideVents(radius, spacing) {
    difference() {
        ventHoles(size_x, size_z, size_y, radius, spacing);
        holeBorder(borderWidth);
    }
}

// create the pattern of vent holes on two oppsite sides of the box
module ventHoles(area_length, area_height, area_depth, radius, spacing) {
    inc = radius+spacing*2;
    for (j = [0:inc:size_z], i = [0:inc:size_x])     
        translate([i,0,j]) ventHole(radius, area_depth);
}

module ventHole(radius, length) {
    translate([radius,-1,radius])
    rotate([-90,0,0]) cylinder(h = length + 2, r = radius);
}

// creates the border around the vent holes so they don't intersect the edges
module holeBorder(mask_extent) {
    externalWidth = size_x + mask_extent;
    externalLength = size_y + mask_extent;
    externalHeight = size_z + mask_extent;
    
    internalWidth = size_x - mask_extent;
    internalLength = externalLength + 2;
    internalHeight = size_z - mask_extent;
    
    difference() {
        cube([externalWidth,externalLength,externalHeight]);
        
        translate([mask_extent/2,-1,mask_extent/2])
        cube([internalWidth,internalLength,internalHeight]);
    }
}

module mountingHoles(radius) {
    side_offset = 20;
    
    translate([0,side_offset,side_offset]) screwAndAccessHole(radius);
    translate([0,size_y-side_offset,side_offset]) screwAndAccessHole(radius);
    translate([0,size_y-side_offset,size_z-side_offset]) screwAndAccessHole(radius);
    translate([0,side_offset,size_z-side_offset]) screwAndAccessHole(radius);
}

module screwAndAccessHole(screwRadius) {
    translate([-wallThickness,0,0]) rotate([0,90,0])
    cylinder(h = wallThickness*3, r = screwRadius);
    
    translate([size_x-(wallThickness*2),0,0]) rotate([0,90,0])
    cylinder(h = wallThickness * 3, r = screwRadius * 3);
}
