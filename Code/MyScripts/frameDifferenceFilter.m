% Image is a gray scale image in range [0,255]
function filteredImage = frameDifferenceFilter(Image, equalizedImage, diffImage, Labels, numLabels, threshold)
    filteredImage = uint8(zeros(size(Image)));
    
    meanIntensity = zeros(1, numLabels);
    
    for superPixelIdx = 1:numLabels
         neededIndices = (Labels == superPixelIdx);
         meanOfDiffSuperPixel = mean(diffImage(neededIndices));
         meanIntensity(superPixelIdx) = meanOfDiffSuperPixel;
    end
    
    sortedMeans = sort(meanIntensity);
    
    highestPercentage = 0.15;
    neededThres = sortedMeans(floor((1-highestPercentage)*numLabels));
    
    for superPixelIdx = 1:numLabels
        neededIndices = (Labels == superPixelIdx);
        
        meanOfDiffSuperPixel = mean(diffImage(neededIndices));
        
        
        % countOfPixels = sum(sum(neededIndices));
        % countOfDifferentPixels = sum(sum(diffImage(neededIndices)>0))
        % fprintf('diff: %i, orig: %i\n',countOfDifferentPixels,  countOfPixels);
        % ratio = countOfDifferentPixels*1.0/countOfPixels;
        
        %sumOfDiffPixels = sum(diffImage(neededIndices));
        %sumOfOriginalPixels = sum(Image(neededIndices));
        %ratio = sumOfDiffPixels*1.0/sumOfOriginalPixels;
        
        if(meanOfDiffSuperPixel>=neededThres)
        %if(meanOfDiffSuperPixel >=10)
        %if(ratio>=threshold)
            filteredImage(neededIndices) = equalizedImage(neededIndices);
        end
        
    end
    
end