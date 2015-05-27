% feature order in feature matrix
% 1- mean intensity
% 2- intensity SD
% 3- mean X position
% 4- mean Y position
% 5- mean X motion
% 6- mean Y motion
% 7- X motion STD
% 8- Y motion STD

function [] = clusterImage(NormalizedGrayImage, useWhiteMask, clusterNumber, featuresToInclude)
    % useWhiteMask: determines the color of the mask
    %               White Masks are useful to visualzie details when
    %               forests are black. Black masks are useful to visualize
    %               superpixels of the smoke and the sky.
    
    SuperPixelNumber = 500;
    CompactnessFactor = 40;
    [Labels, numLabels] = SLICdemo(NormalizedGrayImage, SuperPixelNumber, CompactnessFactor);
    
    SuperpixelBoundaries =  drawSuperpixelBoundaries(NormalizedGrayImage, Labels, useWhiteMask);
    
    figure();
    imshow(SuperpixelBoundaries);

    featureMatrix = extractFeatures(NormalizedGrayImage, Labels, numLabels);
    
    featureMatrix = normalizeFeatures(featureMatrix);
    
    featureMatrix = featureMatrix(featuresToInclude>0, :);
    
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
    
    %%clustersToInclude = 4;
    %%brightestClusterIndices = clustersCorrespondingToMeans(1:clustersToInclude);
    %%brightestClustersImage = uint8(zeros(size(NormalizedGrayImage)));
    %%for i = 1:clustersToInclude
    %%    brightestClustersImage(ClusterImage == brightestClusterIndices(i)) = NormalizedGrayImage(ClusterImage == brightestClusterIndices(i));
    %%end
    
    %% figure();
    %% imshow(brightestClustersImage);
    
end