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
    SuperPixelClusterIndices = kmeans(featureMatrix', clusterNumber);
    
    ClusterImage = double(zeros(size(NormalizedGrayImage)));
    
    for i = 1:numLabels
        ClusterImage(Labels == i) = SuperPixelClusterIndices(i);
    end
    
    
    figure();
    ClusterImageNormalized = ClusterImage./clusterNumber;
    imshow(ClusterImageNormalized);
    
    clusterMeans = zeros(clusterNumber);
    clusterSTDs = zeros(clusterNumber);
    
    for clusterIdx = 1:clusterNumber
        currentClusterImage = uint8(zeros(size(NormalizedGrayImage)));
        
        currentClusterImage(ClusterImage==clusterIdx) = NormalizedGrayImage(ClusterImage==clusterIdx);
        
        
        figure();
        imshow(currentClusterImage);
        
        figure();
        subplot(1, 2, 1);
        %%figure();
        imshow(currentClusterImage);
        %%title(clusterIdx);
        
        subplot(1, 2, 2);
        %%figure();
        neededPixels = currentClusterImage(currentClusterImage~=0);
        imhist(neededPixels);
        
        clusterMeans(clusterIdx) = mean(neededPixels);
        clusterSTDs(clusterIdx) = std(double(neededPixels));
    end
    
    [sortedMeans, clustersCorrespondingToMeans] = sort(clusterMeans, 'descend');
    clustersToInclude = 4;
    brightestClusterIndices = clustersCorrespondingToMeans(1:clustersToInclude);
    brightestClustersImage = uint8(zeros(size(NormalizedGrayImage)));
    for i = 1:clustersToInclude
        brightestClustersImage(ClusterImage == brightestClusterIndices(i)) = NormalizedGrayImage(ClusterImage == brightestClusterIndices(i));
    end
    
    figure();
    imshow(brightestClustersImage);
    
end