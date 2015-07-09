function [magnitude, angle] = computeMagnitudeAngle(vx, vy)
   [angle, magnitude] = cart2pol(vx, vy);
   angle(angle<0) = angle(angle<0) + 2*pi;
   angle = angle*180/pi;
end