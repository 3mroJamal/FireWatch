% returns the feature matrix of an image where each column corresponf to a
% super pixel and each row correspond to a feature
% Feature Indices: 
% 1) Mean Intensity
% 2) Intensity SD
% 3) Mean x position
% 4) Mean y postion

function [featureMatrix] = extractFeatures(NormalizedGrayScaleImage, FeatureNumber, Labels, NumLabels)
    featureMatrix = zeros(FeatureNumber, NumLabels);
    
    [rows, columns] = size(NormalizedGrayScaleImage);
    
    for SuperPixelIdx = 1:NumLabels
        neededPixels = NormalizedGrayScaleImage(Labels == SuperPixelIdx);
        neededPixelsPositions = find(Labels == SuperPixelIdx);
        
        if(FeatureNumber >=1)
            meanOfNeededPixels = mean(neededPixels);
            featureMatrix(1, SuperPixelIdx) = meanOfNeededPixels;
        end
        
        if(FeatureNumber >=2)
            stdOfNeededPixels = std(double(neededPixels));
            featureMatrix(2, SuperPixelIdx) = stdOfNeededPixels;
        end
        
        
        if(FeatureNumber >=3)
            rowIdx = mod((neededPixelsPositions-1) ,rows) +1;
            meanRow = mean(rowIdx);
            featureMatrix(3, SuperPixelIdx) = meanRow;
        end

        if(FeatureNumber >=4)
            colIdx = floor((neededPixelsPositions+1)/rows);
            meanColumn = mean(colIdx);
            featureMatrix(4, SuperPixelIdx) = meanColumn;
        end
        
    end
    
    %% Part to visualize the computed means and cluster centers
    %{
    MeanImage = zeros(rows, columns);
    MeanImage = uint8(MeanImage);
    for i = 1:NumLabels
        MeanImage(Labels == i) = featureMatrix(1, i);
    end
    
    figure();
    imshow(MeanImage);
   
    for i = 1:NumLabels
        text(featureMatrix(4,i), featureMatrix(3,i), 'h');
    end  
    %}
end