//Copyright 2019 Robert Witts
//This library is licensed under the LGPL 3.0 See http://creativecommons.org/licenses/LGPL/3.0/
include <ScrewsMetric/Internal/ScrewsMetric-core-BoltSelector.scad>;
include <ScrewsUNC/Internal/ScrewsUNC-core-BoltSelector.scad>;

function isBoltInScrewsSystem(boltType, size) = size<100?isBoltInScrewsMetric(boltType, size):isBoltInScrewsUNC(boltType, size);
function getHeadDiameter(boltType, size) = size<100?M_getHeadDiameter(boltType, size):UNC_getHeadDiameter(boltType, size);
function getHeadHeight(boltType, size) = size<100?M_getHeadHeight(boltType, size):UNC_getHeadHeight(boltType, size);

module BoltOnSurface(boltType, size, length, ERR=0, hollow = false, silent = false){
   if(size<100){
      M_BoltOnSurface(boltType, size, length, ERR, hollow, silent);
   }else{
      UNC_BoltOnSurface(boltType, size, length, ERR, hollow, silent);
   }
}
module BoltFlushWithSurface(boltType, size, length, ERR=0, hollow = false, override = false, silent = false){
   if(size<100){
      M_BoltFlushWithSurface(boltType, size, length, ERR, hollow, override, silent);
   }else{
      UNC_BoltFlushWithSurface(boltType, size, length, ERR, hollow, override, silent);
   }
}
module BoltNormalWithSurface(boltType, size, length, ERR=0, hollow = false, silent = false){
   if(size<100){
      M_BoltNormalWithSurface(boltType, size, length, ERR, hollow, silent);
   }else{
      UNC_BoltNormalWithSurface(boltType, size, length, ERR, hollow, silent);
   }
}
module BoltInHoleFromTop(boltType, size, length, holeDepth, ERR=0, hollow = false, silent = false){
   if(size<100){
      M_BoltInHoleFromTop(boltType, size, length, holeDepth, ERR, hollow, silent);
   }else{
      UNC_BoltInHoleFromTop(boltType, size, length, holeDepth, ERR, hollow, silent);
   }
}
module BoltInHoleFromBottom(boltType, size, length, holeDepth, ERR=0, hollow = false, silent = false){
   if(size<100){
      M_BoltInHoleFromBottom(boltType, size, length, holeDepth, ERR, hollow, silent);
   }else{
      UNC_BoltInHoleFromBottom(boltType, size, length, holeDepth, ERR, hollow, silent);
   }
}
module BoltInHoleFromNormal(boltType, size, length, holeDepth, ERR=0, hollow = false, silent = false){
   if(size<100){
      M_BoltInHoleFromNormal(boltType, size, length, holeDepth, ERR, hollow, silent);
   }else{
      UNC_BoltInHoleFromNormal(boltType, size, length, holeDepth, ERR, hollow, silent);
   }
}
echo("ScrewsUniversal Bolt types: \'allenBolt\' \'allenButtonBolt\' \'allenCountersunkBolt\' \'hexHeadBolt\' \'hexFlangeBolt\' \'hexHeadBoltAllowSpin\'\n");
echo("ScrewsUniversal bolt system utility functions: \'getHeadDiameter\' \'getHeadHeight\'");
echo("ScrewsUniversal bolt system modules:  \'BoltOnSurface\' \'BoltFlushWithSurface\' \'BoltNormalWithSurface\' \'BoltInHoleFromTop\' \'BoltInHoleFromBottom\' \'BoltInHoleFromDefault\' \'BoltInHoleFromNormal\'\n");
