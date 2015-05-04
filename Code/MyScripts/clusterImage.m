function [] = clusterImage(NormalizedGrayImage, useWhiteMask)
    % useWhiteMask: determines the color of the mask
    %               White Masks are useful to visualzie details when
    %               forests are black. Black masks are useful to visualize
    %               superpixels of the smoke and the sky.
    
    SuperPixelNumber = 2000;
    CompactnessFactor = 50;
    [Labels numLabels] = SLICdemo(NormalizedGrayImage, SuperPixelNumber, CompactnessFactor);
    Labels = Labels + 1;
    
    binaryMask = drawregionboundaries(Labels);    
    
    MaskedImage = NormalizedGrayImage;
    
    if(useWhiteMask)
        MaskedImage(binaryMask==1) = 255;
    else
        MaskedImage(binaryMask==1) = 0;
    end
    
    figure();
    imshow(MaskedImage);

    featureNumber = 4;
    featureMatrix = extractFeatures(NormalizedGrayImage, featureNumber,Labels, numLabels);
end