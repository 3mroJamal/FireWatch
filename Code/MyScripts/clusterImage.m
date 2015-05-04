function [] = clusterImage(NormalizedGrayImage, useWhiteMask)
    % useWhiteMask: determines the color of the mask
    %               White Masks are useful to visualzie details when
    %               forests are black. Black masks are useful to visualize
    %               superpixels of the smoke and the sky.
    
    SuperPixelNumber = 2000;
    CompactnessFactor = 50;
    Labels = SLICdemo(NormalizedGrayImage, SuperPixelNumber, CompactnessFactor);
    
    binaryMask = drawregionboundaries(Labels);    
    
    MaskedImage = NormalizedGrayImage;
    
    if(useWhiteMask)
        MaskedImage(binaryMask==1) = 255;
    else
        MaskedImage(binaryMask==1) = 0;
    end
    
    figure();
    imshow(MaskedImage);
end