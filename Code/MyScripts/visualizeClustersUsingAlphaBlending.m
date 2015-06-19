function [] = visualizeClustersUsingAlphaBlending(imageDictionary, labelsDictionary, numLabelsDictionary, SuperPixelClusterIndices, alpha)

[imageCnt ~] = size(imageDictionary);

superpixelsOfPreviousImages = 0;
for imageIdx = 1:imageCnt
    
    currentImage = imageDictionary(num2str(imageIdx));
    
    
     figure();
    imshow(currentImage);
    
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
        currentImageClusterLabels(currentImageSuperpixelLabel == superpixelIdx) = superpixelClusterLabel;
    end
    
    
    maskedImage = drawSuperpixelBoundaries(currentImage, currentImageSuperpixelLabel, 0);
    blendedImage = alphaBelnding(maskedImage, alpha, currentImageClusterLabels);
    
    
    
    figure();
    imshow(blendedImage);
    
end




end