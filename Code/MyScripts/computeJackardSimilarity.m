function [jackardSim] = computeJackardSimilarity(LabelsDictionary, numLabelsDictionary, imageNamesDictionary,SuperPixelClusterIndices, clusterNumber, dirPath)

JackardSimIntersection = zeros(1, clusterNumber);
JackardSimUnion = zeros(1, clusterNumber);

[imageCnt ~] = size(LabelsDictionary);
superpixelsOfPreviousImages = 0;
for imageIdx = 1:imageCnt
    
    currentImageSuperpixelLabel = LabelsDictionary(num2str(imageIdx));
    currentImageSuperpixelCount = numLabelsDictionary(num2str(imageIdx));
    
    currentImageSuperpixelClusterIndices = SuperPixelClusterIndices(superpixelsOfPreviousImages+1:superpixelsOfPreviousImages+ currentImageSuperpixelCount);
    
    superpixelsOfPreviousImages = superpixelsOfPreviousImages + currentImageSuperpixelCount;
    
    currentImageClusterLabels = zeros(size(currentImageSuperpixelLabel));
    
    for superpixelIdx = 1:currentImageSuperpixelCount
        superpixelClusterLabel = currentImageSuperpixelClusterIndices(superpixelIdx);
        currentImageClusterLabels(currentImageSuperpixelLabel == superpixelIdx) = superpixelClusterLabel;
    end
    
    fullImageName = imageNamesDictionary(num2str(imageIdx));
    [~, labelImageName, ext] = fileparts(fullImageName);
    labelImageName(size(labelImageName,2)) = 'g';
    labelImageName = strcat(labelImageName, 't');
    labelImageName = strcat(labelImageName, ext);
    
    labelImage = imread(fullfile(dirPath, labelImageName));
    maxValueInLabelImage = max(max(labelImage));
    
  
    for clusterIdx = 1:clusterNumber
        intersection = sum(sum(currentImageClusterLabels == clusterIdx & labelImage==maxValueInLabelImage));
        
        union = sum(sum(labelImage == maxValueInLabelImage)) + sum(sum(currentImageClusterLabels == clusterIdx)) - intersection;
        
        
        JackardSimIntersection(clusterIdx) = JackardSimIntersection(clusterIdx) + intersection;
        JackardSimUnion(clusterIdx) = JackardSimUnion(clusterIdx) + union;
        
        fprintf('cluster: %i, intersection: %i, union: %i\n', clusterIdx, intersection, union);
    end
    fprintf('\n\n');
    jackardSim = JackardSimIntersection./JackardSimUnion;
   
end
