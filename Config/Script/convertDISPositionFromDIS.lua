angleConversions = require("angleConversions")
require("lla2ecef")
require("ReferenceLatLongAlt")

lastPositionX = 0
lastPositionY = 0
lastPositionZ = 0

function convertDISPositionFromDIS()

lastPositionX = DSimLocal.X
lastPositionY = DSimLocal.Y
lastPositionZ = DSimLocal.Z

-- Since we are working over a fairly small part of the planet, we can assume a flat surface
--convert lat/long to geocentric
tempx, tempy, tempz = lla2ecef(referenceOffset_Lat , referenceOffset_Long , referenceOffset_Alt )

-- Data we are receving is already geocentric
-- * 100 convert units from meters to cm

DSimLocal.X = (tempx - DSimLocal.X)--* 100
DSimLocal.Y = (tempy - DSimLocal.Y)--* 100
DSimLocal.Z = (tempz - DSimLocal.Z)--* 100

end