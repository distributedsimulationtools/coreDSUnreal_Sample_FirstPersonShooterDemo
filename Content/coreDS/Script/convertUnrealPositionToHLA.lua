angleConversions = require("angleConversions")
require("ecef2lla")
require("ReferenceLatLongAlt")

function convertUnrealPositionToHLA (value)

-- Since we are working over a fairly small part of the planet, we can assume a flat surface
--convert lat/long to geocentric
enuX, enuY, enuZ = EnuToEcef( value['WorldLocation.Y']:toDouble()/100,  value['WorldLocation.X']:toDouble()/100, value['WorldLocation.Z']:toDouble()/100, referenceOffset_Lat , referenceOffset_Long , referenceOffset_Alt )

value['WorldLocation.X']:set(enuX)
value['WorldLocation.Y']:set(enuY)
value['WorldLocation.Z']:set(enuZ)

lat, lon, alt = ecef2lla( value['WorldLocation.X']:toDouble() , value['WorldLocation.Y']:toDouble() ,  value['WorldLocation.Z']:toDouble())

lat = math.rad(lat)
lon = math.rad(lon)

local roll =  value['Orientation.Psi']:toFloat()-- roll
local pitch = value['Orientation.Theta']:toFloat()--pitch
local yaw = value['Orientation.Phi']:toFloat() --yaw

value['Orientation.Theta']:set(angleConversions.getThetaFromTaitBryanAngles(lat, lon, yaw, pitch));
value['Orientation.Phi']:set(angleConversions.getPhiFromTaitBryanAngles(lat, lon, yaw, pitch, roll))
value['Orientation.Psi']:set(angleConversions.getPsiFromTaitBryanAngles(lat, lon, yaw, pitch))

end
