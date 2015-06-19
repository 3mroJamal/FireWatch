function [relativeIntensityVector] = extractRelativeIntensityFeatures(normalizedImage, meanSuperpixelIntensityVector, meanXPosVector, meanYPosVector, numberOfSuperPixels, neighboringSuperpixelsWindow)
    relativeIntensityVector = zeros(1, numberOfSuperPixels);
    [imagesRow, imageCols] = size(normalizedImage);
    
    imagePixels = imagesRow*imageCols;
    pixelsPerSuperpixel = imagePixels/(numberOfSuperPixels*1.0);
    superPixelSideLength = ceil(sqrt(double(pixelsPerSuperpixel)));
    
    
    
   
    
    for superpixelIdx = 1:numberOfSuperPixels
           meanSuperpixelIntensity = meanSuperpixelIntensityVector(superpixelIdx);
           superpixelXCenter = meanXPosVector(superpixelIdx);
           superpixelYCenter = meanYPosVector(superpixelIdx);
           
           
           windowDiameter = ceil((neighboringSuperpixelsWindow + 0.5) * superPixelSideLength);
           windowUpperBound = max( 1, superpixelXCenter - windowDiameter);
           windowLowerBound = min(imagesRow, superpixelXCenter + windowDiameter);
           
           windowLeftBound = max(1, superpixelYCenter - windowDiameter);
           windowRightBound = min(imageCols,superpixelYCenter + windowDiameter);
           
           
           
          %%if(mod(superpixelIdx, 50) ==0)
          %%    fprintf('Idx: %i, upperBound: %i, lowerBound: %i, leftBound: %i, rightBound: %i\n', superpixelIdx, windowUpperBound,windowLowerBound,  windowLeftBound, windowRightBound);
          %%    newImage = normalizedImage;
          %%    newImage(windowUpperBound:windowLowerBound, windowLeftBound:windowRightBound) = 0;
          %%    figure();
          %%    imshow(newImage);
          %%end
          
           
           
          windowValues =  normalizedImage(windowUpperBound:windowLowerBound, windowLeftBound:windowRightBound);
           
          meanOfWindow = mean(windowValues(:));
          relativeIntensityVector(superpixelIdx) = meanSuperpixelIntensity/meanOfWindow;
          
    end
    
end