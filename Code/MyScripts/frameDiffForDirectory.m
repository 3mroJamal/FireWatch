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
          
       
          normalizedImage = uint8(normalizeImage(imZero).*255);
          %figure();
          %imshow(normalizedImage);
          %title('Normalized Image');
          
          
          AdaptiveEqualizedImage = adapthisteq(normalizedImage);
          figure();
          imshow(AdaptiveEqualizedImage);
          title('Adaptive Equalization');
            

           
          diffOne = frameDifference(imZero, imOne);
          diffTwo = frameDifference(imOne, imTwo);
          
          diff = zeros(size(diffOne));
          diff(diffOne>=diffTwo) = diffOne(diffOne>=diffTwo);
          diff(diffTwo>diffOne) = diffTwo(diffTwo>diffOne);
          diff = uint8(diff);
                    
         
          figure();
          imshow(diff);
          title('DIFF Image');
          
          saltAndPepperDiff = medfilt2(diff, [15 15]);          
          %%figure();
          %%imshow(saltAndPepperDiff);
          %%title('Diff Salt and Pepper');

          dilatedDiff = imdilate(saltAndPepperDiff, ones(20));
          
          
          figure();
          imshow(dilatedDiff);
          title('dilated image');
          
         
          
           [labelsAdaptive, numLabelsAdaptive] = SLICdemo(AdaptiveEqualizedImage, 500, 40);
           binaryMaskAdaptive = drawregionboundaries(labelsAdaptive); 
           maskedImageAdaptive = AdaptiveEqualizedImage;
           maskedImageAdaptive(binaryMaskAdaptive==1) = 0;
          
           %figure();
           %imshow(maskedImageAdaptive);
           %title('maskedImageAdaptive');
          
          
          %% Super pixels of normalized image (No equalization) have more straight noundaries
          [labelsNormalized, numLabelsNormalized] = SLICdemo(normalizedImage, 500, 40);
          binaryMaskNormalized = drawregionboundaries(labelsNormalized);
          maskedImageNormalized = AdaptiveEqualizedImage;
          maskedImageNormalized(binaryMaskNormalized==1) = 0;
          
          %%figure();
          %%imshow(maskedImageNormalized);
          %%title('maskedImageNormalized');
          
          filteredImageAdaptive = frameDifferenceFilter(normalizedImage, AdaptiveEqualizedImage,  dilatedDiff, labelsAdaptive, numLabelsAdaptive, 0.1);
          figure();
          imshow(filteredImageAdaptive);
          title('Filtered out image Apative');
          
          
          %%filteredImageNormalized = frameDifferenceFilter(normalizedImage, AdaptiveEqualizedImage,  dilatedDiff, labelsNormalized, numLabelsNormalized, 0.1);
          %%figure();
          %%imshow(filteredImageNormalized);
          %%title('Filtered out image Normalized');
          
          
      end

  
end