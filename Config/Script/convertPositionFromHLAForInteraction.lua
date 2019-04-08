angleConversions = require("angleConversions")
require("ecef2lla")
require("lla2ecef")
require("ReferenceLatLongAlt")


function convertPositionFromHLAForInteraction()
-- Since we are working over a fairly small part of the planet, we can assume a flat surface
--convert lat/long to geocentric
tempx, tempy, tempz = lla2ecef(referenceOffset_Lat , referenceOffset_Long , referenceOffset_Alt )

-- Data we are receving is already geocentric
-- * 100 convert units from meters to cm

DSimLocal.X = (DSimLocal.X - tempx)
DSimLocal.Y = (DSimLocal.Y - tempy)
DSimLocal.Z = (DSimLocal.Z - tempz)

end
