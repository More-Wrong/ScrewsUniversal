//Copyright 2019 Robert Witts
//This library is licensed under the LGPL 3.0 See http://creativecommons.org/licenses/LGPL/3.0/
include <ScrewsUNC/Internal/ScrewsUNC-core.scad>;
include <ScrewsMetric/Internal/ScrewsMetric-core.scad>;
mm = 1;
inches = 25.4;
Units = mm;
ScrewsUniversal_name = 0;
function Universal(a, b) = a<100?M(a, b):UNC(a, b);

function isValueInScrewsDatabase(a, b) = a<100?isValueInScrewsMetric(a, b):isValueInScrewsUNC(a, b);


function getRodD(a) = a<100?M_getRodD(a):UNC_getRodD(a);

function toMetric(size) = size<100?size:SCREWS_UNIVERSAL_INTERNAL_GetHighDiffMetric(size)<SCREWS_UNIVERSAL_INTERNAL_GetLowDiffMetric(size)?SCREWS_UNIVERSAL_METRIC_EQUIVILENCE_LARGER[size-100]:SCREWS_UNIVERSAL_METRIC_EQUIVILENCE_SMALLER[size-100];

function toUNC(size) = size>=100?size:SCREWS_UNIVERSAL_INTERNAL_GetHighDiffUNC(size)<SCREWS_UNIVERSAL_INTERNAL_GetLowDiffUNC(size)?SCREWS_UNIVERSAL_UNC_EQUIVILENCE_LARGER[size]:SCREWS_UNIVERSAL_UNC_EQUIVILENCE_SMALLER[size];

SCREWS_UNIVERSAL_UNC_EQUIVILENCE_SMALLER = [ScrewsUNC_name, undef, UNC4, UNC6, UNC10, UNC12, UNC5_16, UNC3_8, UNC7_16, UNC2, UNC5, UNC1_2, UNC5_8, UNC3_4, UNC7_8];
SCREWS_UNIVERSAL_UNC_EQUIVILENCE_LARGER = [ScrewsUNC_name, UNC2, UNC5, UNC8, UNC12, UNC1_4, UNC3_8, UNC7_16, UNC1_2, UNC3, UNC6, UNC5_8, UNC3_4, UNC7_8, UNC1inch];

SCREWS_UNIVERSAL_METRIC_EQUIVILENCE_SMALLER = [ScrewsMetric_name, M2, M2_5, M2_5, M3, M3_5, M4, M4, M5, M6, M6, M8, M10, M12, M14, M16, M20, M24];
SCREWS_UNIVERSAL_METRIC_EQUIVILENCE_LARGER   = [ScrewsMetric_name, M2_5, M3, M3, M3_5, M4, M5, M5, M6, M8, M8, M10, M12, M14, M16, M20, M24, undef];


function SCREWS_UNIVERSAL_INTERNAL_GetHighDiffMetric(size) = SCREWS_UNIVERSAL_METRIC_EQUIVILENCE_LARGER[size-100]!=undef?M_getRodD(SCREWS_UNIVERSAL_METRIC_EQUIVILENCE_LARGER[size-100])-UNC_getRodD(size):1000000;
function SCREWS_UNIVERSAL_INTERNAL_GetLowDiffMetric(size) = SCREWS_UNIVERSAL_METRIC_EQUIVILENCE_SMALLER[size-100]!=undef?UNC_getRodD(size)-M_getRodD(SCREWS_UNIVERSAL_METRIC_EQUIVILENCE_SMALLER[size-100]):1000000;

function SCREWS_UNIVERSAL_INTERNAL_GetHighDiffUNC(size) = SCREWS_UNIVERSAL_UNC_EQUIVILENCE_LARGER[size]!=undef?UNC_getRodD(SCREWS_UNIVERSAL_UNC_EQUIVILENCE_LARGER[size])-M_getRodD(size):1000000;
function SCREWS_UNIVERSAL_INTERNAL_GetLowDiffUNC(size) = SCREWS_UNIVERSAL_UNC_EQUIVILENCE_SMALLER[size]!=undef?M_getRodD(size)-UNC_getRodD(SCREWS_UNIVERSAL_UNC_EQUIVILENCE_SMALLER[size]):1000000;


echo("ScrewsUniversal is active, this will provide a set of values for you programmes to use, for creating holes for UNC and Metric parts, such as bolts. By default the system will work in mm, to change this use Units = inches;\n");
echo("The wing nuts in this system are of the american kind, with square ends to the wings, if you are not using these, please be careful, as yours may not fit.\n");

echo("ScrewsUniversal available values: 'ScrewsUniversal_name', 'boltD', 'nutFlatD', 'nutPeakD', 'fullNutH', 'domeNutHexH', 'domeNutTotalH', 'allenBoltHeadD', 'allenBoltHeadH', 'nylocNutH''', 'studdingConnectorNutL', 'squareNutFlatD', 'squareNutPeakD', 'thinSquareNutH', 'hexHeadBoltHeadH', 'hexFlangeHeadH', 'hexHeadFlatD', 'hexHeadPeakD', 'hexFlangeT', 'hexFlangeD', 'allenBoltKeySize', 'allenButtonBoltKeySize', 'allenCountersunkBoltKeySize', 'allenButtonBoltHeadD', 'allenButtonBoltHeadH', 'allenCountersunkBoltHeadD', 'allenCountersunkBoltHeadH' 'squareNutH' 'wingNutBaseH' 'wingNutBaseD' 'wingNutWingT' 'wingNutWingExtension' 'wingNutWingH' \n");
