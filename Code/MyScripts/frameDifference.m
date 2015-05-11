function [diffImage] = frameDifference (I1, I2)
    
    diffImage = uint8(abs(int32(I1) - int32(I2)));
    figure();
    imshow(normalizeImage(diffImage));
    title('Normalized');
    
    
    figure();
    imshow(histeq(diffImage));
    title('Equalized');
 
end