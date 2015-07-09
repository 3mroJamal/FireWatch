% Extract the "relative intensity feature", which is the ratio between
% superpixel intensity and its neighbors
% normalizedImage: double Image in range [0,1]
% meanSuperpixelIntensityVector: mean intensity per superpixel
% meanXPosVector: X position of the superpixel (X axis goes from top to bottom)
% meanYPosVector: Y position of the superpixel (Y axis foes from left to right)
% numberOfSuperPixels: number of superpixels in "normalizedImage"
% neighboringSuperpixelsWindow: hald the side length of the neighboring
% superpixel square to be considered. For example, if 1, if means consider
% the 3*3 superpixel neighborhood, if 2, it means consider the 5*5
% superpixel neighborhood
% It actually considers a sqaure neighborhood around each superpixel
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
           
           windowMinXBound = max(1, superpixelXCenter - windowDiameter);
           windowMaxXBound = min(imageCols,superpixelXCenter + windowDiameter);
           
           windowMinYBound = max( 1, superpixelYCenter - windowDiameter);
           windowMaxYBound = min(imagesRow,superpixelYCenter + windowDiameter);
           
           %% windowUpperBound = max( 1, superpixelXCenter - windowDiameter);
           %% windowLowerBound = min(imagesRow, superpixelXCenter + windowDiameter);
           
           %% windowLeftBound = max(1, superpixelYCenter - windowDiameter);
           %% windowRightBound = min(imageCols,superpixelYCenter + windowDiameter);
           
           
           
          %% if(mod(superpixelIdx, 50) ==0)
          %%    fprintf('Idx: %i, upperBound: %i, lowerBound: %i, leftBound: %i, rightBound: %i\n', superpixelIdx, windowMinYBound,windowMaxYBound,  windowMinXBound, windowMaxXBound);
          %%    newImage = normalizedImage;
          %%    newImage(windowMinYBound:windowMaxYBound, windowMinXBound:windowMaxXBound) = 0;
          %%    figure();
          %%    imshow(newImage);
          %% end
          
           
           
          windowValues =  normalizedImage(windowMinYBound:windowMaxYBound, windowMinXBound:windowMaxXBound);
           
          
          %% fprintf('upper: %i, lower: %i, left: %i, right: %i\n', windowUpperBound, windowLowerBound, windowLeftBound, windowRightBound);
          
          meanOfWindow = mean(windowValues(:));
          relativeIntensityVector(superpixelIdx) = meanSuperpixelIntensity/meanOfWindow;
          
    end
    
end