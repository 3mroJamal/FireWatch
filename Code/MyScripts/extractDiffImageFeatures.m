% Returned features
% 1- mean of diff image intensity
% 2- std of diff image intensity

function [featureMatrix] = extractDiffImageFeatures(imZero, imOne, imTwo, labels, numLabels )
    
     featureMatrix = zeros(1,numLabels);
        

     diffOne = frameDifference(imZero, imOne);
     diffTwo = frameDifference(imOne, imTwo);
          
     diff = zeros(size(diffOne));
     diff(diffOne>=diffTwo) = diffOne(diffOne>=diffTwo);
     diff(diffTwo>diffOne) = diffTwo(diffTwo>diffOne);
     diff = uint8(diff);
                    
         
     %%figure();
     %%imshow(diff);
     %%title('DIFF Image');
          
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