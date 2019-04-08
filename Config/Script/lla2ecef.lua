--  LLA2ECEF Convert geodetic coordinates to Earth-centered Earth-fixed
--  (ECEF)  coordinates.
--   P = LLA2ECEF( LLA ) the geodetic coordinates (latitude, longitude and altitude), LLA, to X,Y,Z
--   LLA= [degrees degrees meters].  P is in meters.
--   The default ellipsoid planet is WGS84. 
--
--   specifying WGS84 ellipsoid model:
--      f = 1/298.257223563;
--      Re = 6378137;
--


function lla2ecef(lat,long,alt)
  -- flattening
local f  = 1.0/298.257223563;
--equatorial radius
local R =  6378137.0;
--calculate excentricity and radius
local a  = R;
local e2 =   1.0 - ( 1.0 - f )^2 ;
--transform to radians
local phi = math.rad(lat);
local lambda = math.rad(long) ;
--calculate sinphi,cosphi 
local sphi = math.sin(phi);
local cphi = math.cos(phi);
local N  = a / math.sqrt(1.0 - e2 * sphi^2);
--lambda (longitude in radians)
local x = (N + alt) * cphi * math.cos(lambda);
local y = (N + alt) * cphi * math.sin(lambda);
local z = (N*(1.0 - e2) + alt) * sphi;
return x, y, z;
  end
  