% Draws superpixel boundaries given an image
% NormalizedGrayImage: Grayscale image to draw boundaries of. range of
% values is [0,255]
% Labels: 1-based matrix with a superpixel label for every pixel
% useWhiteMask: boolean indicating whether to draw boundaries between
%               superpixels in white or black.


function[MaskedImage] = drawSuperpixelBoundaries(NormalizedGrayImage, Labels, useWhiteMask)
    
    binaryMask = drawregionboundaries(Labels);    
    
    MaskedImage = NormalizedGrayImage;
    
    if(useWhiteMask)
        MaskedImage(binaryMask==1) = 255;
    else
        MaskedImage(binaryMask==1) = 0;
    end
end