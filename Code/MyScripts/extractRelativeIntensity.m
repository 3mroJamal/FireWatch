% Compute the relative intensity of every super[ixel relative to its
% neighbors
function [featureMatrix] = extractRelativeIntensity(grayImage, labels, numlabels)
   [rows cols] = size(grayImage);
   pixelsPerSuperpixel = rows*cols*1.0/numlabels;
   superpixelSideLength = floor(sqrt(double(pixelsPerSuperpixel)));
   windowSize = 5*superpixelSideLength;
    
   figure();
   imshow(grayImage);
   title('original Image');
   
   
   superpixelBoundaries = drawSuperpixelBoundaries(grayImage, labels, 0);
   
   figure();
   imshow(superpixelBoundaries);
   title('Segmented Image');
   
   rowsMatrix = zeros(size(grayImage));
   
   for i = 1:rows
       rowsMatrix(i,:) = i;
   end
   
   columnsMatrix = zeros(size(grayImage));
   for j = 1:cols
       columnsMatrix(:,j) = j;
   end
   
   for superpixelIdx = 1:numlabels
       
       neededPixels = (labels==superpixelIdx);
       meanX = mean(rowsMatrix(neededPixels));
       meanY = mean(columnsMatrix(neededPixels));
       
       meanIntensityOfCurrentSuperpixel = mean(grayImage(neededPixels));
       
       
       
       lowestX = max(1,floor(meanX-windowSize/2));
       highestX = min(rows, floor(meanX+windowSize/2));
       
       lowestY = max(1, floor(meanY - windowSize/2));
       highestY = min(cols, floor(meanY + windowSize/2));
       
       neighboringPart = labels(lowestX:highestX, lowestY:highestY);
       uniqueSuperpixels = unique(neighboringPart);
       numberOfUniqueSuperpixels = size(uniqueSuperpixels,1);
       
       for neighborSuperpixel = 1:numberOfUniqueSuperpixels
           currentSuperpixel = 
       end
       
       %%newImage = superpixelBoundaries;
       %%newImage(lowestX:highestX, lowestY:highestY) = 0;
       %%maskedNewImage = drawSuperpixelBoundaries(newImage, labels, 1);
       
       %%figure();
       %%imshow(maskedNewImage);
       
   end
   
   
end