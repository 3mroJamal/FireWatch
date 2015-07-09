% For every image, it draws superpixels belonging to a different cluster in
% a separate figure
% imageDictionary: dictionary containing first image of every triplet, keys
% are 1,2,3,....
% labelsDictionary: dictionary containing superpixel labels per image,
% indexed in teh same way as the image dictionary
% numLabelsDictionary: dictionary saving number of superpixels per image
% SuperPixelClusterIndices: Vector assiging each superpixel to a cluster
% clusterNumber: number of clusters used

% To be called from the clusterDirectory script

function [] = visualizeClustersInSeparateFigures(imageDictionary, labelsDictionary, numLabelsDictionary, SuperPixelClusterIndices, clusterNumber)

[imageCnt ~] = size(imageDictionary);

superpixelsOfPreviousImages = 0;
for imageIdx = 1:imageCnt
    currentImage = imageDictionary(num2str(imageIdx));
    
    figure();
    imshow(currentImage);
    title('original image');
    
    currentImageSuperpixelCount = numLabelsDictionary(num2str(imageIdx));
    currentImageLabel = labelsDictionary(num2str(imageIdx));
    
    currentImageSuperpixelClusterIndices = SuperPixelClusterIndices(superpixelsOfPreviousImages+1:superpixelsOfPreviousImages+ currentImageSuperpixelCount);
    
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