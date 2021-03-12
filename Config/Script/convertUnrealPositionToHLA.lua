angleConversions = require("angleConversions")
require("ecef2lla")
require("ReferenceLatLongAlt")

function convertUnrealPositionToHLA ()

-- Since we are working over a fairly small part of the planet, we can assume a flat surface
--convert lat/long to geocentric
DSimLocal.WorldLocation.X, DSimLocal.WorldLocation.Y, DSimLocal.WorldLocation.Z = EnuToEcef(DSimLocal.WorldLocation.Y/100, DSimLocal.WorldLocation.X/100, DSimLocal.WorldLocation.Z/100, referenceOffset_Lat , referenceOffset_Long , referenceOffset_Alt )

lat, lon, alt = ecef2lla(DSimLocal.WorldLocation.X ,DSimLocal.WorldLocation.Y , DSimLocal.WorldLocation.Z)

lat = math.rad(lat)
lon = math.rad(lon)

local roll =  DSimLocal.Orientation.Psi-- roll
local pitch = DSimLocal.Orientation.Theta--pitch
local yaw = DSimLocal.Orientation.Phi --yaw

DSimLocal.Orientation.Theta = (angleConversions.getThetaFromTaitBryanAngles(lat, lon, yaw, pitch));
DSimLocal.Orientation.Phi = (angleConversions.getPhiFromTaitBryanAngles(lat, lon, yaw, pitch, roll))
DSimLocal.Orientation.Psi =  (angleConversions.getPsiFromTaitBryanAngles(lat, lon, yaw, pitch))

end