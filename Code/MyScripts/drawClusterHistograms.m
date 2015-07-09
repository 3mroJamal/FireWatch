% Draws histograms of features in each cluster
% Used in the cluster directory script
% originalFeatureMatrix: feature matrix without normalizing features to 0
% mean and unit variance
% featureNames: names of features in a cell array
% clusterNumber: number of clusters
% superPixelClusterIndices: vector with labels to which cluster each
% superpixel belong
function [] = drawClusterHistograms(originalFeatureMatrix, featureNames, clusterNumber, superPixelClusterIndices)
    chosenFeatureNames = featureNames;
    numberOfFeatures = size(chosenFeatureNames, 2);
    
    for chosenFeatureIdx = 1:numberOfFeatures
        chosenFeatureName = chosenFeatureNames(chosenFeatureIdx);
        chosenFeatureValues = originalFeatureMatrix(chosenFeatureIdx, :);
        
        for clusterIdx = 1:clusterNumber
            superpixelsInCurrentCluster = (superPixelClusterIndices==clusterIdx);
            chosenFeatureValuesInCurrentCluster = chosenFeatureValues(superpixelsInCurrentCluster);
            figure();
            hist(chosenFeatureValuesInCurrentCluster);
            title(strcat(chosenFeatureName, ' in cluster: ', num2str(clusterIdx)));
        end
    end
    
end