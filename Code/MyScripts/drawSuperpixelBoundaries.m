function[MaskedImage] = drawSuperpixelBoundaries(NormalizedGrayImage, Labels, useWhiteMask)
% draw superpixel boundaries given an image
% NormalizedGrayImage: Image to draw boundaries of
% Labels: 1-based matrix with a superpixel label for every pixel
% useWhiteMask: boolean indicating whether to draw boundaries between
%               superpixels in white or black.
    
    binaryMask = drawregionboundaries(Labels);    
    
    MaskedImage = NormalizedGrayImage;
    
    if(useWhiteMask)
        MaskedImage(binaryMask==1) = 255;
    else
        MaskedImage(binaryMask==1) = 0;
    end
end