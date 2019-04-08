local angleConversions = {}

_toDegrees = 57.2957795131;
_toRadians =  0.01745329252;


function angleConversions.toDegrees(val)
	return val * _toDegrees
end

function angleConversions.toRadian(val)
	return val * _toRadians
end

-- Original function written by the folks from http://open-dis.sourceforge.net/
--
-- Gets a degree heading for an entity based on euler angles. All angular values passed in must be in radians.
-- @param lat Entity's latitude,    IN RADIANS
-- @param lon Entity's longitude,   IN RADIANS
-- @param psi Psi angle,            IN RADIANS
-- @param theta Theta angle,        IN RADIANS
-- @return the heading, in degrees, with 0 being north, positive angles going clockwise,
-- and negative angles going counterclockwise (i.e., 90 deg is east, -90 is west)

function angleConversions.getOrientationFromEuler(lat, lon, psi, theta)
	local sinlat = math.sin(lat);
	local sinlon = math.sin(lon);
	local coslon = math.cos(lon);
	local coslat = math.cos(lat);
	local sinsin = sinlat * sinlon;

	local cosTheta = math.cos(theta);
	local cosPsi = math.cos(psi);
	local sinPsi = math.sin(psi);
	local sinTheta = math.sin(theta);


	local cosThetaCosPsi = cosTheta * cosPsi;
	local cosThetaSinPsi = cosTheta * sinPsi;
	local sincos = sinlat * coslon;

	local b11 = -sinlon * cosThetaCosPsi + coslon * cosThetaSinPsi;
	local b12 = -sincos * cosThetaCosPsi - sinsin * cosThetaSinPsi - coslat * sinTheta;

	return angleConversions.toDegrees(math.atan2(b11, b12)); --range is -pi to pi
end

--
-- Gets a degree pitch for an entity based on euler angles. All angular values passed in must be in radians.
-- @param lat Entity's latitude,    IN RADIANS
-- @param lon Entity's longitude,   IN RADIANS
-- @param psi Psi angle,            IN RADIANS
-- @param theta Theta angle,        IN RADIANS
-- @return the pitch, in degrees, with 0 being level. A negative values is when the entity's
-- nose is pointing downward, positive value is when the entity's nose is pointing upward.
--
function angleConversions.getPitchFromEuler(lat, lon, psi, theta)
	local sinlat = math.sin(lat);
	local sinlon = math.sin(lon);
	local coslon = math.cos(lon);
	local coslat = math.cos(lat);
	local cosLatCosLon = coslat * coslon;
	local cosLatSinLon = coslat * sinlon;

	local cosTheta = math.cos(theta);
	local cosPsi = math.cos(psi);
	local sinPsi = math.sin(psi);
	local sinTheta = math.sin(theta);

	return angleConversions.toDegrees(math.asin(cosLatCosLon*cosTheta*cosPsi + cosLatSinLon*cosTheta*sinPsi - sinlat*sinTheta))
end

--
-- Gets the degree roll for an entity based on euler angles. All angular values passed in must be in radians.
-- @param lat Entity's latitude,    IN RADIANS
-- @param lon Entity's longitude,   IN RADIANS
-- @param psi Psi angle,            IN RADIANS
-- @param theta Theta angle,        IN RADIANS
-- @param phi Phi angle,            IN RADIANS
-- @return the roll, in degrees, with 0 being level flight, + roll is clockwise when looking out the front of the entity.
--
function angleConversions.getRollFromEuler(lat, lon, psi, theta, phi)
	local sinlat = math.sin(lat);
	local sinlon = math.sin(lon);
	local coslon = math.cos(lon);
	local coslat = math.cos(lat);
	local cosLatCosLon = coslat * coslon;
	local cosLatSinLon = coslat * sinlon;

	local cosTheta = math.cos(theta);
	local sinTheta = math.sin(theta);
	local cosPsi   = math.cos(psi);
	local sinPsi   = math.sin(psi);
	local sinPhi   = math.sin(phi);
	local cosPhi   = math.cos(phi);

	local sinPhiSinTheta = sinPhi * sinTheta;
	local cosPhiSinTheta = cosPhi * sinTheta;

	local b23 = cosLatCosLon*(-cosPhi*sinPsi + sinPhiSinTheta*cosPsi) +
				 cosLatSinLon*( cosPhi*cosPsi + sinPhiSinTheta*sinPsi) +
				 sinlat * (sinPhi * cosTheta);

	local b33 = cosLatCosLon*( sinPhi*sinPsi + cosPhiSinTheta*cosPsi) +
				 cosLatSinLon*(-sinPhi*cosPsi + cosPhiSinTheta*sinPsi) +
				 sinlat * (cosPhi * cosTheta);

	return angleConversions.toDegrees(math.atan2(-b23, -b33));
end

--
-- Gets the Euler Theta value (in radians) from position and Tait-Brayn yaw and roll angles
-- @param lat Entity's latitude,    IN RADIANS
-- @param lon Entity's longitude,   IN RADIANS
-- @param yaw   entity's yaw angle (also know as the entity's bearing or heading angle), in degrees
-- @param pitch entity's pitch angle, in degrees
-- @return the Theta value in radians
--
function angleConversions.getThetaFromTaitBryanAngles(lat, lon, yaw, pitch)
	local sinLat = math.sin(lat);
	local cosLat = math.cos(lat);

	local cosPitch = math.cos(pitch*_toRadians);
	local sinPitch = math.sin(pitch*_toRadians);
	local cosYaw   = math.cos(yaw*_toRadians);
 
	return math.asin( -cosLat * cosYaw * cosPitch - sinLat * sinPitch );
end

--
-- Gets the Euler Psi value (in radians) from position and Tait-Brayn yaw and roll angles
-- @param lat Entity's latitude,    IN RADIANS
-- @param lon Entity's longitude,   IN RADIANS
-- @param yaw   ettity's yaw angle (also know as the entity's bearing or heading angle), in degrees
-- @param pitch entity's pitch angle, in degrees
-- @return the Psi value in radians
--
function angleConversions.getPsiFromTaitBryanAngles(lat, lon, yaw, pitch)
	local sinLat = math.sin(lat);
	local sinLon = math.sin(lon);
	local cosLon = math.cos(lon);
	local cosLat = math.cos(lat);
	local cosLatCosLon = cosLat * cosLon;
	local cosLatSinLon = cosLat * sinLon;
	local sinLatCosLon = sinLat * cosLon;
	local sinLatSinLon = sinLat * sinLon;

	local cosPitch = math.cos(pitch*_toRadians);
	local sinPitch = math.sin(pitch*_toRadians);
	local sinYaw   = math.sin(yaw*_toRadians);
	local cosYaw   = math.cos(yaw*_toRadians);

	local a_11 = -sinLon * sinYaw * cosPitch - sinLatCosLon * cosYaw * cosPitch + cosLatCosLon * sinPitch;
	local a_12 =  cosLon * sinYaw * cosPitch - sinLatSinLon * cosYaw * cosPitch + cosLatSinLon * sinPitch;

	return math.atan2(a_12, a_11);
end

--
-- Gets the Euler Phi value (in radians) from position and Tait-Brayn yaw, pitch and roll angles
-- @param lat Entity's latitude,    IN RADIANS
-- @param lon Entity's longitude,   IN RADIANS
-- @param yaw yaw angle (also know as the entity's bearing or heading angle), in degrees
-- @param pitch entity's pitch angle, in degrees
-- @param roll  entity's roll angle (0 is level flight, + roll is clockwise looking out the nose), in degrees
-- @return the Phi value in radians
--
function angleConversions.getPhiFromTaitBryanAngles(lat, lon, yaw, pitch, roll)
	local sinLat = math.sin(lat);
	local cosLat = math.cos(lat);

	local cosRoll  = math.cos(roll*_toRadians);
	local sinRoll  = math.sin(roll*_toRadians);
	local cosPitch = math.cos(pitch*_toRadians);
	local sinPitch = math.sin(pitch*_toRadians);
	local sinYaw   = math.sin(yaw*_toRadians);
	local cosYaw   = math.cos(yaw*_toRadians);

	local a_23 = cosLat * (-sinYaw * cosRoll + cosYaw * sinPitch * sinRoll) - sinLat * cosPitch * sinRoll;
	local a_33 = cosLat * ( sinYaw * sinRoll + cosYaw * sinPitch * cosRoll) - sinLat * cosPitch * cosRoll;

	return math.atan2(a_23, a_33);
end

return angleConversions
