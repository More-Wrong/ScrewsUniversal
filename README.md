ScrewsUniversal
============

## What is it?

ScrewsUniversal is a OpenSCAD library combining the functions of both ScrewsMetric and ScrewsUNC, it allows the use of both UNC and Metric bolts, and is designed to allow other systems to added in future. 
It contains little individual code, but instead changes the access functions, so they can switch between the different systems.
The variables, functions and modules used to access the system are the same as in ScrewsMetric, and ScrewsUNC, so it should be possible to simply switch ScrewsUniversal in instead of either of the others.

## Getting started

In order for this library to work, both ScrewsMetric and ScrewsUNC must be installed, as described in the Installation section in their README files, for completeness the Installation section below holds the instructions for Installing them too.
If you not want to add ScrewsMetric and ScrewsUNC to your OpenSCAD library folder, you can instead add them to the Internal directory underneath ScrewsUniversal, and this should also work, but will not allow you to access them individually.

There are three demo files, one demonstrating pure Metric functionality, which is an exact clone of the demo file from ScrewsMetric, called `ScrewsMetric-Demo.scad`.
There is another demonstrating pure UNC functionality, which is an exact clone of the demo file from ScrewsUNC, called `ScrewsUNC-Demo.scad`.
The third demonstrates the combination, with both Metric and UNC parts, called `ScrewsUniversal-Demo.scad`.
These files hold simple demonstrations, showing simple functionality and parameterisation.
Try changing the variables, for example change the size of the bolt to `M8` or the bolt type to `allenButtonBolt`


### Installation

These installations rely on the library system in OpenSCAD.
Details of how the library system works, and where it is located can be found in the Openscad user manual: `https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Libraries`


To install ScrewsMetric and ScrewsUNC, simply move the entire ScrewsMetric folder from ScrewsMetric, and the entire ScrewsUNC folder from ScrewsUNC into the library folder, the folders to be moved are in the same directory as the README.

After this, to install ScrewsUniversal, move the ScrewsUniversal folder, from the directory containing the README into you library.


To include the system into any Openscad code, simply use:

    include <ScrewsUniversal/ScrewsUniversal.scad>;

The optional libraries can be included similarly:

    include <ScrewsUniversal/Optional-Bearings.scad>;
    include <ScrewsUniversal/Optional-Frames.scad>;
    include <ScrewsUniversal/Optional-Rails.scad>;
    include <ScrewsUniversal/Optional-Steppers.scad>;

It is important to include the files first, as they may otherwise override your own configuration.

ScrewsMetric or ScrewsUNC can be included using:

    include <ScrewsMetric/ScrewsMetric.scad>;

or

    include <ScrewsUNC/ScrewsUNC.scad>;

DO NOT USE BOTH AT ONCE, THEY WILL NOT WORK TOGETHER.

## Things to be careful of

ScrewsUniversal attempts to imitate ScrewsMetric and ScrewsUNC entirely, however there are some circumstaces it cannot deal with.
These problems could be averted, but doing so would make it difficult to tell what the program is actualy, e.g. converting one type of washer into another. Instead the program throws an error.

The section which causes most problems is the washer system. This is because different kinds of washers are available for metric and imperial, metric has forms A-G, and imperial has table 1-4.
If an invalid combination of washer form and size is requested (either metric form, imperial size or imperial form, metric size) this error will be thrown:

    ERROR: Recursion detected calling function 'ScrewsUniversal_size_and_washer_type_combination_invalid___both_must_either_be_metric_or_imperial' 

This is not a recursion error, but there is no other way of throwing errors inside functions.
If you use `SG_proceedOnError = true;` the system will not throw this kind of error, it will either return `undef` or not do anything. This is not recommended, as parts may silently disappear, or be misplaced, without you knowing.

The optional bearings system works in entirely metric bearings, so while it will try to match imperial size, it will always be somewhat out.
The optional rails system works with MGN type rails, which use metric sizes, so it will always try to use metric bolts, and the parts will not fit if imperial bolts are used.
The optional steppers system works with NEMA stepper motors, which use metric sizes, so it will always try to use metric bolts, and the parts will not fit if imperial bolts are used.

The function `toMetric(size)` will provide closest metric size to a given UNC size (if given a metric size, it will not change it).
The function `toUNC(size)` will provide closest UNC size to a given metric size (if given a UNC size, it will not change it).

The metric sizes are:
`M2` `M2_5` `M3` `M3_5` `M4` `M5` `M6` `M8` `M10` `M12` `M14` `M16` `M20` `M24`
(2_5 means 2.5, but openscad does not support this as a variable name for obvious reasons)

The UNC sizes are somewhat more complex, there are two types of size: numeric and non-numeric.
Numeric sizes represent smaller bolts, and are of the form `UNC12` with the relevant number.
Non-Numeric sizes are larger, and referenced in fractions of an inch, however 1/4" does not work as a variable name, so instead `UNC1_4` is used.
The 1" size is represented as `UNC1inch` to avoid confusion with numeric size 1.

The UNC sizes are: `UNC2` `UNC3` `UNC4` `UNC5` `UNC6` `UNC8` `UNC10` `UNC12`
`UNC1_4` `UNC5_16` `UNC3_8` `UNC7_16` `UNC1_2` `UNC5_8` `UNC3_4` `UNC7_8` `UNC1inch`


If you are already aware of how ScrewsMetric or ScrewsUNC works, reading below here is unnecessary.

## Usage

ScrewsUniversal is intended to allow more easily parametrised designs, 
where a single variable can be declared for the size of the bolts to be used, 
and a single change can change many things, including the head insets etc.

ScrewsUniversal has roughly three layers, the *database*, the *modules* and the *selectors*. 
It is highly recommended that you use the selectors, 
as these can provide an interface onto any of the other parts, 
are more flexible in their usage and provide better comparability with ScrewsMetric and ScrewsUNC.
The Nut and Bolt selectors should switch between UNC and Metric with no extra work.

All things created by the system are designed as negatives (unless using `hollow = true`) to be taken out of an object.

The database provides basic values, and is accessed using the `Universal()` function, giving it first the size, and then the dimension required, e.g. `Universal(M5, nutPeakD)`

The modules attempt to model one thing each, such as a particular kind of nut or bolt, e.g.

    AllenButtonBolt(M8, length = 20);

The selectors allow switching between one type of bolt and another, e.g.

    BoltFlushWithSurface(allenBolt, M8, length = 20);
vs

    BoltFlushWithSurface(allenButtonBolt, M8, length = 20);

The selectors all have information retrieval functions, which will return the value for that size and type of thing, 
e.g. `echo(getHeadDiameter(allenBolt, UNC12));` which will return the same as: `echo(M(UNC12, allenBoltHeadD));` 
but allows the bolt type to change more easily.


The values used are designed to be used in variables, e.g.

    myBoltSize = M3;
    myBoltType = allenBolt

    BoltNormalWithSurface(myBoltType, myBoltSize, length = 20);

If the database does not contain a value, it will throw an error, such as

    ERROR: Recursion detected calling function 'ScrewsMetric_value_does_not_exist___Try_another_size_of_bolt' 

or

    ERROR: Recursion detected calling function 'ScrewsUNC_value_does_not_exist___Try_another_size_of_bolt' 

if the requested value is UNC.
This is not a recursion error, but is the only way to throw errors within functions.
To disable this, set `SG_proceedOnError = true;` however this is not recommended, as it can make errors hard to trace, and may mean you do not notice them, meaning a bolt may silently disappear.

All the sections of ScrewsUniversal try to provide as much information as possible through echo statements, so all the values you might need should be present.

In order to get the diameter of a shaft, use `getRodD(M3)` rather than `Universal(M3, boltD)` as this makes it more compatible with ScrewsMetric and ScrewsUNC.

If parts do not fit correctly, try using the `ERR` value found in most functions, 
it enlarges the holes, make it negative to make the holes smaller. 
It is recommended that you use any system in your slicer instead, such as 'horizontal expansion' in cura

The `Units` variable can be set to `mm` or `inches`: changing this scales the results given by all modules and functions into the specified unit.

To activate the system for rendering ScrewsUniversal components, use

    GHOST = true;

The washer system is slightly separate, but the access methods are similar, 
for high level access use `Washer(form, size)`, e.g. `Washer(washerFormG, M10)` or `Washer(washerTable3Light, UNC1_4)`. 
The form can be A-G (e.g. `washerFormA`) if the size is metric, or Table 1-4 (table 3 and 4 in light or heavy) if the size is UNC.
The functions `getWasherT(form, size)` and `getWasherOuterD(form, size)` provide high level access to the databases.

The UNC washer system is somewhat more complex, as table 1 and 2 are only available in the numeric sizes, whereas table 3 and 4 are available only in non numeric sizes.

## Bearings, Steppers, Rails and Frames

These sections are not included in ScrewsUniversal by default, as they are somewhat independent, while they use the system, they primarily use their own internal database.
This is because the things they model do not fit within normal metric sizes, so inserting them into the main array would be messy and difficult.

### Bearings

The Bearing system supports multiple forms of bearings, e.g. 624 vs 604

To use it, either ask for a specific bearing, using `BearingType()` and giving it the specific bearing, e.g. 

    BearingType(605_bearing);

Or ask it for a bearing for a particular size, specifying the series, e.g. 

    BearingFromDiam(4, 620_seriesBearings);

It also supports ScrewsMetric sizes as an argument, e.g.

    BearingFromSize(M8, 620_seriesBearings);

To do this it searches for a bearing that will fit the rod size provided, it will notify you if the bearing might not fit correctly, due to being too large, as not all bearing sizes exist.
If not given a series it will default to the 600 series.
The bearing system supports `600`, `620`, `630` and `670` series for metric, and `KLNJ` and `LJ` bearings for imperial, in various sizes.
Metric bearings come in 3, 4, 5, 6, 7, 8, 9, 10, 12, 15, 17, 20, 25 and 30mm internal diameters, 
whereas the imperial come in 1/8", 3/16", 1/4", 3/8", 1/2", 5/8", 3/4", 7/8", and 1" sizes (although the LJ series only has 1/2", 5/8", 3/4", 7/8" and 1").

### Steppers

This system has a database on all the basic *NEMA* stepper motors (08, 11, 14, 17, 23, 24, 34 and 42)
The `Nema24` is unreliable, as there is no agreed standard other than 'slightly bigger than NEMA 23'
The *NEMA* standard is specified with metric sizes, so it will always try to use metric sizes, and imperial bolts might not fit.
To get plain information from it use `stepperStats()`, e.g. 

    stepperStats(Nema08, stepperWidth)

To get the positions of the bolts use `getStepperBoltPositions()`, e.g. `getStepperBoltPositions(Nema42)`
This will return an array of the locations of the bolts relative to the top corner of the stepper, e.g.

    for(i = getStepperBoltPositions(Nema11)){
       translate(i)Rod(M2, 5);
    }

The stepper system can cut holes for steppers, and render them, using `stepper()` 
this will try to give a reasonable value for the length of the stepper, 
but as steppers can be almost any length, it can be passed as a parameter. 
The shaft length can also be passed, but if no value is given, a reasonable number will be chosen. 

The `orientation` parameter is where to render the wires, if left, no wires are rendered, but values `0`, `1`, `2` and `3` will give the four sides.

The `dualShaft` parameter is a boolean, if set to true, it will render the stepper with a shaft coming out both ends.
e.g.

    stepper(Nema11);
    stepper(Nema17, 40, 10, 2, true);
    stepper(Nema23, orientation = 2);

### Rails

This system has a database on all the basic MGN linear Rails (MGN-7, MGN-9, MGN-12, MGN-15, MGW-7, MGW-9, MGW-12, MGW-15)
MGN linear Rails are specified with metric sizes, so it will always try to use metric sizes, and imperial bolts might not fit.
To simply obtain information from the database, use `railDimensions()`, e.g.

    railDimensions(MGN_7, linearRailAssemblyTotalHeight)

To get the closest rail length possible to a certain length, use `getActualRailLength()`, e.g.`getActualRailLength(MGN_7, 200)`, this rounds the length up. This is performed automatically on any lengths given.

To get the positions of the bolts for the block, use `getRailBlockBoltPositions()`, e.g. `getRailBlockBoltPositions(MGN_7, linearRailHForm)`

To get the positions of the bolts for the rail, use `getRailBoltPositions()`, e.g. `getRailBoltPositions(MGN_7, 200, 2)`, where the 200 is the length of the rail, and the two is the number of bolts wanted at each end.

There exist three modules which translate any children they are given to the positions of bolts required for the rails or blocks:

 - `railBoltPositionsTranslate` which translates to the positions, given the same parameters as the function. This mirrors the children if there are dual bolts, such as on the MGW-15 rails.
 - `railBlockBoltPositionsTranslate` which translates to the positions of the bolts on the block.
 - `railBlockBoltPositionsTranslateMirroring` which translates to the positions, but mirrors the children so as to attempt to preserve rotational information in a reasonable way.

e.g.

    railBlockBoltPositionsTranslateMirroring(MGN_15)cube([1, 10, 1]);

vs


    railBlockBoltPositionsTranslate(MGN_15)cube([1, 10, 1]);

they also work on groups of objects

    railBlockBoltPositionsTranslate(MGN_12){
       cube([1, 10, 1]);
       cylinder(r = 2, h = 3);
    }

To cut the gap required for a rail to fit, use `rail()`, e.g. `rail(MGW_7);`
`position` is the location of the block if it is to be rendered, it only affects the rendering, not the physical part. 
`cutBlockHole` sets whether to include the space the block requires to move freely in the part, enabled by default.
To cut the hole underneath a part for a block to fit, use `railBlock()`, e.g. `railBlock(MGW_9, linearRailHForm);`
`slowMode` in this context, if set to true as a parameter, will render the ball bearings used inside the block, this impacts performance so is disabled by default.

### Frames

This is system to create nice-looking frames, these are meant to bolt on to surfaces. 
These are meant to remove similar code for creating mountings. 

#### General modules

The `frames_curveToSlope()` is an internal module, creating a quarter of a stretched circle to the given dimensions.

The `minimalBridge()` module creates a bridge between two cylinders, with a curve to minimise plastic use, which exactly matches the two cylinders at either end.

Its full parameter list is very long:
`minimalBridge(minW, h= undef, h1 = undef, h2 = undef, d = undef, r = undef, d1 = undef, d2 = undef, r1 = undef, r2 = undef, sep = undef, l = undef, l1 = undef, l2 = undef, speed = 1, $fn = 500, hRoundfn = 100);`

These parameters are designed to mimic that of `cylinder()` in that only one of several different ways to specify each feature need be used, 
it is recommended to use `h = 5` rather than using the ordering of the parameters.

The `minW` parameter specifies the narrowest width of the bridge. If this is smaller than either diameter, the module will simply `hull()` the two cylinders.
These are the different kinds of parameters:

##### Diameters
 - `d` the simplest way, specifies the diameter of both cylinders.
 - `r` also very simple, specifies the radius of both cylinders.
 - `d1`, `d2` specifies the diameter of cylinder 1 and 2 respectively: must be used together
 - `r1`, `r2` specifies the radius of cylinder 1 and 2 respectively: must be used together

##### Heights
 - `h` the simplest way, specifies the height of both cylinders
 - `h1`, `h2` specifies the heights of cylinder 1 and 2 respectively: must be used together

If the heights are different, some method of joining the cylinders can be used. The method used is specified by the speed parameter, 
which specifies how performance intensive an operation should be used. Each value has different effects:
 - 2 simply makes one taller than other, no joining performed, is the default.
 - 1 hulls the two cylinders, while preserving bridge shape, looks alright, depending on circumstance, can look weird.
 - 0 creates a rotational extrude of an inverted curve, very pretty, very performance intensive.

##### Separation/Location
There are different ways of controlling the location of the two cylinders (only in 2D space) 
 - `sep` This specifies the separation, cylinder 1 at `[0, 0]`, cylinder 2 at `[sep, 0]`
 - `l` specifies location of cylinder 2, as a 2D vector, cylinder 1 at `[0, 0]`, cylinder 2 at `l`
 - `l1`, `l2` specifies location of cylinder 1 and 2, as 2D vectors, cylinder 1 at `l1`, cylinder 2 at `l2`

##### Side numbers ($fn)
There are two values of $fn used. this is due to the different requirements of different parts of the shape. 
The cylinders used to create the curve need comparatively high side count, 
as they can be very large, but the shaping used at `speed = 0` needs comparitivly low $fn or the performance becomes unbearable, 
this second value is what `hRoundfn` is for.

##### Example

    minimalBridge(8, h1 = 5, h2 = 10, d1 = 20, d2 = 10, l1 = [20, 0], l2 = [0, 20], speed = 0, $fn = 500, hRoundfn = 100);

#### Frame modules

There are 7 different frame styles available, each of which tried to be consistent style, 
so that the difference is more aesthetic that functional, 
although some will be stronger, and some use less plastic.

 - `frames_flatBase`	this is never a complex part, and will rarely even do the expected job, but is the simplest thing with the specified footprint, more for demo and testing than actual use
 - `frames_roundedBase`  this does the simplest thing that works, building a tall base, with holes for bolts. It sometimes has some customisation, but rarely much
 - `frames_hullBase`   this does a simple `hull()` operation over the necessary parts, so is simple, but uses less plastic than `frames_roundedBase`, although can look weird with rounded corners
 - `frames_pyramidBase`  this does a more complex `hull()` with slightly angled corners, resulting in a simple shape, but less weird than simple hull
 - `frames_sphericalBase`  this creates rounded corners everywhere, generally working better as the top of a part, very performance intensive
 - `frames_inverseCurve`  this creates almost the exact opposite of `frames_sphericalBase` looking good leading up to a pillar, very performance intensive
 - `frames_bridgeBase`   uses the `minimalBridge()` module for everything, making it quite light on plastic, and looking more skeletal than the others, performance cost depends on `speed` variable

The general idea is to use the same style across a design, so that the parts look similar.

For each kind of base, there is a separate module, e.g. `frames_roundedBaseAngle`, however much like the core systems, there are selectors, and these are recommended, 
it is also recommended to use the names of variables when assigning them for these modules, as there are a lot, and it can become confusing.

There are three ways of creating bases, for different kinds of base:

##### Four bolt

    frames_base(baseType, boltSepX, boltSepY, baseT, boltType, boltSize, cornerD, h, topDimensions, corneringEffectLevel, circular, center, speed);

This creates a simple four bolt base, with bolt separations specified by `boltSepX` and `boltSepY` for the two dimensions of separation.
 - `baseT` is the thickness of the underlying board, which parts are built onto.
 - `boltType` and `boltSize` specify the bolts to be used at the corners of the base.
 - `cornerD` specifies the size of the rounded corners, around the bolts.
 - `h` specifies the maximum height, including the baseT, so above what it's screwed onto.
 - `topDimensions` can either be a number (for a square or circle) or a vector (for a rectangle)
 - `corneringEffectLevel` is a little arbitrary, it effects the amount of diagonal used for pyramid, the rounding factor for spherical and inverse, and the minW for bridge
 - `circular` is a boolean, if true, the `topDimensions` vector's first value, or value is set to a simple number, is used as the diameter of a cylinder to act as the top surface.
 - `center` is a boolean, if set to true, the base will be centred about the origin (although not height wise) otherwise, it will be centred about the first bolt hole.
 - `speed` is used for the speed variable of the bridges in `frames_bridgeBase`

Example:

    frames_base(frames_hullBase, boltSepX = 40, boltSepY = 30, baseT = 5, boltType = allenBolt, boltSize = M3, cornerD = 8, h = 10, topDimensions = [30, 15], corneringEffectLevel = 8, circular = true, center = false, speed = 1);

##### Two bolt

    frames_base2(baseType, boltSep, baseWidth, baseT, boltType, boltSize, h, topType, topW, topL, center, speed);

Some of the parameters are the same, but the differences are:

 - `boltSep` defines the separation of the bolts, there is only one axis for this.
 - `baseWidth` defines the width of the part, similar to `cornerD`, but defines some of the properties of the top part (how wide it is).
 - `topW` defines the size of the top, the exposed connection point.
 - `topL` only used for some values of `topType`, other value.

`topType` defines the kind of top the part should have, it can have any one of five values:

 - `framesTop_none` this is the default if any invalid value is given, acts like `frames_flatBase`
 - `framesTop_square` creates a rectangular top section, of size `[topW, baseWidth]`
 - `framesTop_cylindrical` creates a cylindrical top section, of diameter `topW`
 - `framesTop_crossCylinder1` creates a cylindrical top section, going across the short width of the piece, of diameter  `topW`
 - `framesTop_crossCylinder2` creates a cylindrical top section, going across the length of the piece, of diameter  `topW`, and length `topL`

Example:

    frames_base2(frames_hullBase, boltSep = 40, baseWidth = 8, baseT = 5, boltType = allenBolt, boltSize = M3, h = 20, topW = 10, topL = 10, corneringEffectLevel = 5, topType = framesTop_square, circular = false, center = false, speed = 0);

##### Angle

    frames_baseAngle(baseType, plateW, plateH, baseHoleSep, baseT, plateT, boltType, boltSize, cornerD, strutT, center = false, speed = 2)


Again, some of the parameters are the same, but the differences are:

 - `plateW` the usable width of the vertical plate, with no obstructions.
 - `plateH` the usable height of the vertical plate, with no obstructions.
 - `plateT` the thickness of the plate.
 - `strutT` the thickness of any struts used for support

Since the distance between the bolts is not consistent across the styles, there are functions to get it:

    getBaseAngleFrontXBoltSep(baseType, plateW, strutT, cornerD)
    getBaseAngleRearXBoltSep(baseType, plateW, strutT, cornerD)


Example:

    frames_baseAngle(frames_hullBase, plateW = 20, plateH = 20, baseHoleSep = 20, baseT = 5, plateT = 5, boltSize = allenBolt, boltSize = M3, cornerD = 8, strutT = 5, center = false, speed = 2);

## Functions and Modules provided
Standard meanings of variable names:

 - `size`: e.g. `M2`
 - `length`: the length of a bolt below the head, e.g. 20 (except for countersunk, where it measures from top of head)
 - `ERR`: amount added to sides of head and shaft to compensate for overprint, make it negative to compensate for under-print
 - `holeDepth`: The depth of the hole leading up to the bottom of the bolt head (except for countersunk, where it measures from top of head)
hollow: boolean, whether to render part itself rather than create the hole for it, not really that useful
 - `VertERR`: the versicle error on nuts, used to mount nuts horisontally and deal with the overhand drooping slightly
 - `distFromEdge`: the distance the nut is from the edge of the material, to define the size of the hole cut
 - `nutType`: the type of nut, as defined within the nut selector
 - `washerType`: the type of washer, as defined within the washer selector
 - `boltType`: the type of bolt, as defined within the bolt selector
 - `override`: creates a object even if not recommended.
 - `silent`: makes the system not complain if small problems are detected (useful if you want to get on with it anyway, and not fill up the console, counter to repeated "WARNING: Button bolts won't look good inset")

### Functions

 - `Universal(size, value_required)` The basic indexing function, used to retrieve values from the database.
 - `getRodD(size)` A higher level way of saying `M(size, boltD)` implemented to allow better compatability with ScrewsUniversal
 - `isValueInScrewsDatabase(a, b)`
 - `isBoltInScrewsSystem(boltType, size)`
 - `getHeadDiameter(boltType, size)`
 - `getHeadHeight(boltType, size)`
 - `isWasherInScrewsSystem(washerType, size)`
 - `getWasherDiam(washerType, size)`
 - `getWasherT(washerType, size)`
 - `isValueInWasherDatabase(nutType, size)`
 - `isNutInScrewsSystem(nutType, size)`
 - `getNutH(nutType, size)`
 - `getNutSideH(nutType, size)`  This is designed to behave well for insetting things like Nylocks and dome nuts.
 - `getNutPeakD(nutType, size)`
 - `getNutFlatD(nutType, size)`
 - `toMetric(size)`
 - `toUNC(size)`


### Modules

 - `Rod(size, length, ERR, hollow);`

#### Bolts:

 - `AllenBolt(size, length, ERR,hollow);`
 - `HexHeadBolt(size, length, ERR,hollow);`
 - `HexHeadFlangeBolt(size, length, ERR, hollow);`
 - `AllenButtonBolt(size, length, ERR, hollow);`
 - `AllenCountersunkBolt(size, length, ERR, hollow);`

#### Bolt holes:

 - `AllenBoltHole(size, length, holeDepth, ERR);`
 - `HexHeadBoltHole(size, length, holeDepth, ERR);`
 - `HexHeadBoltHoleAllowingSpin(size, length, holeDepth, ERR);`
 - `HexHeadFlangeBoltHole(size, length, holeDepth, ERR);`
 - `AllenButtonBoltHole(size, length, holeDepth, ERR);`
 - `AllenCountersunkBoltHole(size, length, holeDepth, ERR);`

#### Washers:

 - `FormAWasher(size, ERR, hollow, VertERR);`
 - `FormBWasher(size, ERR, hollow, VertERR);`
 - `FormCWasher(size, ERR, hollow, VertERR);`
 - `FormDWasher(size, ERR, hollow, VertERR);`
 - `FormEWasher(size, ERR, hollow, VertERR);`
 - `FormFWasher(size, ERR, hollow, VertERR);`
 - `FormGWasher(size, ERR, hollow, VertERR);`

 - `Table1Washer(size, ERR, hollow, VertERR);`
 - `Table2Washer(size, ERR, hollow, VertERR);`
 - `Table3LightWasher(size, ERR, hollow, VertERR);`
 - `Table3HeavyWasher(size, ERR, hollow, VertERR);`
 - `Table4LightWasher(size, ERR, hollow, VertERR);`
 - `Table4HeavyWasher(size, ERR, hollow, VertERR);`

#### Nuts:

 - `ThinSquareNut(size, ERR, hollow, VertERR);`
 - `SquareNut(size, ERR, hollow, VertERR);`
 - `StuddingConnector(size, ERR, hollow, VertERR);`
 - `FullNut(size, ERR, hollow, VertERR);`
 - `NylockNut(size, ERR, hollow, VertERR);`
 - `DomeNut(size, ERR, hollow, VertERR);`
 - `WingNutLocked(size, ERR, hollow, VertERR);`
 - `WingNutRotatable(size, ERR, hollow, VertERR);`

#### Nut holes:

 - `FullNutHole(size, distFromEdge, ERR, VertERR);`
 - `DomeNutHole(size, distFromEdge, ERR, VertERR);`
 - `NylockNutHole(size, distFromEdge, ERR, VertERR);`
 - `ThinSquareNutHole(size, distFromEdge, ERR, VertERR);`
 - `SquareNutHole(size, distFromEdge, ERR, VertERR);`
 - `StuddingConnectorHole(size, distFromEdge, ERR, VertERR);`
 - `WingNutLockedHole(size, distFromEdge, ERR, VertERR);`


### Selectors:

#### Bolts:

  For these, the surface is at z = 0
 - `BoltOnSurface(boltType, size, length, ERR, hollow, silent);`
  creates the bolt on the surface
 - `BoltFlushWithSurface(boltType, size, length, ERR, hollow, override, silent);`
  insets bolts into surface
 - `BoltNormalWithSurface(boltType, size, length, ERR, hollow, silent);`
  Does the most common action, whatever makes most sense


#### Bolt holes:

 - `BoltInHoleFromTop(boltType, size, length, holeDepth, ERR, hollow, silent);`
  Measures from the top of the bolt head, making a hole above for the bolt to enter.
 - `BoltInHoleFromBottom(boltType, size, length, holeDepth, ERR, hollow, silent);`
  Measures from bottom of the bolt head, making a hole above for the bolt to enter.
 - `BoltInHoleFromNormal(boltType, size, length, holeDepth, ERR, hollow, silent);`
  Measures wherever is most applicable on that type of bolt, making a hole above for the bolt to enter.

#### Washers and Nuts:

 - `Washer(form, size, ERR, hollow, VertERR);`
 - `Nut(nutType, size, ERR, hollow, VertERR);`
 - `NutHole(nutType, size, depth, ERR, VertERR);`


## Internal Structure

The ScrewsUniversal.scad file, the one which is included, includes all the internal files, 
in a good order to ensure that the echo statements arrive in a good order, and aren't repeated.

There are several components to ScrewsUniversal as represented by the files found in Internal:

 - ScrewsUniversal-Base.scad
 - ScrewsUniversal-Modules.scad
 - ScrewsUniversal-BoltSelector.scad
 - ScrewsUniversal-NutSelector.scad
 - ScrewsUniversal-Washers.scad

These files contain little code, like the equivalent (non core) files in ScrewsMetric and ScrewsUNC.
Each of these files replaces an equivalent in the other versions, but will address the call to a different underlying module/function depending on whether the sizes are UNC or Metric.
This is an example from ScrewsUniversal-Modules.scad:

    module AllenBolt(size, length, ERR=0,hollow = false){
       if(size <+ 100){
          M_AllenBolt(size, length, ERR,hollow);
       } else {
          UNC_AllenBolt(size, length, ERR,hollow);
       }
    }


All Optional modules avoid addressing the structure in any way, calling modules which they have not loaded, but openscad doesn't mind as long as they are present at runtime. 
They can address sizes etc. through the `ScrewsUniversal-sizeDeclaration` file, which merely acts like a .h file in c, only declaring the necessary global variables. 
These sizes can be used, for example, to allow the specification of a size of bolt, e.g. for steppers.



All the lookups are done though indexing, so `M8` is really equal to 6, while the UNC values are 100 bigger that their index, allowing the system to check whether the size is metric or UNC.
Using the numeric value of the index HAS NO MEANING WHATSOEVER and using indexes instead of the names is also not recommended, it just makes things harder to read.

Doing any numerical operation on any of the indexes will also lead to a nonsensical result, as the indexes are not necessarily in size order:
`echo(M2_5 > M8);`
and
`echo(UNC2 > M24);`
come out true

The underlying array is called `M` for the metric version and `UNC` for the UNC version
so `M[boltD][M2]` gives the same result as `Universal(M2, boltD)`, 
however if a non-existent value is indexed, `undef` is returned, resulting in many hard to find bugs.
There is also no guarantee that the underlying array will not change its structure, 
for example it may invert and become `M[M2][boltD]` without any warning, 
the structure may also change, so there is no array, so using it is asking for problems in a version update.

If you want to check whether a value exists, use `isValueInScrewsDatabase(a, b)` 
giving it the same values as you would the `Universal()` function.
This will not fail if the value does not exist, and will work with either metric or imperial.

Each value is assigned to a variable before being entered into the array, these variables follow the pattern:
`M2_nutPeakD`
which is returned by
`Universal(M2, nutPeakD)`

Do not use these values directly, it is no more compact than indexing them, 
and no faster as almost all performance losses in OpenScad are in the rendering.

`hollow` is used as an argument to many modules to make them go into display mode, the results are not accurate, and are just there to look pretty. 

`AllenBoltHole()` is a module which creates a channel leading to the head, to allow fully embedded bolts

`FullNutHole()` is a module which creates a channel leading to a nut, to allow it to be side inserted.

The array for the washer system is accessed through `WasherDimensions()`, e.g. `WasherDimensions(M8, washerFormA, washerT)`, 
however higher level functions should be used, `Washer(WasherDimensions, M8)` providing the general module, 
the functions `getWasherT(form, size)` and `getWasherOuterD(form, size)` providing the information.
The modules `FormAWasher(size)` through to `FormGWasher(size)` and `Table1Washer(size)` through to `Table4HeavyWasher(size)` call the Washer module, so are actually more indirect.
This is because the layout of the array makes it easy to switch between values, and all washers are fundamentally the same shape.

The washer forms for the UNC washer are also 100 more than the index, to allow the system to detect incompatable washer form/size combinations.
