% feature order in feature matrix
% 1- mean intensity
% 2- intensity SD
% 3- mean X position
% 4- mean Y position
% 5- mean X motion
% 6- mean Y motion
% 7- X motion STD
% 8- Y motion STD
% 9- mean of diffImage
% 10- std of diffImage

function [] = clusterImage(Image, ImageTwo, useWhiteMask, clusterNumber, featuresToInclude)
    % useWhiteMask: determines the color of the mask
    %               White Masks are useful to visualzie details when
    %               forests are black. Black masks are useful to visualize
    %               superpixels of the smoke and the sky.
    
    
    normalizedImage = normalizeImage(Image);
    grayscaleImage = uint8(normalizedImage.*255);
    
    SuperPixelNumber = 500;
    CompactnessFactor = 40;
    [Labels, numLabels] = SLICdemo(grayscaleImage, SuperPixelNumber, CompactnessFactor);
    
    SuperpixelBoundaries =  drawSuperpixelBoundaries(grayscaleImage, Labels, useWhiteMask);
    
    %%% figure();
    %%% imshow(SuperpixelBoundaries);
    %%% title('Superpixels');

    colorFeatureMatrix = extractFeatures(grayscaleImage, Labels, numLabels);
    
    normalizedImageTwo = normalizeImage(ImageTwo);
    motionFeatureMatrix = extractMotionFeatures(normalizedImage, normalizedImageTwo, Labels,numLabels);
    
    featureMatrix = [colorFeatureMatrix; motionFeatureMatrix];
    
    %% figure();
    %% hist(featureMatrix(1,:));
    %% title('Mean Intensity Hist');
    
    %% figure();
    %% hist(featureMatrix(2,:));
    %% title('Intensity STD Hist');
    
    %% figure();
    %% hist(featureMatrix(3,:));
    %% title('Mean X hist');
    
    %% figure();
    %% hist(featureMatrix(4,:));
    %% title('Mean Y hist');
    
    %% figure();
    %% hist(featureMatrix(5,:));
    %% title('X motion hist');
    
    %% figure();
    %% hist(featureMatrix(6,:));
    %% title('X motion STD hist');
        
    %% figure();
    %% hist(featureMatrix(7,:));
    %% title('Y motion hist');
    
    %% figure();
    %% hist(featureMatrix(8,:));
    %% title('Y motion STD hist');
    
    
    featureMatrix = normalizeFeatures(featureMatrix);
    
    featureMatrix = featureMatrix(featuresToInclude>0, :);
        
    SuperPixelClusterIndices = kmeans(featureMatrix', clusterNumber);
    
    % Each pixel has a label to which cluster does it belong
    ClusterImage = double(zeros(size(Image)));
    
    for i = 1:numLabels
        ClusterImage(Labels == i) = SuperPixelClusterIndices(i);
    end
    
    
    figure();
    ClusterImageNormalized = ClusterImage./clusterNumber;
    imshow(ClusterImageNormalized);
    title('Cluster Image');
    
    clusterMeans = zeros(clusterNumber);
    clusterSTDs = zeros(clusterNumber);
    
    %% statistics per cluster
    for clusterIdx = 1:clusterNumber
        currentClusterImage = uint8(zeros(size(Image)));
        currentClusterImage(ClusterImage==clusterIdx) = grayscaleImage(ClusterImage==clusterIdx);
        
        figure();
        imshow(currentClusterImage);
        
        figure();
        subplot(1, 3, 1);
        imshow(currentClusterImage);
        
        %% subplot(1, 2, 2);
        neededPixels = currentClusterImage(currentClusterImage~=0);
        %% imhist(neededPixels);
        
        
        clusterMeans(clusterIdx) = mean(neededPixels);
        clusterSTDs(clusterIdx) = std(double(neededPixels));
        
        %% row vector with ones at superpixels belonging to current clusters
        clusterSuperpixels = (SuperPixelClusterIndices' == clusterIdx);
        
        superpixelIntensities = featureMatrix(1, :);
        clusterSuperpixelIntensities = superpixelIntensities(clusterSuperpixels);
        
        subplot(1,3,2);
        hist(clusterSuperpixelIntensities);
        title(' Histogram of Mean superpixels intensities');
        
        
        superpixelSTD = featureMatrix(2,:);
        clusterSuperpixelSTD = superpixelSTD(clusterSuperpixels);
        
        subplot(1,3,3);
        hist(clusterSuperpixelSTD);
        title('Hist of Superpixel STDs');
        
    end
    
    %% [sortedMeans, clustersCorrespondingToMeans] = sort(clusterMeans, 'descend');
    
    %%clustersToInclude = 4;
    %%brightestClusterIndices = clustersCorrespondingToMeans(1:clustersToInclude);
    %%brightestClustersImage = uint8(zeros(size(NormalizedGrayImage)));
    %%for i = 1:clustersToInclude
    %%    brightestClustersImage(ClusterImage == brightestClusterIndices(i)) = NormalizedGrayImage(ClusterImage == brightestClusterIndices(i));
    %%end
    
    %% figure();
    %% imshow(brightestClustersImage);
    
end