function [featureMatrixNormalized] = normalizeFeaturesOfOneImage(featureMatrixOfOneImage)
    minOfEachRow = (min(featureMatrixOfOneImage'))';    
    minRepeated = repmat(minOfEachRow, 1, size(featureMatrixOfOneImage,2));
    
    featureMatrixShiftedToZero = featureMatrixOfOneImage - minRepeated;
    
    maxOfEachRow = (max(featureMatrixShiftedToZero'))';
    maxRepeated = repmat(maxOfEachRow, 1, size(featureMatrixShiftedToZero,2));
    
    featureMatrixNormalized = featureMatrixShiftedToZero./maxRepeated;
    
    
end