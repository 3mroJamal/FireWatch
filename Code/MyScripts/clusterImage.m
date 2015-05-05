function [] = clusterImage(NormalizedGrayImage, useWhiteMask)
    % useWhiteMask: determines the color of the mask
    %               White Masks are useful to visualzie details when
    %               forests are black. Black masks are useful to visualize
    %               superpixels of the smoke and the sky.
    
    SuperPixelNumber = 2000;
    CompactnessFactor = 50;
    [Labels, numLabels] = SLICdemo(NormalizedGrayImage, SuperPixelNumber, CompactnessFactor);
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

    featureNumber = 2;
    featureMatrix = extractFeatures(NormalizedGrayImage, featureNumber,Labels, numLabels);
    
    featureMatrix = normalizeFeatures(featureMatrix);
    
   
    clusterNumber = 5;
    clusterIndices = kmeans(featureMatrix', clusterNumber);
    
    ClusterImage = double(zeros(size(NormalizedGrayImage)));
    
    for i = 1:numLabels
        ClusterImage(Labels == i) = clusterIndices(i)/clusterNumber;
    end
    
    
    figure();
    imshow(ClusterImage);
    
    for clusterIdx = 1:clusterNumber
        currentClusterImage = uint8(zeros(size(NormalizedGrayImage)));
        
        for superPixelIdx = 1:numLabels
            superPixelClusterIdx = clusterIndices(superPixelIdx);
            if(superPixelClusterIdx == clusterIdx)
                currentClusterImage(Labels == superPixelIdx) = NormalizedGrayImage(Labels == superPixelIdx);
            end
        end
        figure();
        subplot(1, 2, 1);
        %%figure();
        imshow(currentClusterImage);
        %%title(clusterIdx);
        
        subplot(1, 2, 2);
        %%figure();
        neededPixels = currentClusterImage(currentClusterImage~=0);
        size(unique(neededPixels))
        %hist(neededPixels);
        imhist(neededPixels);
    end
end