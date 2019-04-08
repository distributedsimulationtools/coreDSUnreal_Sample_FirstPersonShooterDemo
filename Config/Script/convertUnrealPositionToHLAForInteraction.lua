angleConversions = require("angleConversions")
require("lla2ecef")
require("ecef2lla")
require("ReferenceLatLongAlt")

function convertUnrealPositionToHLAForInteraction ()

-- Since we are working over a fairly small part of the planet, we can assume a flat surface
--convert lat/long to geocentric
tempx, tempy, tempz = lla2ecef(referenceOffset_Lat , referenceOffset_Long , referenceOffset_Alt )
 
DSimLocal.X = tempx + DSimLocal.X
DSimLocal.Y = tempy + DSimLocal.Y
DSimLocal.Z = tempz + DSimLocal.Z

end