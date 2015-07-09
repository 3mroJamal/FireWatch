% Partitions an image into square blocks of "blockSize" instead of
% superpixels
% Can be used by the cluster directory script to cluster square blocks
% instead of superpixels
function [labels, numLabels] = slicBlocks(GrayScaleImage, blockSize)
    [rows, cols] = size(GrayScaleImage);
    superpixelIdx = 1;
    labels = zeros(rows, cols);
    for blockRowIdx = 1:blockSize:rows
        for blockColIdx = 1:blockSize:cols
            blockUpperBound = blockRowIdx;
            blockLowerBound = min(blockUpperBound+blockSize - 1, rows);
            
            blockLeftBound = blockColIdx;
            blockRightBound = min(blockColIdx + blockSize -1, cols);
            
            labels(blockUpperBound:blockLowerBound, blockLeftBound:blockRightBound) = superpixelIdx;
            superpixelIdx = superpixelIdx +1;
            
        end
        
    end
    numLabels = superpixelIdx-1;
end