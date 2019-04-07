//Copyright 2019 Robert Witts
//This library is licensed under the LGPL 3.0 See http://creativecommons.org/licenses/LGPL/3.0/
include<ScrewsUNC/Internal/ScrewsUNC-core-Washers.scad>;
include<ScrewsMetric/Internal/ScrewsMetric-core-Washers.scad>;

function SCREWS_UNIVERSAL_WASHER_FORM_SIZE_CHECK(size, form) = size<100?form<100?true:ScrewsUniversal_size_and_washer_type_combination_invalid___both_must_either_be_metric_or_imperial():form<100?ScrewsUniversal_size_and_washer_type_combination_invalid___both_must_either_be_metric_or_imperial():false;

function ScrewsUniversal_size_and_washer_type_combination_invalid___both_must_either_be_metric_or_imperial() = SG_proceedOnError?undef:ScrewsUniversal_size_and_washer_type_combination_invalid___both_must_either_be_metric_or_imperial();

function WasherDimensions(a, b, c) = SCREWS_UNIVERSAL_WASHER_FORM_SIZE_CHECK(a, b)?M_WasherDimensions(a, b, c):UNC_WasherDimensions(a, b, c);

function isValueInWasherDatabase(a, b, c) = SCREWS_UNIVERSAL_WASHER_FORM_SIZE_CHECK(a, b)?isValueInScrewsMetricWasher(a, b, c):isValueInScrewsUNCWasher(a, b, c);

function getWasherT(a, b) = SCREWS_UNIVERSAL_WASHER_FORM_SIZE_CHECK(a, b)?M_getWasherT(a, b):UNC_getWasherT(a, b);
function getWasherOuterD(a, b) = SCREWS_UNIVERSAL_WASHER_FORM_SIZE_CHECK(a, b)?M_getWasherOuterD(a, b):UNC_getWasherOuterD(a, b);

module Washer(form, size, ERR = 0, hollow = false, VertERR = 0){
   if(SCREWS_UNIVERSAL_WASHER_FORM_SIZE_CHECK(size, form)){
      M_Washer(form, size, ERR, hollow, VertERR);
   } else {
      UNC_Washer(form, size, ERR, hollow, VertERR);
   }
}

function isWasherFormValid(form, size) = form<100?size<100:size>=100;

echo("ScrewsUniversal Washer system loaded: Washer table 1,2,3,4 (3 and 4 in light and heavy), as well as Form A-G available, e.g. washerTable1 or washerFormA\nTo create a washer use Washer(form, size);\nSpecific washers can also be created, but this is not reccomended, e.g. Table1Washer(size);\nTo access values in the database, use WasherDimensions(size, form, value), which contains washerT and washerOuterD\ngetWasherT(size, form) and getWasherOuterD(size, form) are shortcuts to this function\n");
echo("Different types of washer are available for Metric and UNC, and there is no direct compatability, so there will be a error if the combination is not valid. \nThe function isWasherFormValid(form, size) returns true if the washer is possible");
echo(WasherDimensions(washerFormA, M3, 1));