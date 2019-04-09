angleConversions = require("angleConversions")
require("lla2ecef")
require("ecef2lla")
require("ReferenceLatLongAlt")

function convertUnrealPositionToHLA ()

-- Since we are working over a fairly small part of the planet, we can assume a flat surface
--convert lat/long to geocentric
tempx, tempy, tempz = lla2ecef(referenceOffset_Lat , referenceOffset_Long , referenceOffset_Alt )
 
DSimLocal.WorldLocation.X = tempx + DSimLocal.WorldLocation.X
DSimLocal.WorldLocation.Y = tempy + DSimLocal.WorldLocation.Y
DSimLocal.WorldLocation.Z = tempz + DSimLocal.WorldLocation.Z

lat, lon, alt = ecef2lla(DSimLocal.WorldLocation.X ,DSimLocal.WorldLocation.Y , DSimLocal.WorldLocation.Z)

lat = math.rad(lat)
lon = math.rad(lon)

local yaw =  DSimLocal.Orientation.Psi-- roll
local pitch = DSimLocal.Orientation.Theta--pitch
local roll = DSimLocal.Orientation.Phi --yaw

DSimLocal.Orientation.Theta = (angleConversions.getThetaFromTaitBryanAngles(lat, lon, yaw, pitch));
DSimLocal.Orientation.Phi = (angleConversions.getPhiFromTaitBryanAngles(lat, lon, yaw, pitch, roll))
DSimLocal.Orientation.Psi =  (angleConversions.getPsiFromTaitBryanAngles(lat, lon, yaw, pitch))

end