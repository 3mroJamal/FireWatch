function [diffImage] = frameDifference (I1, I2)
    
    % thresholding to uint8 removes lots of info since difference can be
    % approx 2000
    % diffImage = uint8(abs(int32(I1) - int32(I2)));
    
    % if I2< I1 -> result is zero as they are of class uint16
    %% diffImage = I2-I1;
    diffImage = abs(int32(I1) - int32(I2));
    
    diffImage = uint8(normalizeImage(diffImage).*255);
 
end