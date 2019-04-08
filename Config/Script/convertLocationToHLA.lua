angleConversions = require("angleConversions")
require("lla2ecef")
require("ecef2lla")
require("ReferenceLatLongAlt")

lastPositionX = 0
lastPositionY = 0
lastPositionZ = 0

function convertLocationToHLA ()

-- Since we are working over a fairly small part of the planet, we can assume a flat surface
--convert lat/long to geocentric
tempx, tempy, tempz = lla2ecef(referenceOffset_Lat , referenceOffset_Long , referenceOffset_Alt )

buffer = DSimLocal.DeadReckoningAlgorithm_A_Alternatives.WorldLocation.X
DSimLocal.WorldLocation.X = tempx + DSimLocal.WorldLocation.Y/100 
DSimLocal.WorldLocation.Y = tempy + buffer/100
DSimLocal.WorldLocation.Z = tempz + ((-1.0 * DSimLocal.WorldLocation.Z)/100)

lastPositionX = DSimLocal.WorldLocation.X
lastPositionY = DSimLocal.WorldLocation.Y
lastPositionZ = DSimLocal.WorldLocation.Z



lat, lon, alt = ecef2lla(lastPositionX ,lastPositionY , lastPositionZ)

lat = math.rad(lat)
lon = math.rad(lon)

local roll = DSimLocal.Orientation.Psi-- heading
local pitch = DSimLocal.Orientation.Theta--pitch
local yaw = DSimLocal.Orientation.Phi--rol

DSimLocal.Orientation.Theta = (angleConversions.getThetaFromTaitBryanAngles(lat, lon, yaw, pitch));
DSimLocal.Orientation.Phi = (angleConversions.getPhiFromTaitBryanAngles(lat, lon, yaw, pitch, roll))
DSimLocal.Orientation.Psi =  (angleConversions.getPsiFromTaitBryanAngles(lat, lon, yaw, pitch))

end

