angleConversions = require("angleConversions")
require("lla2ecef")
require("ReferenceLatLongAlt")

lastPositionX = 0
lastPositionY = 0
lastPositionZ = 0

function convertPositionFromDIS()

lastPositionX = DSimLocal.X
lastPositionY = DSimLocal.Y
lastPositionZ = DSimLocal.Z

-- Since we are working over a fairly small part of the planet, we can assume a flat surface
--convert lat/long to geocentric
tempx, tempy, tempz = lla2ecef(referenceOffset_Lat , referenceOffset_Long , referenceOffset_Alt )


DSimLocal.X = (tempx - DSimLocal.X)
DSimLocal.Y = (tempy - DSimLocal.Y)
DSimLocal.Z = (tempz - DSimLocal.Z)

end