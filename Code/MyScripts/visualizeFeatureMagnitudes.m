% Visualizes magnitude of each feature per superpixel
% For each feature: it draws a figure of the image segmented to superpixels
% and in the center of superpixels lies an arrow showing the magnitude of
% the feature, Thus it draws as many figures as the number of features

% normalizedImage: double image in [0,1] range
% featureMatrix: matrix containing the feature values of the "normalizedImage"
% featureNames: names of the features in the feature matrix
% labels: labels showing to which superpixel does every pixel belongs
% xPosVector: vector with mean x position of each superpixel
% yPosVector: vector with mean y position of each superpixel


% Usage: to be called from the clusterDirectory Script
function [] = visualizeFeatureMagnitudes(normalizedImage, featureMatrix, featureNames, labels, xPosVector, yPosVector)
    featureNumber = size(featureMatrix, 1);
    superpixelNumber = size(featureMatrix, 2)
   
    for featureIdx = 1:featureNumber
        normalizedGrayImage = uint8(normalizedImage.*255);
        MaskedImage = drawSuperpixelBoundaries(normalizedGrayImage, labels, 0);
        figure();
        imshow(MaskedImage);
        hold on;
        currentFeatureName = featureNames(featureIdx);
        currentFeatureValues = featureMatrix(featureIdx, :);
        size(currentFeatureValues)
        
        quiver(yPosVector, xPosVector, currentFeatureValues,currentFeatureValues);
        
        cellArray = {};
        for superpixelIdx = 1:superpixelNumber
            cellArray{superpixelIdx} = num2str(sprintf('%0.2f',currentFeatureValues(superpixelIdx) ));
        end
        
        
        %% text(yPosVector,xPosVector, cellArray, 'FontSize', 10, 'FontWeight', 'bold');
        title(strcat(currentFeatureName, ' Magnitude'));
        
        figure();
        hist(currentFeatureValues);
        title(strcat(currentFeatureName, ' Histogram'));
    end

end