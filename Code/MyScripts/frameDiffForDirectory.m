% For every triplet separately, compute the difference image, and then do
% median filtering on diff image to remove noise, and dilation to enlarge
% candidate regions and then extract super pixels according to some
% filtering condition defined in frameDiffernceFilter (ex: 15% of 
% brightest superpixels in diff image)

%tripletsCount: number of triplets to consider, -1 considers all triplets
%in the directory

% Sample Command: 
% frameDiffForDirectory('D:\FireWatch\SampleImagesRaw\confirmedGermany\confirmedGermanyTrainAll\', -1)


% Remarks: performs resonably well on Barbara's dataset
% This is a preliminary script to extract the regions of interest in an
% image

function [] = frameDiffForDirectory(dirPath, tripletsCount)
  dirInfo = dir(dirPath);
  
  tripletsConsidered = 0;
  for i = 3:size(dirInfo)
      
      [pathstr,nameNoExt,ext] = fileparts(dirInfo(i).name);
      if ~(isequal('.tif', ext) || isequal('.png', ext))
        continue;
      end
      
      
      if (tripletsConsidered == tripletsCount)
        break;
      end
      
      lastCharacter = nameNoExt(size(nameNoExt,2));
      if(lastCharacter == '0')
          tripletsConsidered = tripletsConsidered+1;
          imZeroName = strcat(nameNoExt, ext);
          imOneName = nameNoExt;
          imOneName(size(imOneName,2)) = '1';
          imOneName = strcat(imOneName, ext);
          
          imTwoName = nameNoExt;
          imTwoName(size(imTwoName,2)) = '2';
          imTwoName = strcat(imTwoName, ext);
          
          % concat directory so that image can be read regardless what
          % current matlab directory is
          imZero = imread(fullfile(dirPath,imZeroName));
          imOne = imread(fullfile(dirPath,imOneName));
          imTwo = imread(fullfile(dirPath,imTwoName));
          
          [imZeroNormalized, imOneNormalized, imTwoNormalized] = normalizeImage(imZero, imOne, imTwo);
                 
          myDiff = abs(imOneNormalized - imZeroNormalized);
          myDiffNormalized = normalizeImage(myDiff);
          
          figure();
          imshow(myDiffNormalized);
          title('myDiffNormalized');
          
          myDiffThresholded = myDiffNormalized;
          myDiffThresholded(myDiffThresholded<0.5) = 0;
          %%myDiffThresholded(myDiffThresholded>=0.3) = 1;
          
          
          figure();
          imshow(myDiffThresholded);
          title('Thresholding');
         
          
          myDiffTwo = abs(imTwoNormalized - imOneNormalized);
          myDiffTwoNormalized = normalizeImage(myDiffTwo);
          
          %%figure();
          %%imshow(myDiffTwoNormalized);
          %%title('myDiffTwoNormalized');
          
            diffAddition = myDiff + myDiffTwo;
            diffAdditionNormalized = normalizeImage(diffAddition);
            %%figure();
            %%imshow(diffAdditionNormalized);
            %%title('normalized diff addition');
          
          imZeroGrayscale = uint8(normalizeImage(imZero).*255);
          %%figure();
          %%imshow(imZeroGrayscale);
          %%title('Normalized Image');
          
          
          AdaptiveEqualizedImage = adapthisteq(imZeroGrayscale);
          figure();
          imshow(AdaptiveEqualizedImage);
          title('Adaptive Equalization');
            

           
          diffOne = frameDifference(imZero, imOne);
          diffTwo = frameDifference(imOne, imTwo);
          diff = zeros(size(diffOne));
          diff(diffOne>=diffTwo) = diffOne(diffOne>=diffTwo);
          diff(diffTwo>diffOne) = diffTwo(diffTwo>diffOne);
          diff = uint8(diff);
          %% figure();
          %% imshow(diff);
          %% title('DIFF Image');
          
          saltAndPepperDiff = medfilt2(diff, [15 15]);          
          %%figure();
          %%imshow(saltAndPepperDiff);
          %%title('Diff Salt and Pepper');

          dilatedDiff = imdilate(saltAndPepperDiff, ones(20));
          %%figure();
          %%imshow(dilatedDiff);
          %%title('dilated image');
          
          %% superpixelNumber = 500;
          %% compactnessFactor = 40;
         
          %% [labelsAdaptive, numLabelsAdaptive] = SLICdemo(AdaptiveEqualizedImage, superpixelNumber, compactnessFactor);
          %% binaryMaskAdaptive = drawregionboundaries(labelsAdaptive); 
          %% maskedImageAdaptive = AdaptiveEqualizedImage;
          %% maskedImageAdaptive(binaryMaskAdaptive==1) = 0;
          
          %% figure();
          %% imshow(maskedImageAdaptive);
          %% title('maskedImageAdaptive');
          
          
          %% Super pixels of normalized image (No equalization) have more straight noundaries
          %% [labelsNormalized, numLabelsNormalized] = SLICdemo(imZeroGrayscale, superpixelNumber, compactnessFactor);
          %% binaryMaskNormalized = drawregionboundaries(labelsNormalized);
          %% maskedImageNormalized = AdaptiveEqualizedImage;
          %% maskedImageNormalized(binaryMaskNormalized==1) = 0;
          
          %% figure();
          %% imshow(maskedImageNormalized);
          %% title('maskedImageNormalized');
          
          %% filteredImageAdaptive = frameDifferenceFilter(imZeroGrayscale, AdaptiveEqualizedImage,  dilatedDiff, labelsAdaptive, numLabelsAdaptive, 0.1);
          %%figure();
          %%imshow(filteredImageAdaptive);
          %%title('Filtered out image Apative');
          
          
          %%filteredImageNormalized = frameDifferenceFilter(imZeroGrayscale, AdaptiveEqualizedImage,  dilatedDiff, labelsNormalized, numLabelsNormalized, 0.1);
          %%figure();
          %%imshow(filteredImageNormalized);
          %%title('Filtered out image Normalized');
          
          
      end

  
end