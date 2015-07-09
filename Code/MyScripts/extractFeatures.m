% Returns the feature matrix of an image where each column corresponds to a
% superpixel and each row correspond to a feature
% Feature Indices: 
% 1) Mean Intensity
% 2) Intensity SD
% 3) Mean X position (horizontal axis from left to right)
% 4) Mean Y postion (vertical axis from top to bottom)

function [featureMatrix] = extractFeatures(normalizedImage, Labels, NumLabels)
    featureMatrix = zeros(4, NumLabels);
    
    [rows, columns] = size(normalizedImage);
    
    %% NormalizedGrayScaleImage = uint8(normalizeImage(Image).*255);
   
    %%figure();
    %%imhist(normalizedImage);
    %%title('Histogram Of Normalized Intensities');
    
   
    
    for SuperPixelIdx = 1:NumLabels
        %% neededPixels = NormalizedGrayScaleImage(Labels == SuperPixelIdx);
        
        neededPixels = normalizedImage(Labels == SuperPixelIdx);
        
        neededPixelsPositions = find(Labels == SuperPixelIdx);
        
        meanOfNeededPixels = mean(neededPixels);
        featureMatrix(1, SuperPixelIdx) = meanOfNeededPixels;
        
        
        stdOfNeededPixels = std(double(neededPixels));
        featureMatrix(2, SuperPixelIdx) = stdOfNeededPixels;
        
        %% This is mean X position where x is a horizontal axis from left to right
        colIdx = floor((neededPixelsPositions+1)/rows);
        meanColumn = mean(colIdx);
        featureMatrix(3, SuperPixelIdx) = meanColumn;
        
        %% This is mean Y where Y is a vertical axis from top to bottom
        rowIdx = mod((neededPixelsPositions-1) ,rows) +1;
        meanRow = mean(rowIdx);
        featureMatrix(4, SuperPixelIdx) = meanRow;
        
        
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
   %end