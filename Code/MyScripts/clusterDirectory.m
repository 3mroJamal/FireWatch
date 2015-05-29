function [] = clusterDirectory(dirPath, tripletsCount, useWhiteMask, clusterNumber, featuresToInclude)
  
  dirInfo = dir(dirPath);
  
  tripletsConsidered = 0;
  
  % each super pixel occupy 1 column in feature Matrix
  featureMatrix = zeros(sum(featuresToInclude), 0);
  
  imageDictionary = containers.Map;
  labelsDictionary = containers.Map;
  numLabelsDictionary = containers.Map;
  
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
          
          
          imZeroNormalized = normalizeImage(imZero);
          
          imZeroGrayScale = uint8(imZeroNormalized.*255);
          
       
          SuperPixelNumber = 500;
          CompactnessFactor = 40;
          [Labels, numLabels] = SLICdemo(imZeroGrayScale, SuperPixelNumber, CompactnessFactor);
          
         
          colorFeatureMatrix = extractFeatures(imZero, Labels, numLabels);
    
          imOneNormalized = normalizeImage(imOne);
          
          motionFeatureMatrix = extractMotionFeatures(imZeroNormalized, imOneNormalized, Labels,numLabels);
          
          diffFeatureMatrix = extractDiffImageFeatures(imZero, imOne, imTwo, Labels, numLabels);
          
          featureMatrixOfCurrentTriplet = [colorFeatureMatrix; motionFeatureMatrix; diffFeatureMatrix];
          
          featureMatrix = [featureMatrix, featureMatrixOfCurrentTriplet];
          
          imageDictionary(num2str(tripletsConsidered)) = imZeroNormalized;
          labelsDictionary(num2str(tripletsConsidered)) = Labels;
          numLabelsDictionary(num2str(tripletsConsidered)) = numLabels;
          
      end
      
  end
  
  
  figure();
  hist(featureMatrix(1,:));
  title('Intensity Hist');
  
  figure();
  hist(featureMatrix(2,:));
  title('STD Hist');
  
  figure();
  hist(featureMatrix(3,:));
  title('X POS Hist');
  
  figure();
  hist(featureMatrix(4,:));
  title('Y POS Hist');
  
  figure();
  hist(featureMatrix(5,:));
  title('X MOTION Hist');
  

  figure();
  hist(featureMatrix(6,:));
  title('X MOTION STD Hist');
  
  figure();
  hist(featureMatrix(7,:));
  title('Y MOTION Hist');
  
  figure();
  hist(featureMatrix(8,:));
  title('Y MOTION STD Hist');
  
  featureMatrix = featureMatrix(featuresToInclude>0, :);
  
  % kmeans expects a matrix where rows correspond to points
  % SuperPixelClusterIndices = kmedoids(featureMatrix', clusterNumber);kmedoids
  SuperPixelClusterIndices = kmeans(featureMatrix', clusterNumber);
      
  [imageCnt ~] = size(imageDictionary)
      
  superpixelsOfPreviousImages = 0;
  for imageIdx = 1:imageCnt
      
    currentImage = imageDictionary(num2str(imageIdx));
    
    figure();
    imshow(currentImage);
    title('original image');
    
    currentImageSuperpixelCount = numLabelsDictionary(num2str(imageIdx));
    currentImageLabel = labelsDictionary(num2str(imageIdx));
    
    currentImageSuperpixelClusterIndices = SuperPixelClusterIndices(superpixelsOfPreviousImages+1:superpixelsOfPreviousImages+ currentImageSuperpixelCount);
    
    fprintf('imageIdx: %i, currentImagepixelCnt: %i, startRange: %i, endRange: %i\n', imageIdx, currentImageSuperpixelCount, superpixelsOfPreviousImages+1,superpixelsOfPreviousImages+ currentImageSuperpixelCount );
    
    superpixelsOfPreviousImages = superpixelsOfPreviousImages + currentImageSuperpixelCount;
    
    
    for clusterIdx = 1:clusterNumber
        currentClusterImage = zeros(size(currentImage));
        
        for superpixelIdx = 1:currentImageSuperpixelCount
            currentSuperpixelClusterLabel = currentImageSuperpixelClusterIndices(superpixelIdx);
           
            if(currentSuperpixelClusterLabel == clusterIdx)
                currentClusterImage(currentImageLabel == superpixelIdx) = currentImage(currentImageLabel == superpixelIdx);
            end
            
        end
        
        figure();
        imshow(currentClusterImage);
        title(num2str(clusterIdx));
        
    end
    
  end

  
end