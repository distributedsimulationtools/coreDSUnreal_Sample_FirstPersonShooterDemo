angleConversions = require("angleConversions")
require("lla2ecef")
require("ReferenceLatLongAlt")

lastPositionX = 0
lastPositionY = 0
lastPositionZ = 0

function convertUnrealPositionToDIS()
-- Since we are working over a fairly small part of the planet, we can assume a flat surface
--convert lat/long to geocentric
tempx, tempy, tempz = lla2ecef(referenceOffset_Lat , referenceOffset_Long , referenceOffset_Alt )

buffer = DSimLocal.X
DSimLocal.X = tempx + DSimLocal.Y/100 
DSimLocal.Y = tempy + buffer/100
DSimLocal.Z = tempz + ((-1.0 * DSimLocal.Z)/100)

lastPositionX = DSimLocal.X
lastPositionY = DSimLocal.Y
lastPositionZ = DSimLocal.Z

end