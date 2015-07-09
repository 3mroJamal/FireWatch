function [resultImage] = computeClusterLabelsPerPixel(Labels, numLabels, superpixelClusterIndices)
    resultImage = zeros(size(Labels));
    for superpixelIdx = 1:numLabels
        clusterIdx = superpixelClusterIndices(superpixelIdx);
        resultImage(Labels == superpixelIdx) = clusterIdx;
    end
end