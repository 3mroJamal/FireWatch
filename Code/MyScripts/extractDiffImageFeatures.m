% Extarct features based on the difference images between first and zeroth
% images as well as second and first triplet images
% Returns a feature matrix with teh 2 features
% 1- mean of diff image intensity
% 2- std of diff image intensity

function [featureMatrix] = extractDiffImageFeatures(normalizedImageZero, normalizedImageOne, labels, numLabels )
    
     featureMatrix = zeros(1,numLabels);

     diffOne = frameDifference(normalizedImageZero, normalizedImageOne);
     %% diffTwo = frameDifference(normalizedImageOne, normalizedImageTwo);
          
     %% diff = zeros(size(diffOne));
     %% diff(diffOne>=diffTwo) = diffOne(diffOne>=diffTwo);
     %% diff(diffTwo>diffOne) = diffTwo(diffTwo>diffOne);
     
     diff = diffOne;
     
     %% diff = normalizeImage(diff);
     
     %% diff = uint8(diff);
          
     %%figure();
     %%imshow(diff);
     %%title('DIFF Image');
     
     %%figure();
     %%imhist(diff);
     %%title('diff hist');
          
     %% saltAndPepperDiff = medfilt2(diff, [15 15]);          
     %%figure();
     %%imshow(saltAndPepperDiff);
     %%title('Diff Salt and Pepper');

     %% dilatedDiff = imdilate(saltAndPepperDiff, ones(20));
          
     %%figure();
     %%imshow(dilatedDiff);
     %%title('dilated image');
     
     for superpixelIdx = 1:numLabels
         neededPixels = (labels==superpixelIdx);
         featureMatrix(1,superpixelIdx) = mean(diff(neededPixels));
         featureMatrix(2, superpixelIdx) = std(double(diff(neededPixels)));
     end
     
   
    
end