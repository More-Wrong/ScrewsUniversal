//Copyright 2019Robert Witts
//This library is licensed under the LGPL 3.0 See http://creativecommons.org/licenses/LGPL/3.0/
include <ScrewsUniversal/ScrewsUniversal.scad>;
H = 15;
W = 40;
L = 20;
boltSize1 = M5;
boltSize2 = UNC1_4;
boltType = allenBolt;

nutType = fullNut;

washerForm1 = washerFormA;
washerForm2 = washerTable3Light;

$fn = 100;
GHOST = true;


module demo1(){
   difference(){
      cube([L, W, H]);
      translate([L/2, W/4, H+0.001])BoltNormalWithSurface(boltType, boltSize1, H+0.002);
      translate([L/2, W*3/4, H+0.001])BoltNormalWithSurface(boltType, boltSize2, H+0.002);
   }
}
module demo2(){
   difference(){
      cube([L, W, H]);
      translate([L/2, W/4, H+0.001])BoltNormalWithSurface(boltType, boltSize1, H+0.002);
      translate([L/2, W/4, getNutSideH(nutType, boltSize1)-0.001])rotate([180, 0, 0])Nut(nutType, boltSize1);
      translate([L/2, W*3/4, H+0.001])BoltNormalWithSurface(boltType, boltSize1, H+0.002);
      translate([L/2, W*3/4, getNutSideH(nutType, boltSize1)-0.001])rotate([180, 0, 0])Nut(nutType, boltSize1);
   }
}
module demo3(){
   difference(){
      cube([L, W, H]);
      translate([-0.001, W/4, H/2])rotate([0, -90, 0])BoltOnSurface(boltType, boltSize1, L+0.002);
      translate([L/2-getNutH(nutType, boltSize1)/2, W/4, H/2])rotate([0, 90, 0])NutHole(nutType, boltSize1, H/2+0.001);
      translate([-0.001, W/4, H/2])rotate([0, 90, 0])Washer(washerForm1, boltSize1);
      translate([-0.001, W*3/4, H/2])rotate([0, -90, 0])BoltOnSurface(boltType, boltSize2, L+0.002);
      translate([L/2-getNutH(nutType, boltSize2)/2, W*3/4, H/2])rotate([0, 90, 0])NutHole(nutType, boltSize2, H/2+0.001);
      translate([-0.001, W*3/4, H/2])rotate([0, 90, 0])Washer(washerForm2, boltSize2);
   }
}
//For demo 3, if you get the error: 
//ERROR: Recursion detected calling function 'ScrewsUniversal_size_and_washer_type_combination_invalid___both_must_either_be_metric_or_imperial' 
//it means the washer type and the bolt size choosen are incompatable. This is because metric washers can only be used in metric sizes, and similar for imperial. To fix it, try changing the washerForm variables.

//if you get the error: 
//ERROR: Recursion detected calling function 'ScrewsUNC_washer_dimension_not_found___Try_another_type'
//while using imperial bolts and washers, it may mean that the washer type you are using is incompatable with the size, as Table 1 and 2 washers are only available for the numeric sizes, while 3 and 4 are not.

demo3();