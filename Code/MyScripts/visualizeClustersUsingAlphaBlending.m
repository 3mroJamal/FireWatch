% Highlights superpixels belonging to each cluster by coloring them by a
% different color
% imageDictionary: dictionary containing zeroth image of every triplet, keys
% are 1,2,3,....
% labelsDictionary: dictionary containing superpixel labels per image,
% indexed in the same way as the image dictionary
% numLabelsDictionary: dictionary saving number of superpixels per image
% SuperPixelClusterIndices: Vector assiging each superpixel to a cluster
% alpha: belding factor to be used
% Image is blended as follows: (blendedImage = alpha*original + (1-alpha)*labelImage)

function [] = visualizeClustersUsingAlphaBlending(imageDictionary, labelsDictionary, numLabelsDictionary,imageNamesDictionary, SuperPixelClusterIndices, alpha, dirPath, ext, clustersToInclude)

outputDirPath = fullfile(dirPath, 'output');
if exist(outputDirPath) == 7
    % remove directory with all subfolders
    rmdir(outputDirPath, 's');
end
mkdir(outputDirPath);

[imageCnt ~] = size(imageDictionary);

outputImageCount = 0;

superpixelsOfPreviousImages = 0;
for imageIdx = 1:imageCnt
    
    currentImage = imageDictionary(num2str(imageIdx));
    
    currentImageName = imageNamesDictionary(num2str(imageIdx));
    
    [pathstr,nameNoExt,ext] = fileparts(currentImageName);
    
    lastCharacter = nameNoExt(size(nameNoExt,2));
    
    currentImageEqualized = adapthisteq(currentImage);
    
    if(lastCharacter =='0')
        figure();
        imshow(currentImageEqualized);
        imwrite(currentImageEqualized, fullfile(outputDirPath, strcat(num2str(outputImageCount),ext)));
        outputImageCount = outputImageCount+1;
    end
    
    %% figure();
    %% imshow(currentImage);
    
    currentImageSuperpixelCount = numLabelsDictionary(num2str(imageIdx));
    %% each pixel is labeled to which superpixel does it belong
    currentImageSuperpixelLabel = labelsDictionary(num2str(imageIdx));
    
    
    
    %% each superpixel is labeled to which cluster does it belong
    currentImageSuperpixelClusterIndices = SuperPixelClusterIndices(superpixelsOfPreviousImages+1:superpixelsOfPreviousImages+ currentImageSuperpixelCount);
    
    superpixelsOfPreviousImages = superpixelsOfPreviousImages + currentImageSuperpixelCount;
    
    % each pixel is labelled to which cluster does it belongs
    currentImageClusterLabels = zeros(size(currentImage));
    
    for superpixelIdx = 1:currentImageSuperpixelCount
        superpixelClusterLabel = currentImageSuperpixelClusterIndices(superpixelIdx);
        
        if(superpixelClusterLabel ==0 )
            continue;
        end
        
        if(sum(clustersToInclude== superpixelClusterLabel)>0)
            currentImageClusterLabels(currentImageSuperpixelLabel == superpixelIdx) = superpixelClusterLabel;
        else
            currentImageClusterLabels(currentImageSuperpixelLabel == superpixelIdx) = 0;
        end
    end
    
    
    maskedImage = drawSuperpixelBoundaries(currentImageEqualized, currentImageSuperpixelLabel, 0);
    blendedImage = alphaBelnding(maskedImage, alpha, currentImageClusterLabels);
    
    
    figure();
    imshow(blendedImage);
    title('blendedImage');
    
    filePath = fullfile(outputDirPath, strcat(num2str(outputImageCount),ext));
    imwrite(blendedImage, filePath);
    outputImageCount = outputImageCount+1;
    
    
end

end