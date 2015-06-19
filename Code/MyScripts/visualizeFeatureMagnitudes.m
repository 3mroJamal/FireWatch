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