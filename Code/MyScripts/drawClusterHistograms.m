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